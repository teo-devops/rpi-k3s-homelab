# Errores comunes

## Objetivo

Resolver los fallos típicos de Cilium en este lab.

## Instalación

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| `make cilium` se para: "El contexto actual es..." | KUBECONFIG apunta a otro clúster | Lánzalo con `make` (fija KUBECONFIG) o revisa que existe `~/.kube/rpi-k3s-homelab.yaml` |
| Pods `cilium-*` en `CrashLoopBackOff` | Requisitos del kernel | `kubectl -n kube-system logs ds/cilium`; vuelve a `make validate` (página de 4 KB, BTF) |
| Pods `cilium-*` en `Init` mucho rato en la Pi 4 | Descargando imágenes en SD | Paciencia la primera vez; mira `kubectl -n kube-system describe pod` |
| Helm agota el tiempo (`--timeout 15m`) | Imágenes lentas o un nodo con problemas | Vuelve a ejecutar `make cilium`: es idempotente |
| Nodos siguen `NotReady` | El agente de ese nodo no está listo | `kubectl -n kube-system get pods -o wide -l k8s-app=cilium` y logs del pod de ese nodo |

## LoadBalancer

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| `EXTERNAL-IP` en `<pending>` | No se aplicó el pool, o está agotado | `kubectl get ciliumloadbalancerippools`: la columna `IPS AVAILABLE` |
| Tiene IP pero `curl` no responde | Nadie la anuncia | `kubectl -n kube-system get lease \| grep l2announce`; revisa que la interfaz se llama `eth0` (`ip link` en el nodo) |
| Funciona y deja de funcionar al rato | IP del pool dentro del DHCP del router: conflicto | Mueve el pool fuera del DHCP ([03/01](../03-red/01-plan-de-direcciones.md)) |

## Red de pods

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| Pods de nodos distintos no se ven | Enrutado nativo roto (nodos en redes distintas) | Comprueba que los tres nodos están en la misma subred; si no, `routingMode: tunnel` |
| Los pods no salen a internet | Masquerade | `cilium status` → línea `Masquerading`; `kubectl -n kube-system exec ds/cilium -- cilium-dbg status --verbose` |
| Un pod no resuelve nombres | CoreDNS o una NetworkPolicy que bloquea DNS | `hubble observe --namespace <ns> --verdict DROPPED`; recuerda permitir el puerto 53 si usas políticas de Egress |

## Herramienta general

```bash
cilium status --verbose
cilium sysdump      # recoge todo en un zip para pedir ayuda
```

---
Anterior: [06 · Hubble](06-hubble.md) · [Índice del tema](README.md) · Siguiente tema: [07 · GitOps con Flux](../07-gitops-flux/README.md)
