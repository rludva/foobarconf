#!/bin/bash

#
# In this scenraio we test only the result of `foobar_foo_gte_10` function.
#

if [ ! -v MY_PATH ]; then
  echo "This test function is not expected to be executed separately.."
  echo
  exit 1
fi

function processTestCase() {

# This should work also as "init" to clean all local variables..
source $MY_PATH/src/foobar.sh

#
CFG_FILE=$(mktemp)
echo "$TEST_CASE_DATA" > $CFG_FILE

#
readConfig
foobar_foo_gte_10
result=$?

#
rm $CFG_FILE

if [ ! $result -eq $EXPECTED_RESULT ] ; then
  echo
  echo "${RED}${BOLD}Failing Test:${RESET} $TEST_DESCRIPTION"
  echo "- foobar_foo_gte_10 with \`$TEST_CASE_DATA\`: $result, Expected: $EXPECTED_RESULT"

  IncFailingCounter
  return 1
fi

IncPassingCounter
return 0
}


#
# EXPECTED_RESULT
# 0 is (true) all is OK
# 1 is (false) error
#

TEST_DESCRIPTION="Check that regular value without any special circumstances is passing"
EXPECTED_RESULT=0
TEST_CASE_DATA="Foo=994"
processTestCase

TEST_DESCRIPTION="Check that regular value: 11 is passing"
EXPECTED_RESULT=0
TEST_CASE_DATA="Foo=11"
processTestCase

TEST_DESCRIPTION="Check that regular value: 10 is passing"
EXPECTED_RESULT=0
TEST_CASE_DATA="Foo=10"
processTestCase

TEST_DESCRIPTION="Check that regular value:9 <10 is failing"
EXPECTED_RESULT=1
TEST_CASE_DATA="Foo=9"
processTestCase

TEST_DESCRIPTION="Check that regular negativ value is out of limit <10 and failing"
EXPECTED_RESULT=1
TEST_CASE_DATA="Foo=-58"
processTestCase

TEST_DESCRIPTION="Check that explicitly positive value is <10 and passing"
EXPECTED_RESULT=0
TEST_CASE_DATA="Foo=+77"
processTestCase

TEST_DESCRIPTION="Check that zero value is out of limit <10 and failing"
EXPECTED_RESULT=1
TEST_CASE_DATA="Foo=0"
processTestCase

TEST_DESCRIPTION="Check that \`negativ\` zero value is out of limit <10 and failing"
EXPECTED_RESULT=1
TEST_CASE_DATA="Foo=-0"
processTestCase

TEST_DESCRIPTION="Check that irregular integer value is failing"
EXPECTED_RESULT=1
TEST_CASE_DATA="Foo=9lorem9"
processTestCase

TEST_DESCRIPTION="The value 2^64 is probably out of range but should pass."
EXPECTED_RESULT=0
TEST_CASE_DATA="Foo=18446744073709551616"
processTestCase

TEST_DESCRIPTION="Float number should fail because it is not integer.."
EXPECTED_RESULT=1
TEST_CASE_DATA="Foo=10.5"
processTestCase
