#!/bin/bash

. /etc/zabbix/scripts/ibmds3512_discovery.sh

DSADDR=$(echo $1)
ISCSIMAC=$(echo $2)

IFS=' '

link_status () {
	LINK_STATUS=$(cat ${REPODIR}/${DSADDR}.system.repo | grep "Host interface:[[:space:]]*iSCSI" -A5 | grep "${ISCSIMAC}" -B4 | grep "Link status:" | awk '{ print $3 }')
	echo ${LINK_STATUS}
}

ip_address (){
	IP_ADDRESS=$(cat ${REPODIR}/${DSADDR}.system.repo | grep "${ISCSIMAC}" -A14 | grep "IP address:" | awk '{ print $3}')
	echo ${IP_ADDRESS}
}

$3

