# What netboot.xyz Is

You have a machine — a new build with no
system on it, a laptop with a broken
one, a server in another room — and you
want an operating system *on* it, or a
rescue tool *in front of* it. The usual
path is physical: download an image on
some other machine, write it to a USB
stick, walk the stick over, boot it.
The image is gigabytes, the writing
takes minutes, and next month the image
is out of date and the stick has the
wrong thing on it anyway.

**netboot.xyz moves that whole errand
onto the network.** It is a **bootloader**
— a program small enough to be the first
thing a machine runs, about a megabyte —
built on the open-source **iPXE** network
boot firmware. Instead of containing an
operating system, it contains a question:
it gets an address from the network,
downloads a **menu**, and displays it.
The menu lists operating system
installers and live systems and tools.
You pick one; only then does anything
large move — the chosen system's kernel
and installer stream down from that
system's own official mirror, and the
install or rescue proceeds exactly as if
you had booted its media. The stick
never exists. Neither does the drawer of
sticks, the out-of-date images, or the
walk.

This works because most machines already
know how to start it. **PXE** — the
Preboot Execution Environment, built
into nearly every PC's firmware for
decades — lets a machine with nothing on
its disk say "give me an address and
something to run" and be handed a file
over the network. netboot.xyz is the
file it gets handed, and the menu that
file shows. Chapter 2 takes the chain
apart link by link.

## A first taste

There are three front doors, and the
project's documentation describes all
three (the lab verified the files behind
each; the boots themselves are
documented-only here — see the README's
honest ledger):

- **A USB key or ISO**, for one machine
  in front of you: write the 2 MB image,
  boot it, and the menu appears
  (chapter 6).
- **Your whole network**, for machines
  you manage: two settings on your DHCP
  server, and every network boot on the
  LAN lands in the menu (chapter 7).
- **A virtual machine's virtual CD
  drive**, for servers and hypervisors:
  attach the ISO, boot from it, install
  (chapter 10).

However it starts, what loads is the
same program. Its embedded script —
which the lab read in the project's
source, transcript
`netboot-xyz-lab/transcripts/t05-repository-and-generation.txt`
— gets an address, offers a four-second
"press m for a failsafe menu" prompt,
and then chains to the real menu:

```text
chain --autofree https://boot.netboot.xyz/3.0.3/menu.ipxe
```

(That address, wearing the current
release's number, is what release
3.0.3's Secure Boot script contains; the
lab fetched that very menu from that
very address and compared it against
the release's own copy — identical.
Transcript `t04-live-endpoint-comparison.txt`.)

## What it is not

It is not an **image library**: apart
from its own live-system assets
(chapter 4), it stores no operating
systems. Debian comes from Debian's
mirrors, Ubuntu from Ubuntu's, at the
moment you ask — which is why the menu
is never out of date and why it needs
the internet, or a mirror you host, at
boot time. It is not a **provisioner**:
it will start an installer beautifully,
but answering the installer's questions
— partitioning, hostnames, accounts,
fifty machines alike — belongs to
kickstart files, preseeds, cloud-init
and the provisioning tools of
chapter 11. It is not a **cloning
system**: the menu *contains* Clonezilla,
but netboot.xyz itself neither captures
nor deploys disk images. And it is
emphatically **not private property of
the client machine**: the chain starts
with a DHCP answer, and a network boot
trusts whoever answers — a property
chapter 12 states plainly, because it
cuts both ways on networks you do not
control.

## Who it is for

The home-lab keeper with more machines
than USB sticks, who rebuilds often
enough to resent the walk. The repairer
who wants Memtest, a partition editor
and a rescue system permanently one
boot away. The virtualisation user
tired of uploading ISOs to a datastore
one at a time. The teacher or tester
who installs a different system every
week — the menu carries testing and
unstable branches next to the releases.
The common thread is one person, a
network they run, and machines they are
allowed to boot: netboot.xyz turns
"find media" into "press the network
boot key".

## The honest catch, up front

A network boot is a chain of five
hand-offs, and each hand-off has its
own way to fail: firmware that will not
network-boot, a DHCP server that points
nowhere, a NIC the bootloader has no
driver for, a mirror having a bad day.
USB media fails too, but it fails in
your hand, privately; netboot.xyz fails
in the open, at boot, sometimes on
someone else's desk. Chapter 13 is the
map of those failures. And there is a
second catch this guide treats as part
of the telling: its lab could serve and
verify every byte of the system but
could not boot so much as a virtual
client, so the two chapters about the
boot itself are the project's
documentation, checked against the
project's source — not war stories.
