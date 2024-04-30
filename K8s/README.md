- [K8s API](https://kubernetes.io/docs/reference/kubernetes-api/)
- [Red Hat OpenShift Container Platform Templates](https://docs.openshift.com/container-platform/3.11/dev_guide/templates.html#dev-guide-templates)

## Follow Logs
```bash
kubectl logs -f $(kubectl get pods | grep -i 'headcount-monthly-fact-eid-53572.*driver' | tail -1 | awk '{print $1}')
```
