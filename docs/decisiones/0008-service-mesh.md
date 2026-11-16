# 0008 · Service mesh: Cilium primero, Linkerd para comparar

- **Estado**: Aceptada
- **Fecha**: 2026-11-16

## Contexto

Queremos aprender service mesh (mTLS, políticas L7, observabilidad entre servicios). El modelo clásico
añade un proxy *sidecar* a cada pod, y su coste crece con el número de pods. Con 2 GB en un nodo, eso pesa.

## Decisión

1. Activar las funciones de mesh de Cilium (Envoy por nodo, sin sidecars), aprovechando que ya está instalado.
2. Instalar Linkerd solo en un namespace de pruebas para comparar el modelo sidecar con mediciones.
3. Se hace en la fase 7, cuando el resto del clúster esté estable.

## Alternativas consideradas

| Opción | A favor | En contra |
|--------|---------|-----------|
| Cilium mesh | Sin piezas nuevas; coste por nodo, no por pod; visible en Hubble | Algunas funciones (mutual auth) son más recientes |
| Linkerd | El sidecar más ligero; muy didáctico; mTLS automático | Coste por pod; una pieza más |
| Istio (ambient o sidecar) | El más completo y extendido en empresas | Demasiado pesado para este hardware |

## Consecuencias

- El Envoy de Cilium añade ~50-100 MB por nodo cuando se activa.
- La comparación medida queda documentada en el tema 11.
