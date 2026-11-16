# Glosario

| Término | Significado |
|---------|-------------|
| **Agent** | En K3s, nodo que solo ejecuta pods (worker) |
| **Allocatable** | Memoria y CPU de un nodo que pueden usar los pods, tras restar las reservas |
| **BTF** | Información de tipos del kernel que permite a eBPF funcionar en kernels distintos |
| **cgroup** | Mecanismo del kernel para limitar recursos de un grupo de procesos |
| **CNI** | Interfaz estándar de los plugins de red de Kubernetes (Cilium, Flannel...) |
| **Control plane** | Componentes que gestionan el clúster: API server, scheduler, controladores |
| **DNS-01** | Reto de Let's Encrypt que demuestra el control de un dominio creando un registro TXT |
| **eBPF** | Programas seguros que se ejecutan dentro del kernel; base de Cilium |
| **Eviction** | Desalojo de pods que hace el kubelet cuando el nodo se queda sin recursos |
| **GitOps** | Práctica en la que Git es la fuente de verdad y el clúster se reconcilia solo |
| **Handler** | En Ansible, tarea que solo se ejecuta si otra notificó un cambio |
| **Idempotente** | Que ejecutarlo varias veces da el mismo resultado que una vez |
| **Ingress** | Punto de entrada HTTP/HTTPS al clúster que enruta por nombre; aquí, Traefik |
| **kube-proxy** | Componente que implementa los Services con iptables; Cilium lo sustituye |
| **kubelet** | Agente de Kubernetes en cada nodo que arranca y vigila los pods |
| **L2 announcement** | Cilium responde a ARP por una IP de LoadBalancer, para que la red de casa la encuentre |
| **LB-IPAM** | Gestión de IPs de LoadBalancer de Cilium |
| **mTLS** | TLS en ambos sentidos: cliente y servidor se autentican con certificados |
| **Node affinity** | Regla que hace que un pod se ejecute (o prefiera ejecutarse) en ciertos nodos |
| **PVC** | PersistentVolumeClaim: petición de almacenamiento persistente de un pod |
| **Rol (Ansible)** | Conjunto reutilizable de tareas, variables y plantillas con un propósito |
| **Server** | En K3s, nodo que ejecuta el control plane |
| **Service mesh** | Capa que gestiona la comunicación entre servicios: mTLS, reintentos, políticas L7 |
| **Sidecar** | Contenedor auxiliar dentro de cada pod (p. ej. el proxy de un service mesh) |
| **SOPS / age** | Herramientas para cifrar secretos y poder guardarlos en Git |
| **Swap** | Memoria virtual en disco o comprimida; aquí desactivada |
| **Taint** | Marca en un nodo que rechaza pods que no la toleren |
| **Throttling** | La Pi baja su frecuencia por calor o falta de corriente |
| **Tier** | En este repo, la categoría de memoria de un nodo: `large`, `medium`, `small` |
| **Tunnel (Cloudflare)** | Conexión saliente desde casa a Cloudflare para publicar servicios sin abrir puertos |
