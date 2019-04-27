# ChromeOS Linux Dev Station

## Or how to bootstrap your VM so you can get to cloning repos and running containers

### Disclaimer

You can `curl` and run the script directly, but the Linux VM has passwordless `sudo`, so before you hose up your system (even if it easy enough to recreate and isolated from your host, it is still silly to break so carelessly), be smart and clone the repo and read the script first, or at least download the raw script file and double check the contents before you `bash bootstrap.sh` or `chmod +x bootstrap.sh && ./bootstrap.sh`.

### Requirements

This bootstrap hopes you are using a Yubikey with a GPG key so you can keep your private keys VERY secure but also able to use it for SSH with a couple awesome extensions from the Chrome Webstore. The Yubikey requires setup on a "real" Linux/macOS/Windows machine until arbitrary USB devices can be passed through to the Linux VM wily-nily, see the Dr. Duh Yubikey guide for that portion. The Chrome extensions can also work on a Linux/macOS/Windows machine with the Secure Shell app so that portion of this guide might be more broadly applicable.
