# Convenciones

## Objetivo

Conocer las reglas que sigue todo el repo para no tener que adivinarlas.

## Nombres

- **Nodos**: `rpi<modelo>-<RAM>g`. Dicen qué son sin abrir ningún fichero: `rpi4-2g` es la Pi 4 de 2 GB.
- **Etiquetas de Kubernetes propias**: prefijo `homelab.io/`, por ejemplo `homelab.io/tier=large`.
- **Dominio**: `example.com` es un marcador. Lo cambias en
  [`ansible/inventory/group_vars/all.yml`](../../ansible/inventory/group_vars/all.yml) cuando tengas el tuyo.
  Los servicios internos cuelgan de `*.home.<dominio>`.

## Estructura del repo

| Carpeta | Contenido |
|---------|-----------|
| `ansible/` | Preparación de los nodos (sistema operativo) e instalación de K3s |
| `kubernetes/` | Todo lo que vive dentro del clúster. Flux lo aplica desde Git |
| `terraform/` | Recursos fuera de casa: DNS y túnel en Cloudflare (opcional) |
| `scripts/` | Comprobaciones de apoyo |
| `docs/` | Esta guía |

## Ficheros que no se suben a Git

El repo es público. Lo que identifica tu red o da acceso no se sube nunca:

- `ansible/inventory/hosts.yml` (tus IPs). Se genera con `make init` desde `hosts.example.yml`.
- Claves, kubeconfig, ficheros `.env`, estado de Terraform. Ver [`.gitignore`](../../.gitignore).
- Los secretos que sí deban vivir en Git irán **cifrados** con SOPS (fase 3).

## Formato de la guía

- Comandos que se ejecutan **en tu portátil** empiezan en la raíz del repo:

  ```bash
  make prepare
  ```

- Comandos que se ejecutan **en un nodo** indican antes dónde:

  ```bash
  ssh homelab@192.168.1.11
  free -h
  ```

- Los valores que debes cambiar por los tuyos aparecen como `192.168.1.x` o `example.com`.

---
Anterior: [03 · Arquitectura](03-arquitectura.md) · [Índice del tema](README.md) · Siguiente tema: [01 · Hardware](../01-hardware/README.md)
