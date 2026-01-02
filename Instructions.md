# This instruction file will tell you what I am trying to achieve, read it through entirely before you start anything

The repository this folder contains is my personal fork of the latest master branch of mediastack 
- github.com/geekau/mediastack
- https://mediastack.guide/

I am trying to modify the base project to work on the specific configuration of my at home server machine (We will be doing the full-download-vpn option described in the README and via the folder layout)

This machine is a tower computer that you can presume is running the latest version of Ubuntu server (headless)

It is connected to my local network via ethernet and has the reserved internal address of 192.168.1.230

I will ssh into it to configure and adjust it

ProtonVPN is the vpn provider I will use

Whenever the choice is given between openvpn and wireguard we will use wireguard

The machine name will be cephalonsimaris and the user will be named nobodyatall

Here's a neofetch result to give you some context on the hardware:

```
nobodyatall@cephalonsimaris:~$ neofetch
            .-/+oossssoo+/-.               nobodyatall@cephalonsimaris 
        `:+ssssssssssssssssss+:`           --------------------------- 
      -+ssssssssssssssssssyyssss+-         OS: Ubuntu 24.04.3 LTS x86_64 
    .ossssssssssssssssssdMMMNysssso.       Kernel: 6.8.0-90-generic 
   /ssssssssssshdmmNNmmyNMMMMhssssss/      Uptime: 5 days, 3 hours, 29 mins 
  +ssssssssshmydMMMMMMMNddddyssssssss+     Packages: 844 (dpkg) 
 /sssssssshNMMMyhhyyyyhmNMMMNhssssssss/    Shell: bash 5.2.21 
.ssssssssdMMMNhsssssssssshNMMMdssssssss.   Resolution: 1024x768 
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   Terminal: /dev/pts/0 
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   CPU: Intel i5-6600K (4) @ 3.900GHz 
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   GPU: AMD ATI Radeon R9 290/390 
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   Memory: 3667MiB / 7880MiB 
.ssssssssdMMMNhsssssssssshNMMMdssssssss.
 /sssssssshNMMMyhhyyyyhdNMMMNhssssssss/                            
  +sssssssssdmydMMMMMMMMddddyssssssss+                             
   /ssssssssssshdmNNNNmyNMMMMhssssss/
    .ossssssssssssssssssdMMMNysssso.
      -+sssssssssssssssssyyyssss+-
        `:+ssssssssssssssssss+:`
            .-/+oossssoo+/-.

nobodyatall@cephalonsimaris:~$ 
```

It has a 256 GB hard drive that everything will be running on and a 1tb hdd that i will store all of the mediastack media on

# IMPORTANT

For the purposes of testing, I will be running ubuntu server in a vm on my development computer to test out the config files we make and modify

Before you begin, create a markdown file called documentation; additionally, read the README.md file that is included in the repo root

Whenever you make changes or at any time want to write some readme/text file documenting something, add a section to this file, including a title, brief description, and date + timestamp of when you wrote it before all of the details (as well as separator before the next section) -- the idea behind that is that I don't want to fill up the repo with various documentation files, but keep it all in one spot

Once we can get the base configuration up and running, I will want to add the following docker containers to the stack:
* adguard home
* home assistant
* netdata