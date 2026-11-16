# 0003 · Cloudflare Tunnel para lo público, Tailscale para administrar

- **Estado**: Aceptada
- **Fecha**: 2026-11-16

## Contexto

Queremos acceder a los servicios desde fuera de casa de la forma más simple y segura. La conexión doméstica
puede no tener IP pública fija, o estar detrás de CGNAT. Abrir puertos expone el router y los servicios a
escaneos constantes.

## Decisión

- **Públicos** (solo lo que se elija): Cloudflare Tunnel. `cloudflared` corre en el clúster y abre una conexión
  saliente a Cloudflare. Lo sensible se protege además con Cloudflare Access (inicio de sesión).
- **Administración** (Grafana, Headlamp, Hubble, API de Kubernetes): solo por Tailscale.
- **Dentro de casa**: Traefik con certificado comodín de Let's Encrypt obtenido por DNS-01.

## Alternativas consideradas

| Opción | A favor | En contra |
|--------|---------|-----------|
| Abrir 80/443 en el router | Sin dependencias externas | Expone la casa a internet, no funciona con CGNAT, requiere DNS dinámico |
| Solo Tailscale | Lo más seguro | No se puede compartir un servicio con alguien que no tenga Tailscale |
| Solo Cloudflare Tunnel | Sin VPN | La administración pasaría por el mismo camino que lo público |
| WireGuard propio | Sin terceros | Requiere abrir un puerto y gestionar claves a mano |

## Consecuencias

- Dependencia de Cloudflare (DNS, túnel, certificados) y de Tailscale. Ambos tienen planes gratuitos
  suficientes para este uso.
- Hace falta un dominio propio gestionado en Cloudflare ([03/05](../03-red/05-dominio-propio.md)).
- El tráfico público pasa por Cloudflare, que termina TLS: no apto para datos que no quieras que vea un tercero.
