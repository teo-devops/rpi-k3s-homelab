# 11 · Service mesh

> **Pendiente: fase 7.** Este tema tiene su índice y objetivos; las páginas se escriben junto con el código
> de esa fase. Mientras tanto, las decisiones de diseño ya están en [decisiones/](../decisiones/README.md).

## Objetivos

- Entender qué aporta un service mesh: cifrado mTLS entre servicios, políticas por ruta HTTP (L7),
  reintentos, división de tráfico y observabilidad.
- Activar las funciones de mesh de **Cilium** (sin sidecars: un Envoy por nodo) y verlas en Hubble.
- Desplegar **Linkerd** en un namespace de pruebas para comparar el modelo **sidecar**.
- Medir el coste en memoria de cada modelo en nodos de 2, 4 y 8 GB.

## Índice previsto

1. Qué es un service mesh y cuándo no lo necesitas
2. Sidecar frente a sidecarless
3. Cilium: políticas L7 y mutual authentication
4. Linkerd en un namespace de pruebas
5. Comparativa medida: latencia y memoria
6. Errores comunes

Decisiones relacionadas: [0008 service mesh](../decisiones/0008-service-mesh.md).

Anterior tema: [10 · Monitorización](../10-monitorizacion/README.md) · Siguiente tema: [12 · Operaciones](../12-operaciones/README.md)
