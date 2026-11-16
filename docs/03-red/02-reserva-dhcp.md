# Reserva DHCP

## Objetivo

Que cada nodo tenga siempre la misma IP.

## Conceptos

Dos maneras de conseguir una IP fija:

- **Reserva DHCP** (recomendada): el router asocia la MAC del nodo a una IP. El nodo sigue pidiendo IP por
  DHCP y siempre recibe la misma. Toda la configuración de red está en un único sitio, el router.
- **IP estática en el nodo**: el nodo se configura la IP él mismo. Si cambias de router o de red, cada nodo
  queda inaccesible hasta que lo arreglas con teclado y pantalla.

Una nota sobre Pi-hole: puede hacer de servidor DHCP, pero si lo ejecutas **dentro** del clúster, los nodos
dependerían del clúster para obtener su propia IP. Si el clúster no arranca, no hay IP, y sin IP no arranca
el clúster. Por eso las reservas van en el router (o en un Pi-hole fuera del clúster).

## Pasos

1. Con las MAC que anotaste en el [primer arranque](../02-sistema-operativo/02-primer-arranque.md), entra
   en tu router, sección DHCP (a veces "IP estática", "reserva de dirección" o "LAN"), y crea una reserva
   por nodo.
2. Reinicia los nodos (o espera a que renueven la concesión) y comprueba que tienen la IP nueva.
3. Copia el inventario de ejemplo y pon las IPs:

   ```bash
   make init
   $EDITOR ansible/inventory/hosts.yml
   ```

### Alternativa: IP estática con Ansible

Si tu router no permite reservas, el rol [`network`](../../ansible/roles/network/tasks/main.yml) configura
IP estática con NetworkManager. En `host_vars/<nodo>.yml`:

```yaml
network_static_enabled: true
network_ipv4_address: 192.168.1.11/24   # la IP actual del nodo
network_ipv4_gateway: 192.168.1.1
network_dns_servers: ["192.168.1.1"]
```

Por seguridad, el rol exige que la IP sea la misma por la que Ansible está conectado: cambiarla en caliente
cortaría la conexión a mitad del playbook.

## Comprobación

```bash
make ping
```

Los tres nodos deben responder `pong`.

---
Anterior: [01 · Plan de direcciones](01-plan-de-direcciones.md) · [Índice del tema](README.md) · Siguiente: [03 · DNS local](03-dns-local.md)
