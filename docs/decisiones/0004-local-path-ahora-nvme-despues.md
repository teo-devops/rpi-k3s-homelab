# 0004 · local-path en SD ahora, NVMe después

- **Estado**: Aceptada
- **Fecha**: 2026-11-16

## Contexto

Solo hay tarjetas SD. Hay planes de añadir NVMe a las Pi 5. Algunos servicios (Prometheus, Grafana)
necesitan volúmenes persistentes.

## Decisión

- Ahora: `local-path` (incluido en K3s). Los workloads con estado se fijan a su nodo con afinidad.
- Con NVMe: montar el disco en `/var/lib/rancher` (rol `nvme`, ya preparado).
- Longhorn solo si hay NVMe en las dos Pi 5, y nunca en la Pi 4.
- Siempre: copias con Velero a un S3 externo.

## Alternativas consideradas

| Opción | A favor | En contra |
|--------|---------|-----------|
| local-path | Cero consumo extra, simple | Sin réplica: si el nodo muere, el volumen no está disponible |
| Longhorn | Réplica entre nodos, snapshots | ~500 MB por nodo, muchas escrituras: inviable en SD y en 2 GB |
| NFS desde un NAS | Volúmenes accesibles desde cualquier nodo | Requiere un NAS; SQLite y similares funcionan mal sobre NFS |

## Consecuencias

- Un fallo de nodo deja sin sus volúmenes a los pods afectados hasta que vuelva: las copias de seguridad son
  la protección real.
- La migración a NVMe requiere mover los datos existentes (se documentará en el tema 08).
