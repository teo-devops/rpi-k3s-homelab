# Etiquetas, reservas y allocatable

## Objetivo

Comprobar en el clúster real que las reservas de memoria del [presupuesto](../01-hardware/03-presupuesto-de-memoria.md)
se han aplicado, y saber leerlas.

## Conceptos

Las reservas se pasan al kubelet desde `host_vars` ([rpi4-2g](../../ansible/inventory/host_vars/rpi4-2g.yml)):

```yaml
kubelet_system_reserved: "cpu=150m,memory=192Mi"
kubelet_kube_reserved: "cpu=150m,memory=160Mi"
kubelet_eviction_hard: "memory.available<128Mi"
```

El kubelet resta todo eso a la capacidad del nodo y anuncia el resultado como **allocatable**. El scheduler
solo mira el allocatable: para él, la Pi de 2 GB tiene unos 1,3 GB.

Las etiquetas se aplican de dos formas: K3s las pone al registrar el nodo (`node-label`), y el playbook las
reaplica siempre con `kubectl label --overwrite`, porque K3s no actualiza `node-label` en nodos ya
registrados. Si cambias el tier en `host_vars`, basta con `make k3s`.

## Pasos

Requisito: Cilium instalado (nodos `Ready`).

```bash
kubectl describe node rpi4-2g | sed -n '/^Capacity/,/^System Info/p'
```

```
Capacity:
  cpu:                4
  memory:             1889964Ki
  pods:               110
Allocatable:
  cpu:                3700m
  memory:             1381036Ki
  pods:               110
```

Lectura (las cifras exactas varían con el modelo y el kernel):

- `cpu: 4` → `3700m`: 150m + 150m reservados.
- `memory`: unos 1,8 GB → 1,3 GB. La diferencia son 192 + 160 + 128 MiB.

Mira también lo que ya está pidiendo cada nodo:

```bash
kubectl describe node rpi4-2g | sed -n '/^Allocated resources/,/^Events/p'
```

## Comprobación

```bash
kubectl get nodes -L homelab.io/tier
kubectl get nodes -o custom-columns=NODO:.metadata.name,ALLOCATABLE:.status.allocatable.memory
```

Cada nodo debe tener su tier y un allocatable coherente con la tabla del presupuesto.

## Experimento

Cambia `kubelet_eviction_hard` del `rpi4-2g` a `memory.available<256Mi`, ejecuta
`make k3s LIMIT=rpi4-2g` (solo reinicia `k3s-agent` en ese nodo) y vuelve a mirar el allocatable. Deja el
valor como estaba al terminar.

---
Anterior: [03 · Instalar](03-instalar.md) · [Índice del tema](README.md) · Siguiente: [05 · Scheduling por memoria](05-scheduling-por-memoria.md)
