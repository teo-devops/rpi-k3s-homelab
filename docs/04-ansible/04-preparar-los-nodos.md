# Preparar los nodos

## Objetivo

Ejecutar la fase 1 completa: tres nodos con el sistema listo para K3s y Cilium.

## Requisitos

- Nodos flasheados y accesibles por SSH ([02](../02-sistema-operativo/README.md)).
- IPs fijas e inventario rellenado ([03/02](../03-red/02-reserva-dhcp.md)).

## Pasos

1. **Herramientas del portátil.**

   ```bash
   make check
   ```

   Si falta Ansible: `pipx install --include-deps ansible`.

2. **Colecciones de Ansible.**

   ```bash
   make deps
   ```

3. **Conectividad.**

   ```bash
   make ping
   ```

   Los tres deben responder `"ping": "pong"`.

4. **Simulación.** Muestra qué cambiaría, sin cambiar nada:

   ```bash
   make prepare-dry
   ```

   Algunas tareas fallan o se saltan en modo simulación porque dependen de algo que aún no existe (un
   módulo sin cargar, un fichero sin crear). Es normal; sirve para leer los cambios previstos (`--diff`).

5. **Ejecución real.**

   ```bash
   make prepare
   ```

   Tarda entre 5 y 20 minutos por nodo la primera vez, según cuántos paquetes haya que actualizar. Cada nodo
   se reinicia una vez al final. Ansible espera a que vuelva antes de pasar al siguiente.

6. **Segunda ejecución.** Lánzalo otra vez:

   ```bash
   make prepare
   ```

   Ahora casi todo debe salir `ok` y ningún nodo debe reiniciarse. Eso demuestra que el playbook es
   idempotente (salvo si `apt` encuentra actualizaciones nuevas).

## Comprobación

[05 · Validar](05-validar.md).

## Si cambias algo más adelante

- Solo un nodo: `make prepare LIMIT=rpi4-2g`
- Solo un rol: `make prepare TAGS=sdcard`
- Ambos: `make prepare LIMIT=rpi4-2g TAGS=sdcard`

---
Anterior: [03 · Los roles de este repo](03-roles-de-este-repo.md) · [Índice del tema](README.md) · Siguiente: [05 · Validar](05-validar.md)
