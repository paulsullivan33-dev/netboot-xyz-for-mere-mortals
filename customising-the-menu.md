# Customising the Menu

**Outcome: a netboot.xyz that answers
to your house — your mirrors, your
timeout, your own menu entries, your
own server for the live images — set
through the override points the project
built for exactly that, rather than by
forking its files.** The override
files were read for real in the lab
(transcript `t05`); the hosted-menu
effects of the settings are as the
project documents them.

## The lightest touch: local-vars.ipxe

Remember stage 3 of the boot: a
bootloader that arrived by TFTP first
looks on that TFTP server for a file
called `local-vars.ipxe`. That file is
the project's designed steering wheel.
The template ships in the source
(`roles/netbootxyz/templates/local-vars.ipxe.j2`),
every line commented out, each one a
variable the menu reads *after* your
file loads:

```ipxe
#!ipxe
### used for adding local variables before loading the menu

### set to enable github custom menu
#set github_user my_github_username

### Sets the local live endpoint for the users local installation
#set live_endpoint http://my_ip_address:8080

### Sets the default boot timeout
#set boot_timeout 300000

### Media Locations for Licensed Distros
#set rhel_base_url http://my_rhel_mirror/rhel/
#set win_base_url http://my_windows_mirror/windows/
```

Uncomment, replace with your values,
place the file in the TFTP root. It is
how a site redirects the live images to
its chapter 5 server (`live_endpoint`),
how a kiosk shortens its five-minute
patience, and how the Windows and RHEL
menus are fed — those two ask for media
*you* supply from your own licences,
and `win_base_url`/`rhel_base_url` are
where you tell them you did. No rebuild,
no edited downloads: the stock
bootloader reads your file on its way
past.

## The middle touch: boot.cfg, honestly edited

Chapter 5's self-hosted menus are
yours, and their `boot.cfg` can be
edited directly: a nearer mirror for a
distribution (`set debian_mirror ...`),
a section switched off, a longer
timeout. Two disciplines keep this
sane. Edit the *served* copy, never
your only copy — keep the release's
original beside it, because the diff
between them is your documentation of
what your site does differently. And
know the cost the project's
self-hosting page states plainly:
edits to a generated `boot.cfg` are
not carried into the next regeneration.
Re-deploy the menus and your edits are
gone — which is why the next level
exists.

## The real home for changes: user_overrides.yml

The menu is *generated* — by an Ansible
role from templates and defaults
(chapter 4, transcript `t05`). The
project's answer to "but I changed
things" is `user_overrides.yml` at the
repository root: any default from
`roles/netbootxyz/defaults/main.yml` —
mirrors, versions, which bootloaders to
build, the boot domain itself — can be
restated there, and the playbook
honours the override every run:

```bash
git clone https://github.com/netbootxyz/netboot.xyz.git /opt/netboot.xyz
# edit user_overrides.yml
ansible-playbook -i inventory site.yml
```

The output lands in the web root,
`/var/www/html` by default; the
project's Docker build produces the
same output into a folder without the
Ansible install. This is the level at
which a self-host stops being "the
release, served" and becomes "our
site's build": your boot domain in the
embedded scripts, your mirrors in every
menu, repeatable from source after any
release bump.

## Your own entries: custom menus

Beyond settings, the menu has a Custom
slot. With custom menus enabled
(`custom_generate_menus: true` in the
overrides), the main menu offers your
`custom/custom.ipxe`, rendered from
your own templates kept outside the
project's tree — the repository ships a
sample at `etc/netbootxyz/custom/`, and
the two trees update independently.
What a custom menu contains is just
iPXE: the lab's own specimen
(`netboot-xyz-lab/custom.ipxe`, served
for real in chapter 5) is the shape in
miniature — a `menu`, some `item`s, a
`choose`, and labels to jump to:

```ipxe
#!ipxe
menu Workshop tools
item shell  iPXE shell
item local  Boot from local disk
item reboot Reboot
choose pick || goto local
goto ${pick}
```

Real house menus chain the same way to
real work: a known-good rescue entry
with this month's kernel parameters, an
installer with the site's preseed URL
baked into the kernel line, a "boot the
spare server image" entry. The pattern
never changes — variables for the
parts that vary, `kernel`/`initrd` (or
`chain`) for the fetch, and the
project's menus open in an editor
beside you as a working example of
every construct you might need.
