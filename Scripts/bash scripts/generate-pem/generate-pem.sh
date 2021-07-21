#!/bin/bash

##################
#Author: Austin Hamrick
#Date: July 14th, 2021
#Description: Generates a PEM based on cert/key pair.
##################


STORE_DIR="*CHANGEME*"
SYS=$1
KEY=$2
CRT=$3

function usage(){
	printf "Usage: ./generate-pem <system> <key-file> <cert-file>"
}

mkdir -p $STORE_DIR/$SYS/

if [[ ! -f $STORE_DIR/$KEY ]]; then
	printf "Key file does not exist.\n\n"
	usage
fi

if [[ ! -f $STORE_DIR/$CRT ]]; then
	printf "Certificate file does not exist.\n\n"
	usage
fi

printf "Moving $KEY to $STORE_DIR/$SYS\n"
mv $STORE_DIR/$KEY $STORE_DIR/$SYS 2>/dev/null
if [[ $? -ne 0 ]]; then
	printf "Failed moving $KEY"
fi

printf "Moving $CRT to $STORE_DIR/$SYS\n"
mv $STORE_DIR/$CRT $STORE_DIR/$SYS 2>/dev/null
if [[ $? -ne 0 ]]; then
	printf "Failed moving $CRT" 
fi

printf "\n\nContents of $STORE_DIR/$SYS\n"
ls $STORE_DIR/$SYS

read -p "Enter to continue..."

clear

printf "\n###############################\n"
printf "# CREATING PEM                #\n"
printf "###############################\n"

cd $STORE_DIR/$SYS

PEM=$(touch $SYS.pem)
cat $KEY > $SYS.pem
cat $CRT >> $SYS.pem

cat $SYS.pem

echo
read -p "If this looks OK, hit enter...."

printf "\n\nListing new contents of $STORE_DIR/$SYS\n"
ls $STORE_DIR/$SYS
