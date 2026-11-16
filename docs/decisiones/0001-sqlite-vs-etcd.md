# 0001 · Un server con SQLite en lugar de tres con etcd

- **Estado**: Aceptada
- **Fecha**: 2026-11-16

## Contexto

K3s puede guardar el estado del clúster en SQLite (un solo server) o en etcd embebido (alta disponibilidad
con tres o más servers). Tenemos tres nodos con 8, 4 y 2 GB y tarjetas SD.

## Decisión

Un único server (`rpi5-8g`) con SQLite. Los otros dos nodos son agents.

## Alternativas consideradas

| Opción | A favor | En contra |
|--------|---------|-----------|
| 1 server, SQLite | Ligero, pocas escrituras, simple de entender | Si cae el server, no se pueden hacer cambios en el clúster |
| 3 servers, etcd | Alta disponibilidad real | etcd escribe y sincroniza a disco continuamente: desgasta la SD y es lento en ella. La Pi de 2 GB no aguanta un control plane. Un quórum con un nodo débil es un quórum frágil |
| 2 servers | — | etcd necesita mayoría: con 2 servers, si cae uno se pierde el quórum. Peor que 1 |

## Consecuencias

- Si `rpi5-8g` se apaga, las aplicaciones de los otros nodos siguen funcionando un tiempo, pero no se pueden
  desplegar cambios ni reprogramar pods.
- Hay que hacer copia de `/var/lib/rancher/k3s/server/db/` (fase 4).
- Camino a alta disponibilidad: tres nodos con al menos 4 GB y NVMe. K3s permite migrar de SQLite a etcd
  arrancando el server con `--cluster-init`.
