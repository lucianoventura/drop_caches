#!/bin/bash
# drop_caches.sh
# Created by:  luciano.ventura@gmail.com 2014-07-30

 
# this script is a porkaround for the Vmware´s memory ballon issue.



# all directories used
readonly home_dir=/u01/Oracle/home_infra/drop_caches
readonly  log_dir=$home_dir/log



#log files
readonly     log_file=$log_dir/drop_caches
readonly out_log_file=$log_file.out



echo " ############################"    >> $out_log_file
echo " $(date) "                        >> $out_log_file
echo " ############################"    >> $out_log_file
echo ""                                 >> $out_log_file



echo "Used memory BEFORE cleaning"      >> $out_log_file
echo ""                                 >> $out_log_file
free -m                                 >> $out_log_file
echo ""                                 >> $out_log_file

# commit data to disk
sync


# free memory
echo 3 > /proc/sys/vm/drop_caches



echo "Used memory AFTER cleaning"       >> $out_log_file
echo ""                                 >> $out_log_file
free -m                                 >> $out_log_file
echo ""                                 >> $out_log_file



exit 0



# this script is based on this site, available and online in 2014-07-30:
# https://www.kernel.org/doc/Documentation/sysctl/vm.txt


# Documentation for /proc/sys/vm/*    kernel version 2.6.29
#     (c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
#     (c) 2008         Peter W. Morreale <pmorreale@novell.com>
# 
# For general info and legal blurb, please look in README.
# 
# ==============================================================
# 
# This file contains the documentation for the sysctl files in
# /proc/sys/vm and is valid for Linux kernel version 2.6.29.
# 
# The files in this directory can be used to tune the operation
# of the virtual memory (VM) subsystem of the Linux kernel and
# the writeout of dirty data to disk.
# 
# Default values and initialization routines for most of these
# files can be found in mm/swap.c.
#
# drop_caches
# 
# Writing to this will cause the kernel to drop clean caches, as well as
# reclaimable slab objects like dentries and inodes.  Once dropped, their
# memory becomes free.
# 
# To free pagecache:
#     echo 1 > /proc/sys/vm/drop_caches
# To free reclaimable slab objects (includes dentries and inodes):
#     echo 2 > /proc/sys/vm/drop_caches
# To free slab objects and pagecache:
#     echo 3 > /proc/sys/vm/drop_caches
# 
# This is a non-destructive operation and will not free any dirty objects.
# To increase the number of objects freed by this operation, the user may run
# `sync' prior to writing to /proc/sys/vm/drop_caches.  This will minimize the
# number of dirty objects on the system and create more candidates to be
# dropped.
# 
# This file is not a means to control the growth of the various kernel caches
# (inodes, dentries, pagecache, etc...)  These objects are automatically
# reclaimed by the kernel when memory is needed elsewhere on the system.
# 
# Use of this file can cause performance problems.  Since it discards cached
# objects, it may cost a significant amount of I/O and CPU to recreate the
# dropped objects, especially if they were under heavy use.  Because of this,
# use outside of a testing or debugging environment is not recommended.
# 
# 
#