# Automated Juniper Network Connect VPN AppleScript


This is a script that will assist you in automating your VPN connection using Network Connect by [Juniper Networks][juniper].  It has been tested on Juniper Networks Network Connect 7.3.4 (24309).

[juniper]: http://www.juniper.net

## Recommended Installation

There are a number of ways to use this AppleScript. This is what I recommend.

Hotbaud Note:  Updated to make generic, since my particular build of Juniper Network Connect is customized for my employer just as Sean Fisk's is customized for his school. It would be a good idea for anyone wishing to adapt this script to remap the text fields and button as referenced in the output of Sean Fisk's delightful dumpobjects.applescript implementation.


Create a `bin` directory for yourself if you don't already have it, and add it to your `PATH`:

    mkdir ~/bin
    echo 'export PATH=~/bin:"$PATH"' >> ~/.bashrc

Reload your shell (assuming bash) so these modifications take effect:

    exec bash

Next, download the script:

    curl https://raw.github.com/hotbaud/juniper-network-connect-vpn-applescript/master/juniper.applescript > ~/bin/juniper

Make it executable:

    chmod +x ~/bin/juniper

You can now use the script like so:

    juniper my.gateway.example.com myusername mypassword

The script will detect whether you are connected to the VPN. If not connected, it will start Network Connect and attempt to connect. If connected, it will sign out of the connection and quit Network Connect.

## Shell Function

The previous instructions get it working, but don't really automate much. I wanted to be able to log in to the VPN by simply typing `vpn` at the terminal. I don't type passwords for websites or SSH, so I shouldn't have to type it for a VPN either. Add this shell function to your `.bashrc` to complete the configuration:

    vpn () {
      juniper my.gateway.example.com myusername mypassword &
    }

It is backgrounded so you don't have to wait for the delay and get your shell back immediately.

Those who are security-minded may not like embedding their password directly into a shell function. If that describes you, you can use `read` to get the password instead:

### Bash

    vpn () {
      # -s: silent, turn off echo
      # -p: prompt
      read -sp 'VPN Password: ' password
      juniper my.gateway.example.com myusername "$password" &
    }

### Zsh

    vpn () {
      # -s: silent, turn off echo
      read -s 'password?VPN Password: '
      juniper my.gateway.example.com myusername "$password" &
    }

## But I use Windows or GNU/Linux!

I believe that Network Connect is scriptable on these operating systems, i.e., it has a command-line interface. I cannot confirm that yet. For some reason, on Mac OS X, Juniper decided not to give us this interface. Boo. That is what this AppleScript is designed to solve.

## Credits

This AppleScript drew from two other scripts created for this purpose:

* <http://scdidadm.tumblr.com/post/5579178924/juniper-network-connect-applescript-start-stop>
* <http://hintsforums.macworld.com/showthread.php?t=99264>

I also used a script from Macworld to help determine the "addresses" of the UI fields and button:

* <http://hints.macworld.com/article.php?story=20111208191312748>

That script is committed in the repository as `dumpobjects.applescript`.
