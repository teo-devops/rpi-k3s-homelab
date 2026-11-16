#!/usr/bin/env bash
# Comprueba que tu ordenador tiene lo necesario para trabajar con el homelab.
# No instala nada: solo dice qué falta y cómo conseguirlo.
# Uso: make check   (o ./scripts/check-prereqs.sh)
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
missing=0

ok()   { printf '  [ OK ]   %s\n' "$1"; }
warn() { printf '  [AVISO]  %s\n' "$1"; }
fail() { printf '  [FALTA]  %s\n' "$1"; missing=$((missing + 1)); }

need() {  # need <comando> <para qué> <cómo instalarlo>
  if command -v "$1" >/dev/null 2>&1; then ok "$1 — $2"; else fail "$1 — $2. Instalar: $3"; fi
}
optional() {  # optional <comando> <fase> <cómo instalarlo>
  if command -v "$1" >/dev/null 2>&1; then ok "$1 — $2"; else warn "$1 — $2 (aún no hace falta). Instalar: $3"; fi
}

echo "Fase 1 — preparar nodos"
need ansible-playbook "automatiza la configuración de las Pi" "pipx install --include-deps ansible"
need ssh "acceso a los nodos" "paquete openssh-client"
need make "atajos del Makefile" "paquete make"

if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
  ok "clave SSH ~/.ssh/id_ed25519.pub"
else
  fail "clave SSH ~/.ssh/id_ed25519.pub. Crear: ssh-keygen -t ed25519"
fi

if [ -f "$REPO_ROOT/ansible/inventory/hosts.yml" ]; then
  ok "inventario ansible/inventory/hosts.yml"
else
  fail "inventario ansible/inventory/hosts.yml. Crear: make init"
fi

if command -v ansible-galaxy >/dev/null 2>&1; then
  for c in ansible.posix community.general; do
    if ansible-galaxy collection list "$c" 2>/dev/null | grep -q "^$c "; then
      ok "colección $c"
    else
      fail "colección $c. Instalar: make deps"
    fi
  done
fi

echo
echo "Fase 2 — K3s y Cilium"
optional kubectl "hablar con el clúster" "https://kubernetes.io/docs/tasks/tools/"
optional helm "instalar Cilium" "https://helm.sh/docs/intro/install/"
optional cilium "estado de Cilium y Hubble" "https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/#install-the-cilium-cli"
optional hubble "consultar flujos de red" "https://docs.cilium.io/en/stable/observability/hubble/setup/#install-the-hubble-client"
if [ -f "$HOME/.kube/rpi-k3s-homelab.yaml" ]; then
  ok "kubeconfig ~/.kube/rpi-k3s-homelab.yaml"
else
  warn "kubeconfig ~/.kube/rpi-k3s-homelab.yaml (aún no hace falta). Lo crea: make k3s"
fi

echo
echo "Fases siguientes"
optional flux "fase 3, GitOps" "https://fluxcd.io/flux/installation/"
optional sops "fase 3, cifrar secretos" "https://github.com/getsops/sops/releases"
optional age "fase 3, claves de cifrado" "paquete age"

echo
echo "Calidad (opcional)"
optional uvx "ejecutar yamllint y ansible-lint sin instalarlos" "https://docs.astral.sh/uv/"
optional shellcheck "revisar scripts" "paquete shellcheck"

echo
if [ "$missing" -eq 0 ]; then
  echo "Todo listo para la fase 1. Siguiente: make ping"
else
  echo "Faltan $missing cosas para la fase 1 (marcadas como [FALTA])."
  exit 1
fi
