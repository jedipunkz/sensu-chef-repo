name "sensu-server"
description "role applied to sensu server."
run_list "recipe[monitor::master]",
  "recipe[monitor::redis]",
  "recipe[monitor::rabbitmq]",
  "recipe[chef-client::service]"
