#!/usr/bin/env ruby

require 'rubygems'
require 'fog'

unless ARGV.length == 1
  puts "Usage: #{$0} <ubuntu_relese [raring|precise]>\n"
  exit 1
end

case ARGV[0].strip
  when "raring"
    puts "[INFO] Ubuntu #{ARGV[0].strip} release selected"
    @rel = ARGV[0].strip
  when "precise"
    puts "[INFO] Ubuntu #{ARGV[0].strip} release selected"
    @rel = ARGV[0].strip
  else
    puts "[ERROR] Wrong release"
    system("#{$0}")
    exit 1
end

def conn(region='us-east-1')
  c = Fog::Compute.new(
    :provider               => 'AWS',
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :region                 => region
  )
  return c
end

def getAllRegions()
  aux = Array.new
  conn().describe_regions.body["regionInfo"].each do |rn|
    aux << rn["regionName"]
  end
  return aux
end

def latestUbuntuAmi(release, region)
 return conn(region).images.all('name' => "ubuntu/images-testing/ebs/ubuntu-#{release}-daily-amd64-server-*").last.id
end

getAllRegions().each do |r|
  puts "[INFO] #{r} --> #{latestUbuntuAmi(@rel, r)}"
end
