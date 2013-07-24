case node["platform"]
when "centos", "redhat"
  default["s3fs"]["packages"] = %w{gcc libstdc++-devel gcc-c++ curl-devel libxml2-devel openssl-devel mailcap make}
  case node["platform_version"].to_i
  when 6
    default["fuse"]["version"] = "2.9.1"
  end
when "amazon"
  default["s3fs"]["packages"] = %w{gcc libstdc++-devel gcc-c++ curl-devel libxml2-devel openssl-devel mailcap make fuse fuse-devel}
  default["fuse"]["version"] ="2.9.2"
when "debian", "ubuntu"
  default["s3fs"]["packages"] = %w{build-essential pkg-config libcurl4-openssl-dev libfuse-dev fuse-utils libfuse2 libxml2-dev mime-support}
  default["fuse"]["version"] = "2.8.7"
end

default["s3fs"]["mount_root"] = '/mnt'
default["s3fs"]["multi_user"] = false
default["s3fs"]["version"] = "1.69"
default["s3fs"]["options"] = 'allow_other,use_cache=/tmp'

default["s3fs"]["data_bag"]["name"] = "s3_keys"
default["s3fs"]["data_bag"]["item"] = "deploy_key"
