# Inventario y variables

## Objetivo

Saber dónde se define cada nodo y cada ajuste, y en qué orden se aplican.

## Conceptos

```
ansible/inventory/
├── hosts.example.yml      # plantilla (en Git)
├── hosts.yml              # el tuyo, con tus IPs (fuera de Git, lo crea `make init`)
├── group_vars/
│   └── all.yml            # ajustes comunes a todos los nodos
└── host_vars/
    ├── rpi5-8g.yml        # lo particular de cada nodo
    ├── rpi5-4g.yml
    └── rpi4-2g.yml
```

- **`hosts.yml`** dice **dónde** está cada nodo (IP) y a qué grupo pertenece (`k3s_server`, `k3s_agents`).
- **`group_vars/all.yml`** dice **cómo** quieres el lab: usuario, zona horaria, dominio, protecciones de la SD.
- **`host_vars/<nodo>.yml`** dice **qué es** cada nodo: su tier y sus reservas de memoria.
- **`roles/*/defaults/main.yml`** son los valores por defecto de cada rol, con la prioridad más baja.

Si una variable aparece en varios sitios, gana la más específica:

```
roles/*/defaults  <  group_vars/all  <  host_vars/<nodo>  <  línea de comandos (-e)
```

Ejemplo: `nvme_enabled` vale `false` en `group_vars/all.yml`. Para activarlo solo en `rpi5-8g`, lo pones a
`true` en `host_vars/rpi5-8g.yml`.

La lista completa de variables está en [referencia/variables.md](../referencia/variables.md).

## Pasos

```bash
make init                               # crea hosts.yml desde el ejemplo
$EDITOR ansible/inventory/hosts.yml     # pon tus IPs
$EDITOR ansible/inventory/group_vars/all.yml   # usuario, zona horaria, clave SSH
```

## Comprobación

```bash
cd ansible && ansible-inventory --graph            # grupos y nodos
cd ansible && ansible-inventory --host rpi4-2g     # variables finales de un nodo
```

---
Anterior: [01 · Conceptos](01-conceptos.md) · [Índice del tema](README.md) · Siguiente: [03 · Los roles de este repo](03-roles-de-este-repo.md)
