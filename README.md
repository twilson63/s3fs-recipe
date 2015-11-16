# s3fs cookbook

Install the [S3FS driver](https://code.google.com/p/s3fs/) for one or more of your Amazon S3 buckets. The cookbook supports using an encrypted data bag to keep data safe in shared situations.

The latest community release can be found at http://community.opscode.com/cookbooks/s3fs.

# What does it do?

It will install S3FS on your server, then it will create folders in the `/mnt` directory named the same as each bucket listed in the data bag.  Lastly, it will create an S3FS mount for each S3 bucket specified in your configuration.

The recipe will handle encrypted data bags, and uses the `Chef::EncryptedDataBagItem.load` with default decryption key file.

# Requirements

## Platform:

* CentOS
* RHEL
* Ubuntu
* Debian

# Usage

To use, create a data bag per each unique S3FS configuration. Here's an example:

```json
{
  "id": "deploy_key",
  "buckets": [ "bucket1", "bucket2" ],
  "access_key_id": "ABCDEFGHIJKLMNOPQRST",
  "secret_access_key": "abcdefghijklmnopqrstuvwxyz01234567890ABC"
}
```

Then, for each node to run this configuration, use a role like this:

```ruby
"run_list": [
  "recipe[s3fs]",
  ...
],
"override_attributes": [
  "s3fs": {
    "data_bag": {
      "name": "s3_keys",
      "item": "deploy_key"
    }
  },
  ...
}
```

It is encouraged, however, to build a wrapper cookbook to specify the necessary attributes, rather than using roles, following the Berkshelf model.

## Multi User Support

If you have multiple AWS IAM users with different keys and multiple buckets that need mounted, you can use `node['s3fs']['multi_user']`. By setting this attribute to true, it will allow you to mount multiple buckets across as many user accounts (with different keys) as you want.

Instead of using `node["s3fs"]["data_bag"]["item"]` to specify which data bag item to load, you create one or more data bags under `node["s3fs"]["data_bag"]["name"]` for each unique AWS IAM user you need to use. The data bag format is otherwise the same.

And example of two separate data bag items in the same data bag:

```json
{
  "id": "s3fs_iam_1",
  "buckets": [ "bucket1", "bucket2" ],
  "access_key_id": "ABCDEFGHIJKLMNOPQRST",
  "secret_access_key": "abcdefghijklmnopqrstuvwxyz01234567890ABC"
}

{
  "id": "s3fs_iam_2",
  "buckets": [ "bucket1", "bucket2" ],
  "access_key_id": "ABCDEFGHIJKLMNOPQRST",
  "secret_access_key": "abcdefghijklmnopqrstuvwxyz01234567890ABC"
}
```

# Attributes

See `attributes/default.rb` for defaults generated per platform.

* `node["s3fs"]["packages"]` - Set of packages needed to install S3FS
* `node["fuse"]["version"]` - The version of FUSE to install
* `node["s3fs"]["version"]` - The version of S3FS to install
* `node["s3fs"]["mount_root"]` - The root path for any mounted S3 buckets
* `node["s3fs"]["multi_user"]` - Enable multi-user support
* `node["s3fs"]["options"]` - Options to set when mounting a bucket to the filesystem

# Recipes

## default

The default recipe installs a set of packages necessary to build S3FS from source, installs FUSE, then builds and installs S3FS.

It then configures and mounts one of more S3 buckets, specified in a data bag's item or items, with the associated AWS credentials.

# Author

Author:: Tom Wilson <tom@jackhq.com>

Copyright:: 2011 Tom Wilson

see LICENSE
