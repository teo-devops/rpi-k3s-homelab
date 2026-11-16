# Cuidar la SD

## Objetivo

Reducir las escrituras innecesarias en las tarjetas SD y saber medir cuánto se escribe.

## Conceptos

Rol [`sdcard`](../../ansible/roles/sdcard/tasks/main.yml), activado con `sdcard_protection_enabled: true`.

| Cambio | Ganancia | Coste |
|--------|----------|-------|
| journald en RAM (`Storage=volatile`, máx. 64 MB) | Los logs del sistema dejan de escribirse en la SD | Los logs del sistema se pierden al reiniciar |
| `noatime` en `/` | No se escribe la fecha de acceso al leer un fichero | Ninguno práctico |
| `/tmp` en RAM (máx. 256 MB) | Temporales fuera de la SD | Lo que se escriba en `/tmp` ocupa RAM |

Raspberry Pi OS ya monta `/` con `noatime`, y Debian 13 (Trixie) ya pone `/tmp` en RAM: el rol solo
actúa si falta.

**Sobre perder los logs al reiniciar**: es aceptable porque los logs importantes (los de los pods) los
recogeremos en el clúster en la fase 6. Si necesitas investigar un reinicio inesperado, cambia
temporalmente `Storage=persistent` en `/etc/systemd/journald.conf.d/10-homelab.conf`.

## Comprobación

```bash
findmnt /tmp                      # FSTYPE tmpfs
journalctl --header | grep -i 'file path'   # debe estar en /run/log/journal (RAM)
sudo iotop -oa                    # quién escribe en disco, acumulado. Ctrl+C para salir
```

Para ver el total escrito en la SD desde el arranque:

```bash
awk '$3=="mmcblk0" {print $10*512/1024/1024 " MB escritos"}' /proc/diskstats
```

Repite el comando tras un día con K3s instalado y tendrás una idea del ritmo de desgaste.

---
Anterior: [04 · Páginas de 4 KB y BTF](04-paginas-4k-y-btf.md) · [Índice del tema](README.md) · Siguiente tema: [03 · Red](../03-red/README.md)
