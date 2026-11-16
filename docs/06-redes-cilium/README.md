# 06 · Redes con Cilium

> **Pendiente: fase 2.** Este tema tiene su índice y objetivos; las páginas se escriben junto con el código
> de esa fase. Mientras tanto, las decisiones de diseño ya están en [decisiones/](../decisiones/README.md).

## Objetivos

- Entender qué hace un CNI y por qué Cilium usa eBPF en vez de iptables.
- Instalar Cilium con Helm como CNI y **sustituto de kube-proxy**.
- Configurar **LB-IPAM + L2 announcements**: IPs de LoadBalancer en tu red de casa sin MetalLB.
- Escribir las primeras **NetworkPolicy** y ver su efecto.
- Usar **Hubble** (CLI y UI) para ver el tráfico entre pods en tiempo real.

## Índice previsto

1. Qué es un CNI. Flannel frente a Cilium
2. eBPF en cinco minutos
3. Instalar Cilium (valores de Helm comentados)
4. LoadBalancer en casa: LB-IPAM y anuncios L2
5. NetworkPolicy: denegar por defecto y abrir lo necesario
6. Hubble: observar la red
7. Errores comunes

Decisiones relacionadas: [0006 Cilium LB frente a MetalLB](../decisiones/0006-cilium-lb-vs-metallb.md).

Anterior tema: [05 · Kubernetes con K3s](../05-kubernetes-k3s/README.md) · Siguiente tema: [07 · GitOps con Flux](../07-gitops-flux/README.md)
