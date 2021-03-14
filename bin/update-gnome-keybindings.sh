#!/usr/bin/env bash

set -e -o pipefail

KEYS_GNOME_WM=/org/gnome/desktop/wm/keybindings
KEYS_GNOME_SHELL=/org/gnome/shell/keybindings
KEYS_GNOME_EXT=/org/gnome/shell/extensions
KEYS_MUTTER=/org/gnome/mutter/keybindings
KEYS_MEDIA=/org/gnome/settings-daemon/plugins/media-keys
KEYS_MUTTER_WAYLAND_RESTORE=/org/gnome/mutter/wayland/keybindings/restore-shortcuts

KEYS_TERMINAL=/org/gnome/terminal/legacy/keybindings

POPOS_SCHEMA_DIR=$HOME/.local/share/gnome-shell/extensions/pop-shell\@system76.com/schemas
KEYS_POP_OS=org.gnome.shell.extensions.pop-shell

# NB: This updates the defaults from pop-os shell, if installed.
# Useful on Ubuntu also, but works better with pop-shell.
set_keybindings() {
	set -x

	# remove more conflicting keybindings
	dconf write ${KEYS_GNOME_WM}/show-desktop "@as []"
	dconf write ${KEYS_GNOME_WM}/begin-move "@as []"
	dconf write ${KEYS_GNOME_WM}/toggle-maximized "['<Ctrl><Super>m']"

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

	dconf write ${KEYS_TERMINAL}/next-tab "'<Super>braceright'"
	dconf write ${KEYS_TERMINAL}/prev-tab "'<Super>braceleft'"
	dconf write ${KEYS_TERMINAL}/close-tab "'<Super>w'"

	# Move the "Activities overview" shortcut to Super_R
	dconf write ${KEYS_MUTTER}/overlay-key "'Super_R'"

	# Remove Alt+<Key> selecting menu items
	gsettings set org.gnome.desktop.interface automatic-mnemonics true

	# conflicting bindings introduces by pop-os
	gsettings --schemadir "${POPOS_SCHEMA_DIR}" set ${KEYS_POP_OS} toggle-tiling "['<Ctrl><Super>y']"
	gsettings --schemadir "${POPOS_SCHEMA_DIR}" set ${KEYS_POP_OS} toggle-floating "['<Ctrl><Super>g']"
	gsettings --schemadir "${POPOS_SCHEMA_DIR}" set ${KEYS_POP_OS} toggle-stacking-global "['<Ctrl><Super>s']"
	gsettings --schemadir "${POPOS_SCHEMA_DIR}" set ${KEYS_POP_OS} tile-orientation "['<Ctrl><Super>o']"

	set +x
}

reset_keybindings() {
	set -x

	# remove more conflicting keybindings
	# remove more conflicting keybindings
	dconf reset ${KEYS_GNOME_WM}/show-desktop
	dconf reset ${KEYS_GNOME_WM}/begin-move
	dconf reset ${KEYS_GNOME_WM}/toggle-maximized

	dconf reset ${KEYS_GNOME_SHELL}/toggle-application-view
	dconf reset ${KEYS_GNOME_SHELL}/focus-active-notification

	dconf reset ${KEYS_GNOME_EXT}/dash-to-dock/shortcut

	dconf reset ${KEYS_MUTTER}/switch-monitor

	# remove bindings introduced by pop-os-shell
    # Lock screen
	dconf reset ${KEYS_MEDIA}/home
	dconf reset ${KEYS_MEDIA}/email
	dconf reset ${KEYS_MEDIA}/www
	dconf reset ${KEYS_MEDIA}/terminal

	dconf reset ${KEYS_TERMINAL}/next-tab
	dconf reset ${KEYS_TERMINAL}/prev-tab
	dconf reset ${KEYS_TERMINAL}/close-tab

	# Move the "Activities overview" shortcut to Super_R
	dconf reset ${KEYS_MUTTER}/overlay-key

	# Remove Alt+<Key> selecting menu items
	gsettings reset org.gnome.desktop.interface automatic-mnemonics

	# conflicting bindings introduces by pop-os
	gsettings --schemadir "${POPOS_SCHEMA_DIR}" reset ${KEYS_POP_OS} toggle-tiling
	gsettings --schemadir "${POPOS_SCHEMA_DIR}" reset ${KEYS_POP_OS} toggle-floating
	gsettings --schemadir "${POPOS_SCHEMA_DIR}" reset ${KEYS_POP_OS} tile-orientation
	gsettings --schemadir "${POPOS_SCHEMA_DIR}" reset ${KEYS_POP_OS} toggle-stacking-global

	set +x
}

usage() {
	echo "USAGE: $0 COMMAND"
	echo
	echo "Commands:"
	echo "    set      sets opinionated keybindings"
	echo "    reset    resets keybindings to original defaults"
}

main() {
	case "$1" in
		set) set_keybindings ;;
		reset) reset_keybindings ;;
		*) usage ;;
	esac
}

main "$@"