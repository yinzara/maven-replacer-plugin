#!/bin/sh

echo "Executing clean and replacement"
mvn clean test

echo ""
echo "Checking contents"
for f in target/classes/*.txt; do
	if [ `grep -c value $f` -ge "1" ]; then
		echo "$f value okay"
	else
		echo "$f failed"
		exit 1
	fi
	
	if [ `grep -c token $f` = "0" ]; then
		echo "$f no longer contains tokens"
	else
		echo "$f failed"
		exit 1
	fi
done

for f in target/classes/nesteddir/*.txt; do
	if [ `grep -c value $f` -ge "1" ]; then
		echo "$f value okay"
	else
		echo "$f failed"
		exit 1
	fi
	
	if [ `grep -c token $f` = "0" ]; then
		echo "$f no longer contains tokens"
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

if [ `grep -c token target/multiple-tokens-for-map-outputfile.txt` = "0" ]; then
	echo "target/multiple-tokens-for-map-outputfile.txt no longer contains tokens"
else
	echo "target/multiple-tokens-for-map-outputfile.txt failed"
	exit 1
fi

if [ `grep -c value1 target/multiple-tokens-for-map-outputfile.txt` = "1" ]; then
	echo "target/multiple-tokens-for-map-outputfile.txt value1 okay"
else
	echo "target/multiple-tokens-for-map-outputfile.txt failed"
	exit 1
fi

if [ `grep -c value2 target/multiple-tokens-for-map-outputfile.txt` = "1" ]; then
	echo "target/multiple-tokens-for-map-outputfile.txt value2 okay"
else
	echo "target/multiple-tokens-for-map-outputfile.txt failed"
	exit 1
fi

#new directory creation stopped was not working, now resolved - Issue 22
if [ `grep -c value target/classes/newdir/simple-outputfile.txt` = "1" ]; then
	echo "target/classes/newdir/simple-outputfile.txt value okay"
else
	echo "target/classes/newdir/simple-outputfile.txt failed"
	exit 1
fi

#log.xml test - Issue 25
if [ `grep -c '<level value="error" />' target/classes/log4j.xml` = "1" ]; then
	if [ `grep -c '<level value="warn" />' target/classes/log4j.xml` = "1" ]; then
		echo "target/classes/log4j.xml failed"
		exit 1
	else
		echo "target/classes/log4j.xml value okay"
	fi
else
	echo "target/classes/log4j.xml failed"
	exit 1
fi

echo ""
echo "Replacer plugin is okay."