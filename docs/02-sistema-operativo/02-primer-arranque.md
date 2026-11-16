# Primer arranque

## Objetivo

Los tres nodos encendidos, localizados en la red y accesibles por SSH con tu clave.

## Pasos

1. Inserta las tarjetas, conecta el Ethernet y la alimentación. El primer arranque tarda 1-2 minutos
   (expande el sistema de ficheros y aplica la configuración de Imager).
2. Localiza las IPs. Opciones, de más fácil a más técnica:
   - La página de "dispositivos conectados" de tu router.
   - mDNS, si tu red lo permite: `ping rpi5-8g.local`
   - Escanear la red: `nmap -sn 192.168.1.0/24`
3. Entra en cada uno:

   ```bash
   ssh homelab@192.168.1.11
   ```

   La primera vez te preguntará si confías en la huella del servidor: responde `yes`.
4. Mientras estás dentro, anota la MAC de la interfaz cableada; la necesitarás para la
   [reserva DHCP](../03-red/02-reserva-dhcp.md):

   ```bash
   ip link show eth0 | awk '/ether/ {print $2}'
   ```

## Comprobación

```bash
ssh homelab@192.168.1.11 'hostname; uname -m'
```

Debe responder sin pedir contraseña, con el hostname correcto y `aarch64`.

## Errores comunes

- **`Permission denied (publickey)`**: la clave pegada en Imager no es la que usa tu `ssh`. Prueba
  `ssh -i ~/.ssh/id_ed25519 homelab@<ip>`.
- **`REMOTE HOST IDENTIFICATION HAS CHANGED`**: has reflasheado una tarjeta y la IP es la misma. Borra la
  huella vieja: `ssh-keygen -R 192.168.1.11`.
- **El nodo no aparece en la red**: revisa el cable y el LED verde de actividad. Si el LED parpadea en
  patrones repetidos, la placa indica un error de arranque (tarjeta mal flasheada).

---
Anterior: [01 · Flashear la SD](01-flashear-la-sd.md) · [Índice del tema](README.md) · Siguiente: [03 · Qué cambia Ansible y por qué](03-que-cambia-ansible.md)
