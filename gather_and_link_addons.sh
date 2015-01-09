#!/bin/bash

if [ ! -z $PATH_TO_BLENDER_RELEASE ]; then
	echo 'Using user provided blender release: '$PATH_TO_BLENDER_RELEASE
	BLENDER_RELEASE_PATH=$PATH_TO_BLENDER_RELEASE
elif [ -z $BLENDER_RELEASE_PATH ]; then
	echo 'Using user provided blender release: '$BLENDER_RELEASE_PATH
else
    BLENDER_RELEASE_PATH=~/blendercad
	echo 'Using default blender release location: '$BLENDER_RELEASE_PATH
fi

BLENDER_SCRIPTS_PATH=$BLENDER_RELEASE_PATH/scripts
BLENDER_ADDONS_PATH=$BLENDER_SCRIPTS_PATH/addons
BLENDER_ADDONS_BACKUP_PATH=$BLENDER_ADDONS_PATH'.bak'

CONFIG_PATH=~/.config/blender
PATH_FOR_TEMPORARY_FILES=$CONFIG_PATH
if [ ! -d $CONFIG_PATH ]; then
	PATH_FOR_TEMPORARY_FILES=/tmp
fi

# For collecting all addons from all the repos into one folder:
ADDONS_COLLECTION_PATH=$PATH_FOR_TEMPORARY_FILES/addons__only_put_here_links

# Remove an out to date link:
# If it's a directory, backup: (and copy back later such that the custom addons take precedence/override the default ones and yet special addons that are only found in a release like cycles/ exist.)
if ( -d $BLENDER_ADDONS_PATH ); then
	mv -i $BLENDER_ADDONS_PATH $BLENDER_ADDONS_BACKUP_PATH
	#$BLENDER_VERSION <-- as git tags are used to remember the commit for a certain release, these kind of backups are not required.
elif ( -f $BLENDER_ADDONS_PATH ); then
	# Remove the symbolic link:
    rm $BLENDER_ADDONS_PATH
fi

ln -s $ADDONS_COLLECTION_PATH $BLENDER_ADDONS_PATH

if (( -f $ADDONS_COLLECTION_PATH )); then
    echo 'Notice: Directory for merging all addons is a file. '$ADDONS_COLLECTION_PATH
	ADDONS_COLLECTION_PATH=$ADDONS_COLLECTION_PATH'.ALTERNATION'
	echo 'Using alternate directory: '$ADDONS_COLLECTION_PATH
elif ! (( -d $ADDONS_COLLECTION_PATH )); then
	mkdir $ADDONS_COLLECTION_PATH
fi

# Remove all links as we will relink anew later:
rm $ADDONS_COLLECTION_PATH/*

# Note that space ' ' is delimiter by default:
# Order matters, later mentioned folders can't override addons that already exist.
if [ ! -z $ALL_PATHS_TO_ADDONS ]; then
	echo 'Using user provided blender addons: '$ALL_PATHS_TO_ADDONS
else
ALL_PATHS_TO_ADDONS=(

    $HOME/blender_addon__export_to_pyrogenesis/*.py
    $HOME/blender_addon__render2print/*.py
    $HOME/blender_addon__selection2bom/*.py
	$HOME/blender_addon__multi_join_or_group_by_autoexpanded_pattern/*.py
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
fi


for i in "${ALL_PATHS_TO_ADDONS[@]}"; do
	
    currentValue=$i
    echo "Linking " ${currentValue}
	#echo '-> into ' ${ADDONS_COLLECTION_PATH}
	
    ln -s $currentValue $ADDONS_COLLECTION_PATH
	
done


