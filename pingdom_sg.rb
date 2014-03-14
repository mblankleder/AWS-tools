#!/usr/bin/env ruby

# Adds Pingdom monitoring system IPs to a given Security Group

%w[ fog ].each { |f| require f }

unless ARGV.length == 2
  puts "Usage: #{$0} <region> <SG_name>\n\n(Ex: #{$0} us-west-2 sec_group_name)"
  exit 1
end

def conn(region)
  c = Fog::Compute.new(
    :provider               => 'AWS',
    :aws_secret_access_key  => ENV['AWS_SECRET_KEY'],
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],
    :region                 => region
  )
  return c
end

def pingdomIps()
  pingdom_ips=`wget --quiet -O- https://my.pingdom.com/probes/feed | grep "pingdom:ip" | sed -e 's|</.*||' -e 's|.*>||'`
  # array with all pingdom ips
  return pingdom_ips.gsub(/\n/,",").split(",")
end

def addIpToSecGroup(region, sec_group_name, ip)
  conn(region).security_groups.get(sec_group_name).authorize_port_range(0..65535,{:cidr_ip => "#{ip}/32"})
end

# sec_group_name is case sensitive here
pingdomIps().each do |ip|
  addIpToSecGroup(ARGV[0], ARGV[1] ,  ip)
  puts "[info] Added #{ip}"
end
