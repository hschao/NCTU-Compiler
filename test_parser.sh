#!/bin/bash

FILE_NAME="test${1:-1}"
TEST_CASE="TestCase/Project5/$FILE_NAME"
./parser $TEST_CASE.p output.j
printf "TEST FILE: $TEST_CASE.p\n\n"

printf 'OUTPUT:\n'
cat output.j
printf '\n\nDIFFERENCE:\n'
colordiff output.j $TEST_CASE.j

printf '\n\nSTART JASMIN:\n'
java -jar TestCase/Project5/jasmin.jar -d ./ output.j
java $FILE_NAME
rm $FILE_NAME.class
rm output.j

