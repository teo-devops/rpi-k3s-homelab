# Los nodos

## Objetivo

Tener el inventario de hardware y saber qué material hace falta para montarlo.

## Inventario

| | `rpi5-8g` | `rpi5-4g` | `rpi4-2g` |
|---|---|---|---|
| Placa | Raspberry Pi 5 | Raspberry Pi 5 | Raspberry Pi 4 Model B |
| CPU | 4 × Cortex-A76, 2,4 GHz | 4 × Cortex-A76, 2,4 GHz | 4 × Cortex-A72, 1,8 GHz |
| RAM | 8 GB | 4 GB | 2 GB |
| Almacenamiento | SD 128 GB | SD 128 GB | SD 128 GB |
| Red | 1 GbE | 1 GbE | 1 GbE |
| PCIe (NVMe) | Sí | Sí | No |
| Rol | control plane | worker | worker ligero |

La Pi 5 es aproximadamente 2-3 veces más rápida que la Pi 4 en CPU. Eso también influye en el reparto: lo
que consume CPU de forma sostenida (Prometheus comprimiendo datos, por ejemplo) va a una Pi 5.

## Lista de material

Imprescindible:

- Las tres placas.
- Una fuente oficial por placa (ver [alimentación](04-alimentacion-y-refrigeracion.md)) o un switch PoE+ con HATs PoE+.
- Disipador activo en las Pi 5 (el Active Cooler oficial basta).
- Tres tarjetas microSD de 128 GB, clase **A2** y de gama "High Endurance" si es posible: aguantan muchas
  más escrituras. Ver [SD hoy, NVMe mañana](05-sd-vs-nvme.md).
- Switch Gigabit y tres cables Ethernet. **Nada de Wi-Fi** para los nodos: latencia variable y cortes rompen
  la comunicación del clúster.

Recomendable:

- Una caja o rack para las tres placas, con ventilación.
- Un lector de tarjetas SD para el portátil.

Futuro:

- HAT NVMe para cada Pi 5 (hay modelos que combinan NVMe y PoE+) y SSD NVMe M.2 2230/2242.

## Comprobación

Cuando tengas el sistema instalado, en cada nodo:

```bash
cat /proc/device-tree/model; echo
free -h
```

El playbook de validación también lo muestra en su resumen (`make validate`).

---
[Índice del tema](README.md) · Siguiente: [02 · Por qué nodos distintos](02-por-que-heterogeneo.md)
