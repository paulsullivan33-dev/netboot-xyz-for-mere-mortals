# Limits

What netboot.xyz cannot do, stated
plainly. The file-level facts were
verified in the lab; the boot-level
ones follow from how the chain is
built, and the project's documentation
agrees with them.

**It starts installers; it does not
finish them.** The menu hands a machine
to an installer and leaves. Unattended
answers, partitioning policy, account
creation, and everything after the
first installer screen belong to the
distribution's own machinery
(preseed, kickstart, autoinstall,
cloud-init) or to a provisioner
(chapter 11). Anyone selling you
"netboot.xyz images our fleet"
is describing other tools wearing its
menu as a hat.

**The catalogue is bounded by what
mirrors publish.** A distribution
appears when its project ships a
netboot-shaped installer, at the
versions its menu script lists.
Anything ISO-only must be cooked into
a live endpoint by the project first —
that pipeline is generous (127
endpoints) but finite, and a niche
system you love may simply not be on
the menu, ever. Your own media can
fill a gap through a custom menu
(chapter 9); the catalogue cannot be
wished longer.

**Licensed systems bring their own
media.** Windows and RHEL are menu
entries that point at *your* copies of
their installation files. netboot.xyz
neither supplies nor licenses them,
and a network full of booting machines
does not change the licence arithmetic
at all.

**It needs a network that cooperates.**
A firmware that will not network-boot,
a DHCP server you may not configure, a
network segmented so the client cannot
reach the file servers, captive
portals and 802.1X port authentication
that demand credentials a bootloader
cannot type — each closes the door
before the menu exists. Guest Wi-Fi is
not a boot network. Wi-Fi booting in
general is the sharp edge: PXE is a
wired story on nearly all firmware,
and iPXE's own wireless support is
narrower still.

**The first hop is frail by design.**
TFTP over UDP has no retransmission
manners worth the name and no
integrity check beyond UDP's checksum;
it survives because the file is small
and the LAN is near. Across subnets it
needs DHCP relay help; across a WAN it
is simply the wrong tool — the chain
switches to HTTP(S) immediately after,
but the first file always makes the
frail hop.

**Trust starts at the DHCP answer.**
A PXE client executes whatever file
the answering server names. On your
network that is the feature; on any
network, it means a rogue DHCP server
is a bootkit delivery service, and
netboot.xyz cannot tell a kind answer
from a hostile one. The signature
checks in the menu protect the *menu*
— they begin after the bootloader is
already running. Secure Boot narrows
the bootloader end (the signed `-sb`
builds), and port security narrows the
rogue-server end; neither is a default
on a home LAN, and honesty requires
saying so.

**Destructive tools are on the menu.**
The Utilities section carries disk
wipers — DBAN on the legacy menu,
ShredOS on both — a menu level and a
confirmation away from erasing whatever
disk is in the machine that booted it.
On a network where *anyone* can
network-boot, that is a physical-access
policy question, not a software one.
Restrict the menu (chapter 9), restrict
the boot key, or accept the exposure
knowingly.

**No state, no memory.** Each boot is
the first boot. The menu does not know
the machine, keeps no inventory, logs
nothing centrally, and cannot answer
"which machines installed what last
week". Provisioners keep books;
netboot.xyz holds a door open.

**This guide's limit, restated.** The
lab verified every byte and read every
script but booted nothing: timings,
firmware behaviours and failure shapes
in chapters 7 and 8 are the project's
documentation, not measurements. A
reader with a LAN learns things in an
afternoon that this guide cannot
claim to know.
