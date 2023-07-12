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
  name                = "instanceProfileSSM"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_role.name
}

resource "aws_iam_instance_profile" "this" {
  role        = aws_iam_role.ssm_role.name
  name        = "instanceProfileSSM"

}