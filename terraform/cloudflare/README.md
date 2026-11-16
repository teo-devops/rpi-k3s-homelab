# terraform/cloudflare/

Opcional. Gestiona como código lo que vive en Cloudflare, fuera de casa:

- Registros DNS públicos de los servicios publicados.
- El Cloudflare Tunnel y sus rutas.
- Las aplicaciones de Cloudflare Access que protegen lo sensible.
- El token de API con permisos mínimos para cert-manager.

> **Pendiente: fase 5.** Hasta entonces, todo esto se puede hacer desde el panel de Cloudflare siguiendo
> [docs/09-exposicion-y-seguridad](../../docs/09-exposicion-y-seguridad/README.md).

El estado de Terraform (`*.tfstate`) y las variables con credenciales (`*.tfvars`) están en `.gitignore`.
