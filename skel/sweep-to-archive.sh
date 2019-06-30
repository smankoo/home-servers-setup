#!/bin/bash

ENSURE_MOUNTED=/seagate
DESTINATION_DIR=/seagate/media/Movies
SOURCE_DIR=/data/couchpotato
DESTINATION_FREE_BUFFER_PERC=10 # amount of space (in percentage) to keep free on destination mount point
TIME_LIMIT_MIN=240 # Time (in minutes) for which the move process should be run. Set to 0 for no limit.



START_TIME=$(date +%s)
TIME_LIMIT_SEC=$((TIME_LIMIT_MIN * 60))
TIME_ELAPSED_SEC=0

while [ true ]; do

    throw_error(){
        error_text=$1
        echo "ERROR: ${error_text}" >&2
    }

    if [ ! -d ${SOURCE_DIR} ]; then
        throw_error "Specified source directory ${SOURCE_DIR} does not exist."
        exit
    fi

    df | awk '{print $6}' | grep -w "${ENSURE_MOUNTED}" >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        throw_error "ERROR: Destination Not Mounted"
        exit
    fi

    move_target=`ls -1 -rtd ${SOURCE_DIR}/* | head -1`

    if [ $? -ne 0 ] || [ "${move_target}" == "" ]; then
        echo "Nothing to move"
        exit
    fi

    if [ ! -d "${DESTINATION_DIR}" ]; then
        mkdir -p "${DESTINATION_DIR}"
    fi


    # Make sure there's sufficient space in destination mount point

    move_target_size_k=`du -sk "${move_target}" | cut -f1`

    
    destination_free_space_k=`df -k "${DESTINATION_DIR}" | tail -1 | awk '{print $4}'`

    destination_free_space_usable_k=$((destination_free_space_k - destination_free_space_k/DESTINATION_FREE_BUFFER_PERC))

    if [ ${destination_free_space_usable_k} -lt ${move_target_size_k} ]; then
        throw_error "Insufficient space in destination."
        throw_error "${move_target} size is ${move_target_size_k}KB, whereas usable free space on ${DESTINATION_DIR} mount point is ${destination_free_space_usable_k}"
        exit
    fi

    echo "Moving ${move_target} to ${DESTINATION_DIR}"
    
    mv -b "${move_target}" "${DESTINATION_DIR}"

    echo "Done"

    CURR_TIME=$(date +%s)
    TIME_ELAPSED_SEC=$(( $CURR_TIME - $START_TIME ))

    echo "Elapsed time is ${TIME_ELAPSED_SEC} seconds"

    if [ ${TIME_LIMIT_SEC} -gt 0 ] && [ ${TIME_ELAPSED_SEC} -ge ${TIME_LIMIT_SEC} ]; then
        TIME_ELAPSED_MIN=$((TIME_ELAPSED_SEC/60))
        echo "Elapsed time ${TIME_ELAPSED_MIN} minutes is greater than time limit ${TIME_LIMIT_MIN} minutes."
        echo "Exiting."
        break
    fi
done