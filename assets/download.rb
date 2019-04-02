#!/usr/bin/env ruby

require 'fileutils'

vpn = {}
%w(IP_ADDRESS NAME REGION).each do |x|
  vpn[x.downcase] = ENV["VPN_#{x}"] || raise("VPN_#{x} not set")
end

file_exts = %w(png conf)
src_dir = "/opt/deploy/configs/#{vpn['ip_address']}/wireguard"
dest_dir = "configs/#{vpn['name']}"

FileUtils.mkdir_p dest_dir

Dir.chdir(dest_dir) do
  file_exts.each do |ext|
    res = system(
      'scp',
      '-oStrictHostKeyChecking=no',
      "root@#{vpn['ip_address']}:#{src_dir}/*.#{ext}",
      "./"
    )
    raise('Failed to SCP') unless res

    Dir.glob("*.#{ext}") do |file|
      FileUtils.mv file, [vpn['region'], vpn['name'], file].join('_')
    end
  end
end
