#!/bin/bash

#
# In this scenario we are testing the behavior of comments.
#

if [ ! -v MY_PATH ]; then
  echo "This test function is not expected to be executed separately.."
  echo
  exit 1
fi

function processTestCase() {

# This should work also as "init" to clean all local variables..
source $MY_PATH/src/foobar.sh

# This is a little bit strange but I need to transfer \t to real tabs..
LINE=$(echo -e "$TEST_CASE_DATA")

isComment "$LINE"
RESULT=$?

if [ ! $RESULT -eq $EXPECTED_RESULT ]; then
  echo
  echo "${RED}${BOLD}Failing Test:${RESET} [$(basename ${BASH_SOURCE[0]})] - $TEST_DESCRIPTION"
  echo "- isComment(\`$TEST_CASE_DATA\`): $RESULT, Expected: $EXPECTED_RESULT"

  IncFailingCounter
  return 1
fi

IncPassingCounter
return 0
}


#
# isComment return 0 (true) if string is comment and 1 (false) if is not a comment..
#

TEST_DESCRIPTION="Normal line is not a comment"
EXPECTED_RESULT=1
TEST_CASE_DATA="Lorem ipsum dolor sit amet"
processTestCase

TEST_DESCRIPTION="Normal comment is a comment"
EXPECTED_RESULT=0
TEST_CASE_DATA="# Lorem ipsum dolor sit amet"
processTestCase

TEST_DESCRIPTION="Comment in the line before space is a comment"
EXPECTED_RESULT=0
TEST_CASE_DATA=" # Lorem ipsum dolor sit amet"
processTestCase

TEST_DESCRIPTION="Comment in the line before spaces is a comment"
EXPECTED_RESULT=0
TEST_CASE_DATA="    # Lorem ipsum dolor sit amet"
processTestCase

TEST_DESCRIPTION="Comment in the line before tab is a comment"
EXPECTED_RESULT=0
TEST_CASE_DATA="\t# Lorem ipsum dolor sit amet"
processTestCase

TEST_DESCRIPTION="Comment in the line before tabs is a comment"
EXPECTED_RESULT=0
TEST_CASE_DATA="\t\t\t# Lorem ipsum dolor sit amet"
processTestCase

TEST_DESCRIPTION="Comment in the line before tabs and spaces is a comment"
EXPECTED_RESULT=0
TEST_CASE_DATA="  \t  \t\t # Lorem ipsum dolor sit amet"
processTestCase

TEST_DESCRIPTION="End of line comments are not implemented"
EXPECTED_RESULT=1
TEST_CASE_DATA="Foo=3 # Lorem ipsum dolor sit amet"
processTestCase