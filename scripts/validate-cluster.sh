#!/usr/bin/env bash
# Comprobación rápida de un clúster Kubernetes ya instalado (fase 2 en adelante).
# Usa el kubeconfig activo (KUBECONFIG o ~/.kube/config).
# Uso: ./scripts/validate-cluster.sh
set -uo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl no está instalado. Lo necesitarás a partir de la fase 2."
  exit 1
fi
if ! kubectl cluster-info >/dev/null 2>&1; then
  echo "No hay clúster accesible con el kubeconfig actual. ¿Has completado la fase 2?"
  exit 1
fi

problems=0

echo "Nodos (con su tier de memoria)"
kubectl get nodes -L homelab.io/tier -o wide
not_ready=$(kubectl get nodes --no-headers | awk '$2 != "Ready" {print $1}')
if [ -n "$not_ready" ]; then
  echo "  Nodos que no están Ready: $not_ready"
  problems=$((problems + 1))
fi

echo
echo "Pods que no están Running ni Completed"
bad_pods=$(kubectl get pods -A --no-headers | awk '$4 != "Running" && $4 != "Completed"')
if [ -n "$bad_pods" ]; then
  echo "$bad_pods"
  problems=$((problems + 1))
else
  echo "  Ninguno"
fi

echo
echo "Uso de recursos (necesita metrics-server, que K3s trae de serie)"
kubectl top nodes 2>/dev/null || echo "  metrics-server aún no responde; prueba en un minuto."

echo
if [ "$problems" -eq 0 ]; then
  echo "Clúster sano."
else
  echo "Hay $problems tipo(s) de problema arriba. Ver docs/12-operaciones/"
  exit 1
fi
