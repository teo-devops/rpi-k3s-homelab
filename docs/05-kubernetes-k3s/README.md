# 05 · Kubernetes con K3s

Instalar Kubernetes en los tres nodos, sin sus piezas de red (las pone Cilium en el tema 06), y aplicar el
reparto por memoria.

| Página | Contenido |
|--------|-----------|
| [01 · Qué es K3s](01-que-es-k3s.md) | Qué trae de serie y qué le quitamos |
| [02 · Server y agents](02-server-y-agents.md) | Cómo se unen los nodos: el token |
| [03 · Instalar](03-instalar.md) | `make k3s` paso a paso y el fichero de configuración |
| [04 · Etiquetas, reservas y allocatable](04-etiquetas-y-reservas.md) | Leer `kubectl describe node` |
| [05 · Scheduling por memoria](05-scheduling-por-memoria.md) | Afinidad de nodo con un ejemplo real |
| [06 · Errores comunes](06-errores-comunes.md) | Qué hacer cuando algo falla |

Requisito: fase 1 terminada (`make validate` en verde en los tres nodos).

Decisiones relacionadas: [0001 SQLite frente a etcd](../decisiones/0001-sqlite-vs-etcd.md),
[0005 nodos heterogéneos](../decisiones/0005-nodos-heterogeneos.md).

Anterior tema: [04 · Ansible](../04-ansible/README.md) · Siguiente tema: [06 · Redes con Cilium](../06-redes-cilium/README.md)
