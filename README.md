op5-cli
========
A command-line interface for the OP5 monitoring system using its REST API

How to install
----------
```
pip install -r requirements.txt
python setup.py install
```

How to run
----------
- Config API

 `$ op5-cli <action_type> <object_type> [<name>] [--data <data>] [--dryrun] [--debug]`

- Filter API

 `$ op5-cli query/querycount <a query in Livestatus Query Language(LQL)> [--dryrun] [--debug]`

- Report API

 `$ op5-cli report <querystring> [--dryrun] [--debug]`

- Command API

 `$ op5-cli command <command> --data <data> [--dryrun] [--debug]`

  Available commands are:

  * ACKNOWLEDGE_HOST_PROBLEM

  * ACKNOWLEDGE_SVC_PROBLEM

  * PROCESS_HOST_CHECK_RESULT

  * PROCESS_SERVICE_CHECK_RESULT

  * SCHEDULE_AND_PROPAGATE_HOST_DOWNTIME

  * SCHEDULE_AND_PROPAGATE_TRIGGERED_HOST_DOWNTIME

  * SCHEDULE_HOST_CHECK

  * SCHEDULE_HOST_DOWNTIME

  * SCHEDULE_SVC_CHECK

  * SCHEDULE_SVC_DOWNTIME

The program will output (only) valid JSON data on success; making it easy for the output to be piped into external tools (e.g. JSON parsers like jq) to be processed further.

Examples
----------
- Config API

 `$ op5-cli read host <host_name>`

 `$ op5-cli read hostgroup <hostgroup_name>`

 `$ op5-cli read hostgroup ""` #use an empty name to list all objects of the given object type

 `$ op5-cli read service "<host_name>|<hostgroup_name>;<service_description>"`

 `$ op5-cli create host --data "$(<example_data/host_data)"`

 `$ op5-cli update host <host_name> --data "$(<example_data/passive_host_data)"`

 `$ op5-cli create host --data '{"host_name":"test"}'`

 `$ op5-cli delete host test`

 `$ op5-cli create service --data "$(<example_data/service_data)"`

 `$ op5-cli overwrite service "<host_name>|<hostgroup_name>;<service_description>" --data "$(<example_data/passive_service_data)"`

- Filter API

  `$ op5-cli query '[hosts] contact_groups >= "itops.mw-services"'`

  `$ op5-cli querycount '[services] contact_groups >= "itops.mw-services"'`

  For operation query, (and not querycount) you may specify the parameters columns, limit, offset, and sort; as specified on: https://monitor/api/help/filter/query

  `$ op5-cli query '[services] contact_groups >= "itops-sms"&columns=state,acknowledged,has_been_checked&limit=100&sort=state'`

- Report API

  You may use the parameters available for the report API as specified on: https://monitor/api/help/report/event

  `$ op5-cli report "report_period=last24hours&limit=2"`

- Command API

  You need to specify the parameters needed for each command type as specified on https://monitor/api/help/command/<command>

  `$ op5-cli command SCHEDULE_SVC_CHECK --data '{"host_name":"monitor.internal.machines","service_description":"Merlin Node Status","check_time":"2015-10-01 17:19:40"}'`

FAQ
---

- The app (or rather the library that the app uses) raises an exception on purpose sometimes and does not catch it, making the execution fail.

Yeah, as you said, that is on purpose. That happens when OP5 has an internal error and it is better to fix that problem first than to let the execution continue.

- I don't want to store my password under ~/.config/op5/config.yaml, what can I do?

You could just delete the line starting with "op5_password:" in that file; and you will be prompted for a password to save in your keyring instead (requires python-keyring installed).

- Can I fetch the password from the pass password manager instead?

Yup. Install passkeyring, set it as the default keyring, and you are all set.

Contributing
------------
Pull requests, bug reports, and feature requests are extremely welcome.
