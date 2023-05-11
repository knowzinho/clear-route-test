# Create the Route53 DNS record
resource "aws_route53_record" "nginx_dns" {
  zone_id = "Z01234"
  name    = "hostedzoneexample.com"
  type    = "A"
  alias {
    name                   = aws_lb.nginx_alb.dns_name
    zone_id                = aws_lb.nginx_alb.zone_id
    evaluate_target_health = true
  }
}