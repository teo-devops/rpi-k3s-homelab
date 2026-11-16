# Tailscale

## Objetivo

Entender cómo administrarás el clúster desde fuera de casa. Se instala en la fase 5.

## Conceptos

**Tailscale** es una VPN basada en WireGuard que no necesita abrir puertos: cada dispositivo establece
conexiones salientes y Tailscale coordina cómo encontrarse. Tus dispositivos forman una red privada
llamada *tailnet*.

El diseño previsto:

- Un nodo (`rpi5-8g`) actúa como **subnet router**: anuncia a la tailnet la red de casa (`192.168.1.0/24`).
- Desde tu portátil, conectado a Tailscale en cualquier sitio, llegas a los nodos y a las IPs de
  LoadBalancer como si estuvieras en casa. Las mismas URLs, el mismo `kubectl`.
- Las herramientas de administración (Grafana, Headlamp, Hubble UI, API de Kubernetes) **solo** se
  publican así, nunca por Cloudflare Tunnel.

Por qué separar: lo público (Tunnel) y lo de administración (Tailscale) tienen riesgos distintos. Si un
servicio público tuviera una vulnerabilidad, las herramientas de administración no están en el mismo camino.
Ver [decisión 0003](../decisiones/0003-tunnel-y-tailscale.md).

## Pasos previos que puedes hacer ya

1. Crea una cuenta gratuita en Tailscale (el plan personal cubre de sobra este uso).
2. Instala el cliente en tu portátil y en tu móvil.

El resto, en [09 · Exposición y seguridad](../09-exposicion-y-seguridad/README.md).

---
Anterior: [03 · DNS local](03-dns-local.md) · [Índice del tema](README.md) · Siguiente: [05 · Dominio propio](05-dominio-propio.md)
