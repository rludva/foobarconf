#!/bin/bash

# Get base directory of this project..
MY_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Definition of result dashboard..
TESTS=0
FAILING=0
PASSING=0

# Definition of colors..
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

BOLD=$(tput bold)
UNDERLINE=$(tput smul)
BLINK=$(tput blink)
RESET=$(tput sgr0)

function IncFailingCounter() {
  ((FAILING=FAILING+1))
  IncTestsCounter
}

function IncPassingCounter() {
  ((PASSING=PASSING+1))
  IncTestsCounter
}

function IncTestsCounter() {
  ((TESTS=TESTS+1))
}

source $MY_PATH/tests/tests_01_return_value.sh
source $MY_PATH/tests/tests_02_foo_value.sh
source $MY_PATH/tests/tests_03_foobar_value.sh
source $MY_PATH/tests/tests_04_comments.sh

# Print results dashboard..
echo 
echo "${BOLD}Results summary:${RESET}"
echo "- Number of failing tests: ${RED}$FAILING${RESET}"
echo "- Number of passing tests: ${GREEN}$PASSING${RESET}"
echo "- Number of processed tests: $TESTS${RESET}"

