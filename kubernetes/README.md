# kubernetes/

Todo lo que corre **dentro** del clúster. Flux lo aplica desde esta carpeta (fase 3).

> Hecho: Flux (`clusters/homelab/`), Cilium y Headlamp (`infrastructure/`), `apps/` vacío y `examples/`.
> El resto se crea con el código de cada fase. Todo menos `examples/` lo aplica Flux desde GitHub.

```
kubernetes/
├── clusters/
│   └── homelab/               # punto de entrada de Flux: qué capas aplicar y en qué orden
├── infrastructure/            # la plataforma, compartida por todas las apps
│   ├── controllers/           # capa 1: qué componentes se instalan
│   ├── configs/               # capa 2: su configuración (dependsOn capa 1)
│   ├── cilium/                # fase 2: CNI, LB-IPAM, Hubble (Flux lo adopta en la fase 3)
│   ├── headlamp/              # fase 3: UI de Kubernetes y Flux
│   ├── cert-manager/          # fase 5: certificados Let's Encrypt por DNS-01
│   ├── traefik/               # fase 5: ingress interno
│   ├── cloudflared/           # fase 5: Cloudflare Tunnel
│   └── monitoring/            # fase 6: kube-prometheus-stack
├── apps/                      # tus servicios
└── examples/                  # manifiestos para experimentar con la guía (no son plataforma)
```

Orden: `flux-system` → `infra-controllers` → `infra-configs` → `apps`, encadenadas con `dependsOn`.
Detalle en [docs/07-gitops-flux/02-estructura.md](../docs/07-gitops-flux/02-estructura.md).

Cada componente indicará su tier (`homelab.io/tier`) y sus `requests` en sus valores de Helm, siguiendo la
[decisión 0005](../docs/decisiones/0005-nodos-heterogeneos.md).

Guía: [docs/07-gitops-flux](../docs/07-gitops-flux/README.md).
