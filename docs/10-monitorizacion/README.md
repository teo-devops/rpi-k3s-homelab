# 10 · Monitorización

> **Pendiente: fase 6.** Este tema tiene su índice y objetivos; las páginas se escriben junto con el código
> de esa fase. Mientras tanto, las decisiones de diseño ya están en [decisiones/](../decisiones/README.md).

## Objetivos

- Instalar **kube-prometheus-stack** ajustado a poca memoria, fijado al nodo `large`.
- Dashboards de nodos (incluidas temperatura y throttling de las Pi), de Flux y de Cilium/Hubble.
- Medir el consumo real de cada componente y actualizar el [presupuesto de memoria](../01-hardware/03-presupuesto-de-memoria.md).
- Alertas útiles (nodo caído, memoria baja, SD llenándose, certificado a punto de caducar) enviadas a tu móvil.

## Índice previsto

1. Métricas, Prometheus y Grafana en cinco minutos
2. Valores de Helm para hardware pequeño: retención, scrape interval, recursos
3. Exporters de la Raspberry Pi: temperatura, voltaje, throttling
4. Dashboards
5. Alertas con Alertmanager
6. Leer el consumo real y ajustar requests y limits
7. Errores comunes

Anterior tema: [09 · Exposición y seguridad](../09-exposicion-y-seguridad/README.md) · Siguiente tema: [11 · Service mesh](../11-service-mesh/README.md)
