#!/bin/bash
usage () {
cat <<-EOH
Usage: $0 [adding anything other than -h triggers an actual run]
Future options:
[enable-ssh] [public-key]

EOH
}

docs () {
#cat < README.md
sed -n -e '/Steps/,$p' README.md
}

[ -z "$1" ] && { usage; docs; exit 0; }
case $1 in
	-h|--help) usage; docs; exit 0;;
esac
echo "Removing file that doesn't allow ssh service to start"
sudo rm -f /etc/ssh/sshd_not_to_be_run 2> /dev/null

read -p $'Do you want to have ssh auto start on VM boot?\nThis is fairly safe as it is requires setting a password to access the system, and one is not set for your user or root by default, plus you should ALWAYS prefer to use private key authentication over passwords\n' BOOT_ENABLE
! [[ "$BOOT_ENABLE" =~ n* ]] && sudo systemctl enable ssh && echo "Enabled SSH on VM boot"
sudo systemctl --no-pager status ssh
sudo systemctl start ssh && echo "Started SSH service"
mkdir -p ~/.ssh/

read -p $'Paste your SSH public key found in the Javascript console\n' PUBKEY
echo $PUBKEY >> ~/.ssh/authorized_keys
echo "Setup complete, you should now be able to connect without a password when your Yubikey is plugged in"
