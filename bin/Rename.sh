#!/bin/bash
a=1
for i in *.jpg; do
	new=$(printf "%d.jpg" ${a})
	mv "${i}" "${new}"
  	let a=a+1
done
for i in *.JPG; do
	new=$(printf "%d.jpg" ${a})
	mv "${i}" "${new}"
	let a=a+1
done
