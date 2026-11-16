# 12 · Operaciones

Tareas del día a día. Este tema crece con cada fase.

## Disponible ya

- Volver a aplicar la configuración de los nodos: `make prepare` (idempotente, ver [04/04](../04-ansible/04-preparar-los-nodos.md)).
- Comprobar el estado de los nodos: `make validate`.
- Comprobar temperatura y alimentación: [01/04](../01-hardware/04-alimentacion-y-refrigeracion.md#comprobación).
- Reconstruir un nodo desde cero: reflashear la SD y `make prepare LIMIT=<nodo>`.
- Comprobación rápida del clúster: `make cluster-check`.
- Cambiar reservas o tier de un nodo: edita su `host_vars` y `make k3s LIMIT=<nodo>` ([05/04](../05-kubernetes-k3s/04-etiquetas-y-reservas.md)).
- Actualizar K3s: comprueba la compatibilidad con Cilium, cambia `k3s_version` y `make k3s`. El playbook
  actualiza primero el server y luego los agents.
- Actualizar Cilium: cambia `CILIUM_VERSION` en el Makefile y `make cilium` ([06/03](../06-redes-cilium/03-instalar-cilium.md#actualizar-cilium)).
- Empezar el clúster de cero: `make k3s-uninstall` y `make k3s`.

## Índice previsto

1. Apagar y encender el clúster en orden (fase 2)
2. Actualizar el sistema operativo nodo a nodo sin cortar servicio (`kubectl drain`)
3. Actualizar K3s con más detalle: drenar nodos, orden, vuelta atrás
4. Actualizar componentes con Flux y Renovate (fase 3)
5. Restaurar desde copia (fase 4)
6. Guía de diagnóstico: de "no funciona" a la causa

Anterior tema: [11 · Service mesh](../11-service-mesh/README.md) · Volver al [inicio](../README.md)
