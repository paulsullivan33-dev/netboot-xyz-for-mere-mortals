# The Neighbours

netboot.xyz sits at a crossing: boot
media on one side, network provisioning
on the other. Its neighbours each took
a different road from that crossing,
and they are characterised here from
their documentation and this guide's
lab — not benchmarked against it.

## Ventoy: the drawer, perfected

Ventoy (which has its own guide in
this series) takes the opposite bet:
put the *images* on the machine you
carry. A Ventoy stick holds whole ISO
files as files; copy a new system onto
it and it appears in Ventoy's boot
menu, no rewriting, dozens per stick.
It works with no network at all, boots
images netboot.xyz cannot (iPXE is a
poor ISO loader, which is why the live
endpoints exist), and asks nothing of
any DHCP server. Its costs are the
physical ones: the stick must be
*there*, its images age where they
sit, and the copying is gigabytes at a
time. Sites commonly run both — Ventoy
for the bench, netboot.xyz for the
building.

## iPXE itself: the engine without the menu

Everything netboot.xyz does, raw iPXE
can do — it *is* iPXE, plus a menu, a
mirror book and a build farm. Writing
your own iPXE scripts buys total
control: your exact entries, your
preseeds, your asset server, nothing
else. It costs the thing netboot.xyz
exists to save: the hundred-odd
distribution entries, their version
chasing (someone updates `debian.ipxe`
when Debian releases; in the raw-iPXE
world that someone is you), and the
live-image endpoints, which have no
raw equivalent at all. A common
graduation is hybrid: netboot.xyz for
the catalogue, a custom menu
(chapter 9) for the house specials,
raw iPXE only when both run out.

## iVentoy: the all-in-one appliance

iVentoy, from Ventoy's author, packages
the whole PXE errand — DHCP proxy,
TFTP, HTTP — into one application that
serves a folder of ISOs to a network,
in the spirit of its sibling. It asks
less networking knowledge than the
chapter 7 route and handles the
per-client filename problem itself.
In exchange it boots ISO *images*,
with the size and the rough edges ISO
booting over iPXE-style chains can
have, and its menu is your folder, not
a maintained catalogue of netboot
installers fetched from their makers.
Choose it when the images you already
have are the point; choose netboot.xyz
when the catalogue is.

## FOG: the cloning workshop

The FOG Project aims one floor up:
capture a machine's disk image, keep a
library of images, deploy them to
fleets, on schedules, with inventory
and management around it. It includes
its own PXE stack to do so. If the job
is *this exact system, on those fifty
desks, by Friday*, FOG — and its
commercial imaging kin — is the tool,
and netboot.xyz's honest answer is
that it merely contains Clonezilla.
If the job is *a fresh install, or a
rescue, on whatever just failed*, the
weight reverses.

## The datacentre provisioners: MAAS, Cobbler, Foreman

Canonical's MAAS, and Cobbler and
Foreman from the Red Hat world, treat
machines as inventory: discover,
commission, deploy with unattended
answers, track, reclaim. They subsume
PXE booting as one stage in a managed
life. They are the right answer at a
scale this guide does not address —
and they are a weekend of
infrastructure to stand up, where
netboot.xyz is a megabyte and two DHCP
fields. The honest line: netboot.xyz
starts installers; provisioners
*finish* them, unattended, at scale,
forever. Know which of those your
problem actually is.

## A plain web server of installers

The minimalist neighbour is no tool at
all: a folder of netboot kernels and
initrds on a web server, and a
hand-written iPXE script naming them.
For exactly two distributions that
never change, this is genuinely enough
— and it is, not coincidentally, what
one submenu of netboot.xyz looks like
from inside. The catalogue is what you
pay the complexity for; do not buy it
if you do not need it.
