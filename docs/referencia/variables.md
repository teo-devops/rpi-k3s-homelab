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
| `k3s_version` | `v1.36.6+k3s1` | Versión de K3s instalada |
| `k3s_kubeconfig_local` | `~/.kube/rpi-k3s-homelab.yaml` | Dónde se guarda el kubeconfig en tu portátil |
| `sdcard_protection_enabled` | `true` | Activa el rol `sdcard` |
| `nvme_enabled` | `false` | Activa el rol `nvme` y PCIe |

## Por nodo (`inventory/host_vars/<nodo>.yml`)

| Variable | Ejemplo | Qué controla |
|----------|---------|--------------|
| `homelab_tier` | `large` | Etiqueta `homelab.io/tier` |
| `kubelet_system_reserved` | `cpu=250m,memory=384Mi` | Reserva para el sistema operativo |
| `kubelet_kube_reserved` | `cpu=250m,memory=512Mi` | Reserva para K3s |
| `kubelet_eviction_hard` | `memory.available<256Mi` | Umbral de desalojo |

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
| k3s | `k3s_cluster_cidr` / `k3s_service_cidr` | `10.42.0.0/16` / `10.43.0.0/16` |
| k3s | `k3s_disable_components` | `servicelb`, `traefik` |
| k3s | `k3s_secrets_encryption` | `true` |
| k3s | `k3s_kubeconfig_context` | `rpi-k3s-homelab` |

El rango de IPs de LoadBalancer no es una variable de Ansible: está en
[`lb-ippool.yaml`](../../kubernetes/infrastructure/cilium/config/lb-ippool.yaml). La versión de Cilium está en el
[`Makefile`](../../Makefile) (`CILIUM_VERSION`).
