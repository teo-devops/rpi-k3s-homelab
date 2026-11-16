# 07 · GitOps con Flux

A partir de aquí, el clúster se configura con commits. Flux lee este repo en GitHub y hace que el clúster
coincida con lo que hay en `kubernetes/`.

| Página | Contenido |
|--------|-----------|
| [01 · Qué es GitOps](01-que-es-gitops.md) | El cambio de mentalidad: de `kubectl apply` a `git push` |
| [02 · Estructura de kubernetes/](02-estructura.md) | Capas, orden de aplicación y por qué |
| [03 · Bootstrap](03-bootstrap.md) | Subir el repo e instalar Flux con `make flux` |
| [04 · Flux adopta Cilium](04-flux-adopta-cilium.md) | Pasar un componente de "a mano" a GitOps sin cortar la red |
| [05 · Secretos con SOPS](05-secretos-sops.md) | Guardar contraseñas cifradas en un repo público |
| [06 · Headlamp](06-headlamp.md) | Ver el clúster y Flux en el navegador |
| [07 · Flujo de trabajo](07-flujo-de-trabajo.md) | Añadir una app, cambiar algo, deshacerlo |
| [08 · Errores comunes](08-errores-comunes.md) | Qué hacer cuando Flux no sincroniza |

Requisito: fase 2 terminada (nodos `Ready`, Cilium funcionando) y una cuenta de GitHub.

Decisiones relacionadas: [0002 Flux](../decisiones/0002-flux.md), [0007 Headlamp como UI](../decisiones/0007-headlamp-como-ui.md).

Anterior tema: [06 · Redes con Cilium](../06-redes-cilium/README.md) · Siguiente tema: [08 · Almacenamiento](../08-almacenamiento/README.md)
