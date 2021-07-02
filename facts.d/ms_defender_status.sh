#!/bin/bash

HEALTH=$(mdatp health --field healthy)

if [ $? == 0 ]
  then LICENSE=$(mdatp health --field licensed)
  else LICENSE='MDATP service is poorly'
fi

echo mdatp_is_healthy=$HEALTH
echo mdatp_is_licensed=$LICENSE
