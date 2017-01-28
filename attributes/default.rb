default['s3fs']['build_from_source'] = true

case node['platform']
when 'opensuse'
  case node['platform_version'].to_f
  when 13.1
    default['s3fs']['packages'] = %w(s3fs) # available in package manager on opensuse 13.1 and fuse is already install
  end
  default['fuse']['version'] = '2.9.3'
when 'centos', 'redhat'
  default['s3fs']['packages'] = %w(gcc libstdc++-devel gcc-c++ curl-devel libxml2-devel openssl-devel mailcap make)
  case node['platform_version'].to_i
  when 6
    default['fuse']['version'] = '2.9.1'
  when 5
    default['fuse']['version'] = '2.8.5'
  end
when 'amazon'
  default['s3fs']['packages'] = %w(gcc libstdc++-devel gcc-c++ curl-devel libxml2-devel openssl-devel mailcap make fuse fuse-devel)
  default['fuse']['version'] = '2.9.2'
when 'debian', 'ubuntu'
  default['s3fs']['packages'] = %w(build-essential pkg-config libcurl4-openssl-dev libfuse-dev fuse-utils libfuse2 libxml2-dev mime-support)
  default['fuse']['version'] = '2.8.7'
  case node['platform_version'].to_i
  when 14
    default['s3fs']['packages'] = %w(
      build-essential
      pkg-config
      libcurl4-openssl-dev
      libfuse-dev
      fuse-emulator-utils
      libfuse2
      libxml2-dev
      mime-support
      automake
    )
    default['fuse']['version'] = '2.9.5'
  end
end

default['s3fs']['mount_root'] = '/mnt'
default['s3fs']['multi_user'] = false
default['s3fs']['version'] = '1.79'
default['s3fs']['options'] = 'allow_other,use_cache=/tmp'

default['s3fs']['data_from_bag'] = false

default['s3fs']['data'] = {
  'buckets' => []
}

default['s3fs']['fuse']['uri'] = 'https://github.com/libfuse/libfuse/releases/download/'
default['s3fs']['uri'] = 'https://github.com/s3fs-fuse/s3fs-fuse/archive/'
default['s3fs']['skip_passwd'] = false
