#!/usr/bin/env bash
# Red de seguridad: falla si en kubernetes/ hay un Secret sin cifrar con SOPS.
# Un repo público con un secreto en claro es un secreto filtrado (aunque luego lo borres:
# queda en el historial de Git). Se ejecuta con `make lint`.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

bad=0
while IFS= read -r -d '' f; do
  case "$f" in ./kubernetes/examples/*) continue ;; esac   # plantillas de práctica
  if grep -qE '^kind:[[:space:]]*Secret[[:space:]]*$' "$f" && ! grep -qE '^sops:' "$f"; then
    echo "SIN CIFRAR: $f   ->  make sops-encrypt FILE=$f"
    bad=$((bad + 1))
  fi
done < <(find ./kubernetes -name '*.yaml' -o -name '*.yml' | tr '\n' '\0')

if [ "$bad" -eq 0 ]; then echo "Ningún Secret sin cifrar."; else exit 1; fi
