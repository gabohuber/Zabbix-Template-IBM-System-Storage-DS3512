#!/bin/bash

. /etc/zabbix/scripts/ibmds3512_discovery.sh

DSADDR=$(echo $1)
VOLNAME=$(echo $2)

IFS=' '

status () {
	STATUS=$(cat ${REPODIR}/${DSADDR}.volume.repo | grep -w ${VOLNAME} -A3 | grep "Logical Drive status:" | awk '{ print $4}')
	echo ${STATUS}
}

capacity () {
	CAPACITY=$(cat ${REPODIR}/${DSADDR}.volume.repo | grep -w ${VOLNAME} -A6 | grep "Capacity:" | awk '{print $2}' | sed 's/,//g' | awk -F'.' '{ print $1 }')
	echo ${CAPACITY}
}

$3
