Sensu Chef Repository
====

author : Tomokazu HIRAI, twitter id : @jedipunkz

Introduction
----

This is chef repository for sensu monitoring system. Sensu is monitoring system
which we can view/controll monitoring items and events. This repository
includes chef roles, data bags, Berksfile for berkshelf.

How to deploy sensu-server
---

get this repository.

    % git clone git://github.com/jedipunkz/sensu-chef-repo.git ~/sensu-chef-repo

make ssl keys for sensu server and client, then put data to data bags of chef.

    % cd ~/sensu-chef-repo/data_bags/ssl
    % ./ssl_certs.sh generate
    % knife data bag create sensu
    % knife data bag from file sensu ./ssl.json

put monitoring item to data bag of chef. example item is here.

    % cd ~/sensu-chef-repo/
    % knife data bag create sensu_checks
    % knife data bag from file sensu_checks data_bags/sensu_checks/proc_cron.json

proc_cron.json : monitoring cron process item.

    {
      "id": "proc_cron",
      "command": "check-procs.rb -p cron -C 1",
      "subscribers": [
        "sensu-client"
      ],
      "interval": 10
    }

get cookbooks by berkshelf.

    % berks install --path ./cookbooks/

upload chef roles to chef server.

    % knife role from file roles/sensu-client.rb # this is needed for deploying sensu-client
    % knife role from file roles/sensu-server.rb

edit "master_address" to sensu-server's IP address.

    % ${EDITOR} cookbooks/monitor/attributes/default.rb
    default["monitor"]["master_address"] = "XXX.XXX.XXX.XXX"

upload cookbooks to chef server.
    
    workstation% knife cookbook upload -a

bootstrap sensu-server for deploying.

    % knife bootstrap <server-ip> -N <server-name> -r 'role[sensu-server]' -x root -i <secret-key>

access to dashboard : http://<server-ip>:8080, user account is here.

    cookbooks/sensu/attributes/default.rb

How to deploy sensu-client
----

    % knife bootstrap <client-ip> -N <client-name> -r 'role[sensu-client]' -x root -i <secret-key>

sensu-client process will connect sensu-server's rabbitmq-server and check it
self and report to sensu-server.

How to add monitoring items
----

create such json file.

    % ${EDITOR} data_bags/sensu_checks/proc_nginx.json

    {
      "id": "proc_cron",
      "command": "check-procs.rb -p ngins -w 5 -c 10",
      "subscribers": [
        "sensu-client"
      ],
      "interval": 10
    }

We can controll subscribers by chef role's name. so if you want separate some
group of subscribers, you can it by separeting chef role name.

put data to chef data bags.

    % knife data bag from file data_bags/sensu_checks/proc_nginx.json

