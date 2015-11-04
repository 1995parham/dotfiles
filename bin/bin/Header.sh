#!/bin/bash

while [ "$#" -ge "1" ]; do
	mv $1 $1.bak
	vim $1 -c "wq"
	cat $1 $1.bak > $1.new
	mv $1.new $1
	shift
done
