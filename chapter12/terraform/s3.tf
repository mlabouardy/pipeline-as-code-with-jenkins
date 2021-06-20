resource "aws_s3_bucket" "marketplace" {
  bucket = "marketplace.${var.domain_name}"
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}


resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.marketplace.id
  policy = <<POLICY
{
  "Id": "1",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.marketplace.arn}/*"
      ],
      "Principal": "*"
    }
  ]
}
POLICY
}