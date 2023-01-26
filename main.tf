provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mkebecloud2" {
  bucket = "mkebecloud2"
  acl    = "private"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::mkebecloud2"
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::mkebecloud2/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
EOF
}

resource "aws_cloudtrail" "example" {
  name = "example"

  s3_bucket_name = aws_s3_bucket.mkebecloud2.id
  is_multi_region_trail = true
}
