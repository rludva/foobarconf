#!/bin/bash

#
# In this scenario we are testing only the value of FooBar from the configuration file.
#

function processTestCase() {

# This should work also as "init" to clean all local variables..
source $MY_PATH/src/foobarconf.sh

#
CFG_FILE=$(mktemp)
echo -e "$TEST_CASE_DATA" > $CFG_FILE

#
readConfig
foobar_value=$FooBar

#
rm $CFG_FILE

if ([ -z $foobar_value ] && [ ! -z $EXPECTED_FOOBAR_VALUE ]) \
   || [ ! $foobar_value -eq $EXPECTED_FOOBAR_VALUE ]; then
  echo
  echo "${RED}${BOLD}Failing Test:${RESET} [$(basename ${BASH_SOURCE[0]})] - $TEST_DESCRIPTION"
  echo "- readConfig(\`$TEST_CASE_DATA\`): FooBar=$foobar_value, Expected: FooBar=$EXPECTED_FOOBAR_VALUE"

  IncFailingCounter
  return 1
fi

IncPassingCounter
return 0
}


TEST_DESCRIPTION="Spaces before the equation are trimmed and set correctly the value"
EXPECTED_FOOBAR_VALUE=123
TEST_CASE_DATA="  FooBar=123"
processTestCase

TEST_DESCRIPTION="Spaces after the equation are not influencing the value"
EXPECTED_FOOBAR_VALUE=123
TEST_CASE_DATA="FooBar=123  "
processTestCase

TEST_DESCRIPTION="Spaces before and after the equation do not influenc the value"
EXPECTED_FOOBAR_VALUE=123
TEST_CASE_DATA="  FooBar=123  "
processTestCase

#
# This test is breaking the testing procedure!
#
TEST_DESCRIPTION="Incorrect integer value with spaces should not be processed."
EXPECTED_FOOBAR_VALUE=
TEST_CASE_DATA="FooBar=1 500"
processTestCase
return

TEST_DESCRIPTION="New line does not have any effect for the result"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar=1500 \n"
processTestCase

TEST_DESCRIPTION="The last defined value is the one that is used."
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar=1500 \nFoo=123"
processTestCase

TEST_DESCRIPTION="The space on the lef of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar =1500"
processTestCase

TEST_DESCRIPTION="The spaces on the lef of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar   =1500"
processTestCase

TEST_DESCRIPTION="The tab one the lef of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar\t=1500"
processTestCase

TEST_DESCRIPTION="The tabs one the lef of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar\t\t=1500"
processTestCase

TEST_DESCRIPTION="The spaces or tabs one the lef of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar  \t \t \t\t  =1500"
processTestCase

TEST_DESCRIPTION="The tab on the right of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar=\t1500"
processTestCase

TEST_DESCRIPTION="The tabs on the right of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar=\t\t\t\t1500"
processTestCase

TEST_DESCRIPTION="The space one the right of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar= 1500"
processTestCase

TEST_DESCRIPTION="The spaces one the right of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar=    1500"
processTestCase

TEST_DESCRIPTION="The spaces or tabs one the right of the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar=\t  \t\t\t  \t1500"
processTestCase

TEST_DESCRIPTION="The spaces or tabs arround the '=' are removed"
EXPECTED_FOOBAR_VALUE=1500
TEST_CASE_DATA="FooBar  \t\t \t=\t   \t\t1500"
processTestCase

TEST_DESCRIPTION="The new line does not mean that the value farther"
EXPECTED_FOOBAR_VALUE=
TEST_CASE_DATA="FooBar   = \n  1500"
processTestCase

TEST_DESCRIPTION="Max integer 2^15 is processed correctly 32768"
EXPECTED_FOOBAR_VALUE=32768
TEST_CASE_DATA="FooBar=32768"
processTestCase

TEST_DESCRIPTION="Max unsigned int, 2^16 is processed correctly 65535"
EXPECTED_FOOBAR_VALUE=65535
TEST_CASE_DATA="FooBar=65535"
processTestCase

TEST_DESCRIPTION="The 2^32 is processed correctly 4294967296"
EXPECTED_FOOBAR_VALUE=4294967296
TEST_CASE_DATA="FooBar=4294967296"
processTestCase

TEST_DESCRIPTION="The value o 2^64 is parsed correctly"
EXPECTED_FOOBAR_VALUE=18446744073709551616
TEST_CASE_DATA="FooBar=18446744073709551616"
processTestCase

TEST_DESCRIPTION="The negative number is parsed correctly"
EXPECTED_FOOBAR_VALUE=-123
TEST_CASE_DATA="FooBar=-123"
processTestCase

TEST_DESCRIPTION="The negative number and space is not valid number"
EXPECTED_FOOBAR_VALUE=
TEST_CASE_DATA="FooBar=- 123"
processTestCase

TEST_DESCRIPTION="Explicitly positive number should be parsed correctly"
EXPECTED_FOOBAR_VALUE=123
TEST_CASE_DATA="FooBar=+123"
processTestCase

TEST_DESCRIPTION="Float number should be parsed correctly"
EXPECTED_FOOBAR_VALUE=12.3
TEST_CASE_DATA="FooBar=12.3"
processTestCase

