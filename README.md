# Prereqs
- DockerForDesktop installed and running
- brew installed
- bash installed and available at `/bin/bash`
- kubectl installed and PATH'ed

# Setup
1. setup kind, istio and the sample app `./setup.sh`
2. port forward through istio`kubectl -n istio-system port-forward svc/istio-ingressgateway 8081:80`

# Workflow
1. Make changes to the lua script in resources 
2. run above setup 
3. `curl -i -H "Host: app.local" http://localhost:8081/`
4. `kubectl logs -n istio-system -lapp=istio-ingressgateway` 

# reset cluster
```
kind delete cluster -n istio-demo
```

