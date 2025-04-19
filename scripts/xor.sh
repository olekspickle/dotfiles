#!/bin/bash

function ascii2dec
{
  RES=""
  for i in `echo $1 | sed "s/./& /g"`
  do 
    RES="$RES `printf \"%d\" \"'$i\"`"
  done 
  echo $RES
}

function dec2ascii
{
  RES=""
  for i in $*
  do 
    RES="$RES`printf \\\\$(printf '%03o' $i)`"
  done 
  echo $RES
}

function xor
{
  KEY=$1
  shift
  RES=""
  for i in $*
  do
    RES="$RES $(($i ^$KEY))"
  done

  echo $RES
}


KEY=$1
TESTSTRING=$2

echo "Original String: $TESTSTRING"
STR_DATA=`ascii2dec "$TESTSTRING"`
echo "Original String Data: $STR_DATA"
XORED_DATA=`xor $KEY $STR_DATA`
echo "XOR-ed Data: $XORED_DATA"
XORED_STR=`dec2ascii $XORED_DATA`
echo "Xored String: $XORED_STR"
RESTORED_DATA=`xor $KEY $XORED_DATA`
echo "Restored Data: $RESTORED_DATA"
RESTORED_STR=`dec2ascii $RESTORED_DATA`
echo "Restored String: $RESTORED_STR"
