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

```bash
kubectl get events --sort-by=.metadata.creationTimestamp  # cluster events
kubectl get <resource-type>
kubectl describe <resource-type> <resource>
kubectl get <resource-type> <resource> -o yaml
kubectl logs -f <resource>
kubectl edit <resource-type>/<resource>
# cronjobs
kubectl get cronjobs
kubectl create job --from=cronjob/<cronjob> <name-for-job>
kubectl get jobs
kubectl get pods
```

## Networking
```bash
kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml
kubectl exec -it dnsutils bash
kubectl get services  # note IP addresses
cat /etc/resolv.conf  # cluster DNS service
dig +search <service>
```
