#!/bin/bash

set -e
set -o pipefail

trap finish EXIT

discord_webhook={{ discord_webhook }}

plot_disks_directory={{ plot_dir }}
hostname=$(cat /proc/sys/kernel/hostname)

plotter={{ plotter.directory }}/build/chia_plot
chia={{ blockchain.directory }}/venv/bin/chia

disks=$(find $plot_disks_directory -mindepth 1 -maxdepth 1 -type d)

finish() {
  curl --header "Content-Type: application/json" -d '{"content": "Plotovanje je stalo na serveru '$hostname'. Potrebno je proveriti server."}' $discord_webhook
}

max_plot_number() {
  local disk_size_in_g=$(df --block-size=G $1 | tail -n +2 | awk '$6!="/" {print $0}' | awk 'END { print $4 }' | sed 's/G$//')
  local number_of_plots=$(echo $disk_size_in_g / 101.4 | bc)
  echo $number_of_plots
}

for disk in $disks; do
  plots=$(max_plot_number $disk)
  if [[ -n $plots ]]; then
    # add plot directory
    $chia plots add -d $disk/
    # run plotting
    $plotter -t /mnt/ssd/ -r 16 -u 512 -v 256 \
      -d $disk/ -n $plots \
      -c {{ contract }} -f {{ farmer_key }}
  fi
done

# notify when plotting ends
curl --header "Content-Type: application/json" -d '{"content": "'$hostname' zavrsio sa plotovanjem"}' $discord_webhook
