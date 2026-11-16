# Scheduling por memoria

## Objetivo

Ver con un ejemplo cómo la afinidad y los `requests` deciden en qué nodo cae cada pod.

## Conceptos

El scheduler elige nodo en dos fases:

1. **Filtrar**: descarta los nodos donde el pod no puede ir: no cabe su `request` de memoria en el
   allocatable libre, o no cumple su afinidad **obligatoria** (`required...`).
2. **Puntuar**: entre los que quedan, elige el mejor según preferencias (`preferred...`), reparto de carga, etc.

El ejemplo [`kubernetes/examples/scheduling-demo.yaml`](../../kubernetes/examples/scheduling-demo.yaml) tiene dos Deployments:

| Deployment | Afinidad | Request | Comportamiento esperado |
|------------|----------|---------|-------------------------|
| `pesado` | **obligatoria** `tier=large` | 512 MiB | Siempre en `rpi5-8g` |
| `ligero` (3 réplicas) | ninguna; anti-afinidad **preferida** entre sí | 16 MiB | Una réplica por nodo, si se puede |

## Pasos

```bash
kubectl apply -f kubernetes/examples/scheduling-demo.yaml
kubectl -n demo get pods -o wide
```

Columna `NODE`: `pesado` en `rpi5-8g`; las tres `ligero` repartidas.

### Experimento 1: lo que no cabe se queda esperando

Pide más memoria de la que tiene el nodo large:

```bash
kubectl -n demo set resources deployment pesado --requests=memory=20Gi --limits=memory=20Gi
kubectl -n demo get pods
kubectl -n demo describe pod -l app=pesado | tail -5
```

El pod nuevo queda `Pending` con un evento como
`0/3 nodes are available: 1 Insufficient memory, 2 node(s) didn't match Pod's node affinity`. Fíjate en que
**no** acaba en otro nodo: la afinidad obligatoria lo impide. Eso es lo que queremos para Prometheus.

Deshazlo:

```bash
kubectl -n demo set resources deployment pesado --requests=memory=512Mi --limits=memory=512Mi
```

### Experimento 2: preferencia frente a obligación

Escala `ligero` a 6 réplicas. Con anti-afinidad *preferida*, el scheduler intenta separarlas, pero cuando no
puede las amontona sin quejarse:

```bash
kubectl -n demo scale deployment ligero --replicas=6
kubectl -n demo get pods -l app=ligero -o wide
```

## Comprobación

```bash
kubectl -n demo get pods -o custom-columns=POD:.metadata.name,NODO:.spec.nodeName,ESTADO:.status.phase
```

Limpieza: `kubectl delete namespace demo`.

## La regla del lab

- Pesado o con estado → afinidad **obligatoria** a su tier.
- Ligero y sin estado → sin afinidad; como mucho, anti-afinidad **preferida** para repartir réplicas.
- Todo con `requests` realistas: sin ellos, el scheduler cree que un pod no ocupa nada.

---
Anterior: [04 · Etiquetas, reservas y allocatable](04-etiquetas-y-reservas.md) · [Índice del tema](README.md) · Siguiente: [06 · Errores comunes](06-errores-comunes.md)
