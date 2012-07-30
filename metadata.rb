maintainer       "Alberta Motor Association"
maintainer_email "webmaster@ama.ab.ca"
license          "Apache 2.0"
description      "Mounts a S3 bucket as file system. Forked from https://github.com/twilson63/s3fs-recipe"
version          "0.0.1"


%w{ubuntu}.each do |os|
  supports os
end

recipe           "s3fs", "Mounts a S3 bucket as file system. Forked from https://github.com/twilson63/s3fs-recipe"