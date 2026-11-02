# Booting from USB and ISO

**Outcome: boot media you trust — the
USB image written whole-device, the ISO
attached where virtual media lives —
and a clear statement of what each
contains: not an operating system, but
the bootloader and its question.** The
writing commands are the project's own
documentation; the lab verified the
images and rehearsed the write against
a file (transcript `t07`), because it
has no USB device to give. Where this
chapter describes an actual boot, it is
documented-only and says so.

## The USB image: two megabytes, whole device

`netboot.xyz.img` is exactly
2,097,152 bytes — 2 MiB — a raw disk
image with a DOS/MBR partition table
and one small active FAT partition
(transcript `t01`). It is written to
the *device*, not to a partition, and
writing it erases the key completely.
The project's documentation gives, for
Linux:

```bash
dd if=netboot.xyz.img of=/dev/sdX
```

with `sdX` your USB device — found by
comparing `lsblk` before and after
inserting it. On macOS the same write
goes to the raw device (`/dev/rdiskN`,
after `diskutil unmountDisk`), and on
Windows the project points at Rufus.
The documentation's own warning leads
its page and is repeated here because
it is the whole safety story: **back up
anything on the key first; the write
overwrites everything on it.** Choosing
the wrong `sdX` is the one catastrophic
mistake available in this guide — the
device you name is the device that gets
the image, whether it was a cast-off
key or your system disk. Check the
name twice, against size and model,
before pressing Enter.

The lab rehearsed the write against an
ordinary file, which proves the part
that can be proven off-device — that a
whole-image copy is exact:

```bash
dd if=netboot.xyz.img of=usb-copy.img bs=1M status=none
sha256sum netboot.xyz.img usb-copy.img
# bcb1f309...85 for both
```

Booting the finished key is
documentation's word for what happens:
set the machine to boot from USB, and
iPXE loads, does DHCP, and chains to
the menu — the key is a delivery
mechanism for the bootloader, nothing
more. Two megabytes is the elegance of
it: the oldest, smallest key in the
drawer is suddenly the only one you
need, because it carries no system at
all — just the question, and the menu
is the answer fetched fresh each time.

## The ISO: for machines you cannot touch

`netboot.xyz.iso` (2.4 MB, a bootable
ISO 9660 image labelled `iPXE`, verified
in transcripts `t01`–`t02`) is the same
bootloader in CD shape. Its home is
*virtual* media: attach it in a
hypervisor's VM settings, in a server's
iDRAC or iLO console, or in Proxmox's
datastore, and the machine boots it as
if a disc were in a tray that does not
exist. That makes it the remote hands
of this guide: a server in another room
or another city can be reinstalled or
rescued from your desk, provided its
management console can mount an ISO and
its network can reach the menu. Burning
it to a physical CD or DVD also works,
for the machines and the occasions that
still call for it.

## Which door, when

- One machine in front of you, once:
  the **ISO in a VM**, or the **USB
  key** on hardware.
- One machine, repeatedly: the USB key
  stays in the drawer; each boot still
  fetches a fresh menu.
- Every machine on a network: neither —
  chapter 7 removes the media entirely
  and lets the network hand the
  bootloader over directly.
