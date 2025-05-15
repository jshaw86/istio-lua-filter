#!/bin/bash

brew install k3d

k3d cluster create istio-demo \
  --port "8080:31402@server:0"

kubectl config use-context k3d-istio-demo
if [ ! -d istio-1.26.0 ]; then
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.26.0 sh -
fi

cd istio-1.26.0
export PATH=$PWD/bin:$PATH

istioctl install --set profile=demo -y

cd  ../

docker build -t flask-error-code-app -f Dockerfile.app .
k3d image import flask-error-code-app -c istio-demo

kubectl apply -f resources/app.yaml
kubectl apply -f resources/gateway.yaml
kubectl apply -f resources/virtualservice.yaml
kubectl apply -f resources/envoyfilter-gateway-lua.yaml
kubectl apply -f resources/istio-log-format-patch.yaml

kubectl -n istio-system rollout restart deployment istio-ingressgateway

