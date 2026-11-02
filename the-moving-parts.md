# The Moving Parts

A network boot looks like one event —
the machine starts, a menu appears —
but it is five hand-offs between five
different parts, and when it fails, it
fails at exactly one of them. This
chapter names the parts. Everything
after it is a closer look at one part
at a time.

## The firmware: the part that knocks

Every PC's firmware — **BIOS** on old
machines, **UEFI** on current ones —
can boot from the network before it
boots from any disk. That ability is
**PXE**: the firmware's network card
driver wakes up, asks the network for
an address and a program, runs the
program it is handed, and only falls
back to disk if the network offers
nothing. You summon it with a boot-menu
key (often F12, F8 or Esc) or by putting
network boot first in the boot order.
The firmware holds no opinions: it will
run whatever file the network names,
which is the power and the risk of
this whole subject in one sentence.

## The DHCP answer: the part that points

PXE's question is a **DHCP** request —
the same protocol that hands out IP
addresses — with two extra fields the
firmware listens for: **next-server**
(option 66), the address of a file
server, and **filename** (option 67),
the name of the boot file on it. An
ordinary DHCP answer, from a home
router that knows nothing of network
booting, leaves both empty, and the
firmware gives up and boots the disk.
A netboot.xyz answer fills them in:
next-server is your file server,
filename is a netboot.xyz bootloader
matching the client's kind — legacy
BIOS or UEFI, 32- or 64-bit, x86 or
ARM. Chapter 7 covers setting this up.
The DHCP server holds the pointing;
it serves no files itself.

## TFTP: the part that carries one file

The firmware fetches the named file by
**TFTP**, a deliberately tiny file
protocol that runs over **UDP** port 69
and exists almost solely for this first
hop. TFTP has no logins, no encryption,
no directory listing — it can fetch one
named file, slowly and simply, which is
all a firmware with no operating system
can manage. The file it fetches is the
netboot.xyz bootloader. After that one
fetch, TFTP's job is done: everything
interesting afterwards travels over
HTTP or HTTPS, which are faster and can
be checked. (This is also the hop the
guide's lab could not perform: UDP is
forbidden in its sandbox, so chapter 7
teaches TFTP from the project's docs.)

## The bootloader: iPXE with a script inside

The boot file is an **iPXE** program —
`netboot.xyz.efi` for UEFI,
`netboot.xyz.kpxe` for legacy BIOS, and
siblings for other cases (chapter 3).
iPXE is a full network-boot environment
in about a megabyte: its own network
drivers, DHCP client, HTTP and HTTPS
clients, scripting language, and menu
system. Baked into each netboot.xyz
bootloader is an **embedded script** —
the program the lab read in source form
in transcript
`t05-repository-and-generation.txt`. It:

1. announces itself and waits four
   seconds for the **m** key, which
   opens a small failsafe menu (local
   boot, manual network settings, a
   debug shell, reboot);
2. runs its own DHCP, because iPXE
   wants the address in its own terms;
3. if it arrived via TFTP from a local
   server, first looks there for local
   files — `local-vars.ipxe` and a
   local menu (this is how a self-hosted
   LAN hijacks the chain politely,
   chapter 9);
4. otherwise chains over HTTPS to
   `boot.netboot.xyz/<version>/menu.ipxe`
   — falling back to HTTP, then to
   booting the local disk, if each step
   fails.

The bootloader holds the *route*; it
holds no menu and no operating systems.

## The menu: scripts, settings, and a mirror book

What the chain downloads is not data but
more programs. **`menu.ipxe`** detects
the architecture, loads **`boot.cfg`**,
and draws the menu. `boot.cfg` is the
settings file: the site name, the boot
domain, whether to verify signatures
(true, unless the Secure Boot path
makes it impossible — chapter 4), the
default timeout, the architecture gates
that decide which sections exist, and
the **mirror book**: for each
distribution, the address of its
project's official mirror. A
distribution submenu — `debian.ipxe`,
`ubuntu.ipxe`, and a hundred kin — asks
which release, builds the netboot
installer address on that mirror, and
loads its kernel and initial ramdisk
over HTTP. **Live** systems are the
exception: their files are too
ISO-shaped for mirrors, so the project
releases prepared kernels and
filesystems itself, from its own GitHub
asset repositories, addressed through
**endpoints** generated from
`endpoints.yml` (chapter 4). Every one
of these files is a small text script,
and the release ships detached
signatures for all of them in a `sigs/`
folder, which iPXE checks before
running them when signature checking is
on.

## Which part holds what

| Question | The part that answers it |
| --- | --- |
| Why did it boot the disk instead? | The firmware — network boot never chosen, or DHCP offered no filename |
| Why this bootloader and not that one? | The DHCP answer — filename is chosen per client kind |
| Why did the first fetch hang? | TFTP — wrong server, wrong name, or UDP blocked |
| Why did it stop at a failsafe menu? | The bootloader's embedded script — its DHCP or chain failed |
| Why is there no Live section? | `boot.cfg` — the architecture gates turned it off for this machine |
| Why is this release missing from a distro's list? | That distro's menu script — and the mirror it points at |
| Why did the installer then stall? | Past netboot.xyz's border — the mirror and the installer itself |

Keep this table. Chapters 7, 8 and 13
are this table, unfolded.
