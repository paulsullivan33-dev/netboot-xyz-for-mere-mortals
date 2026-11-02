# Reading the Menu

**Outcome: the menu stops being a
black box. You will have unpacked the
release's menu files, read the main
menu, the settings file and one
distribution's script, and be able to
say where any entry comes from and
where its files are fetched.** All of
this chapter was read, for real, from
release 3.0.3's `menus.tar.gz`
(transcript `t03`).

## Unpacking the menu

Alongside the bootloaders, each release
publishes `menus.tar.gz` — the entire
web side of netboot.xyz, about 400 KB
of archive that unpacks to 218 entries:

```bash
tar -xzf menus.tar.gz
ls | wc -l        # 109
```

One hundred and nine items at the top:
a small text script per menu and per
distribution (`menu.ipxe`, `linux.ipxe`,
`debian.ipxe`, `live-ubuntu.ipxe`, …),
the settings file `boot.cfg`, an
`index.html`, two helper binaries
(`memdisk`, `wimboot`), and a `sigs/`
folder holding 109 detached signatures —
one per script, the raw material of the
signature check described below. There
is no compiled code to trust here and
nothing you may not read: the whole
product, minus the bootloader, is
scripts all the way down.

## The main menu is a program

`menu.ipxe` opens like every iPXE
script, with the `#!ipxe` marker, and
then *does* things rather than listing
things:

```ipxe
:start
isset ${arch} && goto skip_arch_detect ||
cpuid --ext 29 && set arch x86_64 || set arch i386
iseq ${buildarch} arm64 && set arch arm64 ||
:skip_arch_detect
chain --autofree boot.cfg ||
```

It detects the CPU architecture, then
immediately loads `boot.cfg`. Only
after that does it draw, and what it
draws is conditional — each section
line is guarded by a switch:

```ipxe
iseq ${menu_linux} 1 && item linux ${space} Linux Network Installs (64-bit) ||
iseq ${menu_live} 1 && item live ${space} Live CDs ||
iseq ${menu_bsd} 1 && item bsd ${space} BSD Installs ||
```

So when a section is missing on some
machine — no Live CDs on a 32-bit box,
no FreeDOS under UEFI — that is not a
bug or a different download. It is
`boot.cfg`'s architecture table making
a decision, and now you know its name.
The menu also ends with a line worth
noticing before you need it:

```ipxe
item sig_check ${space} netboot.xyz [ enabled: ${sigs_enabled} ]
```

## boot.cfg: settings and the mirror book

`boot.cfg` is three documents in one
file. First, the globals:

```ipxe
set site_name netboot.xyz
set boot_domain boot.netboot.xyz/3.0.3
set sigs_enabled true
iseq ${efi/SecureBoot} 01 && set sigs_enabled false ||
set sigs http://${boot_domain}/sigs/
isset ${boot_timeout} || set boot_timeout 300000
```

Signature checking is **on**: before
the chain runs a menu script, iPXE
verifies it against the detached
signature in `sigs/`. The one exception
is written into the file itself — when
the machine booted through the upstream
Secure Boot path, signature checking is
turned off, because that path's iPXE
cannot perform the verification. The
default timeout is 300000 ms: left
alone, the menu waits five minutes,
then boots the local disk. That number
matters again in chapter 9.

Second, the **mirror book** — for each
distribution, the address of its own
project's official mirror:

```ipxe
set debian_mirror http://deb.debian.org
set ubuntu_mirror http://archive.ubuntu.com
set archlinux_mirror mirrors.kernel.org
set fedora_mirror http://mirrors.kernel.org
```

Twenty-odd distributions, each
installed from home, not from
netboot.xyz's servers. Third, the
architecture gates: blocks that set the
`menu_*` switches per combination of
x86_64, i386, arm64, BIOS and UEFI —
plus a small cloud section that, on
bare-metal providers, swaps in serial
consoles and `-metal` bootloaders.

## A distribution menu, and a live one

`debian.ipxe` shows the install pattern.
It offers releases — at 3.0.3, Debian
13 (trixie) and 12 (bookworm), plus
testing and unstable, plus a "type any
older codename" escape hatch that
quietly switches the mirror to
`archive.debian.org` — then builds the
standard netboot path on the mirror
`boot.cfg` named, and loads the kernel
and initrd from there. Nothing about
Debian is stored in the menu but a
list of names and the knowledge of
where Debian keeps its installer.

Live systems invert that. A live image
is a whole filesystem, and mirrors do
not keep one in netboot shape — so the
project cooks its own: it takes the
upstream release apart, adjusts the
initrd to boot from the network, and
re-publishes the pieces as GitHub
releases of its own (repositories like
`debian-squash` and `debian-core-13`
under the netbootxyz organisation).
`live-debian.ipxe` therefore points at
those, through the `live_endpoint`
variable:

```ipxe
set squash_url ${live_endpoint}/debian-squash/releases/download/13.6.0-b92f504b/filesystem.squashfs
set kernel_url ${live_endpoint}/debian-core-13/releases/download/13.4.0-0a426450/
```

The tags (`13.6.0-b92f504b`) are version
plus a short build hash — every live
entry pins an exact build, and the list
of all of them, 127 endpoints at this
release, is generated from the
`endpoints.yml` in the source
repository (transcript `t05`). Hold on
to `live_endpoint`: chapter 9 shows it
is the single most useful knob a
self-hoster gets, because it is a
variable — and variables can be
overridden.
