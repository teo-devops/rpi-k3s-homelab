# Dominio propio

## Objetivo

Saber por qué el lab necesita un dominio y dejarlo preparado en Cloudflare antes de la fase 5.

## Conceptos

Un dominio propio (por ejemplo `tunombre.dev`) permite dos cosas:

1. **Certificados TLS válidos para servicios internos.** Let's Encrypt solo emite certificados para dominios
   que demuestras controlar. Con el reto **DNS-01**, la demostración consiste en crear un registro TXT en el
   DNS del dominio: no hace falta que Let's Encrypt pueda conectar con tu casa. cert-manager lo hace solo
   usando la API de Cloudflare. Resultado: `https://grafana.home.tunombre.dev` con candado verde, sin
   exponer nada a internet.
2. **Publicar servicios con Cloudflare Tunnel**, que exige que el dominio esté gestionado en Cloudflare.

Hasta que lo tengas, el repo usa `example.com` como marcador.

## Pasos

1. Elige un dominio. Los `.dev`, `.com` o `.es` cuestan unos 10-15 € al año.
2. Cómpralo en Cloudflare Registrar (vende a precio de coste) o en otro registrador y cambia sus servidores
   DNS a los que te indique Cloudflare.
3. En Cloudflare, activa la verificación en dos pasos de tu cuenta: quien controla el DNS controla tus certificados.
4. Cambia `homelab_domain` en [`group_vars/all.yml`](../../ansible/inventory/group_vars/all.yml).

El token de API para cert-manager se crea en la fase 5, con permisos mínimos (solo editar DNS de esa zona).

## Comprobación

```bash
dig NS tudominio.dev +short     # deben aparecer servidores *.ns.cloudflare.com
```

---
Anterior: [04 · Tailscale](04-tailscale.md) · [Índice del tema](README.md) · Siguiente tema: [04 · Ansible](../04-ansible/README.md)
