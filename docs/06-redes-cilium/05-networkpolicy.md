# NetworkPolicy

## Objetivo

Restringir quién puede hablar con quién dentro del clúster, y verlo funcionar.

## Conceptos

Por defecto, en Kubernetes **todo pod puede hablar con todo pod**. Una **NetworkPolicy** selecciona pods y
dice qué tráfico pueden recibir (`Ingress`) o enviar (`Egress`). Reglas clave:

- En cuanto un pod está seleccionado por alguna política de `Ingress`, solo recibe lo que esas políticas permiten.
- Las políticas **suman**: no hay "denegar" explícito, solo "permitir". Por eso el patrón es
  *denegar por defecto* (una política que selecciona todo y no permite nada) más *permisos concretos*.

Cilium aplica las NetworkPolicy estándar de Kubernetes y además tiene las suyas (`CiliumNetworkPolicy`), que
añaden reglas por ruta HTTP, por nombre DNS y más. Las veremos en el tema de [service mesh](../11-service-mesh/README.md).

[`kubernetes/examples/netpol-demo.yaml`](../../kubernetes/examples/netpol-demo.yaml) contiene:

| Política | Efecto |
|----------|--------|
| `denegar-entrada` | Ningún pod de `demo` recibe tráfico |
| `permitir-whoami` | `whoami` recibe en el puerto 80 solo de pods con etiqueta `acceso=si` |

## Pasos

Con [whoami](04-loadbalancer-en-casa.md) desplegado:

1. **Antes de la política**, un pod cualquiera llega:

   ```bash
   kubectl -n demo run cliente --rm -it --image=busybox:1.37 --restart=Never -- \
     wget -qO- -T 3 http://whoami | head -1
   ```

2. **Aplica las políticas** y repite:

   ```bash
   kubectl apply -f kubernetes/examples/netpol-demo.yaml
   kubectl -n demo run cliente --rm -it --image=busybox:1.37 --restart=Never -- \
     wget -qO- -T 3 http://whoami
   ```

   Ahora falla por tiempo de espera: el paquete se descarta.

3. **Con la etiqueta** permitida:

   ```bash
   kubectl -n demo run cliente --rm -it --image=busybox:1.37 --restart=Never --labels=acceso=si -- \
     wget -qO- -T 3 http://whoami | head -1
   ```

   Vuelve a responder.

4. ¿Y desde tu portátil, por la IP de LoadBalancer? `curl http://192.168.1.200` también falla: el tráfico
   de fuera no lleva la etiqueta `acceso=si`. Para permitirlo habría que añadir una regla `from` con
   `ipBlock` de tu red. Pruébalo como ejercicio.

## Comprobación

En la [página siguiente](06-hubble.md) verás los paquetes descartados con Hubble, con el motivo.

Limpieza al terminar el tema: `kubectl delete namespace demo`.

---
Anterior: [04 · LoadBalancer en casa](04-loadbalancer-en-casa.md) · [Índice del tema](README.md) · Siguiente: [06 · Hubble](06-hubble.md)
