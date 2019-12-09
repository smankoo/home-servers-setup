#!/bin/bash

ENSURE_MOUNTED=/seagate
DESTINATION_DIR=/seagate/media/Movies
SOURCE_DIR=/data/couchpotato
DESTINATION_FREE_BUFFER_PERC=10 # amount of space (in percentage) to keep free on destination mount point
TIME_LIMIT_MIN=240 # Time (in minutes) for which the move process should be run. Set to 0 for no limit.


START_TIME=$(date +%s)
TIME_LIMIT_SEC=$((TIME_LIMIT_MIN * 60))
TIME_ELAPSED_SEC=0

throw_error(){
    error_text=$1
    echo "ERROR: ${error_text}" >&2
}

parent_id=`ps -o ppid= -p $$`

running_count=`ps -ef | grep sweep_to_archive.sh | grep -v $$ | grep -v ${parent_id} | grep -v grep | wc -l`

if [ ${running_count} -gt 0 ]; then
    throw_error "Another instance of the script is already running. Current process id is: $$"
    throw_error "`ps -ef | grep sweep_to_archive.sh | grep -v $$ | grep -v ${parent_id} | grep -v grep`"
    exit
fi

if [ ! -d ${SOURCE_DIR} ]; then
    throw_error "Specified source directory ${SOURCE_DIR} does not exist."
    exit
fi

ls -1 ${SOURCE_DIR} | while read move_target
do
    move_target_abs=${SOURCE_DIR}/${move_target}
    df | awk '{print $6}' | grep -w "${ENSURE_MOUNTED}" >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        throw_error "ERROR: Destination Not Mounted"
        exit
    fi


    if [ -e "${DESTINATION_DIR}/${move_target}" ]; then
        echo "${move_target} already exists in ${DESTINATION_DIR}"
        continue
    fi

    if [ ! -d "${DESTINATION_DIR}" ]; then
        mkdir -p "${DESTINATION_DIR}"
    fi

    # Make sure there's sufficient space in destination mount point

    move_target_size_k=`du -sk "${move_target_abs}" | cut -f1`

    destination_free_space_k=`df -k "${DESTINATION_DIR}" | tail -1 | awk '{print $4}'`

    destination_free_space_usable_k=$((destination_free_space_k - destination_free_space_k/DESTINATION_FREE_BUFFER_PERC))

    if [ ${destination_free_space_usable_k} -lt ${move_target_size_k} ]; then
        throw_error "Insufficient space in destination."
        throw_error "${move_target_abs} size is ${move_target_size_k}KB, whereas usable free space on ${DESTINATION_DIR} mount point is ${destination_free_space_usable_k}"
        exit
    fi

    echo "Moving ${move_target_abs} to ${DESTINATION_DIR}"
    
    mv -b "${move_target_abs}" "${DESTINATION_DIR}"
    
    echo "Done"

    CURR_TIME=$(date +%s)
    TIME_ELAPSED_SEC=$(( $CURR_TIME - $START_TIME ))

    echo "Elapsed time is ${TIME_ELAPSED_SEC} seconds"

    if [ ${TIME_LIMIT_SEC} -gt 0 ] && [ ${TIME_ELAPSED_SEC} -ge ${TIME_LIMIT_SEC} ]; then
        TIME_ELAPSED_MIN=$((TIME_ELAPSED_SEC/60))
        echo "Elapsed time ${TIME_ELAPSED_MIN} minutes is greater than time limit ${TIME_LIMIT_MIN} minutes."
        echo "Exiting."
        exit
    fi
done