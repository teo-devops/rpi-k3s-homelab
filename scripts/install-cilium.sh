#!/usr/bin/env bash
# Instala (o actualiza) Cilium con Helm y aplica la configuración de LoadBalancer.
# Uso: make cilium      (el Makefile fija KUBECONFIG y CILIUM_VERSION)
# Guía: docs/06-redes-cilium/03-instalar-cilium.md
set -euo pipefail

# shellcheck source=scripts/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
CILIUM_DIR="$REPO_ROOT/kubernetes/infrastructure/cilium"
CILIUM_VERSION="${CILIUM_VERSION:?Falta CILIUM_VERSION}"

require_cmd kubectl helm
require_homelab_context

# Desde la fase 3, Cilium lo gestiona Flux. Actualizarlo a mano crearía dos fuentes de verdad.
if kubectl -n kube-system get helmreleases.helm.toolkit.fluxcd.io cilium >/dev/null 2>&1; then
  die "Cilium ya lo gestiona Flux. Cambia kubernetes/infrastructure/cilium/ y haz push (docs/07-gitops-flux/04-flux-adopta-cilium.md)"
fi

api_host=$(api_server_host)
echo "API server: $api_host"

echo "==> Instalando Cilium $CILIUM_VERSION"
helm repo add cilium https://helm.cilium.io >/dev/null 2>&1 || true
helm repo update cilium >/dev/null
helm upgrade --install cilium cilium/cilium \
  --version "$CILIUM_VERSION" \
  --namespace kube-system \
  --values "$CILIUM_DIR/values.yaml" \
  --set k8sServiceHost="$api_host" \
  --wait --timeout 15m

echo "==> Esperando a que el operador cree los tipos de recurso de Cilium"
for crd in ciliumloadbalancerippools.cilium.io ciliuml2announcementpolicies.cilium.io; do
  until kubectl get crd "$crd" >/dev/null 2>&1; do sleep 3; done
  kubectl wait --for condition=established "crd/$crd" --timeout=120s
done

echo "==> Aplicando pool de IPs y anuncios L2"
kubectl apply -k "$CILIUM_DIR/config"

echo "==> Esperando a que los nodos estén Ready"
kubectl wait --for=condition=Ready nodes --all --timeout=10m
kubectl get nodes -L homelab.io/tier

echo
echo "Cilium instalado. Siguiente: make cilium-status"
