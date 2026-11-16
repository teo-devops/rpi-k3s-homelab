#!/usr/bin/env bash
# Instala (o actualiza) Cilium con Helm y aplica la configuración de LoadBalancer.
# Uso: make cilium      (el Makefile fija KUBECONFIG y CILIUM_VERSION)
# Guía: docs/06-redes-cilium/03-instalar-cilium.md
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CILIUM_DIR="$REPO_ROOT/kubernetes/infrastructure/cilium"
CILIUM_VERSION="${CILIUM_VERSION:?Falta CILIUM_VERSION}"
EXPECTED_CONTEXT="${EXPECTED_CONTEXT:-rpi-k3s-homelab}"

for cmd in kubectl helm; do
  command -v "$cmd" >/dev/null || { echo "Falta $cmd. Ejecuta: make check"; exit 1; }
done

# Seguridad: no instalar nada en otro clúster por un KUBECONFIG equivocado.
context=$(kubectl config current-context 2>/dev/null || true)
if [ "$context" != "$EXPECTED_CONTEXT" ]; then
  echo "El contexto actual es '$context', no '$EXPECTED_CONTEXT'. Abortado."
  echo "¿Has ejecutado 'make k3s'? KUBECONFIG=${KUBECONFIG:-<sin definir>}"
  exit 1
fi

# La IP del API server sale del propio kubeconfig: https://<ip>:6443
server_url=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
api_host=${server_url#https://}
api_host=${api_host%%:*}
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
