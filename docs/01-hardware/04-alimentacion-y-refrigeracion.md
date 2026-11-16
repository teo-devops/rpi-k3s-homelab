# Alimentación y refrigeración

## Objetivo

Evitar los dos fallos de hardware más comunes en clústeres de Raspberry Pi: falta de corriente y calor.

## Conceptos

Una Pi con alimentación insuficiente no se apaga: **baja la frecuencia** y corrompe escrituras en la SD.
Una Pi demasiado caliente también baja la frecuencia (throttling). Ambas cosas parecen "Kubernetes va
lento" y cuestan mucho de diagnosticar si no sabes buscarlas.

## Alimentación

| Placa | Fuente recomendada | Notas |
|-------|--------------------|-------|
| Pi 5 | 27 W USB-C PD (5,1 V / 5 A), la oficial | Con fuentes de 3 A limita la corriente USB y avisa al arrancar |
| Pi 4 | 15 W USB-C (5,1 V / 3 A), la oficial | |

Alternativa: **PoE+** (802.3at). Un switch PoE+ y un HAT PoE+ por placa: un solo cable por nodo para red y
corriente. Comprueba que el presupuesto total de potencia del switch cubre los tres nodos (unos 25 W por Pi 5
con NVMe, unos 15 W por la Pi 4).

## Refrigeración

- Pi 5: disipador activo (ventilador) obligatorio bajo carga sostenida.
- Pi 4: disipador pasivo suele bastar con carga ligera, que es la que tendrá.

## Comprobación

En cada nodo:

```bash
vcgencmd measure_temp      # temperatura del SoC. Por debajo de 70 °C, bien
vcgencmd get_throttled     # 0x0 = nunca ha habido problemas
```

Si `get_throttled` no es `0x0`, el bit indica la causa:

| Bit | Valor | Significado |
|-----|-------|-------------|
| 0 | `0x1` | Bajo voltaje ahora |
| 2 | `0x4` | Limitado ahora |
| 16 | `0x10000` | Hubo bajo voltaje desde el arranque |
| 18 | `0x40000` | Hubo limitación desde el arranque |

En la fase 6 estas métricas irán a Grafana para verlas en el tiempo.

## Errores comunes

- **Reinicios aleatorios bajo carga**: casi siempre la fuente. Prueba con la oficial antes de buscar otra causa.
- **Cargadores de móvil**: muchos no negocian 5 A en la Pi 5. No son fuentes válidas.

---
Anterior: [03 · Presupuesto de memoria](03-presupuesto-de-memoria.md) · [Índice del tema](README.md) · Siguiente: [05 · SD hoy, NVMe mañana](05-sd-vs-nvme.md)
