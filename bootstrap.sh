#!/bin/bash
usage () {
cat <<-EOH
Usage: $0
Future options:
[enable-ssh] [public-key]
EOH
}
case $1 in
	-h|--help) usage; exit 0;;
esac
sudo rm -f /etc/ssh/sshd_not_to_be_run 2> /dev/null
read -p $'Do you want to have ssh auto start on VM boot?\nThis is fairly safe as it is requires setting a password for a user if you are\'t using private key authentication\n' BOOT_ENABLE
! [[ "$BOOT_ENABLE" =~ n* ]] && sudo systemctl enable ssh
sudo systemctl --no-pager status ssh
sudo systemctl start ssh
mkdir -p ~/.ssh/
read -s -p $'Paste your SSH public key from smart-ssh\n' PUBKEY
echo $PUBKEY | tee -a ~/.ssh/authorized_keys