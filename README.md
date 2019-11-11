# ChromeOS Linux Dev Station

## Or how to bootstrap your VM so you can get to cloning repos and running containers

### Disclaimer

You can `curl` and run the script directly, but the Linux VM has passwordless `sudo`, so before you hose up your system (even if it easy enough to recreate and isolated from your host, it is still silly to break so carelessly), be smart and clone the repo and read the script first, or at least download the raw script file and double check the contents before you `bash bootstrap.sh doit` or `chmod +x bootstrap.sh && ./bootstrap.sh doit`.

### Requirements

This bootstrap hopes you are using a Yubikey with a GPG key so you can keep your private keys VERY secure but also able to use it for SSH with a couple awesome extensions from the Chrome Webstore. The Yubikey requires setup on a "real" Linux/macOS/Windows machine until arbitrary USB devices can be passed through to the Linux VM wily-nily, see the Dr. Duh Yubikey guide for that portion. The Chrome extensions can also work on a Linux/macOS/Windows machine with the Secure Shell app/extension so that portion of this guide might be more broadly applicable.

Install the following extensions (Ctrl+click on each url to open in your browser)

1. Secure Shell app/extension (by Google)
  * Pick one or both if you want
  * https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo
  * https://chrome.google.com/webstore/detail/secure-shell-extension/iodihamcpbpeioajjeobimgagajmlibd?hl=en
2. Crosh Window extension 
  * This allows Ctrl+W/Ctrl+N/Ctrl+T/etc to go into Secure Shell/Crosh instead of ChromeOS so eg Ctrl+W doesn't close the window
  * https://chrome.google.com/webstore/detail/crosh-window/nhbmpbdladcchdhkemlojfjdknjadhmh
3. Smartcard Connector (by Google).
  * If you will be using a Yubikey/Nitrokey/other GPG enabled smartcard then install this
  * https://chrome.google.com/webstore/detail/smart-card-connector/khpfeaanjngmcnplbdlpegiifgpfgdco

### Steps

1. To open Secure Shell as a window, open the Launcher fully (hit the Search key and the ^ to expand it), then locate the Secure Shell icon and right click (two finger click or press and hold on a touchscreen) and where it says "New tab" hit the arrow and select "New window".
2. Now launch Secure Shell and add a new entry by filling in the fields at the bottom.
    * You will want to use the username that was created in your VM, it matches the part of your email address before the @gmail.com portion (or @whateverdomain.com if you use GSuite).
    * For the hostname it should be penguin.linux.test unless you've done some advanced changes.
    * You can leave the port empty as it defaults to 22 which is the normal SSH port.
    * In the "SSH relay server options" add '--ssh-agent=gsc'
    * In the "SSH arguments" add '-A'
3. Click Connect or press Enter

4. You will get prompted for a password, DON'T PANIC, you haven't (and shouldn't) set one, this is OK, just hit Enter each time it asks until the connection fails
5. Press Ctrl+Shift+J to open the Javascript console, if you have a Yubikey/smartcard inserted and you have configured a GPG key on it, you should see the SSH public key that needs placed into the ~/.ssh/authorized_keys file in this console, copy it and paste it into the Terminal of the Linux VM and hit Enter and then try Connect again, you should get prompted for your Yubikey's PIN, and you can decide whether to cache the PIN or not, and then BAM, you should be in your VM with the MAJOR benefit of having your SSH public key courtesy of the -A option provided to the SSH agent.

#### Bonus points

While playing with some additional options to configure the system in a repeatable way (and idempotently as well), it occurred to me that Jess Frazelle has a pretty awesome set of Dockerfiles and her dotfiles has a .dockerfunc file that lets you run many GUI applications from within containers. Due to the fact that ChromeOS has Sommelier to handle X11 and/or Wayland applications, you can use her dotfiles with only a couple simple tweaks. The main one is to run `xhost local:` after starting your VM and/or SSH session, after that any container like `gimp` or `audacity` should hit the sommelier wrapping just by requesting access to the X11 server. The best part is this also works if you are using the Secure Shell app to access the Linux VM rather than the Terminal, so you can still forward in your SSH agent and do things that require access to it for cloning/pushing/etc. I've forked her dotfiles https://github.com/espoelstra/jessfraz-dotfiles/tree/master-crostini and if you checkout the master-crostini branch, it has some tweaks to make things play a little nicer in the Linux VM. You still run `bin/install.sh` to install and it will direct you what the valid options are, though many of them might not apply or be required, there are a couple packages that her dotfiles expect that are present unless you install the `basemin`.

If you happen to break your VM/container while playing around, you can use Crosh and `vmc` to delete/recreate it. The cool thing is you can also setup a "Crosh connection" in the Secure Shell app so you don't have to remember the Ctrl+Alt+T shortcut to open a Crosh tab, and you also get the benefit of being able to use Ctrl+W and other shortcuts if you installed Crosh Window.

Create a new connection in Secure Shell using "dummy@>crosh" in the first line  or if you don't like dummy in the name you can just put that as the user and use `>crosh` as the host and hit Enter/Return and you should get a crosh> prompt. If you are in developer mode you can type 'shell' to get a real shell, otherwise you can play with 'vmc' or 'vsh' and look at some of the other commands with 'help_advanced'.
