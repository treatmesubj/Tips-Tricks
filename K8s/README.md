- [Kubernetes (K8s) API](https://kubernetes.io/docs/reference/kubernetes-api/)
- [Red Hat OpenShift Container Platform Templates](https://docs.openshift.com/container-platform/3.11/dev_guide/templates.html#dev-guide-templates)

### Config
```bash
kubectl config get-clusters
kubectl config get-contexts
kubectl config get-users

kubectl config use-context <context-name>
```

### Resource Usage
```bash
kubectl top nodes
kubectl describe nodes
kubectl describe nodes | grep -A 2 -e "^\\s*CPU Requests"

kubectl top pods -n <namespace>
```

### Get all K8s Resources/Objs
```bash
kubectl api-resources --verbs=list --namespaced -o name

kubectl api-resources --verbs=list --namespaced -o name \
  | xargs -n 1 kubectl get --show-kind --ignore-not-found -l <label>=<value> -n <namespace>
```

### Debug Pods
- Bad: you shouldn't directly mess w/ app container
```bash
kubectl --namespace demo exec -it <pod-name> -- sh
```

- [Good](https://en.wikipedia.org/wiki/Linux_namespaces): create ephemeral container in app's same Linux Kernel namespace in an extra pod, which can be deleted after
```bash
kubectl --namespace demo get pod <pod-name> --output yaml
kubectl debug --namespace demo <pod-name> --image alpine \
    --stdin --tty --share-processes --copy-to <pod-copy-name>
    # ps aufx
    # exit
kubectl --namespace demo delete pod <pod-copy-name>
```

#### Investigating
```bash
kubectl get <resource-type> <resource> -o yaml
kubectl describe <resource-type> <resource|pod>
kubectl get event --sort-by=.metadata.creationTimestamp --field-selector involvedObject.name=<resource|pod>
kubectl logs -f <resource>

kubectl edit <resource-type>/<resource>

# cronjobs
kubectl get cronjobs
kubectl create job --from=cronjob/<cronjob> <name-for-job>
kubectl get jobs
kubectl get pods

# copy file from pod to local machine
kubectl exec -it <pod> -- bash
# find / -type f -name 'myfile'
kubectl cp <pod>:/path/to/myfile myfile

# copy local file to pod
kubectl cp myfile <pod>:/path/to/myfile
```

## Networking
```bash
kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml
kubectl exec -it dnsutils -- bash
kubectl get services  # note IP addresses
cat /etc/resolv.conf  # cluster DNS service
dig +search <service>
```

Your laptop, the host, has a bridge network interface `cni0` into the private network that the containers are running in.
Your host's IP is `10.42.0.1` on that private network.
```
$ ip addr show dev cni0
188: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    link/ether 06:d3:9b:0c:ee:be brd ff:ff:ff:ff:ff:ff
    inet 10.42.0.1/24 brd 10.42.0.255 scope global cni0
       valid_lft forever preferred_lft forever
    inet6 fe80::4d3:9bff:fe0c:eebe/64 scope link
       valid_lft forever preferred_lft forever
```
Each of those containers have a routing table and their default gateway to any other IP is your host: `10.42.0.1`
```
$ sudo ip -all netns exec route
...
netns: cni-bd52b5cc-b724-fd82-01c7-bcf0f0d97f49
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         10.42.0.1       0.0.0.0         UG    0      0        0 eth0
10.42.0.0       0.0.0.0         255.255.255.0   U     0      0        0 eth0
10.42.0.0       10.42.0.1       255.255.0.0     UG    0      0        0 eth0
```

Services and pods have IPs
```
$ kubectl get services -A
NAMESPACE     NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
default       kubernetes            ClusterIP   10.43.0.1       <none>        443/TCP                      2d23h
kube-system   kube-dns              ClusterIP   10.43.0.10      <none>        53/UDP,53/TCP,9153/TCP       2d23h
kube-system   metrics-server        ClusterIP   10.43.3.140     <none>        443/TCP                      2d23h

$ kubectl get pods -A -o=custom-columns=NAME:metadata.name,STATUS:status.phase,IP:status.podIP
NAME                                      STATUS    IP
dnsutils                                  Running   10.42.0.16
coredns-ccb96694c-7vgbs                   Running   10.42.0.3
local-path-provisioner-5cf85fd84d-g5q46   Running   10.42.0.5
metrics-server-5985cbc9d7-9mkb6           Running   10.42.0.6
```

