#!/bin/sh

set -ex

# NB: This updates the defaults from pop-os shell, if installed.
# Useful on Ubuntu also, but works better with pop-shell.
set_keybindings() {
    KEYS_GNOME_WM=/org/gnome/desktop/wm/keybindings
    KEYS_GNOME_SHELL=/org/gnome/shell/keybindings
    KEYS_GNOME_EXT=/org/gnome/shell/extensions
    KEYS_MUTTER=/org/gnome/mutter/keybindings
    KEYS_MEDIA=/org/gnome/settings-daemon/plugins/media-keys
    KEYS_MUTTER_WAYLAND_RESTORE=/org/gnome/mutter/wayland/keybindings/restore-shortcuts

	# remove more conflicting keybindings
    dconf write ${KEYS_GNOME_WM}/show-desktop "@as []"
    dconf write ${KEYS_GNOME_WM}/begin-move "@as []"

    dconf write ${KEYS_GNOME_SHELL}/toggle-application-view "@as []"
    dconf write ${KEYS_GNOME_SHELL}/focus-active-notification "@as []"

    dconf write ${KEYS_GNOME_EXT}/dash-to-dock/shortcut "@as []"

    dconf write ${KEYS_MUTTER}/switch-monitor "@as []"

	# remove bindings introduced by pop-os-shell
    # Lock screen
    dconf write ${KEYS_MEDIA}/home "@as []"
    dconf write ${KEYS_MEDIA}/email "@as []"
    dconf write ${KEYS_MEDIA}/www "@as []"
    dconf write ${KEYS_MEDIA}/terminal "@as []"

	KEYS_TERMINAL=/org/gnome/terminal/legacy/keybindings

	dconf write ${KEYS_TERMINAL}/next-tab "'<Super>braceright'"
	dconf write ${KEYS_TERMINAL}/prev-tab "'<Super>braceleft'"
	dconf write ${KEYS_TERMINAL}/close-tab "'<Super>w'"

	# Move the "Activities overview" shortcut to Super_R
	dconf write ${KEYS_MUTTER}/overlay-key "'Super_R'"

	# Remove Alt+<Key> selecting menu items
	gsettings set org.gnome.desktop.interface automatic-mnemonics true
}

set_keybindings
