# 07 · GitOps con Flux

> **Pendiente: fase 3.** Este tema tiene su índice y objetivos; las páginas se escriben junto con el código
> de esa fase. Mientras tanto, las decisiones de diseño ya están en [decisiones/](../decisiones/README.md).

## Objetivos

- Entender GitOps: Git es la fuente de verdad y el clúster se reconcilia solo.
- Hacer el bootstrap de Flux apuntando a la carpeta `kubernetes/` de este repo.
- Cifrar secretos con **SOPS + age** para poder guardarlos en un repo público.
- Instalar **Headlamp** con su plugin de Flux como interfaz gráfica.

## Índice previsto

1. Qué es GitOps y qué problema resuelve
2. Estructura de `kubernetes/`: clusters, infrastructure, apps
3. Bootstrap de Flux
4. Secretos con SOPS y age
5. Headlamp: ver el clúster y el estado de Flux
6. Flujo de trabajo: cambiar algo con un commit
7. Errores comunes

Decisiones relacionadas: [0002 Flux](../decisiones/0002-flux.md), [0007 Headlamp como UI](../decisiones/0007-headlamp-como-ui.md).

Anterior tema: [06 · Redes con Cilium](../06-redes-cilium/README.md) · Siguiente tema: [08 · Almacenamiento](../08-almacenamiento/README.md)
