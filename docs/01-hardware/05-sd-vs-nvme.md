# SD hoy, NVMe mañana

## Objetivo

Conocer los límites de las tarjetas SD, cómo los mitigamos y cómo será el paso a NVMe.

## Conceptos

Una SD tiene dos problemas para un servidor:

1. **Escrituras limitadas.** Cada celda aguanta un número finito de ciclos. Kubernetes escribe mucho:
   logs, la base de datos del control plane, imágenes de contenedor, métricas.
2. **Escritura aleatoria lenta.** Bases de datos pequeñas con muchas escrituras (SQLite de K3s, Prometheus)
   sufren más que con un SSD.

Un NVMe en la Pi 5 resuelve ambas: más rápido en un orden de magnitud y con una resistencia muy superior.

## Cómo protegemos la SD mientras tanto

| Medida | Dónde | Qué evita |
|--------|-------|-----------|
| Logs del sistema en RAM | rol `sdcard` | Escritura continua de journald |
| `noatime` | rol `sdcard` | Escribir la fecha de acceso en cada lectura |
| `/tmp` en RAM | rol `sdcard` | Ficheros temporales en la SD |
| SQLite en vez de etcd | fase 2 | etcd sincroniza a disco continuamente |
| Prometheus con retención corta | fase 6 | Muchos GB de escrituras al día |

Detalle en [02 · Cuidar la SD](../02-sistema-operativo/05-cuidar-la-sd.md).

## Plan para NVMe

Cuando montes un NVMe en una Pi 5, el repo ya está preparado:

1. En `ansible/inventory/host_vars/<nodo>.yml`:

   ```yaml
   nvme_enabled: true
   nvme_format_confirm: true   # solo la primera vez
   ```

2. `make prepare LIMIT=<nodo>`: el rol `boot` activa PCIe en `config.txt` y reinicia.
3. `make prepare LIMIT=<nodo> TAGS=nvme`: el rol `nvme` formatea (solo si el disco está vacío) y monta el
   disco en `/var/lib/rancher`. Desde ese momento K3s guarda ahí imágenes, base de datos y volúmenes.
4. Quita `nvme_format_confirm` del fichero.

Arrancar el sistema entero desde NVMe (no solo los datos) requiere cambiar el orden de arranque en la
EEPROM de la Pi 5 (`sudo rpi-eeprom-config --edit`, `BOOT_ORDER=0xf416`). Se documentará en
[08 · Almacenamiento](../08-almacenamiento/README.md); no se automatiza porque un error deja la placa sin arrancar.

Ver [decisión 0004](../decisiones/0004-local-path-ahora-nvme-despues.md).

## Errores comunes

- **El rol `nvme` se niega a montar**: `/var/lib/rancher` ya tiene datos de K3s en la SD. Montar encima
  los ocultaría. Hay que migrarlos a mano (fase 4).
- **No aparece `/dev/nvme0n1`**: PCIe aún no está activado (falta un reinicio) o el cable plano del HAT está mal encajado.

---
Anterior: [04 · Alimentación y refrigeración](04-alimentacion-y-refrigeracion.md) · [Índice del tema](README.md) · Siguiente tema: [02 · Sistema operativo](../02-sistema-operativo/README.md)
