# netboot.xyz for Mere Mortals

Ordinarily, installing or rescuing an
operating system starts with a download:
fetch an ISO of several gigabytes, write
it to a USB stick, carry the stick to the
machine, boot it, and repeat — with a
different stick, or the same stick
rewritten — for the next system.
**netboot.xyz** removes the stick from
that loop. It is a tiny **network
bootloader**, about a megabyte of
**iPXE**, that any machine can load
instead of an operating system. It asks
the network for a menu, shows you a list
of operating systems and tools — dozens
of Linux installers and live systems,
the BSDs, Windows install media you
provide, disk and memory utilities —
and then fetches whichever one you pick,
over the network, from its official
mirror, at the moment you pick it. One
boot device, every system, nothing to
keep up to date on a shelf of USB keys.

This guide explains how that trick
works end to end: the boot chain from
firmware to menu, the boot files and
how to prove they are genuine, how the
menu itself is built (it is a folder of
small scripts, and you can read all of
them), how to serve the whole thing
yourself instead of using the project's
hosted service, how to make boot media,
and how to tell your own network to
offer it. The final stretch — a machine
actually network-booting — needs a LAN
with DHCP and TFTP, which this guide's
lab does not have, so that stretch is
taught from the project's documentation
and labelled as such wherever it
appears. Nothing here pretends
otherwise.

The lab behind this guide ran everything
the sandbox allows, for real:
**netboot.xyz 3.0.3**, the current
release, identified by its repository
tags after the API rate-limited the
first attempt. It downloaded ten of the
release's assets from GitHub — the UEFI,
legacy, SNP and UNDIONLY bootloaders,
the ISO and USB images, the kernel-form
bootloader, the Secure Boot autoexec
script and the checksums file — and
verified all eight checksummed files
against the published SHA-256 list:
eight for eight. It unpacked
`menus.tar.gz` (218 entries: 109 menu
scripts, their 109 detached signatures,
and the `boot.cfg` settings file), read
the main menu, a distribution menu and a
live-image menu line by line, fetched
the live menu from
`boot.netboot.xyz/3.0.3` and found it
byte-for-byte identical to the release's
copy, and cloned the source repository
to see how Ansible templates and a
127-row `endpoints.yml` generate it all.
Then it self-hosted: the boot files and
menus served over HTTP on a loopback
port, fetched back, and hashed — the
menu matching its local copy, the UEFI
bootloader and the ISO matching the
project's published checksums through
the extra hop. Finally it rehearsed the
USB write against an ordinary file and
confirmed the image copies exactly.

What the lab could not do is the thing
itself: **network-boot a machine**. PXE
booting speaks DHCP and TFTP over UDP,
and the sandbox forbids UDP outright —
so no client ever asked for an address,
no TFTP server ever answered, and no
machine ever booted. Chapters 7 and 8,
which cover exactly that, are written
from the project's own documentation,
say so on their faces, and give you the
checks to run on your own network
instead. `criteria.md` keeps the full
ledger of what was run and what was
only read.

## What this guide covers

- [**What netboot.xyz is**](what-netboot-xyz-is.md) —
  the mental model: a megabyte of
  bootloader that fetches a menu of
  operating systems over the network,
  so one boot entry replaces a drawer
  of USB sticks
- [**The moving parts**](the-moving-parts.md) —
  the firmware, the DHCP answer, the
  iPXE bootloader and its embedded
  script, the menu files, `boot.cfg`,
  the mirrors and live endpoints — and
  which part holds what
- [**Getting the boot files**](getting-the-boot-files.md) —
  the release's many file shapes, which
  one a given machine needs, and the
  checksum check that proves your
  copies are the project's
- [**Reading the menu**](reading-the-menu.md) —
  `menu.ipxe` and `boot.cfg` read line
  by line: architecture detection, the
  mirror book, signature checking, and
  how a distribution menu and a live
  menu differ
