# Errores comunes

## Objetivo

Diagnosticar por qué Flux no aplica lo que esperas.

## Método

Flux siempre dice qué le pasa. Sigue la cadena de arriba abajo y para en el primer `False`:

```bash
make flux-status
flux logs --level=error --since=10m
```

Orden: `gitrepository/flux-system` → `kustomization/flux-system` → `infra-controllers` → `infra-configs` →
`apps` → cada `helmrelease`.

## Tabla de síntomas

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| `make flux`: "no puedo leer la rama main" | Repo no creado, privado, o sin push | Crea el repo público y `git push` |
| GitRepository `False`: autenticación | El repo es privado | Hazlo público, o configura una clave de despliegue (fuera de esta guía) |
| No aplica tu último cambio | No has hecho push, o no ha pasado el intervalo | `git status`; `make flux-reconcile` |
| Kustomization: `kustomize build failed` | Error de sintaxis o fichero no listado | `kubectl kustomize <carpeta>` en tu portátil muestra el error exacto |
| Kustomization: `dependency ... is not ready` | Una capa anterior falla | Arregla primero la capa de la que depende |
| `decryption failed` / `sops-age` not found | Falta el Secret de la clave | `make sops-init` |
| `variable K8S_SERVICE_HOST not set` o Cilium sin IP de API | Falta el ConfigMap `cluster-vars` | `make flux` lo vuelve a crear |
| HelmRelease `install retries exhausted` | El chart falla al instalar | `kubectl -n <ns> describe helmrelease <nombre>` y los eventos de sus pods |
| Headlamp sin menú Flux | El initContainer no pudo descargar el plugin | `kubectl -n headlamp logs deploy/headlamp -c plugin-flux` |
| Un `kubectl edit` desaparece | Es GitOps funcionando | Haz el cambio en Git o suspende la Kustomization |

## Volver a empezar

Desinstalar Flux sin tocar lo que gestiona:

```bash
flux uninstall --keep-namespace
```

Los recursos aplicados (Cilium, Headlamp...) siguen en el clúster; `make flux` los vuelve a adoptar.

---
Anterior: [07 · Flujo de trabajo](07-flujo-de-trabajo.md) · [Índice del tema](README.md) · Siguiente tema: [08 · Almacenamiento](../08-almacenamiento/README.md)
