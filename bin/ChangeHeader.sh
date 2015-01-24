#!/bin/bash

while [ "$#" -ge "1" ]; do
	cp $1 $1.bak
	tail -n +11 $1 > $1.new.1
	rm $1
	vim $1 -c "wq"
	cat $1 $1.new.1 > $1.new.2
	rm $1.new.1
	mv $1.new.2 $1
	shift
done
