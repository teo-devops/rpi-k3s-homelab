# 09 · Exposición y seguridad

> **Pendiente: fase 5.** Este tema tiene su índice y objetivos; las páginas se escriben junto con el código
> de esa fase. Mientras tanto, las decisiones de diseño ya están en [decisiones/](../decisiones/README.md).

## Objetivos

- Instalar **Traefik** como ingress interno con IP de LoadBalancer.
- Emitir un certificado comodín `*.home.<dominio>` con **cert-manager** y el reto **DNS-01** de Cloudflare.
- Configurar el DNS local hacia Traefik.
- Publicar servicios concretos con **Cloudflare Tunnel** (sin abrir puertos) y protegerlos con Cloudflare Access.
- Instalar **Tailscale** como subnet router para administrar desde fuera.
- (Opcional) Gestionar DNS y túnel de Cloudflare con **Terraform**.

## Índice previsto

1. Los tres caminos del tráfico (casa, tú desde fuera, público)
2. Traefik: IngressRoute y middlewares
3. cert-manager y DNS-01: token de Cloudflare con permisos mínimos
4. DNS local con comodín
5. Cloudflare Tunnel con cloudflared
6. Cloudflare Access delante de lo sensible
7. Tailscale subnet router
8. Terraform para Cloudflare
9. Errores comunes

Requisito previo: [dominio propio](../03-red/05-dominio-propio.md).
Decisiones relacionadas: [0003 Tunnel y Tailscale](../decisiones/0003-tunnel-y-tailscale.md).

Anterior tema: [08 · Almacenamiento](../08-almacenamiento/README.md) · Siguiente tema: [10 · Monitorización](../10-monitorizacion/README.md)
