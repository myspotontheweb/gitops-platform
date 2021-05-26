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

