# Testing - Using Bash to Test C

This is going to be quite a long lab- you may find it useful to split it over 2 sessions, reading up to and completing **task 1**, then coming back to do **task 2** after you've let it all sink in!

In this lab, I'm going to walk you through creating a set of tests using Bash, showing how to test expected outputs from a program with a command line input, as well as a basic menu system to see how you test user inputs.

I will also talk (or read, I suppose!) you through how I personally plan tests before I write code to help you to be able to start the assignment.

After this lab, you should be able to complete the first part of the assignment- creating a test script and test data.

## A Note on Bash

As I've said, you do not need to write your script in bash if you are confident in learning another testing library in your own time, and with no expectation of my or TAs' support. If you choose to work with a testing library such as CUnit or Unity (the 2 I recommend as both are well documented online, just be aware that Unity is also the name of a popular game engine so your google results may be unhelpful at times), you need to keep in mind that I won't necessarily be able to help.

In this lab, you don't have my sourcecode or function names, so you won't be able to use a unit testing library. You could instead go back and write a set of unit tests for your COMP1711 assignment, as this is a relatively similar task.

You should still read up to Task 1 and complete that, as it will help you understand how to plan your tests.

## The Brief

In this lab, we'll be creating some tests for a program for which you do not have the code. This emulates real life, as you should always be writing the tests before you write the code. You won't be writing the code for this program (I have provided an executable for you to play with, source code will be provided at the end of the week if you want some debugging practice!).


>Testing Top Tip 1: 
>Never write tests to fit a specific piece of code- write the tests to fit the **specification**, then write the code to pass the tests.

## Program Specification: Student Data Handling Script

### 1. Overview

The `studentData` script is designed to handle student data stored in a CSV file. The program takes the path to a CSV file as a command-line argument upon execution, reads and validates the data, and provides the user with four options for data manipulation.

### 2. Functional Requirements

#### 2.1 Command-Line Argument

- The program should accept a CSV file path as a command-line argument upon execution.
- The program should ensure that there is data present in each cell
- The program should ensure that the student ID and the grade are numerical data
- The program should ensure that all grades are between 0 and 100 inclusive.

#### 2.2 Menu System

- Present a menu to the user with the following options:
  1. Display the entire dataset
  2. Search by student ID and display the corresponding data
  3. Calculate the average grade
  4. Display the number of records in the file

#### 2.3 User Input

- Accept user inputs for selecting menu options and providing additional parameters when required.

#### 2.4 Functionality

- **Option 1: Display the entire dataset**
  - Display the complete student dataset with columns: `StudentID`, `Surname`, `Firstname`, `Grade`.

- **Option 2: Search by student ID**
  - Prompt the user to enter a student ID.
  - Display the data corresponding to the entered student ID.

- **Option 3: Calculate the average grade**
  - Calculate and display the average grade based on the `Grade` column of all students in the dataset.

- **Option 4: Display the number of records**
  - Display the total number of records (rows) in the CSV file.

### 3. Example Usage

```bash
./studentData data.csv
``````

### 4. Example Output

```
File data.csv successfully loaded.

Menu Options:
1. Display the entire dataset
2. Search by student ID
3. Display the average grade
4. Display the number of records

Please choose an option (1-4): 1

Student ID   Surname   Firstname   Grade
00291   Jones   Lucy   59
10223   McLeod   James   37
13012   Huang   Wei   82
01293   Singh   Gurtek   63

Menu Options:
1. Display the entire dataset
2. Search by student ID
3. Display the average grade
4. Display the number of records

Please choose an option (1-4): 2

Enter the student ID: 10223

ID: 10223
Surname: McLeod
Firstname: James
Grade: 37

Menu Options:
1. Display the entire dataset
2. Search by student ID
3. Display the average grade
4. Display the number of records

Please choose an option (1-4): 3

Average grade: 60.25

Menu Options:
1. Display the entire dataset
2. Search by student ID
3. Display the average grade
4. Display the number of records

Please choose an option (1-4): 4

Number of records: 4


[ I have shown all 4 options here, but the program **does not loop** ]

