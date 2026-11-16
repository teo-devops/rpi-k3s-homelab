# DNS local

## Objetivo

Entender cómo se resolverán nombres como `grafana.home.example.com` dentro de casa. La configuración se
hace en la fase 5; aquí está el diseño.

## Conceptos

Todas las aplicaciones web entran por **Traefik**, que tendrá una IP de LoadBalancer (por ejemplo
`192.168.1.200`). Traefik mira el nombre pedido y reenvía a la aplicación correcta. Por tanto, basta con
que **todos** los nombres `*.home.example.com` apunten a esa IP: un registro comodín (wildcard).

```
*.home.example.com  →  192.168.1.200 (Traefik)  →  grafana, headlamp, tus apps...
```

¿Dónde se crea ese registro? Opciones:

| Opción | Ventaja | Inconveniente |
|--------|---------|---------------|
| DNS del router | Sin piezas nuevas | Muchos routers domésticos no permiten registros propios |
| Pi-hole | Además bloquea publicidad; admite comodines con una línea de dnsmasq | Una pieza más que mantener |
| DNS público (Cloudflare) apuntando a una IP privada | Funciona en cualquier red sin configurar nada | Publica tu IP interna (dato poco sensible, pero visible) |

La decisión se toma en la fase 5. Con Pi-hole, el comodín es una línea de configuración de dnsmasq:

```
address=/home.example.com/192.168.1.200
```

**Por qué no `.local` ni un dominio inventado**: `.local` está reservado para mDNS y da conflictos, y un
dominio inventado no puede tener certificados de Let's Encrypt. Por eso usamos un subdominio de un dominio
real. Ver [dominio propio](05-dominio-propio.md).

---
Anterior: [02 · Reserva DHCP](02-reserva-dhcp.md) · [Índice del tema](README.md) · Siguiente: [04 · Tailscale](04-tailscale.md)
