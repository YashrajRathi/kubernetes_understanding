apt install -y containerd  ;
mkdir -p /etc/containerd/  ;
containerd config default | sudo tee /etc/containerd/config.toml   ;
cat /etc/containerd/config.toml ;
sed -i "s/SystemdCgroup = .*/SystemdCgroup = true/"  /etc/containerd/config.toml ;
systemctl restart containerd  ;
swapoff -a  ;
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg  ;
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list ;
cat /etc/apt/sources.list.d/kubernetes.list  ;
apt update  ;
apt-get install -y kubelet kubeadm kubectl ; apt-mark hold kubelet kubeadm kubectl ;
unix:///run/containerd/containerd.sock  ;
crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock ;
crictl config --set image-endpoint=unix:///run/containerd/containerd.sock ;
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" copy_sysctl.conf ;
sudo sysctl -w net.ipv4.ip_forward=1 ;
systemctl restart containerd  ;
this_ec2_ip_address=$(ip route show default | grep "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" -o | tail -n 1) ;
AWS_TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 60"`
public_hostname=$(curl -H "X-aws-ec2-metadata-token: $AWS_TOKEN" http://169.254.169.254/latest/meta-data/public-hostname)
kubeadm init --apiserver-cert-extra-sans "$public_hostname" --apiserver-advertise-address $this_ec2_ip_address --pod-network-cidr=10.244.0.0/16 ;
export KUBECONFIG=/etc/kubernetes/admin.conf  ;
curl https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/canal.yaml -O ;
kubectl apply -f canal.yaml;
