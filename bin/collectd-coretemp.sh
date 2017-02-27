#!/bin/sh
# Custom CPU temperature plugin for collectd
# See https://collectd.org/wiki/index.php/Plugin:Exec
# See https://collectd.org/documentation/manpages/collectd-exec.5.shtml

HOSTNAME="${COLLECTD_HOSTNAME:-`hostname -f`}"
INTERVAL="${COLLECTD_INTERVAL:-10}"

ncpus=`sysctl -n hw.ncpu`
# Because seq is inclusive :(
ncpus=`expr $ncpus - 1`

while sleep "$INTERVAL"; do
   for cpu in `seq 0 $ncpus`; do
     temp=`sysctl -n dev.cpu.$cpu.temperature | sed s/...$//`
     echo "PUTVAL \"$HOSTNAME/coretemp-$cpu/temperature\" interval=$INTERVAL N:$temp"
   done
 done

