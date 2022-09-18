#!/bin/bash

CFG_FILE="/tmp/foobar"

# Variables
Foo=""
Bar=""
FooBar=""

#
WARNINGS=false

function foobar_foo_gte_10() {
  file=$CFG_FILE
  opt="Foo"
  expected_value="10"
  assert_msg="Option '$opt' is greater than or equal to '$expected_value' in '$file'"

  let value="$opt"
  if [ $value -ge $expected_value ]; then
    echo "PASS - $assert_msg"
    return 0
  fi
  echo "FAIL - $assert_msg"
  return 1
}

function readConfig() {
  while IFS=: read -r line
  do
    line=$(trim "$line")
    if isComment $line || isEmpty $line; then
      continue 
    fi
    extractVariables "$line"
  done <$CFG_FILE
}

function extractVariables() {
  line="$1"

  variable=${line%=*}
  variable=$(trim "$variable")

  value=${line#*=}
  value=$(trim "$value")

  if [ "$variable" = "Foo" ] && isInteger "$value"; then
    Foo="$value"
  fi
  if [ "$variable" = "Bar" ]; then
    Bar="$value"
  fi
  if [ "$variable" = "FooBar" ] && isInteger "$value"; then
    FooBar="$value"
  fi
}

function isInteger() {
  integer="$1"
  if [ "$integer" -eq "$integer" ] 2> /dev/null; then
    return 0
  fi
  warning "Warning: "$integer" is not decimal integer!"
  return 1
}

function isString() {
  echo "not implemented"
  exit 1
}

function isComment() {
  comment="$1"

  # Remove spaces from the left of the comment..
  comment=$(echo "$comment" | sed -e 's/^[[:space:]]*//')

  if [[ $comment == \#* ]]; then
    return 0
  fi
  return 1
}

function isEmpty() {
  string="$1"
  if [ -z "$string" ]; then
    return 0
  fi
  return 1
}

function trim() {
  string="$1"
  echo $(echo $string | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
}

function warning() {
  message="$1"
  if $WARNINGS; then
    echo "$message"
  fi
}
