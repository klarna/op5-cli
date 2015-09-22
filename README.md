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

 `$ op5-cli query/querycount <query> [--dryrun] [--debug]`

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

FAQ
---

- I get an "ImportError: No module named op5" when I try to run the application

You didn't fetch the submodule which contains the library.

$ git submodule update --init

- The app (or rather the library that the app uses) raises an exception on purpose sometimes and does not catch it, making the execution fail.

Yeah, as you said, that is on purpose. That happens when OP5 has an internal error and it is better to fix that problem first than to let the execution continue.

- I don't want to store my password under .config/op5/config.yaml, what can I do?

You could just delete the line starting with "op5_password:" in that file; and you will be prompted for a password to save in your keyring instead (requires python-keyring installed).

- Can I fetch the password from pass password manager instead?

Yup. see https://confluence.internal.machines/display/teamitopsmw/passkeyring+backend and https://stash.int.klarna.net/projects/OPSMON/repos/passkeyring/browse. Install passkeyring, set it as the default keyring, and you are all set.

Contributing
------------
Pull requests, bug reports, and feature requests are extremely welcome.
