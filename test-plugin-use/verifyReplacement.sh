#!/bin/sh

checkForTokens() {
	FILE=$1
	TOKEN=$2
	
	if [ `grep -c $TOKEN $FILE` = "0" ]; then
		echo "$FILE $TOKEN removed"
	else
		echo "$FILE failed"
		exit 1
	fi
	
	if [ $# = 3 ]; then
		VALUE=$3		
		if [ `grep -c $VALUE $FILE` -gt "0" ]; then
			echo "$FILE $VALUE found"
		else
			echo "$FILE $VALUE not found"
			exit 1
		fi
	fi
}

checkFileSizeMatches() {
	LHS=`stat -c %s $1`
	RHS=`stat -c %s $2`

	if [ $LHS != $RHS ]; then
		echo "File sizes don't match between $1 and $2"
		exit 1
	else
		echo "File sizes match between $1 and $2"
	fi
}

echo "Executing clean and replacement"
mvn clean test
if [ $? != 0 ]; then
	echo "Maven command failed"
	exit 1
fi

checkFileSizeMatches src/main/resources/simple.txt target/classes/simple.txt
checkFileSizeMatches src/main/resources/largefile.txt target/classes/largefile.txt
checkFileSizeMatches src/main/resources/regex.txt target/classes/regex.txt

echo ""
echo "Checking contents"

for f in target/classes/*.txt; do
	checkForTokens $f token value
done

checkForTokens target/classes/nesteddir/multiple-files1.txt token value
checkForTokens target/classes/nesteddir/multiple-files2.txt token value
checkForTokens target/simple-outputfile-remove.txt token
checkForTokens target/multiple-tokens-for-map-outputfile.txt token1 value1
checkForTokens target/multiple-tokens-for-map-outputfile.txt token2 value2
checkForTokens target/classes/newdir/simple-outputfile.txt token value
checkForTokens target/classes/special/multiple-tokens-to-replace.txt token1 value1
checkForTokens target/classes/special/multiple-tokens-to-replace.txt token2 value2
checkForTokens target/classes/include2 token value
checkForTokens target/classes/file1 token value
checkForTokens target/classes/file2 token value
checkForTokens target/classes/linematch.txt replace=token replace=value

echo ""
echo "Replacer plugin is okay."
