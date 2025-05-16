#!/bin/bash

# Install kind if not already installed
brew install kind

# Create kind cluster with port forwarding for Istio ingress
kind create cluster --name istio-demo --config resources/kind-cluster-config.yaml

kubectl config use-context kind-istio-demo

# Download Istio if needed
if [ ! -d istio-1.26.0 ]; then
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.26.0 sh -
fi

cd istio-1.26.0
export PATH=$PWD/bin:$PATH

# Install Istio with default demo profile
istioctl install --set profile=demo -y
cd ..

# Build and load your app image into kind
docker build -t flask-error-code-app -f Dockerfile.app .
kind load docker-image flask-error-code-app --name istio-demo

# Deploy your resources
kubectl apply -f resources/app.yaml
kubectl apply -f resources/gateway.yaml
kubectl apply -f resources/virtualservice.yaml
kubectl apply -f resources/envoyfilter-gateway-lua.yaml
kubectl apply -f resources/istio-log-format-patch.yaml

# Restart ingressgateway to ensure changes are picked up
kubectl -n istio-system rollout restart deployment istio-ingressgateway

echo "✅ You can now access your app at: http://localhost:8080/"
