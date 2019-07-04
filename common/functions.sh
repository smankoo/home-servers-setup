function get_new_container_id {
    for i in `pct list | awk 'FNR>1{print $1}'`; do
        con_id=$((i+1))
        pct status ${con_id} >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo ${con_id}
            return 0
        fi
    done
}
