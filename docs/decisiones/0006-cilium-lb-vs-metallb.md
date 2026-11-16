# 0006 · Cilium (CNI, kube-proxy y LoadBalancer) en lugar de Flannel y MetalLB

- **Estado**: Aceptada
- **Fecha**: 2026-11-16

## Contexto

K3s trae Flannel (red de pods), kube-proxy (Services), ServiceLB (LoadBalancer básico) y una
NetworkPolicy mínima. Queremos aprender redes modernas con eBPF, observar el tráfico y tener IPs de
LoadBalancer estables en la red de casa, con el menor número de piezas.

## Decisión

Cilium como única pieza de red: CNI, sustituto de kube-proxy, NetworkPolicy, **LB-IPAM + L2 announcements**
para LoadBalancer, y Hubble para observar. K3s se instala con sus componentes de red desactivados.

## Alternativas consideradas

| Opción | A favor | En contra |
|--------|---------|-----------|
| Flannel + ServiceLB (por defecto) | Cero configuración | ServiceLB usa las IPs de los nodos; sin NetworkPolicy completa; poco que aprender |
| Flannel + MetalLB | MetalLB es el estándar clásico y muy documentado | Una pieza más; no aporta observabilidad |
| Cilium + MetalLB | Separación de responsabilidades | Duplica lo que Cilium ya hace |
| Cilium completo | Una sola pieza, eBPF, Hubble, base para service mesh | Más complejo de depurar; ~200 MB por nodo; requisitos de kernel ([02/04](../02-sistema-operativo/04-paginas-4k-y-btf.md)) |

## Consecuencias

- La fase 1 prepara el kernel para Cilium (páginas de 4 KB, comprobación de BTF, `rp_filter`).
- Si un día cambias de CNI, MetalLB es la opción para LoadBalancer.
- Los anuncios L2 funcionan como MetalLB en modo L2: una IP la "posee" un nodo cada vez; si cae, otro la toma.
