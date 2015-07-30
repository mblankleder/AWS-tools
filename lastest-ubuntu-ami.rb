#!/usr/bin/env ruby

# require 'rubygems'
require 'fog'
require 'trollop'

def_rel = 'trusty'
def_dev_type = 'ebs'

opts = Trollop.options do
	opt :release, 'Ubuntu release trusty or precise', type: :string, default: def_rel
	opt :root_dev_type, 'Root device type hvm or ebs', type: :string, default: def_dev_type
end

msg = "[INFO] Ubuntu #{opts[:release].upcase} release with #{opts[:root_dev_type].upcase} root device selected.\n Use #{__FILE__} -h for more options."

case opts[:release]
when 'trusty'
	puts msg
	@rel = opts[:release]
when 'precise'
	puts msg
	@rel = opts[:release]
else
	puts "[WARNING] Wrong release name #{opts[:release]}. Using default."
	@rel = def_rel
end

def conn(region = 'us-east-1')
	Fog::Compute.new(
		 provider: 'AWS',
 		aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
 		aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
 		region: region
	)
end

def all_regions
  aux = []
  conn.describe_regions.body['regionInfo'].each do |rn|
    aux << rn['regionName']
  end
  aux
end

def latest_ubuntu_ami(release, region)
	filter_str = "ubuntu/images-testing/hvm/ubuntu-#{release}-daily-amd64-server-*"
	conn(region).images.all('name' => filter_str).last.id
end

all_regions.each do |r|
  puts "[INFO] #{r} --> #{latest_ubuntu_ami(@rel, r)}"
end
