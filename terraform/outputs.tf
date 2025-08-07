output "elasticsearch_url" {
  value = "http://${docker_container.elasticsearch.name}:${var.es_port}"
}

output "logstash_endpoint" {
  description = "Logstash Beats input URL"
  value       = "tcp://${docker_container.logstash.name}:5044"
}

output "kibana_url" {
  description = "Kibana web UI URL"
  value       = "http://${docker_container.kibana.name}:5601"
}
