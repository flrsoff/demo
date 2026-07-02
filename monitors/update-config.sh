#!/bin/bash
SCRIPT_DIR=$(dirname $0)
CONFIG_FILE="monitors.yml"
MONITOR_LIST_DIR="list"

cd $SCRIPT_DIR
rm -fr $MONITOR_LIST_DIR && mkdir -p $MONITOR_LIST_DIR

profile=`cat profile`
count=$(yq ".$profile | length" "$CONFIG_FILE")
for i in $(seq 0 $((count - 1))); do
    name=$(yq ".$profile[$i].name" "$CONFIG_FILE") && name=${name//\"}
    monitor_config_dir=$MONITOR_LIST_DIR/$name
    mkdir $monitor_config_dir
    
    echo $(yq ".$profile[$i].primary" "$CONFIG_FILE") > $monitor_config_dir/primary

    field=$(yq ".$profile[$i].resolution" "$CONFIG_FILE") && echo ${field//\"} > $monitor_config_dir/resolution
    echo `yq ".$profile[$i].position[0]" "$CONFIG_FILE"`x`(yq ".$profile[$i].position[1]" "$CONFIG_FILE")` > $monitor_config_dir/pos
    field=$(yq ".$profile[$i].rotation" "$CONFIG_FILE") && echo ${field//\"} > $monitor_config_dir/rotation
    field=$(yq ".$profile[$i].scale" "$CONFIG_FILE") && echo $field"x"$field > $monitor_config_dir/scale
    echo $(yq -r ".$profile[$i].desktops[]" "$CONFIG_FILE" | xargs) > $monitor_config_dir/desktops
done
