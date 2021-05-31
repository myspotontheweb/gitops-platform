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
