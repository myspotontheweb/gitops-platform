
all: create

#
# Create Kubernetes cluster
#
create: bootstrap-eks
	ark install argocd

bootstrap-eks:
	eksctl create cluster -f bootstrap/eks-fargate-config.yaml

#
# Install targets
#
install: install-aws-cli install-eksctl install-arkade install-deps 

install-aws-cli:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install

install-deps:
	ark get kubectl
	ark get helm
	ark get kubectx
	ark get kubens
	ark get argocd
	ark get yq

install-arkade:
	curl -sLS https://dl.get-arkade.dev | sudo sh

install-eksctl:
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(shell uname -s)_amd64.tar.gz" | tar xz -C /tmp
	sudo mv /tmp/eksctl /usr/local/bin

#
# Remove everything
#
clean: clean-eks
	rm -rf aws
	rm -f awscliv2.zip

clean-eks:
	eksctl delete cluster fargate-cluster --region eu-west-1

