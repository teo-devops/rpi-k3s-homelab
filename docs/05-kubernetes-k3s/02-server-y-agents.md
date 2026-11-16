# Server y agents

## Objetivo

Entender cómo se forma el clúster: quién manda, quién obedece y cómo se reconocen.

## Conceptos

| | Server (`rpi5-8g`) | Agent (`rpi5-4g`, `rpi4-2g`) |
|---|---|---|
| Control plane | Sí: API, scheduler, controladores, base de datos | No |
| Ejecuta pods | Sí | Sí |
| Servicio systemd | `k3s` | `k3s-agent` |
| Puerto que expone | 6443 (API de Kubernetes) | — |

El server **también ejecuta pods**: con 8 GB sobra memoria, y ahí irán la monitorización y las herramientas
de administración. No le ponemos *taint* de control plane.

### El token

Para unirse, un agent necesita dos cosas: la dirección del server (`https://192.168.1.11:6443`) y un
**token**. El token demuestra que el agent tiene permiso para entrar y le permite verificar que habla con
el server auténtico (incluye un resumen del certificado de la autoridad del clúster).

K3s genera el token al instalar el server, en `/var/lib/rancher/k3s/server/node-token`.

Cómo lo maneja el repo ([`roles/k3s/tasks/main.yml`](../../ansible/roles/k3s/tasks/main.yml)):

1. Se instala el server, que genera su token.
2. Para cada agent, Ansible lee el token **directamente del server** en ese momento.
3. Lo escribe en `/etc/rancher/k3s/config.yaml` del agent, con permisos `0600` (solo root).
4. Las tareas que lo tocan tienen `no_log: true`: no aparece en la salida de Ansible.

Así el token nunca se guarda en el repo ni en tu portátil. Si reinstalas el server, el token cambia, y la
siguiente ejecución de `make k3s` lo propaga solo.

### Cómo se mantiene conectado un agent

Cada agent mantiene una conexión con el server. Si el server se reinicia, los agents reconectan solos.
Los pods que ya corren en un agent siguen funcionando aunque el server esté caído; lo que no se puede es
crear, borrar ni mover pods hasta que vuelva.

---
Anterior: [01 · Qué es K3s](01-que-es-k3s.md) · [Índice del tema](README.md) · Siguiente: [03 · Instalar](03-instalar.md)
