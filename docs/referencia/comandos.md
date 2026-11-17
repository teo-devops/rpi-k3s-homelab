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
| `make k3s` | Instala K3s y trae el kubeconfig |
| `make cilium` | Instala o actualiza Cilium |
| `make cilium-status` | Estado de Cilium |
| `make hubble-ui` | Abre Hubble UI |
| `make nodes` | Nodos, tier y consumo |
| `make cluster-check` | Comprobación rápida del clúster |
| `make k3s-uninstall` | Borra K3s de todos los nodos (pide confirmación) |
| `make sops-init` | Clave age, `.sops.yaml` y Secret para Flux |
| `make sops-encrypt FILE=...` | Cifra un Secret |
| `make flux` | Instala Flux y lo conecta con GitHub |
| `make flux-status` | Estado de Flux y de todo lo que gestiona |
| `make flux-reconcile` | Sincroniza con Git ya |
| `make headlamp` | Interfaz web con token de solo lectura |
| `make lint` | yamllint, ansible-lint, shellcheck |
| `make docs-check` | Enlaces rotos en la documentación |
| `make k8s-check` | Construye y valida `kubernetes/` sin clúster (kustomize + kubeconform) |
| `make ci` | Todo lo anterior: lo mismo que el CI de GitHub |

## Ansible a mano (desde `ansible/`)

```bash
ansible-inventory --graph                       # ver el inventario
ansible-inventory --host rpi5-8g                # variables finales de un nodo
ansible all -m ansible.builtin.setup -a 'filter=ansible_memtotal_mb'   # un dato de todos
ansible all -b -m ansible.builtin.command -a 'uptime'                  # un comando en todos
```

## Kubernetes (con `export KUBECONFIG=~/.kube/rpi-k3s-homelab.yaml`)

| Comando | Qué muestra |
|---------|-------------|
| `kubectl get nodes -L homelab.io/tier` | Nodos con su tier |
| `kubectl describe node <nodo>` | Capacidad, allocatable, condiciones, pods |
| `kubectl get pods -A -o wide` | Todos los pods y su nodo |
| `kubectl top nodes` / `kubectl top pods -A` | Consumo real |
| `kubectl get events -A --sort-by=.lastTimestamp` | Qué ha pasado últimamente |
| `cilium status` | Salud de Cilium |
| `hubble observe --verdict DROPPED -f` | Paquetes descartados en directo |
| `kubectl -n kube-system get lease \| grep l2announce` | Qué nodo anuncia cada IP de LoadBalancer |
| `kubectl get ciliumloadbalancerippools` | IPs libres del pool |

## Flux

| Comando | Qué hace |
|---------|----------|
| `flux get all -A` | Estado de fuentes, Kustomizations y HelmReleases |
| `flux reconcile kustomization <nombre> --with-source` | Aplicar ya, releyendo Git |
| `flux suspend kustomization <nombre>` / `flux resume ...` | Pausar y reanudar |
| `flux logs --level=error --since=10m` | Errores recientes de los controladores |
| `flux events --for Kustomization/<nombre>` | Historia de una Kustomization |
| `helm -n kube-system history cilium` | Revisiones de una release (también las de Flux) |
| `sops <fichero>.sops.yaml` | Editar un secreto cifrado (con `SOPS_AGE_KEY_FILE`) |

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
| `sudo journalctl -u k3s -f` | Logs de K3s (server) |
| `sudo journalctl -u k3s-agent -f` | Logs de K3s (agent) |
| `sudo cat /etc/rancher/k3s/config.yaml` | Configuración de K3s generada por Ansible |
| `sudo k3s crictl ps` | Contenedores del nodo, sin pasar por Kubernetes |
