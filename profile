[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

export EDITOR=vim
export LESS=-Ri
export MANPAGER="vim -M +MANPAGER -"

export QT_QPA_PLATFORMTHEME=gtk2
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel ${_JAVA_OPTIONS}"
