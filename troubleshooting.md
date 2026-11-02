# Troubleshooting

Ordered the way the boot is ordered:
find the stage that stops, and the
cause lives in that stage's part
(chapter 2's table). Boot-stage advice
here is the project's documentation
and the chain's logic; the file-stage
advice was lived by the lab.

## The bytes are wrong before anything boots

**A checksum fails.** Do not boot the
file. Re-download it — and check *what*
you downloaded: a rate-limited or
erroring server can hand you an HTML
page wearing a binary's name. The lab
hit GitHub's API rate limit on its
first probe of the release (transcript
`t00`) and later hashed the empty
string when a fetch raced a starting
server (transcript `t06`):
`e3b0c442...` is the SHA-256 of nothing,
and it means the *fetch* failed, not
the release. `file` is the second
witness: a real `.efi` says PE32+, a
real ISO says ISO 9660.

## The machine boots its disk and says nothing

Network boot was never requested, or
the request was answered without a
filename. Summon the firmware's boot
menu explicitly (F12 is common) and
choose the network entry by hand once,
to separate "not in the boot order"
from "not offered". If the PXE banner
appears and reports an address but no
boot file — or the famous
`PXE-E53: No boot filename received` —
the DHCP answer is the whole story:
options 66/67 are absent, or the DHCP
server you configured is not the one
answering. **Two DHCP servers** —
router plus your new one — produce the
intermittent version of this fault,
working at 2 p.m. and not at 3,
depending on which answered first.
One authority per network segment;
make it a decision, not an accident.

## The firmware names the file, then stalls or refuses

`PXE-T01`/`TFTP not found` family:
the filename in the DHCP answer and
the file in the TFTP root must agree
*exactly* — case, extension, no stray
path. A refusal with the file present
usually means the shape is wrong for
the firmware: a legacy `.kpxe` offered
to a UEFI machine, or an x86_64 file
offered to ARM. Match filename to
client kind (chapter 7's table) — in a
mixed fleet, this is the fault that
looks like networking and is actually
filing.

## iPXE loads, but the card is dead inside it

The classic. The bootloader's native
driver does not drive this network
card. The release builds the ladder of
fallbacks for exactly this: try the
**SNP** UEFI build (`netboot.xyz-snp.efi`,
which rides the firmware's own network
stack), or on legacy BIOS the
**UNDIONLY** build
(`netboot.xyz-undionly.kpxe`, which
borrows the card's firmware driver —
the project's documentation names it
as the remedy "if you are experiencing
issues with the regular bootloader").
Opposite symptom, same chapter: a
keyboard dead at the menu on an old
BIOS machine points at the **legacy**
builds, which leave USB emulation
alone.

## The banner shows, then HTTPS fails, then local boot

The embedded script's fallback ladder,
working as designed (its stages are
quoted in chapter 8): LAN fine, route
outward broken. Read it as a network
diagnosis — DNS unreachable, gateway
wrong, an authenticating proxy, or a
firewall that passes port 69 and 80
but not 443. The structural cure is in
this guide: serve the menus yourself
(chapter 5) and set `live_endpoint`
(chapter 9), so the chain's far end is
a server in the same room.

## The menu appears, but a pick fails

Read the error's address. A
distribution menu builds its path on
*that distribution's mirror* — mirror
down, directory renamed after a new
release, or the version freshly
retired: retry later, pick the newer
release, or set a different mirror in
`boot.cfg` (chapter 9). A *live* pick
failing names a GitHub endpoint
instead — a pinned build superseded.
And if the failure is a signature
refusal, believe it: files that do not
verify are not run, the check has done
its one job, and the fix is fresh
files, not disabling the check.

## Secure Boot machines refuse the bootloader

Use the signed builds: the `-sb`
family, with `autoexec.ipxe` beside
them (chapter 3) — release 3.0.x ships
UEFI Secure Boot support on iPXE
v2.0.0 signed binaries. Note what
changes downstream: on that path the
menu's own signature checks are off
(chapter 4 explains why), so the
chain's integrity rests on the
firmware's signature instead. Know
which of your fleets is in which
posture before an incident asks you.

## It works, on the wrong release

A machine chainloads an ancient menu,
or your LAN's edits "didn't take": the
bootloader's version and the menu
folder it chains to are a matched pair
(chapter 3). Old TFTP roots accumulate
old bootloaders the way drawers
accumulate USB sticks. Serve one
release per folder, point the DHCP
filename at the folder you mean, and
delete the fossils on purpose.
