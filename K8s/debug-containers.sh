# Source: https://gist.github.com/vfarcic/9d9de2cf93b6514ab8cf8fed56542352

##################################################################
# How to Debug Kubernetes Applications With Ephemeral Containers #
# https://youtu.be/qKb6loAEPV0                                   #
##################################################################

#######
# Bad #  you shouldn't directly mess w/ app container
#######
kubectl --namespace demo exec -it <pod-name> -- sh

########  https://en.wikipedia.org/wiki/Linux_namespaces
# Good #    create ephemeral container in app's same Linux Kernel namespace
########      in an extra pod, which can be deleted after
kubectl --namespace demo get pod <pod-name> --output yaml

kubectl debug --namespace demo <pod-name> --image alpine \
    --stdin --tty --share-processes --copy-to <pod-copy-name>
    # ps aufx
    # exit

kubectl --namespace demo delete pod <pod-copy-name>

