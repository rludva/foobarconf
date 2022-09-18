# foobarconf
Homework for FooBar Configuration..

## TODO
- Creating temporary file for the configuration? 
  Maybe correct and accepted but also may not. Probably should be tested in the origin configuration file..
  => That is done in the tests_00_foobar_foo_gte_10.sh


## Problems to solve or think about
- How to add array to array TEST_CASE(NAME, DESCRIPTION, EXPECTED_RESULT) => TEST_CASES[] it is always added to the end and not added as a next filed.
(a, b, c) 
(c, d, f)
=> (a, b, c, c, d, f) instead of [0](a, b, c) , [1](c, d, f)

- How to add the '\n' character to a string? The raw 0x0a value is not '\n'
  => OK it is important to use `echo -e "first-line\nsecond-line"`. The `-e` is the hint.

- How to add <tab> to a string when '\t' is interpreted like two characters?
  Do I really have to use echo again?
  => yes

- Checking if the integer is integer: a) vs b)
  a)  [[ "$value" != ?(-)+([[:digit:]]) ]]
  b)  [ "$integer" -eq "$integer" ]

- Redirect the output of app functions to `/dev/null` during processing tests?
  (yes/no)

- !!! The tests in tests folder are not expected to be executed separately, that should be fixed! !!!

- This in test_03_bar is failing and needs more investigation!
```
TEST_DESCRIPTION="Tab is not removed when string is in double-quotes."
EXPECTED_BAR_VALUE="\"	string value\""
TEST_CASE_DATA="Bar=\"\tstring value\""
processTestCase
#
# Failing! Need to correct and decide if test is wrong or application is wrong..
#
# Looks like there are two types of <tab> characters:
#  a) 0x09      "	" - as a result of echo "	" (<tab>)
#  b) 0x2a 0x0a "	" - as a result of echo -e "\t"
#
# Check with: echo -e ' \t ' | hexdump -C
```