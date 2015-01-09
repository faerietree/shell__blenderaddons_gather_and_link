Gather and link addons
======

Why use?
-----
Keep addons in a single location, e.g. your development repository.

What the script does?
----
First gathers all addons from the folders as you specified. Then links them to the blender release addons/ folder backing up the existing addons/ folder into adddons.bak/.

Usage:
----
    chmod +x /path/to/gather_and_link_addons.sh
    /path/to/gather_and_link_addons.sh

In my case: (just use CTRL+R in the command line to search for a command you already entered before)

    ~/shell__blenderaddons_gather_and_link/gather_and_link_addons.sh

or

    PATH_TO_BLENDER_RELEASE=~/blendercad ~/shell__blenderaddons_gather_and_link/gather_and_link_addons.sh



Example addons paths configuration: (order matters!)
----

Order matters: A twice existing file can't be overridden. The first file will take precedence (may depend on operating system). 

     
    ALL_PATHS_TO_ADDONS=(
        
        $HOME/blender_addon__export_to_pyrogenesis/*.py
        $HOME/blender_addon__render2print/*.py
        $HOME/blender_addon__selection2bom/*.py
        $HOME/blender_addon__multi_join_or_group_by_autoexpanded_    pattern/*.py
        $HOME/blender_addon__meshlint/*.py
        
        $HOME/BlenderCAM/scripts/addons/*
        $HOME/blender_addon__basrelief/basrelief.py

        $HOME/blender-addons-zeffii/*
        $HOME/macouno-read-only/Blender/addons/*
        
        $HOME/blender-addons-misc/*
        
        $HOME/blender-addons-modified/*
        
        $HOME/blender-addons/*
        $HOME/blender-addons-contrib/*
        
        $BLENDER_ADDONS_BACKUP_PATH
    )

By including `BLENDER_ADDONS_BACKUP_PATH`, which usually is just `/path/to/blenderreleasefiles/2.xy/scripts/addons.bak/` it's ensured that at least all release provided addons exist.
 

