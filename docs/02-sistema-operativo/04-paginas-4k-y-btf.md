# Páginas de 4 KB y BTF

## Objetivo

Entender dos requisitos del kernel que impone Cilium y que no son evidentes.

## Conceptos

### Tamaño de página

El kernel gestiona la memoria en bloques llamados **páginas**. Lo habitual en Linux es 4 KB. La Pi 5 con
Raspberry Pi OS arranca por defecto un kernel con páginas de **16 KB** (`kernel_2712.img`), algo más rápido
en algunas cargas.

El problema: parte del software asume páginas de 4 KB. Algunas herramientas eBPF y algunas imágenes de
contenedor (las que usan ciertos asignadores de memoria, como jemalloc compilado para 4 KB) fallan o se
comportan mal con 16 KB. En un clúster con Cilium no merece la pena el riesgo.

La solución es oficial y sencilla: decirle al firmware que cargue el kernel genérico de 64 bits, que usa
4 KB. Es una línea en `config.txt`:

```
kernel=kernel8.img
```

La añade el rol [`boot`](../../ansible/roles/boot/templates/config.txt.block.j2), solo en las Pi 5. La Pi 4 ya
usa 4 KB.

### BTF

**eBPF** permite cargar pequeños programas dentro del kernel de forma segura. Cilium lo usa para toda la
red: en vez de miles de reglas iptables, programas eBPF deciden qué hacer con cada paquete.

**BTF** (BPF Type Format) es información sobre las estructuras internas del kernel. Permite que un programa
eBPF compilado una vez funcione en kernels distintos. El kernel la expone en `/sys/kernel/btf/vmlinux`.

Sin BTF, Cilium funciona en su configuración básica, pero algunas funciones avanzadas no. Por eso la
validación lo comprueba y avisa, en lugar de suponer.

## Comprobación

```bash
getconf PAGESIZE                 # 4096
ls -l /sys/kernel/btf/vmlinux    # debe existir
uname -r                         # en Pi 5, sin el sufijo "-v8-16k"
```

O todo junto: `make validate`.

## Errores comunes

- **PAGESIZE sigue siendo 16384 tras `make prepare`**: el nodo no se ha reiniciado o `config.txt` tiene un
  `kernel=` posterior que lo sobreescribe. Mira el final de `/boot/firmware/config.txt`.
- **Falta BTF**: plan B, instalar Ubuntu Server para Raspberry Pi, que trae BTF y páginas de 4 KB de
  serie. Los roles de Ansible están pensados para Debian y funcionarían casi sin cambios.

---
Anterior: [03 · Qué cambia Ansible y por qué](03-que-cambia-ansible.md) · [Índice del tema](README.md) · Siguiente: [05 · Cuidar la SD](05-cuidar-la-sd.md)
