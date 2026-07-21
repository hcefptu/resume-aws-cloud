terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_dynamodb_table" "visitor-counter" {
    name         = "visitor-counter"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"

    attribute {
        name = "id"
        type = "S"
    }
}

resource "aws_iam_role" "lambda_role" {
    name         = "lambda_resume_counter_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = { Service = "lambda.amazonaws.com" }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
    role         = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

data "archive_file" "lambda_zip" {
    type         = "zip"
    source_file  = "lambda_function.py"
    output_path  = "lambda_function.zip"
}

resource "aws_lambda_function" "resume_counter" {
    filename         = data.archive_file.lambda_zip.output_path
    function_name    = "GetVisitorCount"
    role             = aws_iam_role.lambda_role.arn
    handler          = "lambda_function.lambda_handler"
    runtime          = "python3.9"
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_apigatewayv2_api" "http_api" {
    name             = "cloud-resume-api"
    protocol_type    = "HTTP"
    cors_configuration {
        allow_origins = ["*"]
        allow_methods = ["GET", "OPTIONS"]
        allow_headers = ["*"]
    }
}

resource "aws_apigatewayv2_stage" "default" {
    api_id            = aws_apigatewayv2_api.http_api.id
    name              = "$default"
    auto_deploy       = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
    api_id           = aws_apigatewayv2_api.http_api.id
    integration_type = "AWS_PROXY"
    integration_uri = aws_lambda_function.resume_counter.invoke_arn
}

resource "aws_apigatewayv2_route" "get_count" {
    api_id          = aws_apigatewayv2_api.http_api.id
    route_key       = "GET /count"
    target          = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
    statement_id   = "AllowExecutionFromAPIGateway"
    action         = "lambda:InvokeFunction"
    function_name  = aws_lambda_function.resume_counter.function_name
    principal      = "apigateway.amazonaws.com"
    source_arn     = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

output "api_url" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}/count"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "cloud-resume-dinhngocminh-2026"
}
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "s3-cloudfront-oac-resume-2026"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "S3Origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https" # Bắt buộc dùng HTTPS
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}