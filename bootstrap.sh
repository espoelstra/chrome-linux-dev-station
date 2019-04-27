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
echo "Removing file that doesn't allow ssh service to start"
sudo rm -f /etc/ssh/sshd_not_to_be_run 2> /dev/null

read -p $'Do you want to have ssh auto start on VM boot?\nThis is fairly safe as it is requires setting a password to access the system, and one is not set for your user or root by default, plus you should ALWAYS prefer to use private key authentication over passwords\n' BOOT_ENABLE
! [[ "$BOOT_ENABLE" =~ n* ]] && sudo systemctl enable ssh && echo "Enabled SSH on VM boot"
sudo systemctl --no-pager status ssh
sudo systemctl start ssh && echo "Started SSH service"
cat <<-EOT
1. You should install the Secure Shell (by Google) and SSH Agent for Secure Shell (by Google) and the Smartcard Connector (by Google). You may also want the Crosh Window extension to open Secure Shell as a window instead of a tab.
2. To open Secure Shell as a window, open the Launcher fully (hit the Search key and the ^ to expand it), then locate the Secure Shell icon and right click and where it says "New tab" hit the arrow and select "New window".
3. Now launch Secure Shell and add a new entry by filling in the fields at the bottom.
    * You will want to use the username that was created in your VM, it matches the part of your email address before the @whateverdomain.com portion.
    * For the hostname it should be penguin.linux.test unless you've done some advanced changes.
    * You can leave the port empty as it defaults to 22 which is the normal SSH port.
    * In the "SSH relay server options" add '--ssh-agent=gsc'
    * In the "SSH arguments" add '-A'
    * Click Connect or press Enter
    * You will get prompted for a password, DON'T PANIC, you haven't (and shouldn't) set one, this is OK, just hit Enter each time it asks until the connection fails
    * Press Ctrl+Shift+J to open the Javascript console, if you have a Yubikey/smartcard inserted and you have configured a GPG key on it, you should see the SSH public key that needs placed into the ~/.ssh/authorized_keys file in this console, copy it and paste it into the Terminal of the Linux VM and hit Enter and then try Connect again, you should get prompted for your Yubikey's PIN, and you can decide whether to cache the PIN or not, and then BAM, you should be in your VM with the MAJOR benefit of having your SSH public key courtesy of the -A option provided to the SSH agent.
EOT

mkdir -p ~/.ssh/

read -p $'Paste your SSH public key found in the Javascript console\n' PUBKEY
echo $PUBKEY >> ~/.ssh/authorized_keys
echo "Setup complete, you should now be able to connect without a password when your Yubikey is plugged in"
