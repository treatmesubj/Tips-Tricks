# CrashLoopBackOff
kubectl describe pod <name>
kubectl logs <podname> -p
kubectl logs <podname> -n  --previous  # check logs of previous container
kubectl get events --sort-by=.metadata.creationTimestamp  # check cluster events
# try increasing memory
