#!/bin/sh


kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.48.1/deploy/static/provider/do/deploy.yaml --kubeconfig=/Users/bdk/.kube/k8s-cluster.yaml

curl -L https://istio.io/downloadIstio | sh -
cd istio-1.10.3

kubectl create namespace istio-system --kubeconfig=/Users/bdk/.kube/k8s-cluster.yaml
helm install istio-base manifests/charts/base -n istio-system --kubeconfig=/Users/bdk/.kube/k8s-cluster.yaml
helm install istiod manifests/charts/istio-control/istio-discovery -n istio-system --kubeconfig=/Users/bdk/.kube/k8s-cluster.yaml
helm install istio-ingress manifests/charts/gateways/istio-ingress -n istio-system --kubeconfig=/Users/bdk/.kube/k8s-cluster.yaml
helm install istio-egress manifests/charts/gateways/istio-egress -n istio-system --kubeconfig=/Users/bdk/.kube/k8s-cluster.yaml

kubectl get pods -n istio-system --kubeconfig=/Users/bdk/.kube/k8s-cluster.yaml -w

wget https://kiali.org/helm-charts/kiali-server-1.38.0.tgz
tar xvzf kiali-server-1.38.0.tgz
cd kiali-server
helm install kiali-server  --namespace istio-system --set auth.strategy="anonymous"    . --kubeconfig=/Users/bdk/.kube/k8s-cluster.yaml
