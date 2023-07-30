data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ssm_role" {
  name               = "instanceProfileSSM"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  policy_arn = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", ""]
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_instance_profile" "this" {
  role = aws_iam_role.ssm_role.name
  name = "instanceProfileSSM"
}

#################
## AWS Kinesis ##
#################
data "aws_iam_policy_document" "Kinesis" {
  statement {
    sid = "1"

    actions = [
      "kinesis:DescribeStream",
      "kinesis:PutRecord",
      "kinesis:PutRecords",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards",
      "kinesis:DescribeStreamSummary",
      "kinesis:RegisterStreamConsumer"
    ]

    resources = [
      aws_kinesis_stream.test_stream.arn,
    ]
  }
}

resource "aws_iam_policy" "kinesis_policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.Kinesis.json
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "kinesis-policy"
  roles      = aws_iam_role.ssm_role.arn
  policy_arn = aws_iam_policy.kinesis_policy.arn
}