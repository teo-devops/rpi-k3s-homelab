# Conceptos de Ansible

## Objetivo

Entender las cinco ideas de Ansible que usa este repo.

## Conceptos

**Ansible** se ejecuta en tu portátil, se conecta a los nodos por SSH y les aplica cambios. No hay que
instalar nada en los nodos (solo necesitan Python, que Raspberry Pi OS ya trae).

| Idea | Qué es | En este repo |
|------|--------|--------------|
| **Inventario** | La lista de máquinas y sus grupos | [`inventory/hosts.yml`](../../ansible/inventory/hosts.example.yml) |
| **Playbook** | Un guion: a qué máquinas, qué roles, en qué orden | [`playbooks/00-prepare-nodes.yml`](../../ansible/playbooks/00-prepare-nodes.yml) |
| **Rol** | Un paquete de tareas con un propósito, reutilizable | [`roles/`](../../ansible/roles/) |
| **Tarea** | Una acción con un módulo (`apt`, `copy`, `lineinfile`...) | dentro de `roles/*/tasks/main.yml` |
| **Handler** | Una tarea que solo se ejecuta si otra cambió algo | "Reiniciar nodo", "Reiniciar sshd" |

### Idempotencia

La idea más importante. Una tarea **idempotente** describe un **estado deseado**, no una acción:
"el fichero X contiene la línea Y", no "añade la línea Y". Ejecutarla una vez o diez da el mismo resultado.

Por eso puedes lanzar `make prepare` tantas veces como quieras: la segunda vez, casi todo sale en verde
(`ok`) en lugar de amarillo (`changed`), y el nodo no se reinicia si no hace falta.

Ejemplo real del rol `boot`: añadir `cgroup_memory=1` a `cmdline.txt` con una expresión regular que solo
coincide si el parámetro **no** está todavía. Si ya está, no se toca.

### Colores de la salida

| Color | Significado |
|-------|-------------|
| verde `ok` | Ya estaba como debía; no se cambió nada |
| amarillo `changed` | Se cambió algo |
| azul `skipping` | La condición de la tarea no se cumple (p. ej. NVMe desactivado) |
| rojo `failed` | Error. Ansible se detiene en ese nodo |

---
[Índice del tema](README.md) · Siguiente: [02 · Inventario y variables](02-inventario-y-variables.md)
