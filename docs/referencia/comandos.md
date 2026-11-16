# Comandos

## Desde tu portátil (raíz del repo)

| Comando | Qué hace |
|---------|----------|
| `make` | Lista todos los atajos |
| `make check` | Comprueba herramientas locales |
| `make init` | Crea `hosts.yml` desde el ejemplo |
| `make deps` | Instala las colecciones de Ansible |
| `make ping` | Prueba la conexión SSH con todos los nodos |
| `make prepare-dry` | Simula la preparación |
| `make prepare` | Prepara los nodos |
| `make prepare LIMIT=rpi4-2g TAGS=kernel` | Un rol en un nodo |
| `make validate` | Valida los requisitos |
| `make lint` | yamllint, ansible-lint, shellcheck |
| `make docs-check` | Enlaces rotos en la documentación |

## Ansible a mano (desde `ansible/`)

```bash
ansible-inventory --graph                       # ver el inventario
ansible-inventory --host rpi5-8g                # variables finales de un nodo
ansible all -m ansible.builtin.setup -a 'filter=ansible_memtotal_mb'   # un dato de todos
ansible all -b -m ansible.builtin.command -a 'uptime'                  # un comando en todos
```

## En un nodo

| Comando | Qué muestra |
|---------|-------------|
| `cat /proc/device-tree/model` | Modelo de placa |
| `free -h` | Memoria y swap |
| `vcgencmd measure_temp` | Temperatura |
| `vcgencmd get_throttled` | Problemas de alimentación o temperatura (`0x0` = ninguno) |
| `getconf PAGESIZE` | Tamaño de página del kernel |
| `cat /sys/fs/cgroup/cgroup.controllers` | Controladores de cgroup activos |
| `swapon --show` | Swap activa |
| `cat /boot/firmware/cmdline.txt` | Parámetros de arranque del kernel |
| `tail -20 /boot/firmware/config.txt` | Bloque añadido por el repo |
| `sudo iotop -oa` | Quién escribe en disco |
| `journalctl -b -p warning` | Avisos desde el último arranque |
| `findmnt` | Sistemas de ficheros montados |
