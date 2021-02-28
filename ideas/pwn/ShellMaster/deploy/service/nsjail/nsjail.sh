#!/bin/bash

mkdir /sys/fs/cgroup/{cpu,memory,pids}/NSJAIL
mkdir -p /var/log/nsjail

nsjail \
    -Ml \
    --port 31337 \
    --chroot /chroot/ \
    --user nobody \
    --group nogroup \
    --hostname jail \
    --log /var/log/nsjail/nsjail.log \
    --time_limit 30 \
    --cgroup_cpu_ms_per_sec 100 \
    --cgroup_mem_max 8388608 \
    --cgroup_pids_max 16 \
    --disable_clone_newnet \
    --env PATH=/bin:/usr/bin \
    -- $@