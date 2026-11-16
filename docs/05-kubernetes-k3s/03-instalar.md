# Instalar K3s

## Objetivo

Un server y dos agents instalados, el kubeconfig en tu portátil y los nodos etiquetados por tier.

## Conceptos

### Configuración por fichero

En vez de pasar flags al instalador, K3s lee `/etc/rancher/k3s/config.yaml`. Cada clave equivale a un flag
(`flannel-backend: none` es `--flannel-backend=none`). Ventajas: se lee de un vistazo, Ansible lo genera
desde una plantilla y, si lo cambias, basta con reiniciar el servicio.

Plantilla: [`roles/k3s/templates/config.yaml.j2`](../../ansible/roles/k3s/templates/config.yaml.j2). Resultado en el server:

| Clave | Valor | Por qué |
|-------|-------|---------|
| `node-ip` | IP del inventario | Que K3s no elija otra interfaz por su cuenta |
| `tls-san` | IP y hostname | El certificado del API server es válido para esos nombres, y así funciona tu kubeconfig |
| `cluster-cidr` / `service-cidr` | `10.42.0.0/16` / `10.43.0.0/16` | Rangos internos ([03/01](../03-red/01-plan-de-direcciones.md)) |
| `secrets-encryption` | `true` | Los Secrets se guardan cifrados en la base de datos |
| `flannel-backend` | `none` | Sin CNI de serie |
| `disable-network-policy` | `true` | Las NetworkPolicy las aplica Cilium |
| `disable-kube-proxy` | `true` | Los Services los implementa Cilium |
| `disable` | `servicelb`, `traefik` | Ver [01](01-que-es-k3s.md) |
| `node-label` | `homelab.io/tier=...` | Etiqueta de tier al registrarse |
| `kubelet-arg` | reservas y desalojo | Ver [04](04-etiquetas-y-reservas.md) |

### Versión fijada

`k3s_version` en [`group_vars/all.yml`](../../ansible/inventory/group_vars/all.yml) fija la versión exacta
(`v1.36.6+k3s1`). Nunca instalamos "la última": Cilium 1.20 está probado con Kubernetes 1.33 a 1.36, y la
1.37 de K3s ya existe pero aún no está en esa lista. Comprobar la compatibilidad antes de actualizar es una
costumbre que conviene adquirir.

### El kubeconfig

Es el fichero con la dirección del clúster y tus credenciales de administrador. El playbook lo copia a
`~/.kube/rpi-k3s-homelab.yaml` (no toca tu `~/.kube/config`), cambiando `127.0.0.1` por la IP del server y
el nombre `default` por `rpi-k3s-homelab`. El Makefile usa siempre ese fichero: así ningún `make` puede
actuar por error sobre otro clúster que uses.

Trátalo como una contraseña: da control total del clúster.

## Pasos

1. Instala `kubectl` y `helm` en tu portátil (`make check` te dice qué falta).
2. Instala K3s:

   ```bash
   make k3s
   ```

   Primero el server, luego los agents, luego las etiquetas. Unos 5 minutos.
3. Para usar `kubectl` fuera del Makefile, en tu terminal:

   ```bash
   export KUBECONFIG=~/.kube/rpi-k3s-homelab.yaml
   ```

## Comprobación

```bash
make nodes
```

```
NAME      STATUS     ROLES                  ...   TIER
rpi4-2g   NotReady   worker                 ...   small
rpi5-4g   NotReady   worker                 ...   medium
rpi5-8g   NotReady   control-plane          ...   large
```

**`NotReady` es lo correcto en este punto**: falta la red. Compruébalo:

```bash
kubectl describe node rpi5-8g | grep -i networkready
# ... container runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady ...
kubectl get pods -A        # coredns, metrics-server y local-path en Pending
```

Siguiente: instalar Cilium en el [tema 06](../06-redes-cilium/03-instalar-cilium.md). Después vuelve a
[04 · Etiquetas, reservas y allocatable](04-etiquetas-y-reservas.md).

## Reinstalar

`make k3s` es idempotente: si la versión instalada coincide con `k3s_version`, no reinstala; si cambias la
configuración, solo reinicia el servicio. Para empezar de cero: `make k3s-uninstall` (borra el clúster y sus
datos, pide confirmación) y luego `make k3s`.

---
Anterior: [02 · Server y agents](02-server-y-agents.md) · [Índice del tema](README.md) · Siguiente: [04 · Etiquetas, reservas y allocatable](04-etiquetas-y-reservas.md)
