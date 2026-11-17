#!/usr/bin/env bash
# Falla si algún .md tiene un bloque ```mermaid. Los diagramas de este repo se dibujan como SVG:
# fuente editable en docs/diagramas/*.html y exportado en docs/img/*.svg (ver docs/diagramas/README.md).
# Uso: make docs-check
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

if hits=$(git grep --untracked -nE '^[[:space:]]*(```|~~~)[[:space:]]*mermaid' -- '*.md'); then
  echo "$hits"
  echo "Bloques Mermaid encontrados: dibújalos como SVG en docs/diagramas/ (ver docs/diagramas/README.md)."
  exit 1
fi
echo "Sin bloques Mermaid."
