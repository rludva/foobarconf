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
cp $CFG_FILE /tmp/origin
bar_value=$Bar

#
rm $CFG_FILE

if [ ! "$bar_value" = "$EXPECTED_BAR_VALUE" ]; then
  echo
  echo "${RED}${BOLD}Failing Test:${RESET} [$(basename ${BASH_SOURCE[0]})] - $TEST_DESCRIPTION"
  echo "- readConfig(\`$TEST_CASE_DATA\`): Bar=\`$bar_value\`, Expected: Bar=\`$EXPECTED_BAR_VALUE\`"

  IncFailingCounter
  return 1
fi

IncPassingCounter
return 0
}

#
#
#

TEST_DESCRIPTION="Test that string is stored in Bar value correctly."
EXPECTED_BAR_VALUE="Lorem ipsum dolor si amet."
TEST_CASE_DATA="Bar=Lorem ipsum dolor si amet."
processTestCase

TEST_DESCRIPTION="Test that latest value is stored in the Bar value"
EXPECTED_BAR_VALUE="Amen dis barius."
TEST_CASE_DATA="Bar=Lorem ipsum dolor si amet.\nBar=Amen dis barius."
processTestCase

TEST_DESCRIPTION="Spaces before string are removed."
EXPECTED_BAR_VALUE="string value"
TEST_CASE_DATA="Bar=  string value"
processTestCase

TEST_DESCRIPTION="Spaces after string are removed."
EXPECTED_BAR_VALUE="string value"
TEST_CASE_DATA="Bar=string value   "
processTestCase

TEST_DESCRIPTION="Spaces before and after string are removed."
EXPECTED_BAR_VALUE="string value"
TEST_CASE_DATA="Bar=  string value   "
processTestCase

TEST_DESCRIPTION="Tab before string is removed."
EXPECTED_BAR_VALUE="string value"
TEST_CASE_DATA="Bar=\tstring value"
processTestCase

TEST_DESCRIPTION="Tab after string is removed."
EXPECTED_BAR_VALUE="string value"
TEST_CASE_DATA="Bar=string value\t"
processTestCase

TEST_DESCRIPTION="Tab is not removed when string is in double-quotes."
EXPECTED_BAR_VALUE="\"	string value\""
TEST_CASE_DATA="Bar=\"\tstring value\""
processTestCase
#
# Failing! Need to correct and decide if test is wrong or application is wrong..
# Probably the 
#