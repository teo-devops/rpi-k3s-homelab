# cilium

Red del clúster: CNI, sustituto de kube-proxy, LoadBalancer en la LAN (LB-IPAM + L2) y Hubble.

| Fichero | Qué es |
|---------|--------|
| `values.yaml` | Valores de Helm, comentados |
| `config/lb-ippool.yaml` | Rango de IPs de LoadBalancer. **Edítalo con tu red** |
| `config/l2-policy.yaml` | Por qué interfaces se anuncian esas IPs |

Instalación (fase 2): `make cilium`. En la fase 3, Flux tomará el relevo de esta misma release de Helm.

Guía: [docs/06-redes-cilium](../../../docs/06-redes-cilium/README.md).
