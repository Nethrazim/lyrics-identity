#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KIND_NAME="lyrics-local"

mkdir -p "$HOME/.local/bin"

if [[ ! -x "$HOME/.local/bin/kubectl" ]]; then
  curl -fsSL -o "$HOME/.local/bin/kubectl" "https://dl.k8s.io/release/v1.30.2/bin/linux/amd64/kubectl"
  chmod +x "$HOME/.local/bin/kubectl"
fi

if [[ ! -x "$HOME/.local/bin/kind" ]]; then
  curl -fsSL -o "$HOME/.local/bin/kind" "https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64"
  chmod +x "$HOME/.local/bin/kind"
fi

if ! sg docker -c "docker info >/dev/null"; then
  echo "Docker daemon access failed. Ensure your user is in the docker group and start a new login session."
  exit 1
fi

if ! "$HOME/.local/bin/kind" get clusters | grep -qx "$KIND_NAME"; then
  sg docker -c "$HOME/.local/bin/kind create cluster --name $KIND_NAME --config $ROOT_DIR/k8s/kind-cluster.yaml"
fi

"$HOME/.local/bin/kubectl" apply -f "$ROOT_DIR/k8s/deployment.yaml"
"$HOME/.local/bin/kubectl" apply -f "$ROOT_DIR/k8s/service.yaml"
"$HOME/.local/bin/kubectl" rollout status deployment/lyricsidentity --timeout=180s

"$HOME/.local/bin/kubectl" get pods -o wide
"$HOME/.local/bin/kubectl" get svc lyricsidentity

echo "Access the API at: http://localhost:30080/weatherforecast"
echo "Swagger URL: http://localhost:30080/swagger"
