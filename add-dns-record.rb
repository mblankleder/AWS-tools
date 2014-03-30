#!/usr/bin/env ruby

require 'rubygems'
require 'fog'

unless ARGV.length == 2
  puts "Usage: ruby add-dns-record.rb subdomain_name hosted_zone_id\n"
  exit 1
end

subdomain_name = ARGV[0]+".exmple.com"
hosted_zone_id = ARGV[1]

def dns()
  c = Fog::DNS.new(
    :provider               => 'AWS',
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
  )
  return c
end

def add_dns_record(sub_dom_name, zone_id)
  zone = dns.zones.get(zone_id)

  record = zone.records.create(
    :value  => '10.0.0.5',
    :name   => sub_dom_name,
    :type   => 'A',
    :ttl    => '300'
  )
end

add_dns_record(subdomain_name, hosted_zone_id)
puts "ok"
