output "aws_address" {
  description = "Web address for the AWS instance"
  value       = "http://${aws_route53_record.aws.fqdn}"
}

output "azure_address" {
  description = "Web address for the Azure instance"
  value       = "http://${aws_route53_record.azure.fqdn}"
}

output "gcp_address" {
  description = "Web address for the GCP instance"
  value       = "http://${aws_route53_record.gcp.fqdn}"
}

output "do_address" {
  description = "Web address for the Digital Ocean instance"
  value       = "http://${aws_route53_record.do.fqdn}"
}
