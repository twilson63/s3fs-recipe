#
# Cookbook Name:: s3fs
# Recipe:: default
#
# Copyright (C) 2011 Tom Wilson
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Define class to include the helper.
class Recipe
  # Simply includes S3FS Helper module.
  class Chef
    include S3FS::Helper
  end
end
Chef::Resource::RemoteFile.send(:include, S3FS::Helper)

node['s3fs']['packages'].each do |pkg|
  package pkg
end

if node['s3fs']['build_from_source']

  unless node['s3fs']['packages'].include?('fuse')
    # install fuse
    remote_file "#{Chef::Config[:file_cache_path]}/fuse-#{node['fuse']['version']}.tar.gz" do
      source uri_join(node['s3fs']['fuse']['uri'], "#{get_release_path(node['fuse']['version'])}/fuse-#{node['fuse']['version']}.tar.gz").to_s
      mode 0644
      action :create_if_missing
    end

    bash 'install fuse' do
      cwd Chef::Config[:file_cache_path]
      code "
      tar zxvf fuse-#{node['fuse']['version']}.tar.gz
      cd fuse-#{node['fuse']['version']}
      ./configure --prefix=/usr
      make
      make install
    "

      not_if { File.exist?('/usr/bin/fusermount') }
    end

  end

  if %w(centos redhat amazon).include?(node['platform'])
    template '/etc/ld.so.conf.d/s3fs.conf' do
      source 's3fs.conf.erb'
      owner 'root'
      group 'root'
      mode 0644
    end

    bash 'ldconfig' do
      code 'ldconfig'
      only_if { `ldconfig -v | grep fuse | wc -l` == 0 }
    end
  end

  remote_file "#{Chef::Config[:file_cache_path]}/s3fs-fuse-#{node['s3fs']['version']}.tar.gz" do
    source uri_join(node['s3fs']['uri'], "v#{node['s3fs']['version']}.tar.gz").to_s
    mode 0644
    action :create_if_missing
  end

  bash 'install s3fs' do
    cwd Chef::Config[:file_cache_path]
    code "
    export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib64/pkgconfig
    tar zxvf s3fs-fuse-#{node['s3fs']['version']}.tar.gz
    cd s3fs-fuse-#{node['s3fs']['version']}
    ./autogen.sh
    ./configure --prefix=/usr
    make
    make install
  "

    not_if { File.exist?('/usr/bin/s3fs') }
  end

end

def retrieve_s3_buckets(s3_data) # rubocop:disable Metrics/MethodLength
  buckets = []

  s3_data['buckets'].each do |bucket|
    bucket = Bucket.new(bucket, node)
    buckets << {
      name: bucket.name,
      path: bucket.path,
      access_key_id: (s3_data.include?('access_key_id') ? s3_data['access_key_id'] : ''),
      secret_access_key: (s3_data.include?('secret_access_key') ? s3_data['secret_access_key'] : '')
    }
  end

  buckets
end

# A simple data holder class for S3 Buckets
class Bucket
  attr_reader :name
  attr_reader :path

  def initialize(bucket, node)
    if bucket.is_a? String
      @name = bucket
      @path = File.join(node['s3fs']['mount_root'], @name)
    elsif bucket.is_a? Hash
      @name = bucket['name']
      @path = bucket['path']
    else
      @name = ''
      @path = ''
    end
  end
end

if node['s3fs']['multi_user']
  buckets = []
  node['s3fs']['data'].each do |item|
    buckets += retrieve_s3_buckets(item)
  end
elsif node['s3fs']['data_from_bag']
  s3_bag = data_bag_item(node['s3fs']['data_bag']['name'], node['s3fs']['data_bag']['item'])
  if s3_bag['access_key_id'].include? 'encrypted_data'
    s3_bag = Chef::EncryptedDataBagItem.load(node['s3fs']['data_bag']['name'], node['s3fs']['data_bag']['item'])
  end

  buckets = retrieve_s3_buckets(
    'buckets' => s3_bag['buckets'],
    'access_key_id' => s3_bag['access_key_id'],
    'secret_access_key' => s3_bag['secret_access_key']
  )
else
  buckets = retrieve_s3_buckets(node['s3fs']['data'])
end

unless node['s3fs']['skip_passwd']
  template '/etc/passwd-s3fs' do
    source 'passwd-s3fs.erb'
    owner 'root'
    group 'root'
    mode 0600
    variables(buckets: buckets)
  end
end

buckets.each do |bucket|
  directory bucket[:path] do
    owner     'root'
    group     'root'
    mode      0777
    recursive true
    not_if do
      File.exist?(bucket[:path])
    end
  end

  mount bucket[:path] do
    device "s3fs##{bucket[:name]}"
    fstype 'fuse'
    options node['s3fs']['options']
    dump 0
    pass 0
    action :mount
    not_if "grep -qs '#{bucket[:path]} ' /proc/mounts"
  end

  mount bucket[:path] do
    device "s3fs##{bucket[:name]}"
    fstype 'fuse'
    options node['s3fs']['options']
    dump 0
    pass 0
    action :enable
    not_if "grep -qs '#{bucket[:path]} ' /etc/fstab"
  end
end
