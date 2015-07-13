#!/usr/bin/env ruby

require 'rubygems'
require 'fog'
require 'trollop'

def_rel = "trusty"
def_dev_type = "ebs"

opts = Trollop::options do
	opt :release, "Ubuntu release trusty or precise", :type => :string, :default => def_rel
	opt :root_dev_type, "Root device type hvm or ebs", :type => :string, :default => def_dev_type
end

msg = "[INFO] Ubuntu #{opts[:release].upcase} release with #{opts[:root_dev_type].upcase} root device selected.\n Use #{$PROGRAM} -h for more options."

case opts[:release]
  when "trusty"
		puts msg
    @rel = opts[:release]
  when "precise"
		puts msg
    @rel = opts[:release]
  else
    puts "[WARNING] Wrong release name #{opts[:release]}. Using default."
		@rel = def_rel
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
 return conn(region).images.all('name' => "ubuntu/images-testing/hvm/ubuntu-#{release}-daily-amd64-server-*").last.id
end

getAllRegions().each do |r|
  puts "[INFO] #{r} --> #{latestUbuntuAmi(@rel, r)}"
end
