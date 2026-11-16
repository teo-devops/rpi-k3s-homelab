# eBPF en cinco minutos

## Objetivo

Saber qué es eBPF y por qué hace que Cilium sea distinto de un CNI clásico.

## Conceptos

**eBPF** permite cargar programas pequeños dentro del kernel de Linux, que se ejecutan cuando ocurre algo:
llega un paquete, se abre una conexión, se llama a una función. El kernel **verifica** cada programa antes
de cargarlo (que termine, que no lea memoria que no debe), así que es seguro sin tener que escribir un
módulo del kernel.

### iptables frente a eBPF

kube-proxy implementa cada Service con reglas iptables. Un paquete hacia un Service recorre una lista de
reglas hasta encontrar la suya. Con pocos Services da igual; con cientos, cada cambio reescribe tablas
enteras y cada paquete recorre listas largas.

Cilium usa programas eBPF enganchados a las interfaces de red y **mapas** eBPF (tablas hash en el kernel):

| | iptables (kube-proxy) | eBPF (Cilium) |
|---|---|---|
| Buscar el destino de un Service | Recorrer reglas en orden | Una consulta a un mapa hash |
| Actualizar un Service | Reescribir tablas | Cambiar una entrada del mapa |
| Ver qué pasa | Contadores de reglas | Eventos por paquete (Hubble) |
| Identidad para filtrar | IPs | Etiquetas de los pods |

Ese último punto importa: las políticas de Cilium no dependen de IPs (que cambian cada vez que un pod se
reinicia), sino de **identidades** derivadas de las etiquetas del pod.

### Por qué preparamos el kernel en la fase 1

- **Páginas de 4 KB** en la Pi 5 y **BTF**: requisitos de los programas eBPF ([02/04](../02-sistema-operativo/04-paginas-4k-y-btf.md)).
- **`rp_filter` desactivado** en las interfaces `lxc*`: son las que Cilium crea para cada pod.

## Comprobación

Con Cilium instalado, puedes ver los programas y mapas desde el propio agente:

```bash
kubectl -n kube-system exec ds/cilium -- cilium-dbg service list   # Services en mapas eBPF
kubectl -n kube-system exec ds/cilium -- cilium-dbg bpf lb list    # el mapa del balanceador
```

---
Anterior: [01 · Qué es un CNI](01-que-es-un-cni.md) · [Índice del tema](README.md) · Siguiente: [03 · Instalar Cilium](03-instalar-cilium.md)
