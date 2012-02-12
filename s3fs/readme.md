# Amazon s3fs Recipe

The purpose of this recipe is to create a s3fs driver for one of your amazon s3 buckets.


## Setup

To use simply include the following nodes in your json string:

    # Amazon Keys
    access_key: 
    secret_key:
    
    # s3 bucket name
    s3: { bucket: 'mybucket' }
    

## What does it do?

It will install s3fs on your server, then it will create a folder that is named the same as your bucket in the /mnt directory.  Lastly it will create a s3fs mount to your s3 bucket specified in your configuration.    

## Support

If you have any problems or change requests to this recipe please contact team@jackrussellsoftware.com
