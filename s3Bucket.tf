resource "aws_s3_bucket" "contentBucket" {
  bucket = "jobcontentbucket"
}

output "contentBucketId" {
  value = "${aws_s3_bucket.contentBucket.id}"
}
output "contentBucketArn" {
  value = "${aws_s3_bucket.contentBucket.arn}"
}
