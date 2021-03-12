Inspiration:
* https://kvz.io/tobuntu.html

## Gnome shorcuts
```
# Fixup the window placement shortcuts
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-down  "['<Ctrl><Alt>Down']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-up  "['<Ctrl><Alt>Up']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-left  "['<Ctrl><Alt>Right']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-right "['<Ctrl><Alt>']"

# Remove useless <Super>+Alphabet shortcuts
# To detect them: (for schema in $(gsettings list-schemas); do gsettings list-recursively $schema; done) | grep '<Super>'
gsettings set org.gnome.settings-daemon.plugins.media-keys rotate-video-lock-static []
gsettings set org.gnome.shell.keybindings toggle-message-tray []
gsettings set org.gnome.shell.keybindings toggle-overview []
gsettings set org.gnome.desktop.wm.keybindings minimize []
gsettings set org.gnome.desktop.wm.keybindings show-desktop []
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver []
gsettings set org.gnome.shell.keybindings toggle-application-view []
gsettings set org.gnome.shell.keybindings focus-active-notification []
gsettings set org.gnome.mutter.keybindings switch-monitor []
gsettings set org.gnome.shell.extensions.dash-to-dock shortcut []

gsettings set org.gnome.desktop.wm.keybindings begin-move []
gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-7 []

# More macOS-like tab navigation in the terminal
# Find all possible config keys via: `gsettings list-recursively` |grep Terminal
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ next-tab "<Super>braceright"
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ prev-tab "<Super>braceleft"
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ move-tab-left "<Super><Shift>Left"
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ move-tab-right "<Super><Shift>Right"
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ close-tab "<Super>w"
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ new-tab "<Super>t"
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ new-window "<Super>n"
# gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ copy "<Super>c"
# gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ paste "<Super>v"

# Move the "Activities overview" shortcut to Super_R
gsettings set org.gnome.mutter overlay-key "Super_R"
gsettings reset org.gnome.desktop.wm.keybindings switch-input-source
gsettings reset org.freedesktop.ibus.general.hotkey triggers

# Remove Alt+<Key> selecting menu items
gsettings set org.gnome.desktop.interface automatic-mnemonics true
```

## Make the Dock more macOS-like
```
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
```

## CLion

Add "macOS" keybindings. Copy it & modify them as follows:
1. Swap "Go to class" & "Go to symbol" to resemble Xcode settings.
2. Make Copy & Paste, `<Ctrl><Shift>C/V`

Open Help > Edit custom properties. Add to that file: `keymap.windows.as.meta=true` to register `<Super>` as `<Meta>`
