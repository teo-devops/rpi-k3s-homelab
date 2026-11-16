# 0005 · Repartir carga por tiers de memoria

- **Estado**: Aceptada
- **Fecha**: 2026-11-16

## Contexto

Los nodos tienen 8, 4 y 2 GB de RAM. El scheduler de Kubernetes, por defecto, trata a todos los nodos como
intercambiables y solo mira si cabe el pod en ese momento.

## Decisión

- Etiqueta `homelab.io/tier` con valores `large`, `medium`, `small`.
- Reservas del kubelet (`system-reserved`, `kube-reserved`, `eviction-hard`) proporcionales a cada nodo.
- Afinidad **obligatoria** para cargas pesadas o con estado; ninguna para cargas ligeras sin estado.
- Sin taints en el nodo pequeño: puede recibir cualquier carga que quepa.
- Todas las cargas declaran `requests` realistas.

## Alternativas consideradas

| Opción | A favor | En contra |
|--------|---------|-----------|
| Tratar todos los nodos igual | Simple | Riesgo de que una carga pesada acabe en 2 GB |
| Taint en el nodo pequeño | Protección fuerte | Hay que añadir tolerancias a todo lo que deba ir allí, incluidos DaemonSets; menos didáctico |
| Etiquetas + afinidad + reservas | Explícito y educativo | Requiere disciplina con los `requests` |

## Consecuencias

- Cada componente nuevo debe decidir su tier, documentado en sus valores de Helm.
- El [presupuesto de memoria](../01-hardware/03-presupuesto-de-memoria.md) se mantiene actualizado con mediciones reales.
