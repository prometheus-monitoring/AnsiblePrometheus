#!/bin/bash
########################################################################################################################################################
# Text Reset
RCol='\e[0m'
Gre='\e[0;32m'
Red='\e[0;31m'
success="[$Gre OK $RCol]"
fail="[$Red Fail $RCol]"
done="[$Gre Done $RCol]"
########################################################################################################################################################
# Declare Variables
# Not need change
DTIME=$(date +"%Y%m%d_%H%M")
SDIR=`pwd`
HOMEPATH="/etc/prometheus/targets"
USER='prometheus'
BACKUPPATH=${HOMEPATH}/backups
# LOGPATH=${BACKUPPATH}/logs
# DLog="${LOGPATH}/backup_$DTIME.log"
########################################################################################################################################################
# Check WorkDIR
function check_homepath() {
        arr_path=(${HOMEPATH} ${BACKUPPATH})
        for hpath in "${arr_path[@]}"
        do
                [ ! -d "${hpath}" ] && sudo mkdir -p "${hpath}"
        done
        echo -e "Check WORKDIR : $done"
}
# Check User
function check_user() {
        sudo getent passwd $USER > /dev/null 2&>1
        if [ $? -eq 0 ]; then
                sudo chown -R $USER:$USER $HOMEPATH
                echo -e "User : $success"
        else
                sudo useradd --no-create-home --shell /sbin/nologin ${USER}
                        sudo chown -R $USER:$USER $HOMEPATH
                        echo -e "User : $success"
        fi
}
# Backup
function create_backup() {
  for target_file in ${HOMEPATH}/targets_*
  do
          filename=`basename "$target_file"`
                cp ${target_file} ${BACKUPPATH}/${filename%.*}_$DTIME.json.bkp
                if [ $? -eq 0 ]
      then
        echo -e "Backup ${target_file}: $success "
      else
        echo -e "Backup: $fail"
                                continue
    fi
        done
}

function  main() {
        check_homepath
        create_backup
        check_user
}

main
