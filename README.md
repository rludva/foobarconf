# foobarconf
Homework for FooBar Configuration..

## TODO
- 

## Problems to solve or think about
- How to add array to array TEST_CASE(NAME, DESCRIPTION, EXPECTED_RESULT) => TEST_CASES[] it is always added to the end and not added as a next filed.
(a, b, c) 
(c, d, f)
=> (a, b, c, c, d, f) instead of [0](a, b, c) , [1](c, d, f)

- How to add \n character to string the raw 0x0a value not '\n'
  => OK it is important to use `echo -e "first-line\nsecond-line"`. The `-e` is the hint.

- How to add <tab> to a string when \t is interpreted like two characters?
  Do I really have to use echo?

- Checking  the integer is integer: a) vs b)
  a)  [[ "$value" != ?(-)+([[:digit:]]) ]]
  b)  [ "$integer" -eq "$integer" ]