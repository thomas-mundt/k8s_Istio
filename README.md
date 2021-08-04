# Istio in Kubernetes

## Deploy Istio into a Kubernetes Cluster

```
wget https://github.com/istio/istio/releases/download/1.0.6/istio-1.0.6-linux.tar.gz
tar -xvf istio-1.0.6-linux.tar.gz
```

Add istioctl to our path
```
export PATH=$PWD/istio-1.0.6/bin:$PATH
```

Or copy to /usr/local/bin
```
cp istioctl /usr/local/bin/
```

Check if Istio can be installed
```
istioctl verify-install
```

Install Istio with Helm
```
kubectl create namespace istio-system
helm install istio-base manifests/charts/base -n istio-system
helm install istiod manifests/charts/istio-control/istio-discovery -n istio-system

#Optional
helm install istio-ingress manifests/charts/gateways/istio-ingress -n istio-system
helm install istio-egress manifests/charts/gateways/istio-egress -n istio-system

#Check
kubectl get pods -n istio-system
```






Set Istio to NodePort at port 30080
```
sed -i 's/LoadBalancer/NodePort/;s/31380/30080/' ./istio-1.0.6/install/kubernetes/istio-demo.yaml
```

Bring up the Istio control plane
```
kubectl apply -f ./istio-1.0.6/install/kubernetes/istio-demo.yaml
```


Verify that the control plane is running
```
kubectl -n istio-system get pods
```

## Install the bookinfo application with manual sidecar injection

```
kubectl apply -f <(istioctl kube-inject -f istio-1.0.6/samples/bookinfo/platform/kube/bookinfo.yaml)
```

Verify that the application is running and that there are 2 containers per pod
```
kubectl get pods
# Ignore the busybox pod, that's part of the environment
```

Once everything is running, let's create an ingress and virtual service for the application
```
kubectl apply -f istio-1.0.6/samples/bookinfo/networking/bookinfo-gateway.yaml
# Verify the page loads at the uri http://<kn1_IP ADDRESS>:30080/productpage
```

## Verify That Routing Rules Are Working by Configuring the Application to Route to v1 Then v2 of the reviews Backend Service

Set the default destination rules
```
kubectl apply -f istio-1.0.6/samples/bookinfo/networking/destination-rule-all.yaml
```


Route all traffic to version 1 of the application and verify that it is working
```
kubectl apply -f istio-1.0.6/samples/bookinfo/networking/virtual-service-all-v1.yaml
```

Update the virtual service file to point to version 2 of the service and verify that it is working. Edit istio-1.0.6/samples/bookinfo/networking/virtual-service-all-v1.yaml (using whatever text editor you like) and change this:
```
- destination:
        host: reviews
        subset: v1
# to this:
- destination:
        host: reviews
        subset: v2
```


## Conclusion


We used Istio to deploy an application in a Kubernetes cluster, and made sure routing rules were sending traffic to whichever targets (versions of a backend service in this case) we wanted. We're done. Congratulations!





