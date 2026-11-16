# Errores comunes

## Objetivo

Resolver los fallos típicos de la instalación de K3s.

## Instalación

| Síntoma | Causa probable | Solución |
|---------|----------------|----------|
| "Esperar a que el API server responda" agota los reintentos | K3s no arranca en el server | En el server: `sudo journalctl -u k3s -n 100`. Busca errores de cgroups (vuelve a `make validate`) o de sintaxis en `/etc/rancher/k3s/config.yaml` |
| Un agent no aparece en `kubectl get nodes` | No llega al server o el token no vale | En el agent: `sudo journalctl -u k3s-agent -n 50`. `curl -k https://<ip-server>:6443` debe responder (aunque sea 401) |
| `x509: certificate is valid for ..., not <ip>` en `kubectl` | La IP del server no está en `tls-san` | Comprueba `ansible_host`; `make k3s` reescribe la configuración y reinicia |
| `kubectl` responde de otro clúster | `KUBECONFIG` apunta a otro fichero | `export KUBECONFIG=~/.kube/rpi-k3s-homelab.yaml`; con `make` no pasa |

## Después de instalar

| Síntoma | Causa | Solución |
|---------|-------|----------|
| Nodos `NotReady` | Falta Cilium | Esperado: [instalar Cilium](../06-redes-cilium/03-instalar-cilium.md) |
| CoreDNS en `Pending` | Falta Cilium | Igual |
| Un nodo pasa a `NotReady` días después | Se quedó sin memoria, o sin red, o se apagó | `kubectl describe node <nodo>` (sección Conditions) y `vcgencmd get_throttled` en el nodo |

## Ver logs de K3s

```bash
ssh homelab@192.168.1.11 'sudo journalctl -u k3s -f'          # server
ssh homelab@192.168.1.13 'sudo journalctl -u k3s-agent -f'    # agent
```

Recuerda que los logs del sistema están en RAM (rol `sdcard`) y se pierden al reiniciar.

## Volver a empezar

`make k3s-uninstall` y luego `make k3s`. El sistema operativo de la fase 1 no se toca.

---
Anterior: [05 · Scheduling por memoria](05-scheduling-por-memoria.md) · [Índice del tema](README.md) · Siguiente tema: [06 · Redes con Cilium](../06-redes-cilium/README.md)
