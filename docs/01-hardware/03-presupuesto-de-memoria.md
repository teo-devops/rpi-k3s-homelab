# Presupuesto de memoria

## Objetivo

Saber, antes de instalar nada, cuánta memoria gastará cada componente y en qué nodo irá.

## Conceptos

De la RAM de un nodo, los pods solo pueden usar el **allocatable**:

```
allocatable = memoria total − system-reserved − kube-reserved − umbral de desalojo
```

- **system-reserved**: para el sistema operativo (sshd, journald, systemd).
- **kube-reserved**: para K3s (kubelet, containerd y, en el server, el API server).
- **Umbral de desalojo** (`eviction-hard`): si la memoria libre baja de aquí, el kubelet empieza a parar
  pods de baja prioridad antes de que el kernel tenga que matar procesos al azar.

Los valores de cada nodo están en `ansible/inventory/host_vars/`
([rpi5-8g](../../ansible/inventory/host_vars/rpi5-8g.yml),
[rpi5-4g](../../ansible/inventory/host_vars/rpi5-4g.yml),
[rpi4-2g](../../ansible/inventory/host_vars/rpi4-2g.yml)) y se aplican en la fase 2.

## Reservas por nodo

| | `rpi5-8g` | `rpi5-4g` | `rpi4-2g` |
|---|---|---|---|
| Memoria que ve Linux (aprox.) | 7,9 GB | 3,9 GB | 1,8 GB |
| system-reserved | 384 MiB | 256 MiB | 192 MiB |
| kube-reserved | 512 MiB | 256 MiB | 160 MiB |
| eviction-hard | 256 MiB | 192 MiB | 128 MiB |
| **Allocatable (aprox.)** | **6,8 GB** | **3,2 GB** | **1,3 GB** |

## Consumo estimado por componente

Cifras orientativas de uso típico en un clúster pequeño. Las mediremos de verdad en la fase 6 y
actualizaremos esta tabla.

| Componente | Memoria aprox. | Dónde |
|------------|----------------|-------|
| Raspberry Pi OS Lite | 150–200 MB | cada nodo (fuera del allocatable) |
| K3s server (API, scheduler, SQLite) | 500–700 MB | `rpi5-8g` (fuera del allocatable) |
| K3s agent (kubelet, containerd) | 150–250 MB | cada worker (fuera del allocatable) |
| Cilium agent | 150–250 MB | cada nodo |
| Cilium operator | 50–100 MB | 1 réplica |
| Hubble relay + UI | ~100 MB | `rpi5-8g` |
| CoreDNS, metrics-server, local-path | ~100 MB | donde caigan |
| Flux (4 controladores) | 200–300 MB | `rpi5-8g` |
| Headlamp | 50–100 MB | `rpi5-8g` |
| Traefik | 60–100 MB | `rpi5-4g` |
| cert-manager (3 pods) | 100–150 MB | `rpi5-4g` |
| Prometheus (retención corta) | 400–800 MB | `rpi5-8g` |
| Grafana | 100–200 MB | `rpi5-8g` |
| node-exporter | 15–30 MB | cada nodo |
| cloudflared | 30–50 MB | `rpi4-2g` |
| Envoy de Cilium (solo con service mesh) | 50–100 MB | cada nodo, fase 7 |

## Suma por nodo

| Nodo | Plataforma estimada | Allocatable | Margen para tus apps |
|------|--------------------|-------------|----------------------|
| `rpi5-8g` | ~2,0 GB | 6,8 GB | holgado |
| `rpi5-4g` | ~0,6 GB | 3,2 GB | holgado |
| `rpi4-2g` | ~0,3 GB | 1,3 GB | justo: solo servicios pequeños |

Conclusiones que justifican el diseño:

- El control plane y la monitorización caben con holgura en la Pi de 8 GB: por eso van ahí.
- La Pi de 2 GB podría ejecutar Cilium y poco más. Un control plane allí no cabría con seguridad.
- El service mesh sin sidecars (Envoy por nodo) cuesta lo mismo con 2 pods que con 50; con sidecars, el
  coste crece con cada pod. En la Pi de 2 GB eso importa. Ver [decisión 0008](../decisiones/0008-service-mesh.md).

## Comprobación

Desde la fase 2 podrás comparar con la realidad:

```bash
kubectl describe node rpi4-2g | grep -A6 Allocatable
kubectl top nodes
```

---
Anterior: [02 · Por qué nodos distintos](02-por-que-heterogeneo.md) · [Índice del tema](README.md) · Siguiente: [04 · Alimentación y refrigeración](04-alimentacion-y-refrigeracion.md)
