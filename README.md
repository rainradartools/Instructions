### Instructions

Rain radar tools are separated into Cloudformation stacks which each represent an area of concern

- data - Essentially just a website-enabled s3 bucket. This stores all the raw rain images
- configuration - Just a bucket that stores configurations
- collector - collects rain radar images and stores them in the data bucket
- animator - an http API for generating animated gif/mp4s from the images stored in S3
- tweeter - uses the animation api to produce an animation for a given radar and time period then uploads to twitter

The design is intended to be modular; users of these tools may not need every single stack.

### Get Started

The below instructions details how to start collecting rain images

#### 1. Deploy configuration stack

Create a new Cloudformation stack using the `cloudformation/configuration-bucket.yml` template in this repo.

###### Parameters:
ConfigurationBucketName: the name for the S3 bucket. These instructions will assume the name is something like `rain-configuration-<yourname>`

Edit `config/enabled_radar_ids.json` so that it contains only the radar ids you want to collect.

upload the configuration files

```
aws s3 cp --recursive ./config s3://rain-configuration-<yourname>
```

#### 2. Deploy data bucket

Create a new Cloudformation stack using the `cloudformation/data-bucket.yml` template

###### Parameters:
RainDataBucketName: the name for the S3 bucket These instructions will assume the name is something like `rain-data-<yourname>`

###### Upload S3-explorer

This is optional (but very useful)... upload [AWS Lab's javascript S3 Explorer](https://github.com/awslabs/aws-js-s3-explorer) so that you can easily browse the radar image data you've collected. 

```
wget https://raw.githubusercontent.com/awslabs/aws-js-s3-explorer/master/index.html
aws s3 cp index.html s3://rain-data-<yourname>/
```

You should now be able to browse the bucket content using the url listed in the CloudFormation outputs.

##### Upload layers

For each radar id listed in the enabled_radar_ids.json configuration file, this script uploads static rain radar background images to the rain-data-bucket

```
./scripts/upload_static_layers.sh config/enabled_radar_ids.json rain-data-<yourname>
```

You should now be able to browse these layers in your s3 data bucket website.

#### 3. Deploy rain-collector stack
See rain-collector stack for deployment instructions