```

### 5. Error Outputs

If errors occur in the program, the following error messages will be displayed:

1. Invalid command line arguments: `Usage: studentData <filename>`
2. File not found: `Error: Bad filename`
3. Invalid csv data: `Error: CSV file does not have expected format`
4. Bad menu choice: `Error: Invalid menu choice` (program should repeat to allow correct menu options to be shown)
5. Student ID not found: `Error: Could not find student`

## So now what?

You have an in-depth specification for this code, so you can start thinking about tests. The best way to do this is to open a notepad (or a new markdown file) on one half of the screen, and the specification on the other.

Read through the specification and consider all the places where things could go wrong- where is the user entering data, and where are decisions being made. These are the **dangerzones** - places where errors are the most likely to happen!

Users enter incorrect data- it could be a misspelled filename, or it could be data in the wrong format.

Decisions tend to be where **developers** make mistakes - we have all, at some point, written AND instead of OR, or forgotten a NOT, or done some other small mistake which makes the whole program go wrong!

While you read the spec, you should try and pick out places where you will write tests - be specific, and if possible, give an example of the data you will use to test it.

Work from top to bottom, in the same order as the program will run. We want our programs to always fail **gracefully** which means that they fail at the earliest possible point, not wasting the processor or the user's time!

Here is part of my test plan for an assignment from last year's course, just showing the kind of notes I make:

```
# arguments
- check for bad arg count (1)
- bad argc (4)

# input & output file handling
- check for bad filename
- check for bad permissions

# magic number
- check 2 chars
- check 'PQ'
- check 'B2'

# dims
- presence check
- check -1 10
- check 0 0
- check 10 10000000
- check 10000000 10000000
```

You can see the level of granularity I like to use - I break it down per part of the program, and I split this up into separate cases I will test. These cases are designed to cover a range of potential errors without being excessive.

In the program I was testing above, `dims` are entered by the user - I will break down that section below to explain my thought process and why I chose those tests:

### Dims - breakdown

First of all, I want to make sure there are 2 numbers (presence check). There's no point doing any further checks if this fails.

Then I need to do some range checks - I want to ensure that my program rejects dimensions which are too small (<1) and too large (>1028). I have 2 separate dimensions **but** I also am thinking ahead- I will definitely be writing a function to check these (I need the code at least twice). Therefore, I know I don't need to check -1, 10 AND 10, -1 because I would be checking the same function for the same outcome twice. Instead, I cover four possible cases- one dimension is too small, both dimensions are too small, one dimension is too large, both dimensions are too large.

This gives me complete coverage, and is also checking the `if` statement which I will write to reject any bad dimensions.

I have chosen a particularly large number for my 'too large' tests because I want to be absolutely certain it fails on huge numbers, as these will cause errors later when I need to allocate memory.

>Testing Top Tip 2: 
>Coverage is very important, but you don't want to write 100 tests for a 20 line program. Be intentional with the data you use to test your program - use it to test your own programming as well as your users' ability to correctly input data. If there are things you **need** your code to fail on (for example the too-large dimensions above), then make sure you test those!

I have left out 'success' tests from my plan, because I usually add this last - but you should always test that your code actually works too!

# Task 1

Using the method above, make yourself a test plan based on the specification for the studentData program. You should end up with around 10-15 tests.

This is my suggested break point - once you have a test plan, you can stop here and continue later if you need to take a break :)

## Writing Test Scrips

Bash is a nice, simple language which gives us a reasonable amount of power in the terminal. We will be writing scripts, which are just multiple bash commands in a single file. To do this, you use the file extension `.sh`.

We also have to do a little bit of setup:
- Add the line `#!/bin/bash` as the first line
- Give yourself permission to run the file using chmod: `chmod +x <name of your .sh file>`

I have provided a very basic script which has 1 test and the hashbang added, so you will need to give youself execution permissions:

```
chmod +x test.sh
```

**Depending on Github, you might need to use chmod to let you run the executable studentData too - just replace test.sh with studentData**

To run the script, you can now use:
```bash
./test.sh
```

I have also commented this extensively, so you might find it useful to read.

I will break down the process of a test here as well.

### Step 1 - Run the executable

This is probably the more complicated bit, as you have 4 'moving parts'
- The name of the executable
- The arguments you are using
- The user inputs
- The output

We will be redirecting both the input and the output so that we can make the program think a user is entering some data, and we can see the printfs and check that the program did the right thing.

```./studentData data1.csv < inputs/example.txt > tmp```

In the example above:
- we are running `studentData` with `data1.csv` as our command line argument
- we are telling it to treat the data inside `inputs/example.txt` as the user input
- we are telling it to store prints in `tmp`

The user input files are pretty simple - just create a text file which has the inputs you want your 'user' to enter, for example:
```
2
13012
```
Would work for testing searching for a specific student.

Then the prints will be stored into 'tmp' - this is just a random filename, I usually use 'tmp' or 'out'.

### Step 2 - Did it pass?

Now you have the program's outputs stored in 'tmp', so we can decide whether the program worked right.

To do this, we'll use `grep` which you hopefully remember from procedural programming. It means 'search for'.

We are combining this with an if statement- these should be self-explanatory as they are basically the same as every other programming language:

```
echo -n "Testing no arguments - "
if grep -q "Usage: studentData <filename>" tmp;
then
    echo "PASS"
else
    echo "FAIL"
fi
```

