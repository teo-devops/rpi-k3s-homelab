# Bootstrap

## Objetivo

Repo en GitHub, Flux instalado en el clúster y primera sincronización completa.

## Conceptos

**Bootstrap** es el único paso manual de GitOps: instalar Flux y decirle de dónde leer. A partir de ahí, Flux
se actualiza a sí mismo desde Git (sus propios manifiestos están en `flux-system/`).

La forma habitual es `flux bootstrap github`, que necesita un token de GitHub porque **escribe** en el repo
(sube los manifiestos de Flux y crea una clave de despliegue). Aquí no hace falta:

- Los manifiestos de Flux ya están en el repo (`gotk-components.yaml`, generado con `flux install --export`).
- El repo es **público**: Flux lo lee por HTTPS sin credenciales.
- Flux nunca escribe en Git.

Resultado: ningún token ni clave de GitHub vive en el clúster. Si alguien comprometiera el clúster, no
podría tocar tu repo.

### Qué hace `make flux`

Script: [`scripts/flux-bootstrap.sh`](../../scripts/flux-bootstrap.sh).

1. Comprueba que GitHub tiene la rama `main` y avisa si tu commit local no está subido.
2. `make sops-init`: clave de cifrado ([05](05-secretos-sops.md)).
3. Crea el ConfigMap `cluster-vars` con la IP del API server.
4. Instala los controladores de Flux y espera a sus tipos de recurso.
5. Aplica `flux-system/` (la conexión con Git y el parche al nodo large).
6. Espera a la primera sincronización.

## Pasos

1. **Herramientas**: `make check`. Para esta fase: `git`, `age-keygen`, `sops` y (recomendada) la CLI `flux`.
2. **Repo en GitHub**. Crea un repositorio público vacío y sube este:

   ```bash
   git remote add origin git@github.com:<tu-usuario>/rpi-k3s-homelab.git
   git push -u origin main
   ```

3. **Apunta Flux a tu repo**: si tu usuario no es el del repo original, cambia `url` en
   [`gotk-sync.yaml`](../../kubernetes/clusters/homelab/flux-system/gotk-sync.yaml), haz commit y push.
4. **Instala**:

   ```bash
   make flux
   ```

5. **Guarda la clave age** que te indica el script (fichero `~/.config/sops/age/rpi-k3s-homelab.agekey`)
   en tu gestor de contraseñas.
6. Haz commit del `.sops.yaml` que ha generado (contiene solo la clave pública) y push.

## Comprobación

```bash
make flux-status
```

Todo debe acabar en `Ready True`:

```
NAME                          REVISION            READY   MESSAGE
gitrepository/flux-system     main@sha1:1e5c...   True    stored artifact for revision 'main@sha1:...'
kustomization/flux-system     main@sha1:1e5c...   True    Applied revision: main@sha1:...
kustomization/infra-controllers ...               True    ...
kustomization/infra-configs   ...                 True    ...
kustomization/apps            ...                 True    ...
helmrelease/cilium            1.20.4              True    Helm upgrade succeeded ...
helmrelease/headlamp          0.46.0              True    Helm install succeeded ...
```

La primera vez, `infra-controllers` tarda unos minutos (descarga Headlamp). Mientras tanto verás
`Unknown` o `False` con el mensaje de lo que está esperando.

---
Anterior: [02 · Estructura de kubernetes/](02-estructura.md) · [Índice del tema](README.md) · Siguiente: [04 · Flux adopta Cilium](04-flux-adopta-cilium.md)
