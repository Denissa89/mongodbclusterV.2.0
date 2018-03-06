#!/bin/bash

mongo1={{ hostvars['mongo-master']['ansible_enp0s3']['ipv4']['address'] }}
mongo2={{ hostvars['mongo-slave-1']['ansible_enp0s3']['ipv4']['address'] }}
mongo3={{ hostvars['mongo-slave-2']['ansible_enp0s3']['ipv4']['address'] }}

port=${PORT:-27017}

RS=rs0
echo "Waiting for startup.."
until mongo --host ${mongodb1}:${port} --eval 'quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)' &>/dev/null; do
  printf '.'
  sleep 1
done

echo "Started.."

echo setup-cnf.sh time now: `date +"%T" `
mongo --host ${mongodb1}:${port} <<EOF
   var cfg = {
        "_id": "${RS}",
        "members": [
            {
                "_id": 0,
                "host": "${mongodb1}:${port}"
            },
            {
                "_id": 1,
                "host": "${mongodb2}:${port}"
            },
            {
                "_id": 2,
                "host": "${mongodb3}:${port}"
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    rs.reconfig(cfg, { force: true });
EOF
