[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

export EDITOR=vim
export LESS=-Ri

export QT_QPA_PLATFORMTHEME=qt6gtk2
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel ${_JAVA_OPTIONS}"
