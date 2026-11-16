# Por qué nodos distintos

## Objetivo

Entender qué problema aparece cuando los nodos no son iguales, y cómo lo resuelve Kubernetes.

## Conceptos

Kubernetes decide dónde ejecutar cada pod (el **scheduling**) mirando dos cosas:

1. **Lo que el pod pide** (`requests` de CPU y memoria).
2. **Lo que el nodo tiene libre** (`allocatable`: memoria total menos lo reservado para el sistema).

Con nodos iguales, da igual dónde caiga cada pod. Con nodos distintos, el scheduler por defecto puede
mandar Prometheus (que puede crecer hasta 1 GB) a la Pi de 2 GB porque "en ese momento cabía". Cuando
crezca, el nodo se queda sin memoria.

En este lab lo resolvemos con tres herramientas que irás viendo:

| Herramienta | Qué hace | Ejemplo |
|-------------|----------|---------|
| **Etiquetas de nodo** | Describen el nodo | `homelab.io/tier=small` |
| **Afinidad de nodo** | Un pod pide (o prefiere) nodos con cierta etiqueta | Prometheus exige `tier=large` |
| **Reservas del kubelet** | Memoria que los pods nunca pueden usar | La Pi 4 reserva unos 350 MB para el sistema |
| **Requests y limits** | Lo que pide y lo máximo que puede usar un pod | cloudflared pide 32 MB, máximo 64 MB |

La regla que seguiremos:

- **Cargas con estado o pesadas** → afinidad obligatoria al nodo que las aguanta.
- **Cargas ligeras y sin estado** → sin afinidad; que el scheduler reparta.
- **El nodo pequeño** no se "prohíbe" (no le ponemos taint): recibe lo que quepa, y las reservas lo protegen.

## Lo que aprenderás comparando nodos

- Leer `kubectl describe node` y entender `Capacity` frente a `Allocatable`.
- Ver un desalojo (eviction) real cuando un nodo se queda corto, y por qué es mejor que un cuelgue.
- Medir en Grafana el coste real de cada componente (fase 6) y comparar con el
  [presupuesto](03-presupuesto-de-memoria.md).

La [decisión 0005](../decisiones/0005-nodos-heterogeneos.md) recoge este diseño.

---
Anterior: [01 · Los nodos](01-los-nodos.md) · [Índice del tema](README.md) · Siguiente: [03 · Presupuesto de memoria](03-presupuesto-de-memoria.md)
