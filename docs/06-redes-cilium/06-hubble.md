# Hubble

## Objetivo

Ver el tráfico del clúster en tiempo real y encontrar por qué se descarta un paquete.

## Conceptos

Como Cilium procesa cada paquete con eBPF, puede emitir un evento por cada flujo: origen, destino, puerto,
veredicto (`FORWARDED`, `DROPPED`) y, si se descarta, el motivo. **Hubble** recoge esos eventos:

| Pieza | Dónde corre | Qué hace |
|-------|-------------|----------|
| Hubble (en el agente de Cilium) | cada nodo | Genera los eventos del nodo |
| Hubble Relay | `rpi5-8g` | Junta los eventos de todos los nodos |
| Hubble UI | `rpi5-8g` | Mapa de servicios y lista de flujos en el navegador |
| CLI `hubble` / `cilium hubble` | tu portátil | Consultar flujos desde la terminal |

Por ahora la UI se abre con un *port-forward* (un túnel temporal desde tu portátil). En la fase 5 se
publicará por Tailscale.

## Pasos

### La interfaz web

```bash
make hubble-ui
```

Abre el navegador en el namespace `demo`. Repite las pruebas de la [página anterior](05-networkpolicy.md):
verás las flechas entre `cliente` y `whoami`, en verde o en rojo.

### La terminal

En una terminal deja abierto el reenvío al relay:

```bash
cilium hubble port-forward
```

En otra, mira los descartes del namespace `demo`:

```bash
hubble observe --namespace demo --verdict DROPPED -f
```

Lanza el cliente sin etiqueta y aparecerá una línea parecida a esta:

```
demo/cliente:43210 (ID:12345) <> demo/whoami-xxx:80 (ID:67890) policy-verdict:none INGRESS DENIED (TCP Flags: SYN)
```

`policy-verdict:none ... DENIED`: ninguna política permite ese tráfico. Así se diagnostica en dos minutos
algo que con `tcpdump` llevaría una tarde.

## Comprobación

- `cilium status` muestra `Hubble Relay: OK`.
- La UI muestra el mapa de servicios del namespace `demo`.
- `hubble observe` muestra los descartes al lanzar el cliente sin etiqueta.

---
Anterior: [05 · NetworkPolicy](05-networkpolicy.md) · [Índice del tema](README.md) · Siguiente: [07 · Errores comunes](07-errores-comunes.md)
