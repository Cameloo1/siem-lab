terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}


# Elasticsearch

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "elasticsearch" {
  name = "docker.elastic.co/elasticsearch/elasticsearch:8.8.2"
}

resource "docker_container" "elasticsearch" {
  image = docker_image.elasticsearch.latest
  name  = "elk-elasticsearch"
  ports {
    internal = 9200
    external = 9200
  }
  env = [
    "discovery.type=single-node",
    "xpack.security.enabled=false",
  ]
}


# Logstash

resource "docker_image" "logstash" {
  name = "docker.elastic.co/logstash/logstash:8.8.2"
}

resource "docker_container" "logstash" {
  image = docker_image.logstash.latest
  name  = "elk-logstash"

  ports {
    internal = 5044
    external = 5044
  }

  volumes {
    host_path      = "/home/kali/siem-lab/logstash/pipeline.conf"  # now absolute
    container_path = "/usr/share/logstash/pipeline/logstash.conf"
  }
}



# Kibana

resource "docker_image" "kibana" {
  name = "docker.elastic.co/kibana/kibana:8.8.2"
}

resource "docker_container" "kibana" {
  image = docker_image.kibana.latest
  name  = "elk-kibana"
  ports {
    internal = 5601
    external = 5601
  }
  env = [
    "ELASTICSEARCH_URL=http://elk-elasticsearch:9200",
  ]
}
