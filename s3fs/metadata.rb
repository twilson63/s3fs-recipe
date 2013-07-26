maintainer        "Jack Russell Software Company"
maintainer_email  "team@jackrussellsoftware.com"
license           "Apache 2.0"
description       "Installs and configures s3fs for creating a file system to an s3 bucket"
version           "1.1.0"

recipe            "s3fs", "Installs and configures s3fs and mounts buckets"

supports          "centos", ">= 6.0"
supports          "redhat", ">= 6.0"
supports          "ubuntu"
supports          "debian"

attribute "s3fs",
  :display_name => "s3fs",
  :description => "Hash of s3fs attributes",
  :type => "hash"

attribute "s3fs/packages",
  :display_name => "s3fs package list",
  :description => "Packages to install to support s3fs"
  
attribute "s3fs/version",
  :display_name => "s3fs version",
  :description => "Version of s3fs to install",
  :default => "1.69"
  
attribute "s3fs/options",
  :display_name => "s3fs options",
  :description => "mount options for s3fs mounts",
  :default => "allow_other,use_cache=/tmp"

  
attribute "fuse",
  :display_name => "fuse",
  :description => "Hash of fuse attributes",
  :type => "hash"

attribute "fuse/version",
  :display_name => "FUSE version",
  :description => "Version of FUSE to be installed"
