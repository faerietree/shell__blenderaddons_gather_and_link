#!/bin/bash

if [ ! -z $PATH_TO_BLENDER_RELEASE ]; then
    echo 'Using user provided blender release: '$PATH_TO_BLENDER_RELEASE
    BLENDER_RELEASE_PATH=$PATH_TO_BLENDER_RELEASE
elif [ ! -z $BLENDER_RELEASE_PATH ]; then
    echo 'Using user provided blender release: '$BLENDER_RELEASE_PATH
else
    BLENDER_RELEASE_PATH='~/blender'
#    BLENDER_RELEASE_PATH='~/blenderart'
#    BLENDER_RELEASE_PATH='~/blendercad'
#    BLENDER_RELEASE_PATH='~/blendercam'
    echo 'Using default blender release location: '$BLENDER_RELEASE_PATH
fi

BLENDER_SCRIPTS_PATH=$BLENDER_RELEASE_PATH'/scripts'
BLENDER_ADDONS_PATH=$BLENDER_SCRIPTS_PATH'/addons'
BLENDER_ADDONS_BACKUP_PATH=$BLENDER_ADDONS_PATH'.bak'

CONFIG_PATH='~/.config/blender'
#PATH_FOR_TEMPORARY_FILES='/tmp'

echo ''
echo '========================'
echo '======= BASIC SETUP AND CHECK OF PATHS'

echo 'Determining addons gather path ...'
# For collecting all addons from all the repos into one folder:
ADDONS_COLLECTION_FOLDERNAME='addons__only_put_here_links'
if [ ! -d ${CONFIG_PATH} ]; then
    ADDONS_COLLECTION_PATH=$HOME"/"$ADDONS_COLLECTION_FOLDERNAME
else
    ADDONS_COLLECTION_PATH=$CONFIG_PATH"/"$ADDONS_COLLECTION_FOLDERNAME
fi
echo 'Using '$ADDONS_COLLECTION_PATH
echo '*done*'


echo 'Backup blender addons folder and link setup ...'
# Remove an out to date link:
if [[ -L ${BLENDER_ADDONS_PATH} ]]; then
    # Remove the symbolic link:
    echo 'Removing existing symbolic link '$BLENDER_ADDONS_PATH
    rm ${BLENDER_ADDONS_PATH}
# If it's a directory, backup: (and copy back later such that the custom addons take precedence/override the default ones and yet special addons that are only found in a release like cycles/ exist.)
elif [[ -d ${BLENDER_ADDONS_PATH} ]]; then
    echo 'Backing up ...'
    mv -i $BLENDER_ADDONS_PATH $BLENDER_ADDONS_BACKUP_PATH
    #$BLENDER_VERSION <-- as git tags are used to remember the commit for a certain release, these kind of backups are not required.
else
    echo 'Nothing to do. Neither directory to backup nor symbolic link to remove.'
fi
echo '*done*'



echo 'Checking addons gather path setup...'
if [[ -f ${ADDONS_COLLECTION_PATH} ]]; then
    echo 'Notice: Directory for merging all addons is a file. '$ADDONS_COLLECTION_PATH
    ADDONS_COLLECTION_PATH=$ADDONS_COLLECTION_PATH'.ALTERNATION'
    echo 'Using alternate directory: '$ADDONS_COLLECTION_PATH
elif [[ ! -d ${ADDONS_COLLECTION_PATH} ]]; then
    echo 'Creating directory '$BLENDER_ADDONS_PATH' ...'
    mkdir $ADDONS_COLLECTION_PATH
    echo '*done*'
else
    echo 'Everything is fine. Path has probably already been set up earlier.'
fi
echo '*done*'

echo 'Linking addons collection path into '$BLENDER_ADDONS_PATH
ln -s $ADDONS_COLLECTION_PATH $BLENDER_ADDONS_PATH
echo '*done*'


# Remove all links as we will relink anew later:
# Prevent trying to delete all root directory files:
if [ ! -z ${ADDONS_COLLECTION_PATH} ]; then
    echo 'Removing all existing gathered addons (links).'
    rm ${ADDONS_COLLECTION_PATH}/*
    echo '*done*'
else
    echo 'Warning: Had to prevent potentially dangerous removing of files as variable ADDONS_COLLECTION_PATH was empty.'
    echo '*skipped*'
fi


echo ''
echo '========================'
echo '======= LINKING GATHERED ADDONS'

# Note that space ' ' is delimiter by default:
# Order matters, later mentioned folders can't override addons that already exist.
if [ ! -z ${ALL_PATHS_TO_ADDONS} ]; then
    echo 'Using user provided blender addons: '$ALL_PATHS_TO_ADDONS
    echo 'Appending previously existing addons, some are required e.g. cycles:'
    $ALL_PATHS_TO_ADDONS=$ALL_PATHS_TO_ADDONS' '$BLENDER_ADDONS_BACKUP_PATH
else
    ALL_PATHS_TO_ADDONS=(

        $HOME/BlenderCAM/scripts/addons/*
        $HOME/blender_addons/basrelief/basrelief.py

        $HOME/blender-addons-antonioya/*py
        $HOME/blender-addons-zeffii/*
        $HOME/Blender_CAD_utils/*
        $HOME/macouno-read-only/Blender/addons/*

        $HOME/blender-addons-misc/*

        $HOME/blender-addons-modified/*
        $HOME/blender-addons-symlinks/*

        $HOME/blender-addons/*
        $HOME/blender-addons-contrib/*

        $BLENDER_ADDONS_BACKUP_PATH/*
    )
fi



for i in "${ALL_PATHS_TO_ADDONS[@]}"; do

    currentValue=$i
    echo "Linking " ${currentValue}
    #echo '-> into ' ${ADDONS_COLLECTION_PATH}

    ln -s $currentValue $ADDONS_COLLECTION_PATH

done

echo '-> into ' ${ADDONS_COLLECTION_PATH}
echo '*done*'

echo 'Removing __pycache__ ...'
rm $BLENDER_ADDONS_PATH/__pycache__ -r
echo '*done*'
