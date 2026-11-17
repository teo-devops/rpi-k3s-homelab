#!/usr/bin/env bash
# Comprueba kubernetes/ sin clúster: cada carpeta que aplica Flux debe construir con
# kustomize y producir manifiestos válidos según su esquema (kubeconform).
# Es lo que haría Flux tras un `git push`, pero antes del push: un fallo aquí es
# un fallo que no llega al clúster.
# Uso: make k8s-check   (necesita kubectl y kubeconform)
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

for tool in kubectl kubeconform; do
  if ! command -v "$tool" >/dev/null; then
    echo "Falta $tool. kubeconform: https://github.com/yannh/kubeconform/releases"
    exit 1
  fi
done

# Esquemas: los de Kubernetes y, para los tipos propios (Flux, Cilium...), el
# catálogo de CRDs de la comunidad. Un tipo sin esquema se cuenta como "Skipped"
# en el resumen en vez de fallar.
KUBECONFORM=(kubeconform -strict -summary -ignore-missing-schemas
  -schema-location default
  -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json')

CLUSTER=kubernetes/clusters/homelab

# Las carpetas que aplica Flux salen de sus propias Kustomizations (`path:`),
# así una capa nueva queda comprobada sin tocar este script.
mapfile -t paths < <(
  echo "$CLUSTER/flux-system"
  grep -hE '^[[:space:]]+path:[[:space:]]*\./' "$CLUSTER"/*.yaml | sed -E 's/.*path:[[:space:]]*\.\///'
)

fail=0
for p in "${paths[@]}"; do
  echo "== $p"
  if ! out=$(kubectl kustomize "$p" 2>&1); then
    echo "$out"
    echo "NO CONSTRUYE: $p"
    fail=1
    continue
  fi
  if [ -z "$out" ]; then
    echo "Vacío (sin recursos todavía)."
    continue
  fi
  printf '%s\n' "$out" | "${KUBECONFORM[@]}" - || fail=1
done

echo "== $CLUSTER/*.yaml y kubernetes/examples"
"${KUBECONFORM[@]}" "$CLUSTER"/*.yaml kubernetes/examples/*.yaml || fail=1

if [ "$fail" -eq 0 ]; then echo "kubernetes/ construye y valida."; else exit 1; fi
