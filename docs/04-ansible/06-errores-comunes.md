# Errores comunes

## Objetivo

Resolver los fallos típicos de la fase 1 sin perder una tarde.

## Conexión

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| `UNREACHABLE ... Permission denied (publickey)` | Usuario o clave incorrectos | Revisa `ansible_user` en `group_vars/all.yml`; prueba `ssh homelab@<ip>` a mano |
| `UNREACHABLE ... Host key verification failed` | Nodo reflasheado, huella cambiada | `ssh-keygen -R <ip>` y vuelve a conectar a mano una vez |
| `Missing sudo password` | El usuario pide contraseña para sudo | Ejecuta con `-K` o configura sudo sin contraseña para ese usuario (Imager lo hace por defecto) |
| `couldn't resolve module/action 'community.general...'` | Faltan colecciones | `make deps` |

## Durante la preparación

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| Falla "Exigir un sistema de 64 bits" | SD con sistema de 32 bits | Reflashea con Raspberry Pi OS Lite (64-bit) |
| `apt` falla con `Could not get lock` | Actualización automática en curso tras el primer arranque | Espera 5 minutos y relanza |
| El reinicio supera el tiempo de espera | El nodo no vuelve | Mira si arranca (LED, pantalla). Revisa el final de `config.txt` desde otro equipo |
| Falla "Validar configuración de sshd" | Error en la configuración de SSH | sshd no se ha reiniciado, sigues dentro. Revisa `/etc/ssh/sshd_config.d/10-homelab.conf` |

## Durante la validación

| Comprobación fallida | Solución |
|----------------------|----------|
| `memory` no está en cgroups | `cat /boot/firmware/cmdline.txt` debe incluir `cgroup_enable=memory`. ¿Se reinició el nodo? |
| PAGESIZE no es 4096 | Pi 5: busca `kernel=kernel8.img` al final de `config.txt` y reinicia |
| Swap distinta de 0 | `systemctl list-units --type swap` muestra quién la activa. Desactívala y abre un issue: el rol debería cubrirlo |
| `ip_forward` no es 1 | `sudo sysctl --system` y revisa errores en `/etc/sysctl.d/90-homelab.conf` |

## Último recurso

Las tarjetas SD se pueden reflashear en minutos y el playbook deja el nodo exactamente igual. Si un nodo
está en un estado raro y no sabes por qué, reflashear y ejecutar `make prepare LIMIT=<nodo>` suele ser más
rápido que investigar. Esa es la ventaja de tenerlo todo en código.

---
Anterior: [05 · Validar](05-validar.md) · [Índice del tema](README.md) · Siguiente tema: [05 · Kubernetes con K3s](../05-kubernetes-k3s/README.md)
