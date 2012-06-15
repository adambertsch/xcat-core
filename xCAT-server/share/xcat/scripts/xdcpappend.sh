#!/bin/sh
# This script is used by the xdcp APPEND: function to perform the
# append operation on the nodes.
#First parm is nodesyncfiledir,  then after that are the lines for the
#APPEND clause  put in the format   
#appendfile appendfile:orgfile appendfile2:orgfile2.....
#
nodesyncfiledir=$1
nodesyncfiledirorg="$nodesyncfiledir/org"
nodesyncfiledirappend="$nodesyncfiledir/append"
skip=0
for i in $*; do
  # skip first parm
  if [ $skip -eq 0 ]; then
    skip=1
    continue
  fi
  # get the append file location
  appendfilebase=`echo "$i"|cut -d ':' -f 1`
  appendfile="$nodesyncfiledirappend$appendfilebase"
  # get the file to append to
  orgfile=`echo "$i"|cut -d ':' -f 2`
  # get the directory to backup the original file to append 
  orgfiledir=`dirname $orgfile`
  filebackupdir="$nodesyncfiledirorg$orgfiledir"
  filebackup="$nodesyncfiledirorg$orgfile"
  # now do the work
  mkdir -p $filebackupdir 
  if [ ! -f "$filebackup" ]; then
    cp -p $orgfile $filebackup
  fi
  cp -p $filebackup $orgfile
  cat $appendfile >> $orgfile

done
exit 0
