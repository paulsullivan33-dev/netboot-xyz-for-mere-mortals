# Serving It Yourself

**Outcome: the complete netboot.xyz web
side — bootloaders and menus — served
from a web server you control, with the
fetched bytes proven identical to the
release's, and your own first custom
menu file sitting in the layout where
the bootloader chain will find it.**
Run for real in the lab, over HTTP on a
loopback port (transcript `t06`); on
your own network the same folder is
served by whatever web server you
already run.

## Why serve it yourself at all

The hosted service is the same files
(transcript `t04`: the menu at
`boot.netboot.xyz/3.0.3/menu.ipxe` is
byte-for-byte the one in the release).
Self-hosting buys three things the
hosted service cannot: **reach** — a
LAN with no internet at boot time can
still boot; **control** — you pin one
release, edit the settings, add your
own entries (chapter 9); and **load** —
forty machines booting at 9 a.m. pull
from your server, not from a project's
donated bandwidth. It costs a folder
and a web server. The whole release
side of this guide's lab — eight
bootloaders plus all menus — came to
about 9 MB.

## The layout

Mirror the hosted shape, because the
scripts assume it:

```text
site/
  ipxe/                 bootloaders, autoexec.ipxe,
                        netboot.xyz-sha256-checksums.txt
  3.0.3/                the unpacked menus.tar.gz:
                        menu.ipxe, boot.cfg, *.ipxe,
                        sigs/, memdisk, wimboot, index.html
```

The version number is a folder name
because the bootloader's embedded
script chains to
`<boot_domain>/<version>/menu.ipxe` —
keep the folder's name equal to the
release the files came from, and a
future release can sit beside it as a
sibling folder rather than overwriting
it mid-flight.

## The serve and the proof

The lab used the web server every
Python install carries, bound to the
loopback address on its lab port; any
static web server does the same job:

```bash
python3 -m http.server 18082 --bind 127.0.0.1 --directory site
```

Then the acceptance test — fetch the
files *back through the server* and
hash what arrives, because what a boot
client will receive is the served
bytes, not the files on disk:

```bash
curl -s http://127.0.0.1:18082/3.0.3/menu.ipxe | sha256sum
# 9c984baf...31  — equals the local menus/menu.ipxe

curl -s http://127.0.0.1:18082/ipxe/netboot.xyz.efi | sha256sum
# 56bb21e9...82  — equals the published checksum, chapter 3

curl -s http://127.0.0.1:18082/ipxe/netboot.xyz.iso | sha256sum
# 2206b05c...d1  — also equals the published checksum
```

Three for three in the lab. The folder
listing at `/` answers 200 (the menus'
own `index.html`), `boot.cfg` and
`version.ipxe` answer 200, and a name
that does not exist answers 404 — the
server's whole personality, and all a
boot client asks of it. (One lab wart,
kept in transcript `t06` because it
teaches the right reflex: the first
fetch raced the server's startup, came
back empty, and hashed to the famous
SHA-256 of nothing at all. Wait for the
port to answer before you fetch — and
when a hash disagrees, suspect the
fetch before the file.)

## Where your own file goes

Into the version folder, next to the
project's scripts. The lab placed a
small `custom.ipxe` of its own there —
a three-item house menu; it is kept at
`netboot-xyz-lab/custom.ipxe` — and the
server served it at
`/3.0.3/custom.ipxe` like any other
file. Nothing registers it and nothing
needs rebuilding for HTTP to serve it;
wiring it into the menu's Custom slot
is a settings matter, and it is
chapter 9's subject. Serving the
files, in other words, is the easy
half — but it is the half that can be
*proven*, at a desk, with hashes,
before any machine is asked to boot
from them.
