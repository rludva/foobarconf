#!/bin/bash

#
# In this scenraio we test the result app: `foobar_foo_gte_10` not only the function where its logic is defined.
#

if [ ! -v MY_PATH ]; then
  echo "This test function is not expected to be executed separately.."
  echo
  exit 1
fi

function processTestCase() {

# Need to source the dependencies because we need the default value of CFG_FILE name..
source $MY_PATH/src/foobar.sh  

# Create temporary configuration file..
MY_CFG_FILE=$(mktemp)
echo "$TEST_CASE_DATA" > $MY_CFG_FILE

# If origin configuration file exists, make o copy of it..
if [ -e "$CFG_FILE" ]; then
  ORIGIN_CFG_FILE_BACKUP_NAME=$(mktemp)
  cp "$CFG_FILE" "$ORIGIN_CFG_FILE_BACKUP_NAME"
fi  

# Copy my configuration file to the origin configoration file..
cp "$MY_CFG_FILE" "$CFG_FILE"

# We do not need the temporary config file where is the currect test case configuration..
rm "$MY_CFG_FILE"

#
# Process the application
#
$MY_PATH/foobar_foo_gte_10
result=$?

# Remove the configuration file and if origin configuration file was there, then restore its content..
rm "$CFG_FILE"
if [ ! -z "$ORIGIN_CFG_FILE_BACKUP_NAME" ]; then
  cp "$ORIGIN_CFG_FILE_BACKUP_NAME" "$CFG_FILE"
fi

if [ ! $result -eq $EXPECTED_RESULT ]; then
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

# 
# Warning: These test cases are the same as in the tests_01_return_value.sh
#          That is not let's say clean, but we need to test the app as unit.
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
