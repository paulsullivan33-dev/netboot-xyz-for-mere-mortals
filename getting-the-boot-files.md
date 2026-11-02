# Getting the Boot Files

**Outcome: a small folder of boot files
whose hashes you have checked against
the project's published list — so that
whatever happens later, you know the
bytes you are booting are the bytes the
project released.** Everything in this
chapter was run for real in the lab,
against release **3.0.3** (transcripts
`t00`–`t02` in `netboot-xyz-lab/`).

## One release, many shapes

A netboot.xyz release is not one file
but a family. Every member is the same
iPXE program wearing a different
container, because firmware, boot media
and network cards each accept different
shapes. The 3.0.3 release publishes
several dozen assets; the shapes that
matter:

| File | Shape | For |
| --- | --- | --- |
| `netboot.xyz.efi` | UEFI application (1.1 MB) | DHCP filename for 64-bit UEFI machines; native iPXE network drivers |
| `netboot.xyz-snp.efi` | UEFI application | Same, driving the card through UEFI's Simple Network Protocol; tries every network device |
| `netboot.xyz-snponly.efi` | UEFI application | SNP, but only the device it was chained from |
| `netboot.xyz.kpxe` | Raw binary (0.4 MB) | DHCP filename for legacy BIOS machines; native drivers |
| `netboot.xyz-undionly.kpxe` | Raw binary (0.1 MB) | Legacy BIOS, borrowing the network card's own firmware driver (UNDI) — the fallback when native drivers misbehave |
| `netboot.xyz.iso` | Bootable ISO (2.4 MB) | CD/DVD and virtual media: VM consoles, iDRAC/iLO, hypervisor datastores |
| `netboot.xyz.img` | Raw disk image (exactly 2 MiB) | Writing to a USB key (chapter 6) |
| `netboot.xyz.lkrn` | Linux-kernel-shaped image | Chainloading from an existing GRUB or similar bootloader |
| `autoexec.ipxe` | Text script | Picked up automatically by the Secure Boot bootloaders from the same folder |

Around those, three families of
variants repeat the same shapes:
**`-legacy`** files use a driver set
that leaves USB keyboards working on
old BIOS machines; **`-metal`** files
are tuned for bare-metal cloud servers
(serial consoles, the providers' network
setup); **`-sb`** files are the Secure
Boot signed builds, and there are
**`-arm64`** editions of the UEFI files
for ARM machines. The project's README
tabulates the whole family; the rule
that chooses among them is simple:
match the *firmware* first (UEFI or
legacy), the *architecture* second
(x86_64 or arm64), and reach for a
variant only when the plain file fails
you — chapter 13 is mostly that
sentence, experienced slowly.

## The download

The files live in two official places:
the GitHub release
(`github.com/netbootxyz/netboot.xyz`,
under Releases) and the project's own
boot service, which serves bootloaders
under `boot.netboot.xyz/ipxe/`. The lab
used the release, whose URL pattern is
plain:

```bash
base=https://github.com/netbootxyz/netboot.xyz/releases/download/3.0.3
curl -LO "$base/netboot.xyz.efi"
curl -LO "$base/netboot.xyz.kpxe"
curl -LO "$base/netboot.xyz.iso"
curl -LO "$base/netboot.xyz.img"
curl -LO "$base/netboot.xyz-sha256-checksums.txt"
```

Two cautions from the lab's own run.
The release number is part of the
address — a bootloader's embedded script
chains to the menu *of its own release*,
so mixing a 3.0.3 bootloader with a
different version's menus is a confusion
you can simply not buy. And a download
is not verified by arriving: the lab's
very first probe of this release hit
GitHub's API rate limit and could have
mistaken an error page for an answer.
Which is what the next step is for.

## The check

Every release publishes
`netboot.xyz-sha256-checksums.txt`: one
SHA-256 hash per asset, with a header
naming the build date and the exact
iPXE commit the bootloaders were built
from (release 3.0.3: built 2026-08-29,
iPXE commit `26f46a2b`). Filter the list
to the files you took, and let
`sha256sum` judge:

```bash
sh netboot-xyz-lab/verify-downloads.sh \
  netboot.xyz.efi netboot.xyz.kpxe \
  netboot.xyz.iso netboot.xyz.img
```

```text
netboot.xyz.efi: OK
netboot.xyz.kpxe: OK
netboot.xyz.iso: OK
netboot.xyz.img: OK
```

(The lab's filter script is in this
guide's lab folder; transcript `t02`
keeps its full run, eight files, eight
OK.) `file` adds a second, independent
witness — it reads shapes, not hashes:

```text
netboot.xyz.efi:  PE32+ executable (DLL) (EFI application) x86-64 ...
netboot.xyz.iso:  ISO 9660 CD-ROM filesystem data 'iPXE' (bootable)
netboot.xyz.img:  DOS/MBR boot sector; partition 4 ... active ...
netboot.xyz.lkrn: Linux kernel x86 boot executable bzImage, version 2.0.0+ (g26f46) ...
```

A 9-byte file saying *Not Found*, an
HTML error page wearing a `.efi` name —
both fail both checks at once. That is
the whole acceptance test for this
chapter, and it is the same check
chapter 5 repeats after serving the
files, and chapter 13 reaches for first
when a boot misbehaves: *prove the
bytes, then debug the behaviour.*
