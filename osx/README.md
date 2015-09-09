## Karabiner Settings

From https://pqrs.org/osx/karabiner/document.html.en#commandlineinterface
Export Karabiner settings using : 
```
$ /Applications/Karabiner.app/Contents/Library/bin/karabiner export > $DOTFILES/osx/karabiner_import.sh
```
Import using
```
$ sh $DOTFILES/karabiner-import.sh
```

Also do '''cp $DOTFILES/osx/private.xml ~/Library/Application\ Support/Karabiner/private.xml''' to copy custom settings to be loaded into Karabiner.
