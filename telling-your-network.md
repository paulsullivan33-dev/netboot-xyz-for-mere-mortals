# Telling Your Network

**Outcome: your LAN offers the menu to
every machine that network-boots — two
fields on the DHCP server, one small
TFTP server, and the judgement to make
the change deliberately.** This chapter
is **documented-only**: it is written
from the project's own documentation
(its "Boot from TFTP" page), because
the lab's sandbox forbids the UDP that
DHCP and TFTP speak, and no machine
booted there. Every configuration below
is the project's text, not a lab result
— the checks offered are ones to run on
your network, where the ground truth
lives.

## Read this first

A DHCP server is not an ordinary
service. It is the network's
constitution: every machine asks it,
at every boot, *who am I, and what do
I run?* Adding boot options changes
the second answer for the whole LAN.
That is exactly the feature you want —
and it deserves the slow chapter. Make
the change on a DHCP server you
administer, on a network you are
responsible for, knowing which
machines will be offered the menu
(only ones that network-boot ask for
the file; the rest never notice).
If your network's DHCP comes from a
home router that offers no boot
options, the project's usual answer is
to let a machine you control — often
the same small server from chapter 5 —
take over DHCP, a decision the Home
Networking guide in this series treats
in full. Do not run two DHCP servers
by accident; chapter 13 returns to
that particular fire.

## The two fields

The project's documentation reduces the
DHCP side to two settings. In ISC DHCP
server syntax:

```text
next-server "1.2.3.4";
filename "netboot.xyz.kpxe";
```

`next-server` is the TFTP server's
address (option 66). `filename` is the
boot file for the client (option 67).
One size does not fit all clients,
though — the filename must match the
client's firmware and architecture:

- Legacy BIOS, x86: `netboot.xyz.kpxe`
  (or `netboot.xyz-undionly.kpxe` where
  the native drivers fail — chapter 13).
- UEFI, x86_64: `netboot.xyz.efi`
  (or the `-snp`/`-snponly` variants).
- UEFI, arm64: `netboot.xyz-arm64.efi`.

Real DHCP servers can choose per client
— ISC's architecture conditionals,
dnsmasq's `dhcp-match`/`dhcp-boot`
tags, Kea's client classes — and the
project's docs assume you will pick the
file your fleet needs most and refine
from there. A mixed fleet served one
filename will boot exactly the machines
that filename fits and strand the rest
at a firmware error; the error is the
diagnostic, and chapter 13 names it.

## The file server: TFTP

The boot file itself is fetched by
TFTP — port 69, UDP — from the
next-server. Any TFTP server works;
the project's documentation shows
dnsmasq doing double duty as DHCP and
TFTP server, which is the smallest
complete setup:

```text
enable-tftp
tftp-root=/var/lib/tftp
dhcp-boot=netboot.xyz.kpxe
```

with, for the DHCP half, the
next-server given as an option:

```text
dhcp-option=66,"0.0.0.0"
```

(`0.0.0.0` there means "this machine",
in dnsmasq's reading.) The boot files
from chapter 3 go in the TFTP root,
under exactly the names the DHCP
answer promises.

Note the division of labour, because it
decides where you host what: **TFTP
carries only the first file.** The
bootloader, once running, speaks HTTP
and HTTPS — so the menus and everything
after can live on the web server from
chapter 5 (or on the project's hosted
service), while TFTP is a one-file
errand. The project's own self-hosting
documentation builds the full version
of that: its Ansible role generates
menus and bootloaders together and
drops them into a web root
(`/var/www/html` by default), and a
Docker build does the same into a
folder — both described in chapter 9.

## The check, on your network

The lab cannot run this for you; on
your LAN the proof is a client. Take
one machine you can afford to reboot,
set it to network boot, and watch the
order of events chapter 8 lays out:
address, filename, the iPXE banner,
the menu. If it boots its disk
instead, the offer was never made
(DHCP). If it names the file and
stalls, the errand failed (TFTP). If
iPXE loads and errors, the chain failed
(HTTP). Three different failures,
three different parts — the moving
parts table from chapter 2, earning
its keep.
