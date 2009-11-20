#!/bin/sh

echo "Executing clean and replacement"
mvn clean test

echo ""
echo "Checking contents"
for f in target/classes/*.txt; do
	if [ `grep -c value $f` = "1" ]; then
		echo "$f okay"
	else
		echo "$f failed"
		exit 1
	fi
done

if [ `grep -c token target/simple-outputfile-remove.txt` = "0" ]; then
	echo "target/simple-outputfile-remove.txt okay"
else
	echo "target/simple-outputfile-remove.txt failed"
	exit 1
fi

echo ""
echo "Replacer plugin is okay."