#!/bin/sh

echo -e "op5_url: https://monitor.int.klarna.net/api\nop5_username: $op5_username\n" > /root/.config/op5-cli/config.yaml
if [ ! -z $op5_password ]; then
	echo -e "op5_password: $op5_password\n" >> /root/.config/op5-cli/config.yaml
fi
/usr/bin/op5-cli $*
