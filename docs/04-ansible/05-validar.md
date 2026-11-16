# Validar

## Objetivo

Confirmar que cada nodo cumple todos los requisitos antes de instalar Kubernetes.

## Conceptos

El playbook [`99-validate.yml`](../../ansible/playbooks/99-validate.yml) solo **lee**: no cambia nada. Es la
red de seguridad entre la fase 1 y la fase 2. Lánzalo siempre que dudes del estado de un nodo.

| Comprobación | Obligatoria | Por qué |
|--------------|-------------|---------|
| Arquitectura `aarch64` | sí | K3s y las imágenes son de 64 bits |
| Página de 4096 bytes | sí | Cilium/eBPF ([02/04](../02-sistema-operativo/04-paginas-4k-y-btf.md)) |
| `memory` en cgroups | sí | Límites de memoria de los pods |
| Swap a 0 | sí | Comportamiento predecible del kubelet |
| `ip_forward` = 1 | sí | Red de pods |
| overlay y br_netfilter | sí | Contenedores y red |
| BTF presente | aviso | Funciones avanzadas de Cilium |
| Hora sincronizada | aviso | TLS y K3s |

## Pasos

```bash
make validate
```

## Comprobación

Cada nodo debe mostrar `requisitos obligatorios OK` y un resumen como:

```
Nodo:      rpi4-2g (Raspberry Pi 4 Model B Rev 1.5)
RAM:       1845 MB  | tier: small
Kernel:    6.12.x-v8+  | página: 4096 bytes
Swap:      0 MB
BTF:       sí
Hora NTP:  yes
```

Con los tres nodos en verde, la fase 1 está terminada. Siguiente: [05 · Kubernetes con K3s](../05-kubernetes-k3s/README.md).

---
Anterior: [04 · Preparar los nodos](04-preparar-los-nodos.md) · [Índice del tema](README.md) · Siguiente: [06 · Errores comunes](06-errores-comunes.md)
