# Flujo de trabajo

## Objetivo

Hacer el ciclo completo de GitOps: añadir una aplicación, cambiarla, ver cómo Flux corrige una desviación
y deshacer con Git.

## Conceptos

```
editar en kubernetes/  ->  make lint  ->  git commit  ->  git push  ->  Flux (≤ 1 min)  ->  clúster
```

Flux mira GitHub cada minuto. Si no quieres esperar: `make flux-reconcile`.

## Pasos

### 1. Añadir una aplicación

Usa el ejemplo de LoadBalancer del tema 06 como primera app gestionada por Flux:

```bash
mkdir -p kubernetes/apps/whoami
cp kubernetes/examples/whoami-lb.yaml kubernetes/apps/whoami/
```

Crea `kubernetes/apps/whoami/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - whoami-lb.yaml
```

Y añádela a [`kubernetes/apps/kustomization.yaml`](../../kubernetes/apps/kustomization.yaml):

```yaml
resources:
  - whoami
```

Comprueba y sube:

```bash
kubectl kustomize kubernetes/apps      # ¿compila?
make lint
git add kubernetes/apps && git commit -m "apps: whoami" && git push
make flux-reconcile
kubectl -n demo get pods,svc
```

### 2. Cambiarla

Cambia `replicas: 2` por `replicas: 3` en `kubernetes/apps/whoami/whoami-lb.yaml`, commit, push, y mira cómo
aparece el tercer pod.

### 3. Desviación: Flux corrige

Cambia algo a mano, sin Git:

```bash
kubectl -n demo scale deployment whoami --replicas=1
```

En el siguiente ciclo de la Kustomization `apps` (como mucho 10 minutos, o al momento con
`flux reconcile kustomization apps`), Flux vuelve a dejar 3 réplicas. Lo que manda es Git.

### 4. Deshacer con Git

```bash
git revert HEAD && git push
```

Vuelve a 2 réplicas. Para quitar la app entera, bórrala de `apps/kustomization.yaml` y de su carpeta: con
`prune: true`, Flux elimina del clúster todo lo que creó para ella.

### 5. Pausar Flux

Para hacer pruebas a mano sin que Flux las deshaga:

```bash
flux suspend kustomization apps
# ... pruebas ...
flux resume kustomization apps
```

## Comprobación

```bash
make flux-status
flux events --for Kustomization/apps
```

---
Anterior: [06 · Headlamp](06-headlamp.md) · [Índice del tema](README.md) · Siguiente: [08 · Errores comunes](08-errores-comunes.md)
