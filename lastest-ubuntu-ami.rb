#!/usr/bin/env ruby

require 'rubygems'
require 'fog'
require 'trollop'

opts = Trollop::options do
	opt :release, "Ubuntu release raring or precise", :type => :string, :default => "precise"
end

msg = "[INFO] Ubuntu #{opts[:release]} release selected. #{$0} -h for more options."

case opts[:release]
  when "raring"
		puts msg
    @rel = opts[:release]
  when "precise"
		puts msg
    @rel = opts[:release]
  else
    puts "[ERROR] Wrong release name"
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
