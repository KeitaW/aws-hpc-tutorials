## Install tools

TODO: fix version
* packer
HashiCorp Packer is an open-source tool for creating identical machine images across multiple platforms using a single source configuration.
We will use Packer to create an Amazon Machine Image (AMI), which simplifies and streamlines deployment in AWS environments.
```
sudo yum install -y yum-utils && \
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo && \
sudo yum -y install packer
```
* ansible
```
pip install ansible
```
* pcluster-related

```
pip install aws-parallelcluster
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
chmod ug+x ~/.nvm/nvm.sh
source ~/.nvm/nvm.sh
nvm install --lts # or  nvm install --lts=Gallium
node --version
```