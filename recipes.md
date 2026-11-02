# Recipes

Small, whole jobs. The file work in
each was verified in the lab; the boot
in each is your network's part, and
chapter 8 is the checklist for it.

## A rescue kit that is always one boot away

**Problem.** A machine will not boot,
and the rescue USB is in another
building, another drawer, another year.

Set up chapter 7 once — DHCP options
and the TFTP file — and the Utilities
menu becomes a standing facility of the
network itself. From the 3.0.3 menus
(transcript `t03`'s source material):
Clonezilla for disk imaging, GParted
for partitions, Rescuezilla and
RedoRescue for backup-and-restore,
Super Grub2 Disk for bootloaders that
have forgotten themselves, Boot Repair
for the same complaint in Ubuntu
dress, Memtest86+ for memory — all of
them loaded into RAM, none of them
touching the patient disk until you
tell them to. The recipe is really a
sentence: *the rescue kit should live
on the network, not on a stick*,
because networks are where you left
them and sticks are not.

## Memory-test a suspect machine

**Problem.** Intermittent crashes,
clean disks, growing suspicion of the
RAM.

Network-boot the machine (any door in
chapter 6 or 7), open **Utilities**,
choose **Memtest86+**. It loads into
memory and runs its passes for as long
as you let it — overnight is the honest
duration for a verdict. Errors are
reported by address and pattern; a
clean pass at dawn is real evidence,
not a vibe. No media to write, nothing
installed, and the machine's own disk
was never mounted.

## Install the machine with no free ports

**Problem.** A small-form-factor box
whose USB ports are all occupied, or a
blade with no ports at all, needs an
operating system.

Attach the ISO instead: in the
hypervisor's or the management
console's virtual media, mount
`netboot.xyz.iso` (verified in chapter
3), set the boot to the virtual CD, and
restart. The menu arrives, the
installer streams from its own
project's mirror, and the install
proceeds — the only "media" involved
never existed physically. This is the
standard trick for remote servers with
iDRAC/iLO-class consoles, and the
reason the ISO is a first-class release
asset rather than an afterthought.

## Pin one release, on purpose

**Problem.** The hosted menu moves with
every upstream release; you want your
site's boots to change only when you
say so.

Self-host (chapter 5) and point your
bootloaders at *your* version folder.
The lab proved the hosted service and
the release tarball carry identical
menus for 3.0.3 (transcript `t04`) — so
serving the tarball is not running
yesterday's approximation; it is
running 3.0.3 exactly, indefinitely,
until you unpack 3.0.4 beside it and
move the pointer. Distribution versions
inside the menus still track their own
mirrors — pinning freezes netboot.xyz,
not Debian — and that is usually the
combination a site actually wants.

## Feed the Windows menu your own media

**Problem.** The menu lists Windows,
but there is nothing for it to load:
Microsoft's installers are licensed
media, and netboot.xyz does not
redistribute them.

Host your own Windows installation
files on a web server the booting
machine can reach, then set
`win_base_url` to their address — at
the menu's own prompt (the Windows
menu asks for the Base URL as an
option), or permanently in
`local-vars.ipxe` (chapter 9). The menu
loads its `wimboot` helper — the binary
sitting in the menus' root since
chapter 4 — and boots your media. The
licence, the media and the activation
remain entirely your affair; the tool
just carries them.
