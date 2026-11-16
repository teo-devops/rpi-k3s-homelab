# cilium

Red del clúster: CNI, sustituto de kube-proxy, LoadBalancer en la LAN (LB-IPAM + L2) y Hubble.

| Fichero | Qué es |
|---------|--------|
| `values.yaml` | Valores de Helm, comentados |
| `config/lb-ippool.yaml` | Rango de IPs de LoadBalancer. **Edítalo con tu red** |
| `config/l2-policy.yaml` | Por qué interfaces se anuncian esas IPs |

| `helmrepository.yaml`, `helmrelease.yaml`, `kustomization.yaml` | Cilium gestionado por Flux (fase 3) |

Instalación inicial (fase 2): `make cilium`. Desde la fase 3, Flux adopta esa misma release de Helm y
`make cilium` se niega a ejecutarse: los cambios se hacen aquí y con `git push`.

Guía: [docs/06-redes-cilium](../../../docs/06-redes-cilium/README.md).
