# Qué cambia Ansible y por qué

## Objetivo

Entender cada cambio que hace el playbook de preparación en el sistema operativo. No hay magia:
todo lo que hace Ansible podrías hacerlo a mano, y aquí se explica qué y por qué.

## cgroups: el controlador de memoria

**Qué es.** Los *control groups* son el mecanismo del kernel para limitar recursos de un grupo de procesos.
Cuando un pod declara `limits.memory: 256Mi`, el kubelet crea un cgroup con ese límite.

**El problema.** El kernel de Raspberry Pi viene con el controlador de memoria **desactivado** para ahorrar
recursos en placas pequeñas. Sin él, K3s no puede limitar memoria y se niega a arrancar.

**El cambio.** Añadir `cgroup_enable=memory cgroup_memory=1` a `cmdline.txt` (la línea de parámetros con la
que arranca el kernel). Rol [`boot`](../../ansible/roles/boot/tasks/main.yml). Requiere reinicio.

**Compruébalo.**

```bash
cat /sys/fs/cgroup/cgroup.controllers    # debe aparecer "memory"
```

## Swap desactivada

**Qué es.** Espacio en disco (o en RAM comprimida, zram) que el kernel usa cuando se queda sin memoria.

**Por qué la quitamos.** Kubernetes decide dónde poner pods según la memoria real. Con swap, un nodo
"lleno" sigue aceptando trabajo pero se vuelve muy lento, y en una SD además la desgasta. Sin swap, el
comportamiento es predecible: si falta memoria, el kubelet desaloja pods de forma ordenada.

**El debate.** Kubernetes ya soporta swap de forma controlada (NodeSwap) y en la Pi de 2 GB podría tener
sentido. Lo dejamos como experimento para cuando el clúster esté estable; las guías de K3s y Cilium
asumen que no hay swap.

**El cambio.** Rol [`swap`](../../ansible/roles/swap/tasks/main.yml): desactiva `dphys-swapfile`
(Bookworm), enmascara `swap.target` (Trixie, donde systemd gestiona la swap) y ejecuta `swapoff -a`.

**Compruébalo.**

```bash
swapon --show     # sin salida = sin swap
free -h           # la fila Swap debe ser 0
```

## Módulos del kernel

| Módulo | Para qué |
|--------|----------|
| `overlay` | Sistema de ficheros por capas: así se construyen los contenedores a partir de imágenes |
| `br_netfilter` | Hace que el tráfico entre interfaces bridge pase por las reglas de red del kernel |

Rol [`kernel`](../../ansible/roles/kernel/tasks/main.yml). Se cargan ahora y en cada arranque
(`/etc/modules-load.d/homelab.conf`).

## Parámetros sysctl

| Parámetro | Valor | Por qué |
|-----------|-------|---------|
| `net.ipv4.ip_forward` | 1 | El nodo enruta paquetes entre pods y hacia fuera. Sin esto, no hay red de pods |
| `net.bridge.bridge-nf-call-iptables` | 1 | Que el filtrado de red vea el tráfico de bridges |
| `fs.inotify.max_user_*` | altos | Prometheus, Flux y otros vigilan muchos ficheros; el límite por defecto se queda corto |
| `kernel.panic` | 10 | Si el kernel falla, reinicia solo en 10 s en vez de quedarse colgado |
| `net.ipv4.conf.lxc*.rp_filter` | 0 | Cilium crea interfaces `lxc*` por pod; el filtro estricto de systemd descartaría su tráfico |

Plantilla: [`90-homelab.conf.j2`](../../ansible/roles/kernel/templates/90-homelab.conf.j2).

## SSH endurecido

Rol [`ssh`](../../ansible/roles/ssh/tasks/main.yml): instala tu clave, prohíbe entrar como root y
desactiva las contraseñas. Antes de reiniciar `sshd` valida la configuración (`sshd -t`), para no
dejarte fuera por un error.

## Base

Rol [`base`](../../ansible/roles/base/tasks/main.yml): actualiza paquetes, instala utilidades (`htop`,
`iotop`, `jq`...), fija el hostname y la zona horaria y asegura la sincronización horaria. La hora
importa: un reloj desfasado hace fallar los certificados TLS y la comunicación de K3s.

## Arranque: config.txt

Además de `cmdline.txt`, el rol `boot` añade un bloque marcado a `config.txt`:

- En la Pi 5, el kernel de páginas de 4 KB. Ver [página siguiente](04-paginas-4k-y-btf.md).
- Audio, cámara y pantalla desactivados (nodo sin periféricos).
- PCIe, solo si `nvme_enabled: true`.

El bloque está delimitado por `# BEGIN/END rpi-k3s-homelab`. Si algún día quieres deshacerlo, bórralo y reinicia.

---
Anterior: [02 · Primer arranque](02-primer-arranque.md) · [Índice del tema](README.md) · Siguiente: [04 · Páginas de 4 KB y BTF](04-paginas-4k-y-btf.md)
