AWS-tools
=========

Scripts to do some AWS operations easier

Install gems
------------
```bundle install```

Requirements
-------------
Amazon keys: 

```export AWS_SECRET_ACCESS_KEY="AAAAAWWWWWSSSSS...."```
```export AWS_ACCESS_KEY_ID="AAAAAWWWWWSSSSS...."```

pingdom_sg.rb
-------------
Script to pupulate AWS security groups with the Pingdom monitor system IPs.

lastest-ubuntu-ami.rb
---------------------
Retrieves the latest AWS AMIs IDs from all regions. 

Useful when you want to bootstrap an instance and need to specify the ami you want.

add-dns-record.rb
-----------------
Creates an A record on Route53 
