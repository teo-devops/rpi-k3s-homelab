# Variables de Ansible

Dónde se define cada variable y su valor por defecto. Para entender la prioridad entre ficheros, ver
[04/02](../04-ansible/02-inventario-y-variables.md).

## Comunes (`inventory/group_vars/all.yml`)

| Variable | Por defecto | Qué controla |
|----------|-------------|--------------|
| `ansible_user` | `homelab` | Usuario SSH creado con Imager |
| `homelab_ssh_public_key_file` | `~/.ssh/id_ed25519.pub` | Clave que se instala en los nodos |
| `homelab_timezone` | `Europe/Madrid` | Zona horaria |
| `base_upgrade_packages` | `true` | Actualizar todo el sistema en cada ejecución |
| `homelab_domain` | `example.com` | Dominio base (fase 5) |
| `network_static_enabled` | `false` | IP estática con NetworkManager |
| `homelab_lb_ip_range` | `192.168.1.200-192.168.1.220` | IPs de LoadBalancer para Cilium (fase 2) |
| `sdcard_protection_enabled` | `true` | Activa el rol `sdcard` |
| `nvme_enabled` | `false` | Activa el rol `nvme` y PCIe |

## Por nodo (`inventory/host_vars/<nodo>.yml`)

| Variable | Ejemplo | Qué controla |
|----------|---------|--------------|
| `homelab_tier` | `large` | Etiqueta `homelab.io/tier` (fase 2) |
| `kubelet_system_reserved` | `cpu=250m,memory=384Mi` | Reserva para el sistema operativo (fase 2) |
| `kubelet_kube_reserved` | `cpu=250m,memory=512Mi` | Reserva para K3s (fase 2) |
| `kubelet_eviction_hard` | `memory.available<256Mi` | Umbral de desalojo (fase 2) |

## Por rol (`roles/<rol>/defaults/main.yml`)

| Rol | Variable | Por defecto |
|-----|----------|-------------|
| base | `base_packages` | curl, jq, htop, iotop, git, rsync, nfs-common, open-iscsi... |
| ssh | `ssh_disable_password_auth` | `true` |
| swap | `swap_disabled` | `true` |
| kernel | `kernel_modules` | `overlay`, `br_netfilter` |
| kernel | `kernel_sysctl` | ver [defaults](../../ansible/roles/kernel/defaults/main.yml) |
| sdcard | `sdcard_journald_runtime_max` | `64M` |
| sdcard | `sdcard_tmp_in_ram` / `sdcard_tmp_size` | `true` / `256M` |
| network | `network_interface` | `eth0` |
| network | `network_ipv4_address` | vacío (obligatorio si se activa) |
| network | `network_ipv4_gateway` | `192.168.1.1` |
| network | `network_dns_servers` | `["192.168.1.1"]` |
| nvme | `nvme_device` | `/dev/nvme0n1` |
| nvme | `nvme_mount_path` | `/var/lib/rancher` |
| nvme | `nvme_format_confirm` | `false` |
| boot | `boot_cmdline_flags` | `cgroup_enable=memory`, `cgroup_memory=1` |
| boot | `boot_pi5_force_4k_kernel` | `true` |
| boot | `boot_headless_tweaks` | `true` |
| boot | `boot_pcie_gen3` | `true` |
