data "aws_route53_zone" "main" {
  name         = "piridishop.shop"
  private_zone = false
}