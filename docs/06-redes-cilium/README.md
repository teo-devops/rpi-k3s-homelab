# 06 · Redes con Cilium

La red del clúster con eBPF: conectar pods, implementar Services sin kube-proxy, dar IPs de tu LAN a los
servicios sin MetalLB, filtrar tráfico y verlo todo con Hubble.

| Página | Contenido |
|--------|-----------|
| [01 · Qué es un CNI](01-que-es-un-cni.md) | El problema que resuelve la red de pods |
| [02 · eBPF en cinco minutos](02-ebpf.md) | Por qué Cilium no usa iptables |
| [03 · Instalar Cilium](03-instalar-cilium.md) | `make cilium` y cada valor de Helm explicado |
| [04 · LoadBalancer en casa](04-loadbalancer-en-casa.md) | LB-IPAM y anuncios L2 con un ejemplo |
| [05 · NetworkPolicy](05-networkpolicy.md) | Denegar por defecto y abrir lo justo |
| [06 · Hubble](06-hubble.md) | Ver el tráfico y los paquetes descartados |
| [07 · Errores comunes](07-errores-comunes.md) | Qué hacer cuando algo falla |

Requisito: K3s instalado ([05/03](../05-kubernetes-k3s/03-instalar.md)), con los nodos en `NotReady`.

Decisiones relacionadas: [0006 Cilium LB frente a MetalLB](../decisiones/0006-cilium-lb-vs-metallb.md).

Anterior tema: [05 · Kubernetes con K3s](../05-kubernetes-k3s/README.md) · Siguiente tema: [07 · GitOps con Flux](../07-gitops-flux/README.md)
