# gitops-platform

The repo used to build the platform

## Quick start

Set AWS variables (This example uses temporary creds)

```
export AWS_ACCESS_KEY_ID="XXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="YYYYYYYYYYY"
export AWS_SESSION_TOKEN="ZZZZZZZZZZ"
```

Install software

```
make install

#
# Update path to include installed tools
#
export PATH=$PATH:$HOME/.arkade/bin
```

Create EKS cluster

```
make 
```

NOTE:

* See [Issue #2](https://github.com/myspotontheweb/gitops-platform/issues/2) for work-around to known startup bug

## ArgoCD

Start a proxy to expose the UI

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Retrieve password

```
PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -ogo-template='{{.data.password | base64decode}}')
echo $PASS
```

Login to the UI

* http://localhost:8080

or login with CLI

```
argocd login localhost:8080 --insecure --username=admin --password=$PASS
```

## Adding a new cluster

Start a second cluster

```
eksctl create cluster -f bootstrap/eks/fargate-cluster2.yaml
```

Add it to ArgoCD

```
argocd cluster add <context name> --name cluster2
```

Wait for it to synchronize

```
$ argocd cluster list
SERVER                                                                    NAME        VERSION  STATUS      MESSAGE
https://XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.eu-west-1.eks.amazonaws.com  cluster2    1.20+    Successful
https://kubernetes.default.svc                                            in-cluster  1.20+    Successful
```

Note how applications are automatically deployed to this cluster

```
$ argocd app list
NAME                    CLUSTER                                                                   NAMESPACE    PROJECT   STATUS  HEALTH   SYNCPOLICY  CONDITIONS  REPO                                                   PATH                TARGET
bootstrap               https://kubernetes.default.svc                                            argocd       default   Synced  Healthy  Auto-Prune  <none>      https://github.com/myspotontheweb/gitops-platform.git  charts/bootstrap
in-cluster-argo-events  https://kubernetes.default.svc                                            argo-events  platform  Synced  Healthy  Auto-Prune  <none>      https://github.com/myspotontheweb/gitops-platform.git  charts/argo-events  HEAD
cluster2-argo-events    https://XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.eu-west-1.eks.amazonaws.com  argo-events  platform  Synced  Healthy  Auto-Prune  <none>      https://github.com/myspotontheweb/gitops-platform.git  charts/argo-events  HEAD
..
..
```

## Adding workloads

Workloads are managed in a separate repository

* https://github.com/myspotontheweb/gitops-workloads

Deployed as follows:

```
#
# Create bootstrap app
#
argocd app create workloads-bootstrap \
  --repo https://github.com/myspotontheweb/gitops-workloads.git \
  --path projects \
  --project default \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace argocd

#
# Set sync policy
#
argocd app set workloads-bootstrap --sync-policy automated --self-heal
```

