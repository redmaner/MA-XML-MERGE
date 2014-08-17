#!/bin/bash
# Copyright (c) 2014, Redmaner

up=$PWD
source $up/merge.cfg

MergeStrings () {
cat > $new_string << EOF
<?xml version='1.0' encoding='UTF-8'?>
<resources>
EOF
cat $orig_string | sed -e '/string name="/!d' | cut -d'"' -f2 | uniq --unique | while read string_name; do
	if [ $(sed -e '/name="'$string_name'"/!d' $targ_string | wc -l) -gt 0 ]; then
		if [ $(sed -e '/name="'$string_name'"/!d' $targ_string | grep '</string>' | wc -l) -gt 0 ]; then
			sed -e '/<string name="'$string_name'"/!d' $targ_string >> $new_string; continue
		else
			sed -e '/<string name="'$string_name'"/,/string>/!d' $targ_string >> $new_string; continue
		fi
	else
		if [ $(sed -e '/name="'$string_name'"/!d' $orig_string | grep '</string>' | wc -l) -gt 0 ]; then
			sed -e '/<string name="'$string_name'"/!d' $orig_string >> $new_string; continue
		else
			sed -e '/<string name="'$string_name'"/,/string>/!d' $orig_string >> $new_string; continue
		fi
	fi
done
echo '</resources>' >> $new_string
$python $up/sort.py $new_string_dir > /dev/null
}

ShowHelp () {
echo -e "\nScript requires three arguments\nFirst argument: path to original strings.xml\nSecond argument: path to target strings.xml\nThird argument: path to new strings.xml"
}

if [ -f "$1" ]; then 
	orig_string=$1	
else
	ShowHelp; exit
fi
if [ -f "$2" ]; then 
	targ_string=$2
else
	ShowHelp; exit
fi
if [ -f "$3" ]; then 
	new_string=$3
	new_string_dir=$(dirname $new_string)
else
	ShowHelp; exit
fi	
