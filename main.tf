terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "---"
}

resource "digitalocean_droplet" "jenkins" {
  image  = "ubuntu-22-04-x64"
  name   = "jenkins"
  region = "nyc1"
  size   = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.atividade.id]
}

data "digitalocean_ssh_key" "atividade" {
  name = "atividade"
}

resource "digitalocean_kubernetes_cluster" "atividade" {
  name   = "atividade"
  region = "nyc1"
  version = "1.22.8-do.1"

  node_pool {
    name       = "atv-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3

    taint {
      key    = "workloadKind"
      value  = "database"
      effect = "NoSchedule"
    }
  }
}