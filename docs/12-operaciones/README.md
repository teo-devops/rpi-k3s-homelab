# 12 · Operaciones

Tareas del día a día. Este tema crece con cada fase.

## Disponible ya

- Volver a aplicar la configuración de los nodos: `make prepare` (idempotente, ver [04/04](../04-ansible/04-preparar-los-nodos.md)).
- Comprobar el estado de los nodos: `make validate`.
- Comprobar temperatura y alimentación: [01/04](../01-hardware/04-alimentacion-y-refrigeracion.md#comprobación).
- Reconstruir un nodo desde cero: reflashear la SD y `make prepare LIMIT=<nodo>`.
- Comprobación rápida del clúster (desde la fase 2): `./scripts/validate-cluster.sh`.

## Índice previsto

1. Apagar y encender el clúster en orden (fase 2)
2. Actualizar el sistema operativo nodo a nodo sin cortar servicio (fase 2)
3. Actualizar K3s (fase 2)
4. Actualizar componentes con Flux y Renovate (fase 3)
5. Restaurar desde copia (fase 4)
6. Guía de diagnóstico: de "no funciona" a la causa

Anterior tema: [11 · Service mesh](../11-service-mesh/README.md) · Volver al [inicio](../README.md)
