group "default" {
  targets = ["build", "load", "deploy"]
}

target "build" {
  context = "."
  dockerfile = "Dockerfile"
  tags = ["demonstrationorg/docker-scout-conveyor:v3.0"]
}

target "load" {
  depends = ["build"]
  outputs = ["type=registry"]
  platforms = ["linux/amd64"]
  # Load the image into the local Kind cluster
  custom = {
    kind-load = "kind load docker-image demonstrationorg/docker-scout-conveyor:v3.0"
  }
}

target "deploy" {
  depends = ["load"]
  #contexts = {
  #  helm = "./helm"
  #}
  custom = {
    helm-install = "helm upgrade --install new-reef-revelations ./new-reef-revelations --namespace default --create-namespace --set image.repository=demonstrationorg/docker-scout-conveyor --set image.tag=v3.0"
  }
}