We can translate this as:
- if you find 'Usage: studentData <filename>' in the file tmp
- then print PASS
- otherwise print FAIL

The key difference in Bash is that we close our if with 'fi'.

This is a full test - just make sure that you include sensible print statements so you can identify what tests pass and which fail

I have added some errors to the code, so some will fail! Your job is to find them and work out what is making them fail - don't edit the test script to make everything 'pass' - write down what the error is, what was expected and what the program got.

To help with this, you might also want to run the code manually with the same data and work out why it's different.

## Important note

I have provided you with 1 **(one)** data file. This is terrible testing - you should make yourself some extra ones! Think about what might go wrong, the errors which could be in a file, etc. Think about all the issues you had when you used my marking script for your coursework last semester- if you write your code to work for one file, it might not work for other files..

Also make some which are correct but have different data in them - after all, testing with one file proves that your code works with **that one file**, not that it will work with everything.

>Testing Top Tip 3: 
>Producing test data is a job which chatGPT is really good at- if you copy and paste in 'data1.csv' and ask it to make you some more data files in the same format, it will do so with as many lines as you want/need.

## 2nd Important Note

When you're writing your greps, you need an expected output. I hope the reason for this is obvious you should **calculate and write these yourself** and not use the executable to write them for you.

If the reason isn't obvious - yes, if you get the code to output something and then copy and paste it and write a test script to compare it to the code's ouput, then it will match. But is that what it should **actually** be outputting, and did it do it correctly? Use the specification to write the test, not the output of the code.

# Task 2 - Test Script

Write your test script, based on your plan, and find the errors with my program. There are several - some are more obvious and easy to find than others.

A full test script (and the sourcecode for you to debug) will be released next week.

## Optional - Improving your script

This section is all **optional**, but should be quick to implement if you want some easy ways to make test scripts more useful for you.

Once you have more than about 10 tests, it becomes slightly more difficult to see which tests passed and which failed. It's sometimes useful to get a bit more information, and we can do that in a couple of simple ways.

### Using Colour - ANSI Codes

We can use ANSI escape codes to change font colours in the terminal. These are series of characters which can be used to change the appearence of text in the terminal- they can change text and background colours, animate text, and move the cursor.

There are lists online for these- you don't need to remember them (I certainly don't!).

```bash
echo -e "\e[32mPASS\e[0m"

echo -e "\e[31mFAIL\e[0m"
```

You can copy and paste these into the terminal to see the result- these change the colours of PASS and FAIL to red and green respectively. I am using these out of convention, but red/green colourblindness is very common so you might want to choose other colours to make test scripts more accessible.

Here's a table with other common colours:
| Color   | ANSI Code  | Example                         |
|---------|------------|---------------------------------|
| Black   | `\e[30m`    | `echo -e "\e[30mText\e[0m"`      |
| Red     | `\e[31m`    | `echo -e "\e[31mText\e[0m"`      |
| Green   | `\e[32m`    | `echo -e "\e[32mText\e[0m"`      |
| Yellow  | `\e[33m`    | `echo -e "\e[33mText\e[0m"`      |
| Blue    | `\e[34m`    | `echo -e "\e[34mText\e[0m"`      |
| Magenta | `\e[35m`    | `echo -e "\e[35mText\e[0m"`      |
| Cyan    | `\e[36m`    | `echo -e "\e[36mText\e[0m"`      |
| White   | `\e[37m`    | `echo -e "\e[37mText\e[0m"`      |

We always finish with `\e[0m]` - this resets the colour to default. We also need to use the `-e` flag to tell Bash to interpret `\` as an escape character.

**Bonus Tip**

Use find and replace (ctrl+f, click the little arrow) to replace echo "PASS"/echo "FAIL" and you can do this to your whole script in seconds.

### Adding Some Maths

Another thing you might want to add is calculating your percentage of tests passed.

First of all, you'll need to make a couple of counters at the top of your test script:

```bash
all_counter=0
pass_counter=0
```

We'll use these to count the number of tests we run, and the number of tests which pass.
```bash
((all_counter++))
if grep ... ;
then
    echo "PASS"
    ((pass_counter++))
else
    echo "FAIL"
fi
```

We increment the all_counter before every test, and we only increment the pass_counter if we pass.

Then you can print these at the end:

```bash
echo "Total tests: $all_counter"
echo "Passed tests: $pass_counter"
echo "Percentage passed: $(echo "scale=2; $pass_counter*100 / $all_counter" | bc)%"
```

This is a bit more complicated because I want a floating point answer- which Bash can't do on its own. So we take the division and pipe it into 'bc' to get the right answer, and scale=2 gives the answer to 2 decimal places.

You could even use the ANSI colour codes with an if statement to change the colour you print this!