# ChromeOS Linux Dev Station

## Or how to bootstrap your VM so you can get to cloning repos and running containers

### Disclaimer

You can `curl` and run the script directly, but the Linux VM has passwordless `sudo`, so before you hose up your system (even if it easy enough to recreate and isolated from your host, it is still silly to break so carelessly), be smart and clone the repo and read the script first, or at least download the raw script file and double check the contents before you `bash bootstrap.sh` or `chmod +x bootstrap.sh && ./bootstrap.sh`.

### Requirements

This bootstrap hopes you are using a Yubikey with a GPG key so you can keep your private keys VERY secure but also able to use it for SSH with a couple awesome extensions from the Chrome Webstore. The Yubikey requires setup on a "real" Linux/macOS/Windows machine until arbitrary USB devices can be passed through to the Linux VM wily-nily, see the Dr. Duh Yubikey guide for that portion. The Chrome extensions can also work on a Linux/macOS/Windows machine with the Secure Shell app so that portion of this guide might be more broadly applicable.

1. Install the Secure Shell (by Google) and SSH Agent for Secure Shell (by Google)
2. If you will be using a Yubikey/Nitrokey/other GPG enabled smartcard then install the Smartcard Connector (by Google).
3. You probably also want the Crosh Window extension to open Secure Shell as a window instead of a tab.

### Steps

1. To open Secure Shell as a window, open the Launcher fully (hit the Search key and the ^ to expand it), then locate the Secure Shell icon and right click and where it says "New tab" hit the arrow and select "New window".
2. Now launch Secure Shell and add a new entry by filling in the fields at the bottom.
    * You will want to use the username that was created in your VM, it matches the part of your email address before the @whateverdomain.com portion.
    * For the hostname it should be penguin.linux.test unless you've done some advanced changes.
    * You can leave the port empty as it defaults to 22 which is the normal SSH port.
    * In the "SSH relay server options" add '--ssh-agent=gsc'
    * In the "SSH arguments" add '-A'
3. Click Connect or press Enter

4. You will get prompted for a password, DON'T PANIC, you haven't (and shouldn't) set one, this is OK, just hit Enter each time it asks until the connection fails
5. Press Ctrl+Shift+J to open the Javascript console, if you have a Yubikey/smartcard inserted and you have configured a GPG key on it, you should see the SSH public key that needs placed into the ~/.ssh/authorized_keys file in this console, copy it and paste it into the Terminal of the Linux VM and hit Enter and then try Connect again, you should get prompted for your Yubikey's PIN, and you can decide whether to cache the PIN or not, and then BAM, you should be in your VM with the MAJOR benefit of having your SSH public key courtesy of the -A option provided to the SSH agent.
