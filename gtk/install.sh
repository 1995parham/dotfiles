#!/bin/sh
# In The Name Of God
# ========================================
# [] File Name : install.sh
#
# [] Creation Date : 11-03-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================
gtk_css_dir=$(cd "$(dirname "$0")" && pwd )

for css in $gtk_css_dir/*.css; do
	cat $css >> $HOME/.config/gtk-3.0/gtk.css
done
