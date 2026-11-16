# Los roles de este repo

## Objetivo

Recorrer cada rol: qué hace, qué variables tiene y dónde se explica el porqué.

## Orden de ejecución

El playbook [`00-prepare-nodes.yml`](../../ansible/playbooks/00-prepare-nodes.yml) los ejecuta en este orden,
**un nodo cada vez** (`serial: 1`): si algo sale mal, solo afecta a un nodo.

| # | Rol | Qué hace | Activado | Explicación |
|---|-----|----------|----------|-------------|
| 1 | [`rpi`](../../ansible/roles/rpi/tasks/main.yml) | Detecta modelo (Pi 4/5), exige 64 bits, localiza `/boot/firmware` | siempre | — |
| 2 | [`base`](../../ansible/roles/base/tasks/main.yml) | Actualiza, instala utilidades, hostname, zona horaria, NTP | siempre | [02/03](../02-sistema-operativo/03-que-cambia-ansible.md#base) |
| 3 | [`ssh`](../../ansible/roles/ssh/tasks/main.yml) | Tu clave, sin root, sin contraseñas | siempre | [02/03](../02-sistema-operativo/03-que-cambia-ansible.md#ssh-endurecido) |
| 4 | [`swap`](../../ansible/roles/swap/tasks/main.yml) | Desactiva la swap | siempre | [02/03](../02-sistema-operativo/03-que-cambia-ansible.md#swap-desactivada) |
| 5 | [`kernel`](../../ansible/roles/kernel/tasks/main.yml) | Módulos y sysctl | siempre | [02/03](../02-sistema-operativo/03-que-cambia-ansible.md#módulos-del-kernel) |
| 6 | [`sdcard`](../../ansible/roles/sdcard/tasks/main.yml) | Logs en RAM, `noatime`, `/tmp` en RAM | `sdcard_protection_enabled` | [02/05](../02-sistema-operativo/05-cuidar-la-sd.md) |
| 7 | [`network`](../../ansible/roles/network/tasks/main.yml) | IP estática con NetworkManager | `network_static_enabled` | [03/02](../03-red/02-reserva-dhcp.md) |
| 8 | [`nvme`](../../ansible/roles/nvme/tasks/main.yml) | Formatea y monta un NVMe | `nvme_enabled` | [01/05](../01-hardware/05-sd-vs-nvme.md) |
| 9 | [`boot`](../../ansible/roles/boot/tasks/main.yml) | cgroups, kernel 4 KB, PCIe | siempre | [02/03](../02-sistema-operativo/03-que-cambia-ansible.md#cgroups-el-controlador-de-memoria) |

`boot` va al final porque sus cambios solo surten efecto tras reiniciar. Cualquier rol que necesite reinicio
avisa al handler **Reiniciar nodo**, y Ansible reinicia **una sola vez** al terminar ese nodo.

## Anatomía de un rol

```
roles/kernel/
├── defaults/main.yml     # variables con sus valores por defecto (léelas primero)
├── tasks/main.yml        # lo que hace
├── handlers/main.yml     # lo que hace solo si algo cambió
└── templates/            # ficheros generados con variables (Jinja2)
```

Consejo para aprender: abre `defaults/main.yml` y `tasks/main.yml` de un rol a la vez que su página de
explicación. Todas las tareas tienen nombre en español y comentarios del porqué.

## Tags

Cada rol tiene un tag con su nombre. Sirve para ejecutar solo una parte:

```bash
make prepare TAGS=kernel             # solo el rol kernel
make prepare TAGS=ssh,swap           # dos roles
```

---
Anterior: [02 · Inventario y variables](02-inventario-y-variables.md) · [Índice del tema](README.md) · Siguiente: [04 · Preparar los nodos](04-preparar-los-nodos.md)
