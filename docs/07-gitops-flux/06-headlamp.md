# Headlamp

## Objetivo

Ver el clúster y el estado de Flux desde el navegador, con un usuario de solo lectura.

## Conceptos

**Headlamp** es una interfaz web para Kubernetes (proyecto de la CNCF). Con su **plugin de Flux** muestra
las Kustomizations, HelmReleases y fuentes, su estado y sus relaciones. Ver
[decisión 0007](../decisiones/0007-headlamp-como-ui.md).

Detalles de la instalación ([`helmrelease.yaml`](../../kubernetes/infrastructure/headlamp/helmrelease.yaml)):

- **El plugin, con un initContainer.** El chart ofrece un "plugin manager" que es un proceso Node.js
  permanente; su propia documentación sugiere reservarle 2 GB. En su lugar, un contenedor `busybox` se ejecuta
  una vez al arrancar el pod, descarga el plugin, **comprueba su checksum** y lo deja en una carpeta compartida.
  Coste en memoria: cero una vez arrancado.
- **Sin permisos propios.** Por defecto el chart da `cluster-admin` a Headlamp. Lo desactivamos: cada persona
  entra con **su** token y ve lo que ese token permite.
- **Usuario de solo lectura** ([`rbac.yaml`](../../kubernetes/infrastructure/headlamp/rbac.yaml)): la cuenta
  `headlamp-lector` tiene el rol `view` (leer casi todo, salvo Secrets) más lectura de nodos, tipos de
  recurso y métricas.
- Va al nodo large, con límite de memoria de 192 MiB.

Por ahora se abre con un *port-forward*. En la fase 5 se publicará por Tailscale.

## Pasos

```bash
make headlamp
```

Muestra un token válido 24 horas y abre el túnel. Abre `http://localhost:8080`, pega el token y entra.

Recorrido sugerido:

1. **Cluster → Nodes**: los tres nodos, su tier, su memoria.
2. **Flux** (menú lateral, lo añade el plugin): Kustomizations en orden de dependencia, HelmReleases con su
   versión.
3. Abre la HelmRelease `cilium`: valores aplicados, historial, eventos.
4. **Workloads → Pods**, filtra por namespace `kube-system` y mira en qué nodo está cada pieza.

## Comprobación

- En el menú lateral aparece **Flux**. Si no, el plugin no se cargó: `kubectl -n headlamp logs deploy/headlamp -c plugin-flux`.
- Intenta borrar un pod desde Headlamp: debe fallar por permisos. Es lo esperado con un token de lectura.

## Si necesitas permisos de escritura

Para, por ejemplo, forzar una reconciliación desde la interfaz, puedes crear una cuenta con el rol `edit` o
usar tu kubeconfig de administrador. Hazlo de forma consciente y temporal: la vía normal para cambiar el
clúster es Git.

---
Anterior: [05 · Secretos con SOPS](05-secretos-sops.md) · [Índice del tema](README.md) · Siguiente: [07 · Flujo de trabajo](07-flujo-de-trabajo.md)
