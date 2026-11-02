# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's fixtures are loopback addresses and one invented
   house menu.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** Chapter 12 names what the tool
   cannot do: it starts installers but never finishes or
   provisions them, its catalogue is bounded by what official
   mirrors publish in netboot shape, licensed systems require
   the reader's own media, the first hop is frail TFTP by
   design, the chain's trust begins at an unauthenticated DHCP
   answer, destructive disk wipers sit on its utilities menu,
   and it keeps no state or inventory of any machine.
8. **The ethics rule is in the text, early.** Network booting
   runs whatever a DHCP answer names, on every machine that
   asks — so chapter 1 and chapter 7 state the line plainly:
   offer this menu only on networks you administer, to
   machines you are entitled to boot. The same rule covers
   the menu's sharp edges: disk-wiping utilities are named
   as destructive in chapters 8 and 12 before any reader can
   meet them as a surprise, licensed installers need the
   reader's own media and licences, and every file the guide
   tells a reader to boot is one whose published checksum the
   guide first teaches them to verify.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is a 2-CPU, 7.7 GB Ubuntu 24.04 sandbox,
shared with other work while the lab ran. Its network rules
forbid UDP outright, which forbids DHCP and TFTP — so this
lab verified everything about netboot.xyz that is files,
scripts and HTTP, and **booted nothing**. That sentence is
the spine of these notes.

netboot.xyz **3.0.3** — identified as the latest stable
release from the repository's tags over git after the
GitHub REST API rate-limited the lab's first probe (t00) —
was exercised from its official GitHub release only. Ten
assets were downloaded (the UEFI, SNP, UNDIONLY and legacy
x86 bootloaders in several shapes, the ISO, the USB image,
the kernel-form bootloader, the Secure Boot autoexec script,
menus.tar.gz and the checksums file), and every downloaded
file that the project publishes a SHA-256 for verified OK
against `netboot.xyz-sha256-checksums.txt` — eight of eight
(t02). The release header dates the build 2026-08-29 and
names the iPXE commit (26f46a2b) the bootloaders were built
from; the `.lkrn` image's internal version string
("2.0.0+ (g26f46)") corroborates it (t01). All transcripts
live in `netboot-xyz-lab/transcripts/`; the lab's own menu
is `netboot-xyz-lab/custom.ipxe` and its checksum filter is
`netboot-xyz-lab/verify-downloads.sh`.

Run for real, with transcripts as evidence:

- Release identification without the API: git tags and the
  release page's asset listing, agreeing on 3.0.3 (t00).
- Downloads and independent identification of each file
  shape by `file`: the .efi a PE32+ UEFI application, the
  .iso a bootable ISO 9660 image labelled "iPXE", the .img
  a 2 MiB DOS/MBR disk image, the .lkrn an x86 bzImage
  (t01).
- Checksum verification of all eight published-hash files,
  8/8 OK (t02).
- Menu anatomy from the unpacked menus.tar.gz: 218 archive
  entries, 109 top-level scripts, 109 detached signatures;
  menu.ipxe's architecture detection and conditional
  sections, boot.cfg's globals, mirror book and architecture
  gates, debian.ipxe's release list and mirror logic,
  live-debian.ipxe's endpoint URLs, and version.ipxe read
  in full (t03).
- The hosted service compared with the release: the menu
  fetched from boot.netboot.xyz/3.0.3/ is byte-identical to
  the tarball's; the unversioned version.ipxe answers "3.x"
  where the tarball's says "3.0.3" (t04).
- The generating repository, cloned at the 3.0.3 tag:
  endpoints.yml counted at 127 endpoint entries, 103 menu
  templates, the embedded bootloader script and the
  local-vars.ipxe template read in source (t05).
- Self-hosting over HTTP: the release layout mirrored into
  ipxe/ and 3.0.3/ folders, served by Python's http.server
  on loopback port 18082, and the bytes proven after the
  hop — the served menu identical to the local copy, the
  served .efi and .iso identical to the published
  checksums; the lab's own custom.ipxe served alongside;
  200s, a 404 for a missing name, and the server stopped
  afterwards (t06).
- The USB image write rehearsed against an ordinary file:
  dd copy hash-identical to the verified download (t07).

Documented only — described from the project's
documentation (netboot.xyz/docs: Boot from TFTP, Boot from
USB, Self Hosting, and the introduction), never run, and
the text does not claim otherwise:

- **Network-booting a machine, in every form.** DHCP
  options, TFTP service, dnsmasq's combined configuration,
  per-client filename selection, the boot sequence of
  chapter 8 stage by stage, and every firmware behaviour —
  the sandbox forbids the UDP these speak, and no client,
  virtual or physical, was booted in this lab.
- USB and ISO boots themselves: writing a real USB device
  (the write was rehearsed against a file), attaching the
  ISO to a real VM or management console, and everything
  on screen after the firmware loads the bootloader.
- The Ansible and Docker self-host builds of chapter 9 —
  the role's templates and defaults were read in source;
  the playbook was not run and no bootloaders were compiled.
- The neighbour tools of chapter 11 (Ventoy excepted as a
  fellow guide in this series) — characterised from their
  documentation, not run or benchmarked.
- Installers and live systems after the menu hands over:
  no operating system was installed or run.

Fixtures are this guide's own and deliberately generic: a
loopback address on the lab's assigned port, and one
three-item "Workshop tools" menu. No real network, person
or organisation is modelled anywhere in the lab.
