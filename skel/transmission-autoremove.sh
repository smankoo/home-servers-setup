#!/bin/bash

# the folder to move completed downloads to

# port, username, password
SERVER="9091 --auth transmission:transmission"

# use transmission-remote to get torrent list from transmission-remote list
# use sed to delete first / last line of output, and remove leading spaces
# use cut to get first field from each line
TORRENTLIST=`transmission-remote $SERVER --list | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=" " --fields=1 | sed 's/\*//g'`

transmission-remote $SERVER --list 

# for each torrent in the list
for TORRENTID in $TORRENTLIST
do
    echo ----
    echo Processing Torrent ID: $TORRENTID 

    # check if torrent download is completed
    #DL_COMPLETED=`transmission-remote $SERVER --torrent $TORRENTID --info | grep "Percent Done: 100%"`
    PCT_DONE=`transmission-remote $SERVER --torrent $TORRENTID --info | grep "Percent Done:"| sed 's/ *//g;s/%//g' | cut -d ":" -f2 | cut -d"." -f1`
    
    if [ $PCT_DONE -lt 100 ]; then
        echo "PCT_DONE: ${PCT_DONE}. Torrent not complete. Moving on."
        continue
    else
        # check torrents current state is STOPPED
        STATE_STOPPED=`transmission-remote $SERVER --torrent $TORRENTID --info | grep "State: Seeding\|Stopped\|Finished\|Idle"`
        if [ !$STATE_STOPPED ]; then
            echo "Torrent not STOPPED. Moving on."
            continue
        else
            echo "Torrent #$TORRENTID is completed"
            echo "Removing torrent from list"
            transmission-remote $SERVER --torrent $TORRENTID --remove
        fi
    fi
done