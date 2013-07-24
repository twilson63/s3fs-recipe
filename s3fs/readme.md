# Amazon s3fs Recipe

The purpose of this recipe is to create a s3fs driver for one of your amazon s3 buckets. The cookbook supports using an encrypted data bag to keep data safe in shared situations.


## Setup

To use, create a data bag per unique s3fs configuration. An example is included. Upload using:

    knife data bag from file examples/s3_keys-deploy_key.json

Then, for each node to run this configuration, use a role like this:

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
    

## What does it do?

It will install s3fs on your server, then it will create folders in the /mnt directory named the same as each bucket listed in the data bag.  Lastly it will create a s3fs mount for each s3 bucket specified in your configuration.

The recipe will handle encrypted data bags, and uses the Chef::EncryptedDataBagItem.load with default decryption key file.

## Multi User Support

If you have multiple AWS IAM users with different keys and multiple buckets that need mounted, you can use `node['s3fs']['multi_user']`. By setting this attribute to true, it will allow you to mount multiple buckets across as many user accounts (with different keys) as you want. Instead of using `node["s3fs"]["data_bag"]["item"]` to specify which data bag item to load, you create one or more data bags under `node["s3fs"]["data_bag"]["name"]` for each unique AWS IAM user you need to use. The data bag format is still the same as it always has been.

## Support

If you have any problems or change requests to this recipe create an issue or submit a pull request on https://github.com/twilson63/s3fs-recipe
