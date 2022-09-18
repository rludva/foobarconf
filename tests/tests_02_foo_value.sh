#!/bin/bash

#
# In this scenaria we are testing only the value of Foo from the configuration file.
#

function processTestCase() {

# This should work also as "init" to clean all local variables..
source $MY_PATH/src/foobarconf.sh

#
CFG_FILE=$(mktemp)
echo -e "$TEST_CASE_DATA" > $CFG_FILE

#
readConfig
foo_value=$Foo

#
rm $CFG_FILE

if ([ -z "$foo_value" ] && [ ! -z "$EXPECTED_FOO_VALUE" ] ) || [ ! "$foo_value" -eq "$EXPECTED_FOO_VALUE" ] 2> /dev/null; then
  echo
  echo "${RED}${BOLD}Failing Test:${RESET} [$(basename ${BASH_SOURCE[0]})] - $TEST_DESCRIPTION"
  echo "- readConfig(\`$TEST_CASE_DATA\`): Foo=$foo_value, Expected: Foo=$EXPECTED_FOO_VALUE"

  IncFailingCounter
  return 1
fi

IncPassingCounter
return 0
}

TEST_DESCRIPTION="Spaces before the equation are trimmed and set correctly the value"
EXPECTED_FOO_VALUE=123
TEST_CASE_DATA="  Foo=123"
processTestCase

TEST_DESCRIPTION="Spaces after the equation are not influencing the value"
EXPECTED_FOO_VALUE=123
TEST_CASE_DATA="Foo=123  "
processTestCase

TEST_DESCRIPTION="Spaces before and after the equation do not influenc the value"
EXPECTED_FOO_VALUE=123
TEST_CASE_DATA="  Foo=123  "
processTestCase

TEST_DESCRIPTION="Incorrect integer value with spaces should not be processed."
EXPECTED_FOO_VALUE=
TEST_CASE_DATA="Foo=1 500"
processTestCase

TEST_DESCRIPTION="New line does not have any effect for the result"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo=1500 \n"
processTestCase

TEST_DESCRIPTION="The last defined value is the one that is used."
EXPECTED_FOO_VALUE=123
TEST_CASE_DATA="Foo=1500 \nFoo=123"
processTestCase

TEST_DESCRIPTION="The space on the lef of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo =1500"
processTestCase

TEST_DESCRIPTION="The spaces on the lef of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo   =1500"
processTestCase

TEST_DESCRIPTION="The tab one the lef of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo\t=1500"
processTestCase

TEST_DESCRIPTION="The tabs one the lef of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo\t\t=1500"
processTestCase

TEST_DESCRIPTION="The spaces or tabs one the lef of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo  \t \t \t\t  =1500"
processTestCase

TEST_DESCRIPTION="The tab on the right of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo=\t1500"
processTestCase

TEST_DESCRIPTION="The tabs on the right of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo=\t\t\t\t1500"
processTestCase

TEST_DESCRIPTION="The space one the right of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo= 1500"
processTestCase

TEST_DESCRIPTION="The spaces one the right of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo=    1500"
processTestCase

TEST_DESCRIPTION="The spaces or tabs one the right of the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo=\t  \t\t\t  \t1500"
processTestCase

TEST_DESCRIPTION="The spaces or tabs arround the '=' are removed"
EXPECTED_FOO_VALUE=1500
TEST_CASE_DATA="Foo  \t\t \t=\t   \t\t1500"
processTestCase

TEST_DESCRIPTION="The new line does not mean that the value farther"
EXPECTED_FOO_VALUE=
TEST_CASE_DATA="Foo   = \n  1500"
processTestCase

TEST_DESCRIPTION="Max integer 2^15 is processed correctly 32768"
EXPECTED_FOO_VALUE=32768
TEST_CASE_DATA="Foo=32768"
processTestCase

TEST_DESCRIPTION="Max unsigned int, 2^16 is processed correctly 65535"
EXPECTED_FOO_VALUE=65535
TEST_CASE_DATA="Foo=65535"
processTestCase

TEST_DESCRIPTION="The 2^32 is processed correctly 4294967296"
EXPECTED_FOO_VALUE=4294967296
TEST_CASE_DATA="Foo=4294967296"
processTestCase

TEST_DESCRIPTION="The value of 2^64 is parsed correctly"
EXPECTED_FOO_VALUE=18446744073709551616
TEST_CASE_DATA="Foo=18446744073709551616"
processTestCase

TEST_DESCRIPTION="The negative number is parsed correctly"
EXPECTED_FOO_VALUE=-123
TEST_CASE_DATA="Foo=-123"
processTestCase

TEST_DESCRIPTION="The negative number and space is not valid number"
EXPECTED_FOO_VALUE=
TEST_CASE_DATA="Foo=- 123"
processTestCase

TEST_DESCRIPTION="Explicitly positive number should be parsed correctly"
EXPECTED_FOO_VALUE=123
TEST_CASE_DATA="Foo=+123"
processTestCase

TEST_DESCRIPTION="Float number should be parsed correctly"
EXPECTED_FOO_VALUE=12.3
TEST_CASE_DATA="Foo=12.3"
processTestCase
#
# Here it is not clear from the task description if read nothing or cut the number
# What is expected?
# a) 12.3 => NULL empty value 
# b) 12.3 => 12 (only decimal part)
#

