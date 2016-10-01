# manual steps
Miscellaneous list of things not yet handled in an automated way.

### highdpi switches for 3k screens
#### cinnamon

```aconf
[cinnamon]
active-display-scale=2

[cinnamon/desktop/interface]
scaling-factor=uint32 2

[gnome/desktop/interface]
scaling-factor=uint32 2
```

#### rxvt
Should have a 1.33 scaling factor based on montor size difference from 1920 to 2560.

```diff
diff --git a/.Xresources b/.Xresources
index c460306..b148339 100644
--- a/.Xresources
+++ b/.Xresources
@@ -33,10 +33,10 @@ URxvt.matcher.button:       1
 ! -- Theme
 URxvt.internalBorder:       0
 URxvt.letterSpace:          -1
-URxvt.font:                 xft:DejaVu Sans Mono for Powerline:size=16:Regular
-URxvt.boldFont:             xft:DejaVu Sans Mono for Powerline:size=16:Bold
-URxvt.italicFont:           xft:DejaVu Sans Mono for Powerline:size=16:Italic
-URxvt.boldItalicFont:       xft:DejaVu Sans Mono for Powerline:size=16:Bold:Italic
+URxvt.font:                 xft:DejaVu Sans Mono for Powerline:size=21:Regular
+URxvt.boldFont:             xft:DejaVu Sans Mono for Powerline:size=21:Bold
+URxvt.italicFont:           xft:DejaVu Sans Mono for Powerline:size=21:Italic
+URxvt.boldItalicFont:       xft:DejaVu Sans Mono for Powerline:size=21:Bold:Italic

 ! -- Transparent background
 URxvt.foreground:           #FFFFFF
```

### dark theme
now an option somewhere in system settings. no dconf entry for it...

## Sublime
Install package control and configure session:

- Preferences -> Install Package Control
- View -> Layout -> Columns: 2 (shortcut key overridden by alt-shift)
- Toggle: Sidebar + Minimap
- Preferences -> Color Scheme -> SetiUX
