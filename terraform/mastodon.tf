resource "kubernetes_namespace" "mastodon" {
    metadata {
      name = "mastodon"
    }
}

resource "helm_release" "mastodon" {
    name = "mastodon"
    namespace = kubernetes_namespace.mastodon.metadata.0.name
    repository = "https://charts.bitnami.com/bitnami"
    chart = "mastodon"

    set {
        name = "apache.ingress.enabled"
        value = true
    }

    set {
        name = "apache.ingress.hostname"
        value = "mastodon.${var.domain}"
    }

    set {
        name = "adminUser"
        value = "ray"
    }

    set {
        name = "adminPassword"
        value = random_password.admin_password.result
    }

    set {
        name = "adminEmail"
        value = "ray@saltrelli.com"
    }
}

resource "random_password" "admin_password" {
    length = 16
    special = false
}

output "mastodon_admin_password" {
    value = random_password.admin_password.result
    sensitive = true
}