resource "aws_iam_instance_profile" "swarm_profile" {
  name = "swarm-profile-${var.environment}"
  role = aws_iam_role.swarm_role.name
}

resource "aws_iam_role" "swarm_role" {
  name = "swarm-role-${var.environment}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "discovery_bucket_access_policy" {
  name = "discovery-bucket-access-policy-${var.environment}"
  role = aws_iam_role.swarm_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}