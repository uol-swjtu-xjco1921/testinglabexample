#!/bin/bash

# remove read permissions from this file - note: put them back at the end!
chmod -r data/bad_perms.csv

echo -e "~~ Argument Tests ~~"

echo -n "Testing no arguments - "
./studentData > tmp
if grep -q "Usage: studentData <filename>" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing 2 arguments - "
./studentData x x > tmp
if grep -q "Usage: studentData <filename>" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi



echo -e "\n~~ File Handling~~"

echo -n "Testing bad filename - "
./studentData fake.csv > tmp
if grep -q "Error: Bad filename" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing bad permissions - "
timeout 0.2s ./studentData data/bad_perms.csv > tmp
if grep -q "Error: Bad filename" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing bad data (missing) - "
timeout 0.2s ./studentData data/bad_data_missing.csv > tmp
if grep -q "Error: CSV file does not have expected format" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing bad data (too low) - "
timeout 0.2s ./studentData data/bad_data_neg.csv > tmp
if grep -q "Error: CSV file does not have expected format" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing bad data (too high) - "
timeout 0.2s ./studentData data/bad_data_high.csv > tmp
if grep -q "Error: CSV file does not have expected format" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing file loads successfully - "
echo "1" | ./studentData data/original.csv > tmp
if grep -q "File data/original.csv successfully loaded." tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -e "\n~~ Bad user inputs ~~"

echo -n "Testing bad menu input (wrong) - "
echo "a" | timeout 0.2s ./studentData data/original.csv > tmp
if grep -q "Error: Invalid menu choice" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing bad menu input (empty) - "
echo "" | timeout 0.2s ./studentData data/original.csv > tmp
if grep -q "Error: Invalid menu choice" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing bad student ID - "
timeout 0.2s ./studentData data/original.csv < inputs/bad_sid.in > tmp
if grep -q "Error: Could not find student" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi


echo -e "\n~~ Success ~~"

echo -n "Testing option 1 - "
echo "1" | timeout 0.2s ./studentData data/good_1_85.csv > tmp
if grep -q "00291   Smith   John   85" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing option 2 (good SID) - "
timeout 0.2s ./studentData data/good_10_80.40.csv < inputs/good_sid.in > tmp
if grep -q "Surname: Moore" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing option 3 - "
echo "3" | timeout 0.2s ./studentData data/good_10_80.40.csv > tmp
if grep -q "Average grade: 80.40" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

## this is a special case we usually add when there is a potential of having
# a data file with no records - because the developer needs to handle
# averages gracefully..
echo -n "Testing option 3 (no data) - "
echo "3" | timeout 0.2s ./studentData data/good_empty.csv > tmp
if grep -q "Average grade: 0" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

echo -n "Testing option 4 - "
echo "3" | timeout 0.2s ./studentData data/good_10_80.40.csv > tmp
if grep -q "Number of records: 10" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi

# adding read perms back on to this for git.
chmod +r data/bad_perms.csv
# I always tidy up and remove the tmp file at the end.
rm -f tmp