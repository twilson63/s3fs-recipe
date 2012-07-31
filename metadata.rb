maintainer       "Tom Wilson"
maintainer_email "tom@jackhq.com"
license          "MIT"
description      "Mounts a S3 bucket as file system"
version          "0.0.1"


%w{ubuntu}.each do |os|
  supports os
end

recipe           "s3fs", "Mounts a S3 bucket as file system. Forked from https://github.com/twilson63/s3fs-recipe"