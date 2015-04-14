#!/usr/bin/env bash

# Dependencies:
# - jq for parsing JSON
# - Your environment configured for OP5 servers (use a test server!)

# Input:
# $1 - command to run
# $2 - Expected exit code (defaults to 0)
function run_tc() {
  command="$1"

  expected_exit_code="$2"
  test -z "$expected_exit_code" && expected_exit_code="0"

  # set +e as this command may fail
  set +e

  # Run command and get return code -- we corrently don't care about output
  eval $command > /dev/null 2> /dev/null
  exit_code="$?"

  # set -e again
  set -e

  if test "$exit_code" = "$expected_exit_code"
  then
	  echo " OK"
  else
	  echo " NOK"
  fi
}

# TODO: Function to check if JSON element has expected content
# Input:
# $1 - JSON string
# $2 - JSON Path
# $3 - Value we expect to find in path
#function test_json() {
#}

# Fail on error
set -e

dir=$(dirname $0)

cd "$dir"

# Path to op5-cli command
op5cmd="../op5-cli"

# Host for test
# NOTE: This won't work if we run this script simultaneously from different
# places, since these tests creates and deletes this host from the server.
host="test-host"

# Test if host exists
# Expect: Does not exist
echo -n "Read non-existing host... "
run_tc "$op5cmd read host ${host}" 104

echo -n "Create host... "
run_tc "$op5cmd create host --data '{\"host_name\":\"${host}\"}'"

echo -n "Commit changes (create action)... "
run_tc "$op5cmd commit-changes"

echo -n "Read host we just created... "
run_tc "$op5cmd read host ${host}"

echo -n "Delete host we just created... "
run_tc "$op5cmd delete host ${host}"

echo -n "Commit changes (delete action)... "
run_tc "$op5cmd commit-changes"

echo -n "Read non-existing host... "
run_tc "$op5cmd read host ${host}" 104

# TODO:
# - Add service to host
# - List changes and confirm what's to be committed
# - Update host and commit changes
# - Confirm no current changes after commit (test_json)
# - Read all hosts
# - Read all hostgroups
# - Read specific hostgroup
# - Read service
