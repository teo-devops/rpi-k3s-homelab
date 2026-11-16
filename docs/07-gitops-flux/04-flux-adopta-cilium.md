# Flux adopta Cilium

## Objetivo

Entender cómo Cilium pasa de estar instalado "a mano" (fase 2) a estar gestionado por Flux, sin cortar la
red ni un segundo.

## Conceptos

### El problema del huevo y la gallina

Flux corre en pods. Los pods necesitan red. La red la da Cilium. Por tanto, **Flux no puede instalar
Cilium** en un clúster vacío: por eso en la fase 2 lo instalamos con Helm desde tu portátil.

Una vez el clúster funciona, sí puede **gestionarlo**: actualizarlo, cambiar sus valores, corregir desviaciones.

### La adopción

Helm guarda cada instalación ("release") con un nombre en un namespace: `make cilium` creó la release
`cilium` en `kube-system`. La [`HelmRelease`](../../kubernetes/infrastructure/cilium/helmrelease.yaml) de Flux
usa **el mismo nombre y namespace**. Cuando helm-controller la procesa, encuentra la release existente y, en
vez de instalar otra, la **actualiza** con los valores de Git. Como los valores y la versión son los mismos
que usó `make cilium`, la actualización no cambia nada: Cilium no se reinicia.

Los valores no se duplican: el `kustomization.yaml` de Cilium convierte el mismo
[`values.yaml`](../../kubernetes/infrastructure/cilium/values.yaml) en un ConfigMap, y la HelmRelease lo lee
(`valuesFrom`). La IP del API server llega por la variable `${K8S_SERVICE_HOST}`.

### La protección

La HelmRelease lleva esta anotación:

```yaml
kustomize.toolkit.fluxcd.io/prune: disabled
```

Sin ella, si alguien borrase el fichero de Git, Flux (con `prune: true`) borraría la HelmRelease, y eso
**desinstala Cilium**. Sin red de pods, Flux ya no podría arreglarlo. Con la anotación, Flux deja de
gestionarla pero no la borra. Es buena práctica para todo lo que sostiene el propio clúster.

### Desde ahora

- `make cilium` se niega a ejecutarse: detecta la HelmRelease. Dos fuentes de verdad acaban mal.
- Para cambiar Cilium: edita `values.yaml` (o la versión en `helmrelease.yaml`), commit, push.

## Comprobación

```bash
helm -n kube-system history cilium
```

Verás la revisión de `make cilium` y una nueva hecha por Flux, con el mismo chart.

```bash
kubectl -n kube-system get pods -l k8s-app=cilium
```

La columna `AGE` de los pods de Cilium no se ha reiniciado con la adopción.

---
Anterior: [03 · Bootstrap](03-bootstrap.md) · [Índice del tema](README.md) · Siguiente: [05 · Secretos con SOPS](05-secretos-sops.md)
