# 08 · Almacenamiento

> **Pendiente: fase 4.** Este tema tiene su índice y objetivos; las páginas se escriben junto con el código
> de esa fase. Mientras tanto, las decisiones de diseño ya están en [decisiones/](../decisiones/README.md).

## Objetivos

- Entender PersistentVolume, PersistentVolumeClaim y StorageClass.
- Usar **local-path** (de serie en K3s) y fijar con afinidad los workloads con estado a su nodo.
- Hacer copias de los volúmenes con **Velero + Kopia** a un almacenamiento S3 externo.
- Migrar a **NVMe** en las Pi 5 y, opcionalmente, **Longhorn** con réplica entre ellas.

## Índice previsto

1. Volúmenes en Kubernetes: PV, PVC y StorageClass
2. local-path: cómo funciona y su gran limitación (un volumen = un nodo)
3. Afinidad para workloads con estado
4. Copias de seguridad con Velero
5. Pasar a NVMe: datos de K3s y arranque desde NVMe (EEPROM)
6. Longhorn en las Pi 5: cuándo merece la pena
7. Errores comunes

Decisiones relacionadas: [0004 local-path ahora, NVMe después](../decisiones/0004-local-path-ahora-nvme-despues.md).

Anterior tema: [07 · GitOps con Flux](../07-gitops-flux/README.md) · Siguiente tema: [09 · Exposición y seguridad](../09-exposicion-y-seguridad/README.md)
