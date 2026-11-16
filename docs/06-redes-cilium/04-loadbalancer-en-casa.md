# LoadBalancer en casa

## Objetivo

Exponer un servicio con una IP de tu red de casa y entender cómo la "encuentra" tu portátil.

## Conceptos

Un Service de tipo `LoadBalancer` pide una IP accesible desde fuera del clúster. En la nube la da el
proveedor. En casa nadie lo hace por defecto: el Service se queda en `<pending>` para siempre. Cilium lo
resuelve en dos partes:

1. **LB-IPAM** reparte IPs del pool
   ([`lb-ippool.yaml`](../../kubernetes/infrastructure/cilium/config/lb-ippool.yaml)) a los Services LoadBalancer.
2. **Anuncios L2** hacen que esas IPs existan en la red. Cuando tu portátil quiere hablar con `192.168.1.200`,
   pregunta por ARP "¿quién tiene 192.168.1.200?". Un nodo elegido por Cilium responde con su MAC. El
   tráfico llega a ese nodo y Cilium lo reparte entre los pods del Service, estén donde estén.

Solo un nodo responde por cada IP (lo elige con un *lease*, un bloqueo en el API server). Si ese nodo cae,
otro adquiere el lease en unos segundos y empieza a responder: failover sin hacer nada.

La [política L2](../../kubernetes/infrastructure/cilium/config/l2-policy.yaml) limita los anuncios a las
interfaces `eth*`, es decir, al cable.

## Pasos

```bash
kubectl apply -f kubernetes/examples/whoami-lb.yaml
kubectl -n demo get service whoami
```

```
NAME     TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)
whoami   LoadBalancer   10.43.82.17    192.168.1.200   80:31234/TCP
```

Desde tu portátil (en la misma red):

```bash
curl http://192.168.1.200
```

La respuesta incluye `Hostname:` (el pod que contestó). Repite varias veces: verás los dos pods alternarse.

¿Qué nodo está anunciando la IP?

```bash
kubectl -n kube-system get lease | grep l2announce
```

### Experimento: failover

Apaga (o desenchufa) el nodo que tiene el lease y lanza `curl` en bucle:

```bash
while true; do curl -s -m 1 http://192.168.1.200 | grep Hostname || echo "sin respuesta"; sleep 1; done
```

Tras unos segundos sin respuesta, otro nodo toma la IP y vuelve a contestar.

## Comprobación

- `EXTERNAL-IP` es una IP de tu pool, no `<pending>`.
- `curl` desde el portátil responde.
- `arp -n 192.168.1.200` (o `ip neigh`) en tu portátil muestra la MAC de uno de los nodos.

Deja el ejemplo desplegado para la [página siguiente](05-networkpolicy.md).

---
Anterior: [03 · Instalar Cilium](03-instalar-cilium.md) · [Índice del tema](README.md) · Siguiente: [05 · NetworkPolicy](05-networkpolicy.md)
