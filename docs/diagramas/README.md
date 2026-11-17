# docs/diagramas/

Fuentes editables de los diagramas de la guía. Cada `.html` es una página autocontenida con un SVG dentro;
el README y las páginas de `docs/` enlazan la versión exportada en [`docs/img/`](../img/).

| Diagrama | Dónde se usa |
|----------|--------------|
| [arquitectura](arquitectura.html) | [README](../../README.md), [00/03](../00-introduccion/03-arquitectura.md) |
| [capas](capas.html) | [00/03](../00-introduccion/03-arquitectura.md) |
| [paquete](paquete.html) | [06/01](../06-redes-cilium/01-que-es-un-cni.md) |
| [gitops](gitops.html) | [07/01](../07-gitops-flux/01-que-es-gitops.md) |
| [capas-flux](capas-flux.html) | [07/02](../07-gitops-flux/02-estructura.md) |
| [sops](sops.html) | [07/05](../07-gitops-flux/05-secretos-sops.md) |

## Por qué no Mermaid

Mermaid coloca las cajas y las flechas solo, y en cuanto un diagrama tiene más de cuatro cajas el resultado
cuesta de leer. Estos diagramas se dibujan a mano con la skill
[diagram-design](https://github.com/cathrynlavery/diagram-design): flechas en ángulo recto, etiquetas que no
pisan las líneas, como mucho nueve cajas y un único elemento destacado. `make docs-check` falla si alguien
añade un bloque ```` ```mermaid ````.

## Cambiar un diagrama

1. Edita el `.html` y ábrelo en el navegador para verlo.
2. Exporta el SVG con las fuentes del sistema (GitHub no carga fuentes web dentro de un SVG):

   ```bash
   python3 <skill diagram-design>/scripts/export_svg.py docs/diagramas/capas.html docs/img/capas.svg --system-fonts
   ```

3. Añade `width` y `height` al `<svg>` exportado con los valores de su `viewBox`.
4. Comprueba que se ve bien en el README o la página donde se usa.
