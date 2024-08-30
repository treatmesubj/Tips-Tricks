- [K8s API](https://kubernetes.io/docs/reference/kubernetes-api/)
- [Red Hat OpenShift Container Platform Templates](https://docs.openshift.com/container-platform/3.11/dev_guide/templates.html#dev-guide-templates)

### Logs
```bash
# follow logs
while :; do
    pod=$(
        kubectl get pods --field-selector=status.phase==Running \
        | grep -E '.*53572.*-[0-9]{10}-driver' | tail -1 \
        | awk '{print $1}'
    )
    [[ $pod ]] && break
    echo -n .
    sleep 3
done; kubectl logs -f $pod | tee $pod.log
```
```bash
# dump logs
kubectl logs $( \
    kubectl get pods | grep -E '.*53572.*-[0-9]{10}-driver' \
    | tail -1 | awk '{print $1}' \
) | nvim - -c "set ft=log"
```

### Resource Usage
```bash
kubectl top nodes
kubectl describe nodes
kubectl describe nodes | grep -A 2 -e "^\\s*CPU Requests"

kubectl top pods -n <namespace>
```
