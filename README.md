Gather and link addons
======

Why use?
-----
Allows to maintain many custom addons all in their respective locations (single source! Not spread in a thousand versions across all places).

No longer deal with redundant copies of addons.

Maintains all blender release-delivered addons.

What the script does?
----
First gathers all addons from addon locations you specified (see example below). Then links them to the blender release addons/ folder backing up the existing addons/ folder into addons.bak/.

Usage:
----
    chmod +x /path/to/gather_and_link_addons.sh
    /path/to/gather_and_link_addons.sh

In my case: (just use CTRL+R in the command line to search for a command you already entered before)

    ~/shell__blenderaddons_gather_and_link/gather_and_link_addons.sh

or

    PATH_TO_BLENDER_RELEASE=~/blendercad ~/shell__blenderaddons_gather_and_link/gather_and_link_addons.sh

When blender complains about missing files:
---
Rerun the script. This is required if you e.g. rename your addons in any of the addon locations (see below). Else blender will complain of not found files of activated addons.



Use without customized addon paths configuration:
---
A folder for symbolic links to addons anywhere in the filesystem now included by default since [version 1.2](https://github.com/faerietree/shell__blenderaddons_gather_and_link/releases):

This allows to just link the addons as symbolic links

    cd $HOME/blender-addons-symlinks
    ln -s ../rel/path/to/addon__module__or.py $HOME/blender-addons-symlinks/
    /path/to/gather_and_link_addons.sh



Example addons paths configuration: (order matters!)
----

Order matters: A twice existing file can't be overridden. The first file will take precedence (may depend on operating system).


    ALL_PATHS_TO_ADDONS=(

        $HOME/BlenderCAM/scripts/addons/*
        $HOME/blender_addons/basrelief/basrelief.py

        $HOME/blender-addons-zeffii/*
        $HOME/macouno-read-only/Blender/addons/*

        $HOME/blender-addons-misc/*

        $HOME/blender-addons-modified/*
        $HOME/blender-addons-symlinks/*

        $HOME/blender-addons/*
        $HOME/blender-addons-contrib/*

        $BLENDER_ADDONS_BACKUP_PATH
    )

By including `BLENDER_ADDONS_BACKUP_PATH`, which usually is just `/path/to/blenderreleasefiles/2.xy/scripts/addons.bak/` it's ensured that at least all release provided addons exist.


