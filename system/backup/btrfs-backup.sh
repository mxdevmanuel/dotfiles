#!/usr/bin/env bash

BCKPFOLDER=/shared/.snapshots
LOCALSNAPS=/home/.snapshots
NEW=BACKUP-new
OLD=BACKUP

[[ ! -d $LOCALSNAPS ]] && mkdir -p $LOCALSNAPS && echo "Creating $LOCALSNAPS"
[[ ! -d $BCKPFOLDER ]] && mkdir -p $BCKPFOLDER && echo "Creating $BCKPFOLDER"

# Bootstrap
[[ -d ${BCKPFOLDER}/${NEW} ]] && mv ${BCKPFOLDER}/${NEW} ${BCKPFOLDER}/${OLD} && \
        echo "Moving ${BCKPFOLDER}/${NEW} to ${BCKPFOLDER}/${OLD}"
[[ -d ${LOCALSNAPS}/${NEW} ]] && mv ${LOCALSNAPS}/${NEW} ${LOCALSNAPS}/${OLD} && \
        echo "Moving ${LOCALSNAPS}/${NEW} to ${LOCALSNAPS}/${OLD}"

# Snapshot
btrfs subvolume snapshot -r /home ${LOCALSNAPS}/${NEW}
sync

# Send to backup volume
if [[ -d ${LOCALSNAPS}/${OLD} ]]
then
        btrfs send -p ${LOCALSNAPS}/${OLD} ${LOCALSNAPS}/${NEW} | btrfs receive ${BCKPFOLDER}
else
        btrfs send ${LOCALSNAPS}/${NEW} | btrfs receive ${BCKPFOLDER}
fi

# Delete old snapshots
[[ -d ${BCKPFOLDER}/${OLD} ]] && btrfs subvolume delete ${BCKPFOLDER}/${OLD}
[[ -d ${LOCALSNAPS}/${OLD} ]] && btrfs subvolume delete ${LOCALSNAPS}/${OLD}
