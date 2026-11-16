# kubernetes/

Todo lo que corre **dentro** del clúster. Flux lo aplica desde esta carpeta (fase 3).

> **Pendiente: fases 2 a 7.** Aquí está la estructura prevista; las carpetas se crean con el código de cada fase.

```
kubernetes/
├── clusters/
│   └── homelab/               # punto de entrada de Flux: qué capas aplicar y en qué orden
├── infrastructure/            # la plataforma, compartida por todas las apps
│   ├── cilium/                # fase 2: CNI, LB-IPAM, Hubble
│   ├── headlamp/              # fase 3: UI de Kubernetes y Flux
│   ├── cert-manager/          # fase 5: certificados Let's Encrypt por DNS-01
│   ├── traefik/               # fase 5: ingress interno
│   ├── cloudflared/           # fase 5: Cloudflare Tunnel
│   └── monitoring/            # fase 6: kube-prometheus-stack
└── apps/                      # tus servicios
```

Orden de dependencias: `cilium` → `cert-manager` → `traefik` → resto. Flux lo garantiza con `dependsOn`.

Cada componente indicará su tier (`homelab.io/tier`) y sus `requests` en sus valores de Helm, siguiendo la
[decisión 0005](../docs/decisiones/0005-nodos-heterogeneos.md).

Guía: [docs/07-gitops-flux](../docs/07-gitops-flux/README.md).
