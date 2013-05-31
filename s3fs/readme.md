# Amazon s3fs Recipe

The purpose of this recipe is to create a s3fs driver for one of your amazon s3 buckets.


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

## Support

If you have any problems or change requests to this recipe create an issue or submit a pull request on https://github.com/twilson63/s3fs-recipe
