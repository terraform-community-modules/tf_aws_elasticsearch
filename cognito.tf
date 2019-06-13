data "aws_iam_policy" "cognito_access" {
  count = "${var.cognito_role_arn == "" ? 1 : 0}"
  arn   = "arn:aws:iam::aws:policy/AmazonESCognitoAccess"
}

resource "aws_iam_role" "cognito_access" {
  count = "${var.cognito_role_arn == "" ? 1 : 0}"
  name  = "CognitoAccessForAmazonES"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cognito_role_attachment" {
  count      = "${var.cognito_role_arn == "" ? 1 : 0}"
  role       = "${aws_iam_role.cognito_access.name}"
  policy_arn = "${data.aws_iam_policy.cognito_access.arn}"
}
