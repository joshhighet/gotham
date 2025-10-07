#!/bin/bash
if [ "$(uname)" != "Linux" ]; then
  echo "script is for linux"
  exit 1
fi
# adduser ${CREATEUSERNAME} --quiet --gecos ""
# password=`openssl rand -base64 12`
# echo ${password} | passwd ${CREATEUSERNAME} --stdin
# usermod -aG sudo ${CREATEUSERNAME}
# sudo runuser -l ${CREATEUSERNAME} -c "mkdir /home/${CREATEUSERNAME}/.ssh"
# sudo runuser -l ${CREATEUSERNAME} -c "touch /home/${CREATEUSERNAME}/.ssh/authorized_keys"
# sudo runuser -l ${CREATEUSERNAME} -c "echo ${PUBKEYGRANT} >> /home/${CREATEUSERNAME}/.ssh/authorized_keys"
# sudo runuser -l ${CREATEUSERNAME} -c "ssh-keygen -t rsa -b 4096 -C autodeploy -f /home/${CREATEUSERNAME}/.ssh/id_rsa -q"
ssh-keygen -t rsa -b 4096 -C autodeploy -q
sudo apt-get -y update
sudo apt-get -y upgrade
APT_PACKAGES=(
  jq
  zsh
  git
  nmap
  tree
  python3-pip
  unattended-upgrades
  apt-transport-https
  qemu-guest-agent
  ca-certificates
  curl
)
sudo apt-get install -y ${APT_PACKAGES[@]}
sudo apt-get -y autoclean
sudo apt-get -y autoremove
touch .hushlogin
timedatectl set-timezone Pacific/Auckland
sudo mkdir -p /etc/apt/keyrings
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
echo '''export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="intheloop"
plugins=(git)
source $ZSH/oh-my-zsh.sh''' > ~/.zshrc
fqdn=$(hostname -f)
cat << "EOF" | awk -v fqdn="$fqdn" '{gsub(/template/,fqdn);print}' > /etc/banner

 _     _       _                _
| |__ (_) __ _| |__  _ __   ___| |_
| '_ \| |/ _` | '_ \| '_ \ / _ \ __|
| | | | | (_| | | | | | | |  __/ |_
|_| |_|_|\__, |_| |_|_| |_|\___|\__|
         |___/      template

EOF
sudo sed -i 's/#Banner none/Banner \/etc\/banner/g' /etc/ssh/sshd_config
sudo service sshd restart
git clone https://github.com/joshhighet/kerchow.git
#pip3 install --upgrade pip
#PYPACKAGES=(
#    shodan
#    virtualenv
#)
#pip3 install ${PYPACKAGES[@]}
cd kerchow && ./setup.sh && cd ..
source ~/.zshrc
