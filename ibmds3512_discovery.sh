#!/bin/bash

REPODIR=/etc/zabbix/scripts/repo
DSADDR=${1}
CLICMD=/opt/IBM_DS/client/SMcli
SUDOCMD=`which sudo`

IFS='
'

system (){
	 ${SUDOCMD} ${CLICMD} ${DSADDR} -c "show storageSubsystem;" > ${REPODIR}/${DSADDR}.system.repo.tmp && mv ${REPODIR}/${DSADDR}.system.repo.tmp ${REPODIR}/${DSADDR}.system.repo

        echo "{
               \"data\":[

                {
                        \"{#DSADDR}\":\"${DSADDR}\"}]}"
}

drive (){
	${SUDOCMD} ${CLICMD} ${DSADDR} -c "show allDrives;" > ${REPODIR}/${DSADDR}.drive.repo.tmp && mv ${REPODIR}/${DSADDR}.drive.repo.tmp ${REPODIR}/${DSADDR}.drive.repo

        echo "{
		\"data\":[
                        " > ${REPODIR}/${DSADDR}.drive.tmp

                for SLOTID in $(cat ${REPODIR}/${DSADDR}.drive.repo | egrep 'Slot [0-9]*' | awk '{print $NF}');
                do
			echo "			{\"{#SLOTID}\":"\"${SLOTID}"\",\"{#DSADDR}\":"\"${DSADDR}"\"}," >> ${REPODIR}/${DSADDR}.drive.tmp
                done
                cat ${REPODIR}/${DSADDR}.drive.tmp | sed '$s/},/}]}/g' && rm -f ${REPODIR}/${DSADDR}.drive.tmp
}

volume (){
        ${SUDOCMD} ${CLICMD} ${DSADDR} -c "show logicalDrives;" > ${REPODIR}/${DSADDR}.volume.repo.tmp && mv ${REPODIR}/${DSADDR}.volume.repo.tmp ${REPODIR}/${DSADDR}.volume.repo

        echo "{
                \"data\":[
                        " > ${REPODIR}/${DSADDR}.volume.tmp

                for VOLNAME in $(cat ${REPODIR}/${DSADDR}.volume.repo | grep "Logical Drive name:" | awk '{print substr($0, index($0,$4))}' | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//');
                do
                        echo "                  {\"{#VOLNAME}\":"\"${VOLNAME}"\",\"{#DSADDR}\":"\"${DSADDR}"\"}," >> ${REPODIR}/${DSADDR}.volume.tmp
                done
                cat ${REPODIR}/${DSADDR}.volume.tmp | sed '$s/},/}]}/g' && rm -f ${REPODIR}/${DSADDR}.volume.tmp
}

controller (){
        echo "{
                \"data\":[
                        " > ${REPODIR}/${DSADDR}.controller.tmp

        for CTLSLOT in $(cat ${REPODIR}/${DSADDR}.system.repo | grep -w "Slot [A-Z]$" | awk '{ print $6 }');
        do
                echo "                  {\"{#CTLSLOT}\":"\"${CTLSLOT}"\",\"{#DSADDR}\":"\"${DSADDR}"\"}," >> ${REPODIR}/${DSADDR}.controller.tmp
        done
        cat ${REPODIR}/${DSADDR}.controller.tmp | sed '$s/},/}]}/g' && rm -f ${REPODIR}/${DSADDR}.controller.tmp
}

iscsi (){
        echo "{
                \"data\":[
                        " > ${REPODIR}/${DSADDR}.iscsi.tmp

	for ISCSIMAC in $(cat ${REPODIR}/${DSADDR}.system.repo | grep "Host interface:[[:space:]]*iSCSI" -A5 | grep "MAC address:" | awk '{ print $3 }');
	do
		echo "                  {\"{#ISCSIMAC}\":"\"${ISCSIMAC}"\",\"{#DSADDR}\":"\"${DSADDR}"\"}," >> ${REPODIR}/${DSADDR}.iscsi.tmp
        done
        cat ${REPODIR}/${DSADDR}.iscsi.tmp | sed '$s/},/}]}/g' && rm -f ${REPODIR}/${DSADDR}.iscsi.tmp
}

if [[ "$2" == "drive" || "$2" == "system" || "$2" == "volume" || "$2" == "controller" || "$2" == "iscsi" ]]; then
        $2
fi

