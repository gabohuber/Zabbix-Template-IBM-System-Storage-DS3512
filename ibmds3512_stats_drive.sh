#!/bin/bash

. /etc/zabbix/scripts/ibmds3512_discovery.sh

DSADDR=$(echo $1)
SLOTID=$(echo $2)

IFS=' '

status () {
	STATUS=$(cat ${REPODIR}/${DSADDR}.drive.repo | grep -w "Slot ${SLOTID}" -A 5 | grep "Status:" | awk '{print $2}')
	echo ${STATUS}
}

interface_type () {
        INTERFACE_TYPE=$(cat ${REPODIR}/${DSADDR}.drive.repo | grep -w "Slot ${SLOTID}" -A 19 | grep "Interface type:" | awk '{print substr($0, index($0,$3))}')
        echo ${INTERFACE_TYPE}
}

associated_array () {
	ASSOCIATED_ARRAY=$(cat ${REPODIR}/${DSADDR}.drive.repo | grep -w "Slot ${SLOTID}" -A 9 | grep -w "Associated array:" | awk '{print substr($0, index($0,$3))}')
	echo ${ASSOCIATED_ARRAY}
}

enclosure () {
	ENCLOSURE=$(cat ${REPODIR}/${DSADDR}.drive.repo | grep -w "Slot ${SLOTID}" | awk -F, '{ print $1}' | awk '{ print $4}')
	echo ${ENCLOSURE}
}

drive_path_redudancy () {
	DRIVE_PATH_REDUDANCY=$(cat ${REPODIR}/${DSADDR}.drive.repo | grep -w "Slot ${SLOTID}" -A19 | grep "Drive path redundancy:" | awk '{ print $4 }')
	echo ${DRIVE_PATH_REDUDANCY}
}

$3
