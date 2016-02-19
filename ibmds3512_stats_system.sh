#!/bin/bash

. /etc/zabbix/scripts/ibmds3512_discovery.sh

DSADDR=$(echo $1)
CTLSLOT=$(echo $2)

IFS=' '

total_capacity () {
	TOTAL_CAPACITY=$(cat ${REPODIR}/${DSADDR}.system.repo | grep "Total Capacity:" | tail -n1 | awk '{ print $3 }' | sed 's/,//g' | awk -F'.' '{ print $1 }')
	echo ${TOTAL_CAPACITY}
}

storage_subsystem_name () {
	STORAGE_SUBSYSTEM_NAME=$(cat ${REPODIR}/${DSADDR}.system.repo | grep "Storage Subsystem Name:" | awk '{ print $4}')
	echo ${STORAGE_SUBSYSTEM_NAME}
}

used_space () {
	USED_SPACE=$(cat ${REPODIR}/${DSADDR}.system.repo |  grep "Total Capacity:" | tail -n1 | awk '{ print $6 }' | sed 's/,//g' | awk -F'.' '{ print $1 }')
	echo ${USED_SPACE}
}

free_space () {
	FREE_SPACE=$(cat ${REPODIR}/${DSADDR}.system.repo |  grep "Total Free Capacity:" | tail -n1 | awk '{ print $4}' | sed 's/,//g' | awk -F'.' '{ print $1 }')
	echo ${FREE_SPACE}
}

psu_online () {
        PSU_ONLINE=$(cat ${REPODIR}/${DSADDR}.system.repo |  grep "Power supply status:  Optimal" | wc -l)
        echo ${PSU_ONLINE}
}

$2
