#!/bin/sh

echo -e "op5_url: https://monitor.int.klarna.net/api\nop5_username: $op5_username" > /root/.config/op5-cli/config.yaml
/usr/bin/op5-cli $*
