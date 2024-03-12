# Test plan

Note: doing this in markdown is totally optional- I like being able to just list out tests without having to worry about adding comment #s.

# Args
- no args
- wrong number (2)

# File IO

- bad filename
- bad permissions
- data in wrong format (missing)
- data with negative grade
- data with >100 grade
- success - shows 'loaded' message

# User input errors

- wrong menu option
- empty menu option
- non existant student ID

# Success

- correct display for 1
- correct display for student ID
- correct average grade (normal)
- correct average grade (no data)
- correct number of records

# ERROR MESSAGES:

(I put these somewhere so I can copy and paste them!)

Usage: studentData <filename>
Error: Bad filename
Error: CSV file does not have expected format
Error: Invalid menu choice
Error: Could not find student