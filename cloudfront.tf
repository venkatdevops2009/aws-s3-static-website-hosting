resource "aws_cloudfront_origin_access_control" "oac" {

  name = "website-oac"

  origin_access_control_origin_type = "s3"

  signing_behavior = "always"

  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "website" {

  enabled = true

  aliases = [
    var.domain_name
  ]

  origin {

    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name

    origin_id = "S3Origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {

    target_origin_id = "S3Origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]

    cached_methods = ["GET", "HEAD"]

    forwarded_values {

      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  default_root_object = "index.html"

  custom_error_response {
    error_code            = 403
    response_code         = 404
    response_page_path    = "/error.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/error.html"
    error_caching_min_ttl = 0
  }

  restrictions {

    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {

    acm_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

    ssl_support_method = "sni-only"

    minimum_protocol_version = "TLSv1.2_2021"
  }
}