#!/usr/bin/env bash
# Instala Flux en el clúster y lo apunta a este repo en GitHub. Idempotente.
# Uso: make flux
# Guía: docs/07-gitops-flux/03-bootstrap.md
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

FLUX_DIR="$REPO_ROOT/kubernetes/clusters/homelab/flux-system"
require_cmd kubectl git
require_homelab_context

# 1. ¿Puede Flux leer el repo? Flux aplica lo que hay en GitHub, no tu copia local.
repo_url=$(awk '/^  url:/ {print $2; exit}' "$FLUX_DIR/gotk-sync.yaml")
echo "==> Repo que leerá Flux: $repo_url"
remote_head=$(git ls-remote "$repo_url" refs/heads/main 2>/dev/null | cut -f1) \
  || true
[ -n "$remote_head" ] || die "no puedo leer la rama main de $repo_url. ¿Existe el repo, es público y has hecho push?"
local_head=$(git -C "$REPO_ROOT" rev-parse HEAD)
if [ "$remote_head" != "$local_head" ]; then
  echo "AVISO: tu commit local ($local_head) no es el de GitHub ($remote_head)."
  echo "       Flux aplicará lo que hay en GitHub. Haz push si quieres tus cambios."
fi

# 2. Clave de SOPS en el clúster.
echo "==> SOPS"
"$REPO_ROOT/scripts/sops-init.sh"

# 3. Variables de tu red que no van a Git.
echo "==> Variables del clúster (ConfigMap flux-system/cluster-vars)"
kubectl -n flux-system create configmap cluster-vars \
  --from-literal=K8S_SERVICE_HOST="$(api_server_host)" \
  --dry-run=client -o yaml | kubectl apply -f -

# 4. Controladores y tipos de recurso de Flux.
echo "==> Instalando Flux"
kubectl apply --server-side -f "$FLUX_DIR/gotk-components.yaml" >/dev/null
kubectl wait --for=condition=established --timeout=2m \
  crd/gitrepositories.source.toolkit.fluxcd.io crd/kustomizations.kustomize.toolkit.fluxcd.io >/dev/null

# 5. La conexión con Git, y los parches propios (nodo large).
kubectl apply --server-side -k "$FLUX_DIR" >/dev/null
kubectl -n flux-system wait deployment --all --for=condition=Available --timeout=5m

# 6. Primera sincronización.
echo "==> Esperando a la primera sincronización con Git"
kubectl -n flux-system wait gitrepository/flux-system --for=condition=Ready --timeout=5m
kubectl -n flux-system wait kustomization/flux-system --for=condition=Ready --timeout=10m

echo
echo "Flux instalado y sincronizado. La plataforma se está desplegando; síguela con:"
echo "  make flux-status"
