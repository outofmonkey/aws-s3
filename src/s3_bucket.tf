
resource "aws_s3_bucket" "mys3bucket" {
  bucket = "mybuckets3bucket1001"

  tags = {
    Name        = "My bucket"
    Environment = "test"
  }
}

resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.mys3bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "object" {
    depends_on = [aws_s3_bucket.mys3bucket, aws_s3_bucket_versioning.version]
  bucket = aws_s3_bucket.mys3bucket.id
  key    = "install-web.sh"
  source = "${path.module}/install-web.sh"
  etag = filemd5("${path.module}/install-web.sh")
    storage_class = "STANDARD"
}

