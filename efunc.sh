#!/bin/bash


counter=0;

while read func;
do
	printf -v c "%03d" $counter
	file="scripts/${c}-${func}.sh"

	# output header
	#cat efunc.head >> ${file}
	sed -n "/^${func}\(\)/,/^}/p" shell.func.sh | sed '1,1d' - | sed '$d' - | sed 's/^\s*local\s*/    /' >> ${file}
	((counter++))
done < shell.func
