#!/bin/bash

. /etc/zabbix/scripts/ibmds3512_discovery.sh

DSADDR=$(echo $1)
CTLSLOT=$(echo $2)

IFS=' '

ctl_status () {
	CTL_STATUS=$(cat ${REPODIR}/${DSADDR}.system.repo | grep -w "Slot ${CTLSLOT}$" -A3 | tail -n1 |awk '{ print $2 }')
	echo ${CTL_STATUS}
}

$3

