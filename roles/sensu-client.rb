name "sensu-client"
description "role applied to sensu client."
run_list "recipe[monitor]",
  "recipe[chef-client::service]"
