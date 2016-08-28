#!/bin/bash

#Custom Module to generate ssh keys

TYPE="rsa"
SIZE=4096
COMMENT=""

if [[ -s $1 ]]; then
	while IFS='' read -r line || [[ -n "$line" ]]; do
		IFS=' ' read -r -a LINEARRAY <<< $line
	done < $1

	for ELEMENT in ${LINEARRAY[@]}
	do
		IFS='=' read -r KEY VALUE <<< ${ELEMENT}

		if [ "$KEY" == "comment" ]; then
			COMMENT=$VALUE
		fi
	done

	if [[ ! -f keypairs/${COMMENT}.pem && ! -f keypairs/${COMMENT}.pub ]]; then
		ssh-keygen -t $TYPE -b $SIZE -C $COMMENT -f keypairs/${COMMENT} -N ""
		mv keypairs/${COMMENT} keypairs/${COMMENT}.pem
		echo "{\"changed\":true}"
	elif [[ ! -f keypairs/${COMMENT}.pem || ! -f keypairs/${COMMENT}.pub ]]; then
		echo "{\"failed\":\"True\",\"msg\":\"A public or private key exists but it's counterpart is missing\"}"
	else
		echo "{\"changed\":false}"
	fi
else
	echo "{\"failed\":\"True\",\"msg\":\"Must Provide a Keyname\"}"
fi
