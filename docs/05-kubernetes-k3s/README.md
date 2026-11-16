# 05 · Kubernetes con K3s

> **Pendiente: fase 2.** Este tema tiene su índice y objetivos; las páginas se escriben junto con el código
> de esa fase. Mientras tanto, las decisiones de diseño ya están en [decisiones/](../decisiones/README.md).

## Objetivos

- Instalar K3s en el server (`rpi5-8g`) y unir los agents con su token.
- Instalarlo **sin** sus piezas de red por defecto, porque las sustituye Cilium:
  `--flannel-backend=none --disable-network-policy --disable-kube-proxy --disable=servicelb --disable=traefik`.
- Aplicar las etiquetas `homelab.io/tier` y las reservas del kubelet definidas en `host_vars`.
- Obtener el kubeconfig en tu portátil y entender qué contiene.

## Índice previsto

1. Qué es K3s y qué trae de serie (y qué le quitamos)
2. Server y agents: el token y cómo se unen los nodos
3. Instalar con Ansible (`playbooks/10-k3s.yml`)
4. Etiquetas, reservas y allocatable: leer `kubectl describe node`
5. Scheduling por memoria: afinidad de nodo con ejemplos
6. Errores comunes

Decisiones relacionadas: [0001 SQLite frente a etcd](../decisiones/0001-sqlite-vs-etcd.md),
[0005 nodos heterogéneos](../decisiones/0005-nodos-heterogeneos.md).

Anterior tema: [04 · Ansible](../04-ansible/README.md) · Siguiente tema: [06 · Redes con Cilium](../06-redes-cilium/README.md)
