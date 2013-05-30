node['s3fs']['packages'].each do |pkg|
  package pkg
end

if not node['s3fs']['packages'].include?("fuse")
  # install fuse
  remote_file "#{Chef::Config[:file_cache_path]}/fuse-#{ node['fuse']['version'] }.tar.gz" do
    source "http://downloads.sourceforge.net/project/fuse/fuse-2.X/#{ node['fuse']['version'] }/fuse-#{ node['fuse']['version'] }.tar.gz"
    mode 0644
    action :create_if_missing
  end

  bash "install fuse" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
    tar zxvf fuse-#{ node['fuse']['version'] }.tar.gz
    cd fuse-#{ node['fuse']['version'] }
    ./configure --prefix=/usr
    make
    make install

    EOH

    not_if { File.exists?("/usr/bin/fusermount") }
  end

end

if %w{centos redhat amazon}.include?(node['platform'])
  template "/etc/ld.so.conf.d/s3fs.conf" do
    source "s3fs.conf.erb"
    owner "root"
    group "root"
    mode 0644
  end

  bash "ldconfig" do
    code "ldconfig"
    only_if { `ldconfig -v | grep fuse | wc -l` == 0 }
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/s3fs-#{ node['s3fs']['version'] }.tar.gz" do
  source "http://s3fs.googlecode.com/files/s3fs-#{ node['s3fs']['version'] }.tar.gz"
  mode 0644
  action :create_if_missing
end

bash "install s3fs" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib64/pkgconfig
  tar zxvf s3fs-#{ node['s3fs']['version'] }.tar.gz
  cd s3fs-#{ node['s3fs']['version'] }
  ./configure --prefix=/usr
  make
  make install
  EOH

  not_if { File.exists?("/usr/bin/s3fs") }
end

s3_bag = data_bag_item(node['s3fs']['data_bag']['name'], node['s3fs']['data_bag']['item'])

template "/etc/passwd-s3fs" do
  source "passwd-s3fs.erb"
  owner "root"
  group "root"
  mode 0600
  variables(:s3_bag => s3_bag)
end

s3_bag['buckets'].each do |bucket|
  directory "/mnt/#{ bucket}" do
    owner     "root"
    group     "root"
    mode      0777
    recursive true
    not_if do
      File.exists?("/mnt/#{ bucket}")
    end
  end

  mount "/mnt/#{ bucket}" do
    device "s3fs##{ bucket}"
    fstype "fuse"
    options node['s3fs']['options']
    dump 0
    pass 0
    action [:mount, :enable]
    not_if "grep -qs '/mnt/#{ bucket} ' /proc/mounts" 
  end
end
