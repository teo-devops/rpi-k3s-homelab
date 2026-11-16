# Instalar Cilium

## Objetivo

Cilium funcionando en los tres nodos, nodos en `Ready` y el pool de IPs de LoadBalancer configurado.

## Conceptos

Cilium se instala con **Helm** (el gestor de paquetes de Kubernetes). Un *chart* de Helm es una plantilla;
los *valores* la personalizan. Todos nuestros valores están en
[`kubernetes/infrastructure/cilium/values.yaml`](../../kubernetes/infrastructure/cilium/values.yaml), comentados.

| Valor | Qué hace | Por qué |
|-------|----------|---------|
| `kubeProxyReplacement: true` | Cilium implementa los Services | K3s se instaló sin kube-proxy |
| `k8sServiceHost` / `k8sServicePort` | IP y puerto del API server | Sin kube-proxy, Cilium no puede usar el Service `kubernetes` para encontrarlo: lo implementa él mismo. El script toma la IP de tu kubeconfig |
| `ipam.mode: cluster-pool` + `10.42.0.0/16` | De dónde salen las IPs de pods; un /24 por nodo | Mismo rango que `cluster-cidr` de K3s, como indica la guía oficial de Cilium para K3s |
| `routingMode: native` + `autoDirectNodeRoutes` | Sin túnel; rutas directas entre nodos | Los tres nodos comparten switch ([01](01-que-es-un-cni.md)) |
| `bpf.masquerade: true` | NAT de pods hacia internet con eBPF | Más eficiente que iptables |
| `l2announcements.enabled` | Anunciar IPs de LoadBalancer en la LAN | Sustituye a MetalLB ([04](04-loadbalancer-en-casa.md)) |
| `k8sClientRateLimit` | Más peticiones por segundo al API server | Recomendado por Cilium con anuncios L2 |
| `operator.replicas: 1` + `nodeSelector` | Un operador, en el nodo large | Ahorra memoria; 3 nodos no necesitan dos |
| `hubble.relay`, `hubble.ui` en large | Observabilidad | Ver [06](06-hubble.md) |

La versión de Cilium está fijada en el [`Makefile`](../../Makefile) (`CILIUM_VERSION := 1.20.4`).

### Qué hace `make cilium`

Script: [`scripts/install-cilium.sh`](../../scripts/install-cilium.sh).

1. Comprueba que el contexto de `kubectl` es `rpi-k3s-homelab`. Si no, se para: protege tus otros clústeres.
2. Saca la IP del API server del kubeconfig.
3. `helm upgrade --install` con los valores (instala o actualiza, idempotente).
4. Espera a que existan los tipos de recurso de Cilium y aplica
   [`config/`](../../kubernetes/infrastructure/cilium/config/): el pool de IPs y la política de anuncios L2.
5. Espera a que todos los nodos estén `Ready`.

## Pasos

1. **Edita el pool de IPs** con el rango que reservaste en tu red
   ([03/01](../03-red/01-plan-de-direcciones.md)):
   [`config/lb-ippool.yaml`](../../kubernetes/infrastructure/cilium/config/lb-ippool.yaml).
2. Instala:

   ```bash
   make cilium
   ```

   La primera vez tarda varios minutos: cada nodo descarga las imágenes de Cilium (las de la Pi 4 más
   despacio). Si quieres verlo mientras tanto, en otra terminal:

   ```bash
   export KUBECONFIG=~/.kube/rpi-k3s-homelab.yaml
   kubectl -n kube-system get pods -w
   ```

3. Instala la CLI de Cilium en tu portátil (`make check` te da el enlace). Es opcional pero muy útil.

## Comprobación

```bash
make nodes            # los tres en Ready
make cilium-status    # todo en OK
```

`cilium status` debe mostrar `Cilium: OK`, `Operator: OK`, `Hubble Relay: OK` y
`KubeProxyReplacement: True`. Y los pods que esperaban la red ya arrancan:

```bash
kubectl get pods -A
```

### Prueba completa (opcional)

```bash
cilium connectivity test
```

Despliega pods de prueba y comprueba decenas de caminos de red. En este hardware tarda 10-20 minutos.
Al terminar borra su namespace: `kubectl delete namespace cilium-test-1`.

## Actualizar Cilium

Antes de la fase 3: cambia `CILIUM_VERSION` en el Makefile (tras comprobar su compatibilidad con tu versión
de Kubernetes) y vuelve a ejecutar `make cilium`. Helm actualiza en orden, nodo a nodo.

Desde la fase 3 lo gestiona Flux: cambia `version` en
[`helmrelease.yaml`](../../kubernetes/infrastructure/cilium/helmrelease.yaml) y haz push
([07/04](../07-gitops-flux/04-flux-adopta-cilium.md)).

---
Anterior: [02 · eBPF en cinco minutos](02-ebpf.md) · [Índice del tema](README.md) · Siguiente: [04 · LoadBalancer en casa](04-loadbalancer-en-casa.md)
