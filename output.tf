output "cloudfront_url" {
  value = aws_cloudfront_distribution.website.domain_name
}

output "website_url" {
  value = "https://${var.domain_name}"
}