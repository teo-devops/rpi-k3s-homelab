# Qué es K3s

## Objetivo

Saber qué es K3s, qué lo diferencia de Kubernetes "a secas" y qué componentes desactivamos.

## Conceptos

**K3s** es Kubernetes certificado, empaquetado en un único binario de unos 70 MB. Es el mismo Kubernetes
(las mismas APIs, los mismos `kubectl` y manifiestos), pero:

- Todo el control plane (API server, scheduler, controladores) corre en **un solo proceso**.
- Usa **SQLite** como base de datos por defecto, en lugar de etcd ([decisión 0001](../decisiones/0001-sqlite-vs-etcd.md)).
- Trae de serie lo que un clúster pequeño suele necesitar.

Lo que trae y lo que hacemos con cada cosa:

| Componente de serie | Para qué sirve | En este lab |
|---------------------|----------------|-------------|
| containerd | Ejecuta los contenedores | Se queda |
| CoreDNS | DNS interno (`servicio.namespace.svc`) | Se queda |
| metrics-server | `kubectl top` | Se queda |
| local-path-provisioner | Volúmenes en el disco del nodo | Se queda ([tema 08](../08-almacenamiento/README.md)) |
| Flannel | Red de pods (CNI) | **Fuera**: lo sustituye Cilium |
| Network policy controller | Aplicar NetworkPolicy | **Fuera**: lo hace Cilium |
| kube-proxy | Implementar los Services con iptables | **Fuera**: lo hace Cilium con eBPF |
| ServiceLB (Klipper) | Services LoadBalancer | **Fuera**: lo hace Cilium LB-IPAM |
| Traefik | Ingress | **Fuera** por ahora: lo instalaremos con Flux (fase 5) para controlar su versión |

¿Por qué quitar tanto? Porque Cilium hace lo mismo de forma más eficiente y observable, y tener dos
componentes compitiendo por la misma tarea (por ejemplo, Flannel y Cilium) rompe la red.
Ver [decisión 0006](../decisiones/0006-cilium-lb-vs-metallb.md).

## Consecuencia importante

Sin Flannel, recién instalado K3s **no hay red de pods**. Los nodos aparecerán `NotReady` y CoreDNS se
quedará `Pending` hasta instalar Cilium. No es un error: es el estado esperado entre `make k3s` y `make cilium`.

---
[Índice del tema](README.md) · Siguiente: [02 · Server y agents](02-server-y-agents.md)
