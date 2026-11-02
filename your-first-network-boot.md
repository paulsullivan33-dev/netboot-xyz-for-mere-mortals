# Your First Network Boot

**Outcome: you can follow a network
boot the way a pilot follows a
checklist — each stage named, what it
looks like when it works, and what it
means when the boot stops there.**
This chapter is **documented-only**:
the sequence is the project's
documentation read against the source
of the embedded script and the menu
(transcripts `t03` and `t05`, both read
for real), but the lab booted nothing,
and no stage below is a lab observation.
The project's documentation site offers
a simulated version of this menu in a
browser, which is a fair rehearsal for
stage 5.

## Stage 1 — the firmware asks

The machine starts; you choose network
boot, or it is first in the boot order.
The firmware's PXE stack broadcasts for
DHCP. On screen: the card's own banner,
then an address, and the two gifts of
chapter 7 — next-server and filename.
*If it stops here:* no DHCP answer at
all (a network problem, or the server
is down), or an answer with no filename
(the offer was never configured). The
firmware shrugs and boots the disk.

## Stage 2 — one file by TFTP

The firmware fetches the named
bootloader from the next-server.
Seconds, for a file under a megabyte
and a half. *If it stops here:* TFTP
errors name themselves — file not
found means the name in the DHCP answer
and the name in the TFTP root disagree;
a timeout means the server or the path
does. A file for the wrong firmware
(legacy image, UEFI machine) fails
differently: the firmware refuses it
or falls through to disk, which is why
chapter 7 spends its care on matching
filenames to clients.

## Stage 3 — the bootloader introduces itself

The screen changes character: iPXE's
banner, and netboot.xyz's own greeting
— the name, the release (`v3.0.3`),
the network card's features and
address. Then the line from the
embedded script:

```text
Hit the m key to open failsafe menu...
```

Four seconds. Pressing **m** opens the
failsafe menu: boot the local drive,
configure the network by hand (for a
machine whose DHCP is being difficult),
retry, drop to an iPXE debug shell, or
reboot. Letting it lapse is the normal
path: the bootloader runs its own DHCP
(iPXE keeps its own books, so the
address appears again — that is not a
malfunction), resolves any proxy-DHCP
question, and looks for local files —
`local-vars.ipxe`, and a local menu if
it was chainloaded from your own TFTP
server. Finding none, it goes to the
hosted chain:

```text
chain --autofree https://boot.netboot.xyz/3.0.3/menu.ipxe
```

*If it stops here:* the messages are
the embedded script's own fallbacks —
HTTPS failed, trying HTTP; HTTP failed,
booting locally. A machine that reaches
iPXE but never the menu has a working
LAN and a broken route outward: DNS,
gateway, or a proxy that wants
authenticating. Your self-hosted server
(chapter 5) exists precisely for this
weather.

## Stage 4 — settings, then signatures

The chain lands in `menu.ipxe`, which
loads `boot.cfg`. With signature
checking on (the default), each menu
script is verified against its detached
signature before it runs; a failure
here is a *refusal*, not a crash —
files that do not check out are not
executed, which is what the check is
for. The version file is consulted
(`upstream_version` — transcript `t04`),
the clock is set from the network, and
the screen clears. You have been
booting for perhaps twenty seconds,
and almost nothing has been downloaded:
a bootloader, a handful of scripts.
The gigabytes are still all in the
future, and only the ones you choose
will travel.

## Stage 5 — the menu

The title line names the site and the
release, and the next-server if there
is one. Below it: **Boot from local
hdd** first (the polite exit), then the
sections your machine's architecture
and firmware allow — Linux Network
Installs, Live CDs, BSD and Unix
installs, FreeDOS, Windows; then the
tools: Utilities for this platform, an
iPXE shell, network card information,
About. Five minutes of inattention and
it boots the local disk on its own;
the timeout is a `boot.cfg` setting
(chapter 9), and on a machine with no
working disk it is worth knowing the
menu will cycle rather than strand you.

## Stage 6 — the pick

Choose Debian, then trixie, and
`debian.ipxe` builds the installer
address on Debian's mirror and loads
its kernel and initrd — a few tens of
megabytes, from Debian, not from
netboot.xyz. From the installer's first
screen onward you are in Debian's
world, on Debian's documentation;
netboot.xyz's part is done, and it was
done before the first megabyte of
installer arrived. Live picks differ
only in source: kernel and squashfs
filesystem stream from the project's
endpoint repositories (chapter 4), the
filesystem loads into memory, and the
machine runs the live system without
its disk being touched — the property
that makes the utilities menu a rescue
kit: Clonezilla, GParted, Memtest86+,
Rescuezilla and their kin all arrive
this way, work in RAM, and leave the
patient exactly as they found it.
Except, chapter 12 insists, the ones
whose whole purpose is to change the
disk — those ask first, and you should
let them.
