# examples/

Manifiestos para experimentar mientras sigues la guía. No forman parte de la plataforma: se aplican y se
borran a mano. Todos usan el namespace `demo`.

| Fichero | Para qué | Guía |
|---------|----------|------|
| `scheduling-demo.yaml` | Ver la afinidad por tier en acción | [05/05](../../docs/05-kubernetes-k3s/05-scheduling-por-memoria.md) |
| `whoami-lb.yaml` | Un Service LoadBalancer con IP de tu LAN | [06/04](../../docs/06-redes-cilium/04-loadbalancer-en-casa.md) |
| `netpol-demo.yaml` | Denegar por defecto y abrir lo justo | [06/05](../../docs/06-redes-cilium/05-networkpolicy.md) |

Limpiar todo: `kubectl delete namespace demo`.
