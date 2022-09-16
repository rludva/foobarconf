#!/bin/bash

CFG_FILE="/tmp/foobar"

# Variables
Foo=""
Bar=""
FooBar=""

function foobar_foo_gte_10() {
  file=$CFG_FILE
  opt="Foo"
  expected_value="10"
  assert_msg="Option '$opt' is greater than or equal to '$expected_value' in '$file'"

  let value="$opt"
  if [ $value -ge 10 ]; then
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
	if [ "$variable" = "FooBar" ]; then
		FooBar="$value"
	fi
}

function isInteger() {
  integer="$1"
	if [ "$integer" -eq "$integer" ] 2> /dev/null; then
	  return 0
	fi
	echo "Warning: "$integer" is not decimal integer!"
	return 1
}

function trim() {
	string="$1"
	echo $(echo $string | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
}

function isComment() {
  comment="$1"
  if [[ $comment == \#* ]]; then
	  return 0
	fi
	return 1
}

function isEmpty() {
  v="$1"
  if [ -z "$v" ]; then
	  return 0
	fi
	return 1
}


readConfig
foobar_foo_gte_10
echo "======="
echo "Foo = .$Foo."
echo "Bar = .$Bar."
echo "FooBar = .$FooBar."
