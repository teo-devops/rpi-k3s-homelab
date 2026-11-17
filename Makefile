# rpi-k3s-homelab — atajos para no tener que recordar comandos largos.
# Escribe `make` o `make help` para ver la lista.

SHELL       := /usr/bin/env bash
ANSIBLE_DIR := ansible
INVENTORY   := inventory/hosts.yml
EXAMPLE_INV := inventory/hosts.example.yml

# Variables opcionales:
#   make prepare TAGS=kernel        -> solo un rol
#   make prepare LIMIT=rpi4-2g      -> solo un nodo
TAGS  ?=
LIMIT ?=

# Fase 2. Todo `kubectl`/`helm` lanzado desde este Makefile usa SOLO el kubeconfig
# del homelab, aunque tengas otros clústeres configurados en ~/.kube/config.
CILIUM_VERSION := 1.20.4
export KUBECONFIG := $(HOME)/.kube/rpi-k3s-homelab.yaml
# Fase 3. Clave privada de SOPS: fuera del repo.
export SOPS_AGE_KEY_FILE := $(HOME)/.config/sops/age/rpi-k3s-homelab.agekey
FILE ?=
# Sin Ansible instalado (p. ej. en el CI) se usa el de uvx.
ANSIBLE_GALAXY := $(if $(shell command -v ansible-galaxy),ansible-galaxy,uvx --from ansible-core ansible-galaxy)
ANSIBLE_ARGS := $(if $(TAGS),--tags $(TAGS)) $(if $(LIMIT),--limit $(LIMIT))

.DEFAULT_GOAL := help

.PHONY: help
help: ## Muestra esta ayuda
	@echo "rpi-k3s-homelab — objetivos disponibles:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[1m%-14s\033[0m %s\n", $$1, $$2}'

## ---------- Fase 1: preparar los nodos ----------

.PHONY: init
init: ## Crea tu inventario (hosts.yml) a partir del ejemplo
	@if [ -f $(ANSIBLE_DIR)/$(INVENTORY) ]; then \
	  echo "Ya existe $(ANSIBLE_DIR)/$(INVENTORY); no lo toco."; \
	else \
	  cp $(ANSIBLE_DIR)/$(EXAMPLE_INV) $(ANSIBLE_DIR)/$(INVENTORY); \
	  echo "Creado $(ANSIBLE_DIR)/$(INVENTORY). Edita las IPs de tus nodos."; \
	fi

.PHONY: check
check: ## Comprueba las herramientas de tu portátil
	@./scripts/check-prereqs.sh

.PHONY: deps
deps: ## Instala las colecciones de Ansible necesarias
	cd $(ANSIBLE_DIR) && $(ANSIBLE_GALAXY) collection install -r requirements.yml

.PHONY: ping
ping: ## Comprueba que Ansible llega a todos los nodos por SSH
	cd $(ANSIBLE_DIR) && ansible all -m ansible.builtin.ping $(if $(LIMIT),--limit $(LIMIT))

.PHONY: prepare-dry
prepare-dry: ## Simula la preparación sin cambiar nada (--check --diff)
	cd $(ANSIBLE_DIR) && ansible-playbook playbooks/00-prepare-nodes.yml --check --diff $(ANSIBLE_ARGS)

.PHONY: prepare
prepare: ## Prepara los nodos (SO, SSH, kernel, swap, SD...)
	cd $(ANSIBLE_DIR) && ansible-playbook playbooks/00-prepare-nodes.yml $(ANSIBLE_ARGS)

.PHONY: validate
validate: ## Verifica que los nodos están listos para K3s y Cilium
	cd $(ANSIBLE_DIR) && ansible-playbook playbooks/99-validate.yml $(if $(LIMIT),--limit $(LIMIT))

## ---------- Fase 2: K3s y Cilium ----------

.PHONY: k3s
k3s: ## Instala K3s (1 server + agents) y trae el kubeconfig
	cd $(ANSIBLE_DIR) && ansible-playbook playbooks/10-k3s.yml $(ANSIBLE_ARGS)

.PHONY: cilium
cilium: ## Instala Cilium (fase 2; desde la fase 3 lo gestiona Flux)
	CILIUM_VERSION=$(CILIUM_VERSION) ./scripts/install-cilium.sh

.PHONY: cilium-status
cilium-status: ## Estado de Cilium (necesita la CLI cilium)
	cilium status --wait

.PHONY: hubble-ui
hubble-ui: ## Abre Hubble UI en tu navegador (port-forward)
	cilium hubble ui

.PHONY: nodes
nodes: ## Nodos con su tier y su uso de recursos
	kubectl get nodes -o wide -L homelab.io/tier
	@kubectl top nodes 2>/dev/null || true

.PHONY: cluster-check
cluster-check: ## Comprobación rápida del clúster
	./scripts/validate-cluster.sh

.PHONY: k3s-uninstall
k3s-uninstall: ## BORRA K3s de todos los nodos (pide confirmación)
	cd $(ANSIBLE_DIR) && ansible-playbook playbooks/90-k3s-uninstall.yml

## ---------- Fase 3: GitOps con Flux ----------

.PHONY: sops-init
sops-init: ## Crea tu clave age, .sops.yaml y el Secret para Flux
	./scripts/sops-init.sh

.PHONY: sops-encrypt
sops-encrypt: ## Cifra un Secret: make sops-encrypt FILE=ruta.sops.yaml
	@test -n "$(FILE)" || (echo "Uso: make sops-encrypt FILE=kubernetes/apps/x/secreto.sops.yaml"; exit 1)
	sops --encrypt --in-place $(FILE)

.PHONY: flux
flux: ## Instala Flux y lo conecta con el repo de GitHub
	./scripts/flux-bootstrap.sh

.PHONY: flux-status
flux-status: ## Estado de todo lo que gestiona Flux
	@if command -v flux >/dev/null 2>&1; then flux get all -A; \
	else kubectl get gitrepositories,kustomizations,helmreleases -A; fi

.PHONY: flux-reconcile
flux-reconcile: ## Pide a Flux que lea Git ya, sin esperar
	flux reconcile kustomization flux-system --with-source

.PHONY: headlamp
headlamp: ## Abre Headlamp en http://localhost:8080 (muestra el token)
	@echo "Token de solo lectura (24 h), pégalo en Headlamp:"
	@kubectl -n headlamp create token headlamp-lector --duration=24h
	@echo
	@echo "Abre http://localhost:8080   (Ctrl+C para cerrar)"
	kubectl -n headlamp port-forward svc/headlamp 8080:80

## ---------- Calidad ----------

.PHONY: lint
lint: ## Pasa yamllint, ansible-lint y shellcheck
	uvx yamllint .
	cd $(ANSIBLE_DIR) && ANSIBLE_INVENTORY=$(EXAMPLE_INV) uvx --from ansible-lint ansible-lint playbooks/
	shellcheck -x scripts/*.sh
	./scripts/check-unencrypted-secrets.sh

.PHONY: docs-check
docs-check: ## Busca enlaces internos rotos en la documentación
	@./scripts/check-docs-links.sh

.PHONY: k8s-check
k8s-check: ## Construye y valida kubernetes/ sin clúster (kustomize + kubeconform)
	@./scripts/check-kubernetes.sh

.PHONY: ci
ci: lint docs-check k8s-check ## Todo lo que comprueba el CI de GitHub

## ---------- Fases siguientes (ver docs/README.md) ----------
# backup:     Velero (fase 4)
