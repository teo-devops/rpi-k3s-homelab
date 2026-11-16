# 0007 · Headlamp como interfaz para Kubernetes y Flux

- **Estado**: Aceptada
- **Fecha**: 2026-11-16

## Contexto

Flux no tiene interfaz gráfica oficial. Para aprender ayuda mucho ver los recursos, sus relaciones y su
estado. La memoria es limitada.

## Decisión

Headlamp (proyecto de la CNCF) con su plugin de Flux, accesible solo por Tailscale. Para la red, Hubble UI.
Para métricas, dashboards de Flux en Grafana.

## Alternativas consideradas

| Opción | A favor | En contra |
|--------|---------|-----------|
| Headlamp + plugin Flux | Una sola herramienta para Kubernetes y Flux, ligera | El plugin de Flux es más sencillo que una UI dedicada |
| Weave GitOps | UI dedicada a Flux | Su empresa cerró; mantenimiento comunitario incierto |
| Solo CLI (`flux`, `kubectl`) | Cero consumo | Menos didáctico para ver relaciones entre recursos |
| Kubernetes Dashboard | Conocido | No entiende los recursos de Flux |

## Consecuencias

- Headlamp no recibe permisos propios: cada usuario entra con su token. El de uso diario es de solo lectura.
- El plugin de Flux se instala con un initContainer que verifica el checksum, no con el plugin manager del
  chart (un proceso Node.js permanente, demasiado pesado para este hardware).
- Si aparece una UI oficial de Flux madura, se revisa esta decisión.