- [**Serving it yourself**](serving-it-yourself.md) —
  the hosted service's exact files,
  served from your own web server: the
  layout, the hashes that prove the
  bytes survive, and where your own
  custom menu plugs in
- [**Booting from USB and ISO**](booting-from-usb-and-iso.md) —
  the 2 MB USB image and the ISO for
  virtual media, how each is written,
  and what the lab proved about the
  writing without a stick to write to
- [**Telling your network**](telling-your-network.md) —
  the DHCP options (next-server and
  filename, options 66 and 67) and the
  TFTP server that make a whole LAN
  offer the menu — from the project's
  documentation, for your network
- [**Your first network boot**](your-first-network-boot.md) —
  the boot, step by step, as the
  documentation describes it and as the
  embedded script's source confirms:
  what you should see, in what order,
  and what each stall means
- [**Customising the menu**](customising-the-menu.md) —
  `local-vars.ipxe`, `boot.cfg` edits,
  your own `custom.ipxe`, pointing the
  live endpoint at your own server, and
  the Ansible overrides that rebuild
  the whole menu to order
- [**Recipes**](recipes.md) — a rescue
  toolkit that is always one boot away,
  installing a machine with no USB
  port free, memory-testing from the
  menu, pinning one release instead of
  chasing the latest, and booting a VM
  from the ISO
- [**The neighbours**](the-neighbours.md) —
  Ventoy and its drawer of images,
  hand-rolled iPXE, iVentoy, FOG, and
  the datacentre provisioners: what
  each does that netboot.xyz doesn't,
  and vice versa
- [**Limits**](limits.md) — it installs
  and rescues but does not provision,
  the menu can only fetch what mirrors
  publish, licensed systems need your
  own media, destructive tools sit two
  menu levels down, and a network boot
  is only as trustworthy as the DHCP
  answer that starts it
- [**Troubleshooting**](troubleshooting.md) —
  the wrong file for the firmware, the
  NIC with no driver, the checksum that
  hashes empty air, the DHCP server
  that will not share the job, and the
  traps this guide's lab fell into
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Running the DHCP and TFTP servers
themselves as a craft — chapter 7 gives
the options and the shape, from the
project's docs, but a DHCP server is a
network's constitution and deserves its
own careful reading (the Home
Networking guide in this series is the
natural companion). Building iPXE from
source: the project compiles its own,
and this guide uses its binaries.
Mass provisioning — imaging fifty
identical machines, unattended installs
at fleet scale — is a different
discipline with different tools, named
in chapter 11. And nothing here boots a
machine *for* you: the last hop happens
on your network, under your hand.

## How to use this guide

Read chapters 1 and 2 before downloading
anything — the boot chain has five
links, and knowing which link you are
looking at turns every later confusion
into a named problem. Chapters 3 and 4
need no network beyond the download
itself and end with files you have
verified and a menu you have read.
Chapter 5 is the heart of the practical
work and is fully checkable at a desk:
serve, fetch, compare hashes. Read
chapter 7 slowly before touching any
DHCP setting — it changes what every
machine on a network does at boot, and
it is deliberately the most careful
chapter here. The lab's transcripts
live in `netboot-xyz-lab/transcripts/`;
its own menu is `netboot-xyz-lab/custom.ipxe`
and its checksum filter is
`netboot-xyz-lab/verify-downloads.sh`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Ventoy for Mere Mortals](https://paulsullivan33-dev.github.io/ventoy-for-mere-mortals/)
- [Proxmox for Mere Mortals](https://paulsullivan33-dev.github.io/proxmox-for-mere-mortals/)
- [Virtual Machines for Mere Mortals](https://paulsullivan33-dev.github.io/virtual-machines-for-mere-mortals/)
- [Home Networking for Mere Mortals](https://paulsullivan33-dev.github.io/home-networking-for-mere-mortals/)
- [Linux for Mere Mortals](https://paulsullivan33-dev.github.io/linux-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/netboot-xyz-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/netboot-xyz-for-mere-mortals/blob/main/LICENSE-CODE).
