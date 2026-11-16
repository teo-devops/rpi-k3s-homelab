# Guía del homelab: empieza aquí

Esta carpeta es un curso práctico. Cada tema explica **qué** vamos a hacer, **por qué** se hace así y
**cómo** comprobar que ha funcionado. El código del repo es la implementación; esta guía es el mapa.

## Cómo leer esta guía

- Los temas están numerados en el orden en que se construye el lab. Síguelos en orden la primera vez.
- Cada tema tiene un `README.md` con su índice y páginas cortas numeradas.
- Todas las páginas siguen la misma estructura:
  **Objetivo · Conceptos · Pasos · Comprobación · Errores comunes · Siguiente paso**.
  Las páginas puramente conceptuales omiten las secciones que no aplican.
- Cuando una página explica un fichero del repo, enlaza a él. Lee los dos a la vez.
- Las decisiones de diseño (por qué Cilium y no Flannel, por qué Flux, etc.) están en
  [decisiones/](decisiones/README.md). Si algo te parece raro, la respuesta suele estar ahí.
- ¿Una palabra que no conoces? [Glosario](referencia/glosario.md).

## Ruta de aprendizaje

| # | Tema | Aprenderás | Estado | Tiempo |
|---|------|-----------|--------|--------|
| 00 | [Introducción](00-introduccion/README.md) | Qué es este lab y qué vas a construir | Listo | 15 min |
| 01 | [Hardware](01-hardware/README.md) | Los tres nodos, cuánta memoria gasta cada pieza | Listo | 20 min |
| 02 | [Sistema operativo](02-sistema-operativo/README.md) | Flashear la SD, qué necesita Linux para Kubernetes | Listo | 45 min |
| 03 | [Red](03-red/README.md) | Direcciones, DNS, dominio, acceso remoto | Listo | 30 min |
| 04 | [Ansible](04-ansible/README.md) | Automatizar la preparación de los nodos | Listo | 45 min |
| 05 | [Kubernetes con K3s](05-kubernetes-k3s/README.md) | Control plane y workers, reparto por memoria | Listo | 45 min |
| 06 | [Redes con Cilium](06-redes-cilium/README.md) | eBPF, LoadBalancer sin MetalLB, Hubble | Listo | 1 h 30 min |
| 07 | [GitOps con Flux](07-gitops-flux/README.md) | El clúster se configura desde Git | Fase 3 | — |
| 08 | [Almacenamiento](08-almacenamiento/README.md) | Volúmenes, afinidad, copias, NVMe | Fase 4 | — |
| 09 | [Exposición y seguridad](09-exposicion-y-seguridad/README.md) | TLS, Cloudflare Tunnel, Tailscale | Fase 5 | — |
| 10 | [Monitorización](10-monitorizacion/README.md) | Prometheus, Grafana, alertas | Fase 6 | — |
| 11 | [Service mesh](11-service-mesh/README.md) | mTLS y L7 con y sin sidecars | Fase 7 | — |
| 12 | [Operaciones](12-operaciones/README.md) | Apagar, actualizar, arreglar | Continuo | — |

"Listo" significa que la guía y el código de ese tema existen y se pueden seguir hoy.
Los temas marcados con una fase tienen ya su índice y objetivos, y se completan cuando llega esa fase.

## Atajos

- Arquitectura en una página: [00-introduccion/03-arquitectura.md](00-introduccion/03-arquitectura.md)
- Chuleta de comandos: [referencia/comandos.md](referencia/comandos.md)
- Todas las variables de Ansible: [referencia/variables.md](referencia/variables.md)
- Algo ha fallado en la preparación: [04-ansible/06-errores-comunes.md](04-ansible/06-errores-comunes.md)
