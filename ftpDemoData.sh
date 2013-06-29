#! /usr/bin/env bash

echo "Well hello, Mr Doug..."

cmds="
rake db:drop
rake db:create
rake db:schema:load
rake db:fixtures:load
rake import:import_units
rake import:import_stations
rake import:import_data[paul123@piguard.com,ftp,data_domains.csv]
rake import:import_data[paul123@piguard.com,ftp,data_sub_domains.csv]
rake import:import_data[paul123@piguard.com,ftp,data_sets.csv]
rake import:import_data[paul123@piguard.com,ftp,data_line_items.csv]
"

# Change Internal File Separator to newline rather than whitespace
IFS=$'\n'

cnt=0
for cmd in $cmds
do
  ((++cnt))
  echo -e "\n**** Step - " $cnt "****\n"
  echo $cmd
  echo
  eval $cmd
done

echo -e "\nSee ya!\n"

