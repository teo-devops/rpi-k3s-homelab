# Qué es un homelab

## Objetivo

Tener claro qué esperar de este proyecto y qué no.

## Conceptos

Un **homelab** es infraestructura propia, en casa, para aprender y para alojar servicios útiles. La diferencia
con un entorno de empresa no es la tecnología (aquí usamos la misma: Kubernetes, GitOps, Prometheus), sino
las restricciones:

- **Recursos escasos.** 14 GB de RAM entre tres placas. Cada componente tiene que justificar lo que consume.
- **Hardware desigual.** Una placa de 8 GB, otra de 4 GB y otra de 2 GB. En una empresa los nodos suelen ser
  iguales; aquí aprenderás a repartir la carga según lo que aguanta cada uno.
- **Discos frágiles.** Las tarjetas SD se desgastan con las escrituras. Hay que cuidarlas.
- **Tu red de casa.** No hay balanceador de carga en la nube ni IP pública fija. Hay que resolver cómo llegar
  a los servicios sin abrir puertos del router.

Esas restricciones son justo lo que hace el lab educativo: obligan a entender cada pieza en lugar de
aceptar los valores por defecto.

### Lo que este repo es

- Una guía paso a paso que se puede reproducir con el mismo hardware o uno parecido.
- Código real (Ansible, manifiestos de Kubernetes) comentado para que se entienda al leerlo.
- Un registro de decisiones: por qué se eligió cada herramienta y qué se descartó.

### Lo que no es

- Un instalador de un solo comando. Cada fase se ejecuta y se comprueba por separado, a propósito.
- Una plataforma de producción con alta disponibilidad real. Con un solo control plane, si la Pi de 8 GB
  se apaga, el clúster deja de aceptar cambios (las aplicaciones siguen funcionando un tiempo). La
  [decisión 0001](../decisiones/0001-sqlite-vs-etcd.md) explica por qué y cómo evolucionar.

## Siguiente paso

[02 · Qué vas a aprender](02-que-vas-a-aprender.md)

---
[Índice del tema](README.md) · Siguiente: [02 · Qué vas a aprender](02-que-vas-a-aprender.md)
