#!/usr/bin/env bash

# Run in debug mode if DEBUG is set
test -z "$DEBUG" || set -x

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

  # Run command and get return code -- we currently don't care about output
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

# TODO:
# - List changes and confirm what's to be committed
# - Update host and commit changes
# - Confirm no current changes after commit (test_json)
# - Read all hosts
# - Read all hostgroups
# - Read specific hostgroup
# - Read service

# Fail on error
set -e

dir=$(dirname $0)

cd "$dir"

# Path to op5-cli command
op5cmd="../op5-cli"

# Host for test
# NOTE: This won't work if we run this script simultaneously from different
# places, since these tests create and delete this host from the server.
test_prefix="test-"

function check_object() {
  object="$1"
  object_name="$2"
  config="$3"

  default_object_name="${test_prefix}${object}"
  default_config="${object}_data"

  test -z "$object_name" && object_name="$default_object_name"
  test -z "$config"      && config="$default_config"

  echo "Creating object $object with name $object_name with JSON data from example_data/${config}"

  echo -n "Read non-existing ${object} ${object_name}... "

  run_tc "$op5cmd read ${object} '${object_name}'" 104

  echo -n "Create ${object} ${object_name}... "

  run_tc "$op5cmd create ${object} --data '$(<../example_data/${config})'"

  echo -n "Commit changes (create action)... "

  run_tc "$op5cmd commit-changes"

  echo -n "Read object we just created... "

  run_tc "$op5cmd read ${object} '${object_name}'"

  echo
}


function check_if_object_exists() {
  object="$1"
  object_name="$2"

  default_object_name="${test_prefix}${object}"

  test -z "$object_name" && object_name="$default_object_name"

  echo -n "Check if ${object} object ${object_name} exists... "
  run_tc "$op5cmd read ${object} '${object_name}'"
}

function delete_object() {
  object="$1"
  object_name="$2"

  default_object_name="${test_prefix}${object}"

  test -z "$object_name" && object_name="$default_object_name"

  echo -n "Delete ${object} with name ${object_name}... "
  run_tc "$op5cmd delete ${object} '${object_name}'"

  echo -n "Commit changes (delete action)... "
  run_tc "$op5cmd commit-changes"

  echo -n "Read non-existing ${object} ${object_name}... "
  run_tc "$op5cmd read ${object} '${object_name}'" 104

   echo
}

#Currently we have tests for:
#- create
#- read
#- delete
#- get-changes
#- commit-changes
#
#Currenly missing tests for:
#- update
#- overwrite
#- undo-changes
#- et.c.

# Required for testing:
# - servicedependency (test-service -> test-service2)
# - hostdependency    (test-host    -> test-host2)
check_object "host"    "test-host2"               "host2_data"
check_object "service" "test-host2;test-service2" "service2_data"

# Exception to string used to find object (default: "test-<object type>"
service_read_string='test-host;test-service'
hostescalation_read_string='Host Escalation for host test-host (#1)'
hostdependency_read_string='"test-host2" depends on host "test-host"'
servicedependency_read_string='"test-host2;test-service2" depends on "test-host;test-service"'

# TODO:
# The following objects are currently not tested
# graph_template    - SQL error when using the API, default graph_template "default" does not exist
# graph_collection  - Requires changes to op5-cli, property "services" require
#                     an array of hashes that is currently not supported:
#                     [{"host":"test-host","service":"test-service"}]

# Create all objects
for object in \
  host \
  service \
  contact \
  contact_template \
  contactgroup \
  host_template \
  hostdependency \
  hostescalation \
  hostgroup \
  management_pack \
  service_template \
  servicedependency \
  servicegroup \
  timeperiod \
  user \
  usergroup
do
  json_read_string="${object}_read_string"
  check_object "$object" "${!json_read_string}"
done

# Check if all objects exist
echo "Check if all objects exist"
for object in \
  service \
  host \
  contact \
  contact_template \
  contactgroup \
  host_template \
  hostdependency \
  hostescalation \
  management_pack \
  hostgroup \
  service_template \
  servicedependency \
  servicegroup \
  timeperiod \
  user \
  usergroup
do
  json_read_string="${object}_read_string"
  check_if_object_exists "$object" "${!json_read_string}"
done

echo

# Delete all objects
# you have to delete management_pack before hostgroup
for object in \
  service \
  contact \
  contact_template \
  contactgroup \
  host_template \
  hostdependency \
  hostescalation \
  management_pack \
  hostgroup \
  service_template \
  servicedependency \
  servicegroup \
  timeperiod \
  user \
  host \
  usergroup
do
  json_read_string="${object}_read_string"
  delete_object "$object" "${!json_read_string}"
done

# Clean away some extra data
delete_object "service" "test-host2;test-service2"
delete_object "host"    "test-host2"
