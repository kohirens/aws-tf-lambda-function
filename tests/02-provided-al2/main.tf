terraform {
  required_providers {
    http = {
      source = "hashicorp/http"
    }

  }
}

variable "url" {
  type = string
}

data "http" "test_function_url_response" {
  url = var.url
}

