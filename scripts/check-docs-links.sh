#!/usr/bin/env bash
# Busca enlaces internos rotos en los .md del repo (enlaces relativos a ficheros).
# Uso: make docs-check
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

broken=0
while IFS= read -r -d '' file; do
  dir=$(dirname "$file")
  # Extrae destinos de enlaces markdown: [texto](destino)
  while IFS= read -r link; do
    target=${link%%#*}            # quita el ancla
    [ -z "$target" ] && continue  # enlace solo a ancla en la misma página
    case "$target" in
      http://*|https://*|mailto:*) continue ;;
    esac
    if [ ! -e "$dir/$target" ]; then
      echo "ROTO: $file -> $link"
      broken=$((broken + 1))
    fi
  done < <(grep -oE '\]\([^)[:space:]]+\)' "$file" | sed -E 's/^\]\((.*)\)$/\1/')
done < <(find . -name '*.md' -not -path './.git/*' -print0)

if [ "$broken" -eq 0 ]; then
  echo "Sin enlaces internos rotos."
else
  echo "$broken enlace(s) roto(s)."
  exit 1
fi
