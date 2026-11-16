#!/usr/bin/env bash
# Prepara el cifrado de secretos con SOPS + age. Idempotente.
#   1. Crea tu clave age (si no existe) FUERA del repo.
#   2. Escribe .sops.yaml con tu clave PÚBLICA (esa sí va a Git).
#   3. Entrega la clave PRIVADA al clúster como Secret, para que Flux descifre.
# Uso: make sops-init
# Guía: docs/07-gitops-flux/05-secretos-sops.md
set -euo pipefail
# shellcheck source=scripts/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

KEY_FILE="${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/rpi-k3s-homelab.agekey}"
SOPS_CONFIG="$REPO_ROOT/.sops.yaml"

require_cmd age-keygen kubectl

if [ ! -f "$KEY_FILE" ]; then
  mkdir -p "$(dirname "$KEY_FILE")"
  (umask 077 && age-keygen -o "$KEY_FILE" 2>/dev/null)
  echo "Clave nueva creada en $KEY_FILE"
  echo
  echo "  IMPORTANTE: guarda una copia de ese fichero en tu gestor de contraseñas."
  echo "  Si lo pierdes, nadie (ni tú) podrá descifrar los secretos del repo."
  echo
fi
public_key=$(age-keygen -y "$KEY_FILE")
echo "Clave pública: $public_key"

if [ -f "$SOPS_CONFIG" ] && ! grep -q "$public_key" "$SOPS_CONFIG"; then
  die ".sops.yaml ya existe con OTRA clave. Revísalo a mano antes de seguir."
fi
cat > "$SOPS_CONFIG" <<CONF
# Reglas de SOPS para este repo. Generado por scripts/sops-init.sh.
# La clave de abajo es PÚBLICA: solo sirve para cifrar. Puede estar en Git.
creation_rules:
  - path_regex: kubernetes/.*\.sops\.ya?ml$
    # Solo se cifran los valores de data/stringData: el resto del Secret
    # (nombre, namespace) queda legible para que Git muestre diffs útiles.
    encrypted_regex: ^(data|stringData)$
    age: $public_key
CONF
echo "Escrito .sops.yaml"

require_homelab_context
kubectl create namespace flux-system --dry-run=client -o yaml | kubectl apply -f - >/dev/null
kubectl -n flux-system create secret generic sops-age \
  --from-file=age.agekey="$KEY_FILE" --dry-run=client -o yaml | kubectl apply -f - >/dev/null
echo "Secret flux-system/sops-age listo: Flux ya puede descifrar."
