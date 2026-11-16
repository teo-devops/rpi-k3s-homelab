#!/usr/bin/env bash
# Funciones compartidas por los scripts. Se carga con: source "$(dirname "$0")/lib.sh"
# shellcheck disable=SC2034  # REPO_ROOT lo usan los scripts que cargan este fichero

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOMELAB_CONTEXT="${HOMELAB_CONTEXT:-rpi-k3s-homelab}"

die() { echo "ERROR: $*" >&2; exit 1; }

require_cmd() {  # require_cmd <comando>...
  local c
  for c in "$@"; do
    command -v "$c" >/dev/null 2>&1 || die "falta '$c'. Ejecuta: make check"
  done
}

# No tocar nunca otro clúster por un KUBECONFIG equivocado.
require_homelab_context() {
  local ctx
  ctx=$(kubectl config current-context 2>/dev/null || true)
  if [ "$ctx" != "$HOMELAB_CONTEXT" ]; then
    die "el contexto de kubectl es '$ctx', no '$HOMELAB_CONTEXT'. Lánzalo con make (KUBECONFIG=${KUBECONFIG:-sin definir})"
  fi
}

# IP del API server, sacada del kubeconfig (https://<ip>:6443).
api_server_host() {
  local url
  url=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
  url=${url#https://}
  echo "${url%%:*}"
}
