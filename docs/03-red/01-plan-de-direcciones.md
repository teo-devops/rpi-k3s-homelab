# Plan de direcciones

## Objetivo

Decidir, antes de instalar nada, qué rangos de IP usa cada parte, para que ninguno se pise.

## Conceptos

En un clúster conviven cuatro tipos de direcciones:

| Tipo | Quién las asigna | Visibles desde | Ejemplo |
|------|------------------|----------------|---------|
| IPs de los nodos | tu router (DHCP) | toda la casa | `192.168.1.11` |
| IPs de LoadBalancer | Cilium (LB-IPAM) | toda la casa | `192.168.1.200` |
| IPs de pods | Cilium | solo dentro del clúster | `10.42.1.15` |
| IPs de Services | K3s | solo dentro del clúster | `10.43.0.10` |

Las dos primeras están en **tu red de casa**, y ahí está el riesgo: si el router reparte por DHCP una IP
que Cilium ha dado a un servicio, habrá dos equipos con la misma IP y fallos intermitentes.

## Pasos

1. Mira la configuración DHCP de tu router y apunta el rango que reparte (p. ej. `.100`-`.199`).
2. Rellena tu plan. El de ejemplo:

   | Uso | Rango | Notas |
   |-----|-------|-------|
   | Router | `192.168.1.1` | |
   | Nodos | `.11`-`.13` | Fuera del DHCP dinámico, con reserva |
   | DHCP dinámico del router | `.100`-`.199` | Móviles, portátiles... |
   | LoadBalancer (Cilium) | `.200`-`.220` | **Fuera** del DHCP. Nadie más las usa |
   | Pods | `10.42.0.0/16` | Interno |
   | Services | `10.43.0.0/16` | Interno |

3. Si tu red de casa ya usa `10.42.x.x` o `10.43.x.x` (raro), cambia los rangos internos en la fase 2.
4. Pon tu rango de LoadBalancer en
   [`kubernetes/infrastructure/cilium/config/lb-ippool.yaml`](../../kubernetes/infrastructure/cilium/config/lb-ippool.yaml).
   Lo usa Cilium a partir de la fase 2.

## Errores comunes

- **Rango de LoadBalancer dentro del DHCP**: el error más típico. Funciona días y de repente un servicio
  deja de responder porque un móvil ha recibido su IP.

---
[Índice del tema](README.md) · Siguiente: [02 · Reserva DHCP](02-reserva-dhcp.md)
