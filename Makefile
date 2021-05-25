UNAME_S := $(shell uname -s)

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
ifeq ($(UNAME_S), Linux)
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
else
	curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
	sudo installer -pkg AWSCLIV2.pkg -target /
endif

install-eksctl:
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(UNAME_S)_amd64.tar.gz" | tar xz -C /tmp
	sudo mv /tmp/eksctl /usr/local/bin


install-arkade:
	curl -sLS https://dl.get-arkade.dev | sudo sh

install-deps:
	ark get kubectl
	ark get helm
	ark get kubectx
	ark get kubens
	ark get argocd
	ark get yq

#
# Remove everything
#
clean: clean-eks clean-files

clean-files:
	rm -rf aws
	rm -f awscliv2.zip
	rm -f AWSCLIV2.pkg

clean-eks:
	eksctl delete cluster fargate-cluster --region eu-west-1

