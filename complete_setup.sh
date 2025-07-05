export KUBECONFIG=/etc/kubernetes/admin.conf  
source /etc/bash_completion
source <(kubectl completion bash)
kubectl config set-context --current --namespace kube-system 
alias k=kubectl 
complete -F __start_kubectl k 