name             's3fs'
maintainer       'Jack Russell Software Company'
maintainer_email 'team@jackrussellsoftware.com'
license          'Apache 2.0'
description      'Mount one or more S3 buckets to the filesystem.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.4'

recipe           's3fs', 'Installs and configures S3FS and mounts buckets'

supports         'centos', '>= 6.0'
supports         'redhat', '>= 6.0'
supports         'ubuntu'
supports         'debian'

attribute 's3fs',
          display_name: 's3fs',
          description: 'Hash of S3FS attributes',
          type: 'hash'

attribute 's3fs/packages',
          display_name: 'S3FS package list',
          description: 'Packages to install to support S3FS',
          type: 'array'

attribute 's3fs/version',
          display_name: 's3fs version',
          description: 'Version of s3fs to install (github release version)',
          default: '1.79'

attribute 's3fs/options',
          display_name: 'S3FS options',
          description: 'Mount options for S3FS mounts',
          default: 'allow_other,use_cache=/tmp',
          type: 'string'

attribute 's3fs/mount_root',
          display_name: 'S3FS mount root',
          description: 'The root path for any mounted S3 buckets',
          type: 'string'

attribute 's3fs/multi_user',
          display_name: 'Multi-user support',
          description: 'Enable multi-user support',
          type: 'string'

attribute 's3fs/data_bag/name',
          display_name: 'S3FS buckets & credentials data bag',
          description: 'The name of the data bag that contains an item with the buckets to mount & necessary AWS credentials',
          type: 'string'

attribute 's3fs/data_bag/item',
          display_name: 'S3FS bucket(s) & credentials data bag item',
          description: 'The name of the data bag item that contains the buckets to mount & necessary AWS credentials',
          type: 'string'

attribute 'fuse',
          display_name: 'fuse',
          description: 'Hash of fuse attributes',
          type: 'hash'

attribute 'fuse/version',
          display_name: 'FUSE version',
          description: 'Version of FUSE to be installed'
