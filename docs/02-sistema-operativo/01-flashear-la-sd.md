# Flashear la SD

## Objetivo

Tres tarjetas SD con Raspberry Pi OS Lite de 64 bits, cada una con su hostname, tu usuario y tu clave SSH,
listas para arrancar sin teclado ni pantalla.

## Conceptos

- **Lite**: sin escritorio. Ahorra unos 300-500 MB de RAM y muchas escrituras. Un servidor no necesita escritorio.
- **64 bits**: K3s, Cilium y casi todas las imágenes de contenedor actuales son `arm64`. Con el sistema de
  32 bits no funcionaría. El playbook lo comprueba y se detiene si no es así.
- **Configuración previa en Imager**: Imager escribe usuario, hostname y clave SSH en la tarjeta. Así el
  primer arranque ya es accesible por SSH, sin contraseñas.

## Pasos

1. En tu portátil, si no tienes clave SSH:

   ```bash
   ssh-keygen -t ed25519 -C "homelab"
   cat ~/.ssh/id_ed25519.pub     # la copiarás en Imager
   ```

2. Instala [Raspberry Pi Imager](https://www.raspberrypi.com/software/).
3. Para cada tarjeta:
   - Dispositivo: Raspberry Pi 5 o Raspberry Pi 4 según la placa.
   - Sistema operativo: *Raspberry Pi OS (other)* → **Raspberry Pi OS Lite (64-bit)**.
   - Personalización:

     | Ajuste | Valor |
     |--------|-------|
     | Hostname | `rpi5-8g`, `rpi5-4g` o `rpi4-2g` |
     | Usuario | `homelab` (o el que quieras; cámbialo en `group_vars/all.yml`) |
     | Contraseña | una robusta: Ansible desactivará el acceso por contraseña igualmente |
     | Wi-Fi | ninguno |
     | Zona horaria | la tuya |
     | SSH | activado, **solo clave pública**, pega tu `id_ed25519.pub` |

4. Etiqueta físicamente cada tarjeta y cada placa con su hostname. Te ahorrará confusiones.

## Comprobación

Al terminar, Imager verifica la escritura. Si da error, prueba otra tarjeta: las SD defectuosas son
habituales y causan fallos muy raros más adelante.

## Errores comunes

- **Elegir "Raspberry Pi OS (64-bit)" con escritorio**: funciona, pero desperdicia memoria. Usa Lite.
- **Olvidar la clave SSH**: tendrás que entrar con contraseña la primera vez y copiarla con
  `ssh-copy-id homelab@<ip>`.

---
[Índice del tema](README.md) · Siguiente: [02 · Primer arranque](02-primer-arranque.md)
