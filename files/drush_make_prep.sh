#!/usr/bin/env bash

if [[ -d $1 && -z `ls -A $1` || ! -e $1 ]]

then
  rmdir $1 &> /dev/null
  exit 0

fi

exit 1