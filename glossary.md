# Glossary

**autoexec.ipxe** — a script iPXE runs
automatically when it finds one beside
the bootloader; the release's Secure
Boot builds load the menu chain through
it.

**boot.cfg** — the menu's settings
file: site globals, the mirror book,
the architecture gates, signature and
timeout settings. Loaded by `menu.ipxe`
before anything is drawn.

**Bootloader** — the first program a
booting machine runs after firmware.
Here, an iPXE build of about a megabyte
with a netboot.xyz script embedded.

**DHCP** — the protocol that hands a
machine its network address — and, with
options 66 and 67, its marching orders
for network booting.

**Endpoint** — in netboot.xyz, one
live-asset package: a prepared kernel
and filesystem in a netbootxyz GitHub
release, catalogued in `endpoints.yml`
and addressed by the live menus.

**iPXE** — the open-source network boot
firmware netboot.xyz is built on: its
own drivers, HTTP(S) client, scripting
language and menus in a megabyte.

**Legacy BIOS (PCBIOS)** — the
pre-UEFI firmware world, where the
boot files are `.kpxe` and drivers are
an adventure.

**live_endpoint** — the variable naming
where live images are fetched from;
defaults to the project's GitHub
organisation, overridable to your own
server.

**local-vars.ipxe** — a file you place
on your TFTP server to steer stock
bootloaders — endpoint, timeouts,
licensed-media locations — before the
menu loads.

**Memdisk** — the helper that lets iPXE
boot small floppy/disk images from
memory; ships with the menus.

**Mirror book** — this guide's name
for boot.cfg's per-distribution list
of official mirror addresses.

**next-server / filename** — DHCP
options 66 and 67: the file server's
address, and the boot file's name. The
two fields that make a network offer
booting.

**PXE** — Preboot Execution
Environment: the firmware feature that
boots a machine from the network,
decades old and in nearly every PC.

**Secure Boot** — UEFI's signature
enforcement on boot code; netboot.xyz's
`-sb` builds are signed for it.

**Signature check (sigs)** — the
menu's own verification: each script
carries a detached signature in `sigs/`,
checked by iPXE before it runs, unless
the Secure Boot path disables it.

**SNP / SNponly** — UEFI builds that
drive the network card through the
firmware's Simple Network Protocol —
all devices, or only the chained one.

**SquashFS** — the compressed,
read-only filesystem format live Linux
systems run from; the payload of the
live endpoints.

**TFTP** — the trivial file protocol
(UDP port 69) that carries the first
file from server to firmware, and
nothing after.

**UNDIONLY** — the legacy build that
borrows the network card's own firmware
driver (UNDI) instead of iPXE's native
drivers; the fallback when a card
misbehaves.

**Wimboot** — the helper that boots
Windows installation files (WIM) under
iPXE; ships with the menus and serves
the Windows entry.
