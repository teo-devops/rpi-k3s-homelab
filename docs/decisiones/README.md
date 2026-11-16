# Decisiones de diseño (ADR)

Un **ADR** (Architecture Decision Record) es una nota corta que registra una decisión: el contexto, lo que se
eligió, lo que se descartó y sus consecuencias. Sirven para que dentro de un año sepas **por qué** el lab es
así, y para que quien lo lea pueda estar en desacuerdo con argumentos.

| # | Decisión | Estado |
|---|----------|--------|
| [0001](0001-sqlite-vs-etcd.md) | Un server con SQLite en lugar de tres con etcd | Aceptada |
| [0002](0002-flux.md) | Flux como motor de GitOps | Aceptada |
| [0003](0003-tunnel-y-tailscale.md) | Cloudflare Tunnel para lo público, Tailscale para administrar | Aceptada |
| [0004](0004-local-path-ahora-nvme-despues.md) | local-path en SD ahora, NVMe después | Aceptada |
| [0005](0005-nodos-heterogeneos.md) | Repartir carga por tiers de memoria | Aceptada |
| [0006](0006-cilium-lb-vs-metallb.md) | Cilium (CNI, kube-proxy y LoadBalancer) en lugar de Flannel y MetalLB | Aceptada |
| [0007](0007-headlamp-como-ui.md) | Headlamp como interfaz para Kubernetes y Flux | Aceptada |
| [0008](0008-service-mesh.md) | Service mesh: Cilium primero, Linkerd para comparar | Aceptada |

Para añadir una: copia [la plantilla](plantilla.md) con el siguiente número.
