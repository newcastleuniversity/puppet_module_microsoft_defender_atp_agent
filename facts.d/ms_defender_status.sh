#!/bin/bash

which mdatp > /dev/null

if [ $? != 0 ]
  then echo mdatp_is_installed=false
  exit 0
fi

HEALTHY=$(mdatp health --field healthy)

if [ $HEALTHY != 'true' ]
# the exit codes of mdatp are not documented, the textual output is
  then echo mdatp_is_healthy=false
  exit 0
fi

LICENCED = $(mdatp health --field licensed)

if [ $LICENCED != 'true ' ]
  then echo mdatp_is_licensed=false
  exit 0
if

echo mdatp_is_installed=true
echo mdatp_is_healthy=true
echo mdatp_is_licensed=true
