#!/usr/bin/env zsh

function install_theme(){
        local groot=$(git rev-parse --show-toplevel)
        local gtkdir=${groot}/.gtk/gruvbox-material-gtk 
        local iconsdir=${HOME}/.local/share/icons
        local themesdir=${HOME}/.local/share/themes

        [[ ! -d $iconsdir ]] && mkdir $iconsdir
        [[ ! -d $themesdir ]] && mkdir $themesdir

        if [[ ! -f $gtkdir ]]
        then
                pushd ${groot}/.gtk
                git clone https://github.com/sainnhe/gruvbox-material-gtk.git

                ln -s ${gtkdir}/icons/Gruvbox-Material-Dark ${iconsdir}/Gruvbox-Material-Dark
                ln -s ${gtkdir}/themes/Gruvbox-Material-Dark ${themesdir}/Gruvbox-Material-Dark
                
                gsettings set org.gnome.desktop.interface gtk-theme Gruvbox-Material-Dark
                gsettings set org.gnome.desktop.interface icon-theme Gruvbox-Material-Dark
        else
                pushd $gtkdir
                git pull
        fi
}

install_theme
