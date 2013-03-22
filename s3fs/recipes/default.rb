%w{ build-essential pkg-config libcurl4-openssl-dev libfuse-dev fuse-utils libfuse2 libxml2-dev mime-support }.each do |pkg|
  package pkg
end

# install fuse
remote_file "/tmp/fuse-#{ node[:fuse][:version] }.tar.gz" do
  source "http://downloads.sourceforge.net/project/fuse/fuse-2.X/#{ node[:fuse][:version] }/fuse-#{ node[:fuse][:version] }.tar.gz"
  mode 0644
end

bash "install fuse" do
  cwd "/tmp"
  code <<-EOH
  tar zxvf fuse-#{ node[:fuse][:version] }.tar.gz
  cd fuse-#{ node[:fuse][:version] }
  ./configure --prefix=/usr
  make
  sudo make install

  EOH

  not_if { File.exists?("/usr/bin/fusermount") }
end

remote_file "/tmp/s3fs-#{ node[:s3fs][:version] }.tar.gz" do
  source "http://s3fs.googlecode.com/files/s3fs-#{ node[:s3fs][:version] }.tar.gz"
  mode 0644
end

bash "install s3fs" do
  cwd "/tmp"
  code <<-EOH
  tar zxvf s3fs-#{ node[:s3fs][:version] }.tar.gz
  cd s3fs-#{ node[:s3fs][:version] }
  ./configure --prefix=/usr
  make
  sudo make install
  EOH

  not_if { File.exists?("/usr/bin/s3fs") }
end

directory "/mnt/#{ node[:s3][:bucket]}" do
  owner     "root"
  group     "root"
  mode      0777
  recursive true
  not_if do
    File.exists?("/mnt/#{ node[:s3][:bucket]}")
  end
end

template "/etc/passwd-s3fs" do
  source "passwd-s3fs.erb"
  owner "root"
  group "root"
  mode 0600
  variables(:access_key => node[:access_key], :secret_key => node[:secret_key])
end

mount "/mnt/#{ node[:s3][:bucket]}" do
  device "s3fs##{ node[:s3][:bucket]}"
  action [:umount]
end

mount "/mnt/#{ node[:s3][:bucket]}" do
  device "s3fs##{ node[:s3][:bucket]}"
  fstype "fuse"
  options "#{node[:s3fs][:options]}"
  dump 0
  pass 0
  action [:mount, :enable]
end
