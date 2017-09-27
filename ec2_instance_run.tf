# null_resources are in use because depends_on for providers is not supported right now.
# See: https://github.com/hashicorp/terraform/issues/2430

resource "null_resource" "setup" {
  triggers {
    ip = "${aws_instance.ec2_linux_instance.id}"
  }
  provisioner "remote-exec" {
    inline = [
        "mkdir -p keys/web keys/worker",
        "rm -f keys/web/*",
        "rm -f keys/worker/*",
        "ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''",
        "ssh-keygen -t rsa -f ./keys/web/session_signing_key  -N ''",
        "ssh-keygen -t rsa -f ./keys/worker/worker_key   -N ''",
        "cp -f ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys",
        "cp -f ./keys/web/tsa_host_key.pub ./keys/worker",
        "docker rm -f $(docker ps -a -q)",
        "docker run -d --name db -e POSTGRES_DB='concourse' -e POSTGRES_USER='${var.postgres_username}' -e POSTGRES_PASSWORD='${var.postgres_password}' -e PGDATA='/database' --restart=always postgres:${var.postgres_version}",
        "sleep 10",
        "docker run -d --name web -v '/home/core/keys/web:/concourse-keys' -e CONCOURSE_GARDEN_DNS_SERVER='8.8.8.8' -e CONCOURSE_BASIC_AUTH_USERNAME='${var.concourse_username}' -e CONCOURSE_BASIC_AUTH_PASSWORD='${var.concourse_password}' -e CONCOURSE_POSTGRES_DATA_SOURCE='postgres://${var.postgres_username}:${var.postgres_password}@db:5432/concourse?sslmode=disable' --restart=always -p 8080:8080 --link='db' concourse/concourse:${var.concourse_version} web",
        "sleep 4",
        "docker run -d --name worker --link='web' --privileged -v '/home/core/keys/worker:/concourse-keys' -e CONCOURSE_GARDEN_DNS_SERVER='8.8.8.8' -e CONCOURSE_TSA_HOST='web' --restart=always concourse/concourse:${var.concourse_version} worker",
      ]
    connection {
      host        = "${aws_eip.concourse_elastic_ip.public_ip}"
      type        = "ssh"
      user        = "core"
      private_key = "${var.instance_key}"
    }
  }
}

resource "null_resource" "update-selfupdate" {
  # Please note: Changes to any instance of the cluster requires re-provisioning
  triggers {
    hash = "${md5("${file("${var.concourse_pipeline_path}/pipeline.yml")}${var.trigger}")}"
  }
  # Deleting old files
  provisioner "remote-exec" {
    inline = [
      "rm -Rf /home/core/pipeline"
    ]
  }
  # Copying new files
  provisioner "file" {
    source      = "${var.concourse_pipeline_path}"
    destination = "/home/core/pipeline"
  }
  # Running docker
  provisioner "remote-exec" {
    inline = [
      "ls /home/core/pipeline",
      "docker run --rm --link=web -e CC_URL=http://web:8080 -e CC_USER=${var.concourse_username} -e CC_PASS=${var.concourse_password} -e CC_COMMAND=set-pipeline -e CC_OPTIONS=' --load-vars-from pipeline/${var.concourse_pipeline_config} --config pipeline/${var.concourse_pipeline_yml} --pipeline ${var.concourse_pipeline_name} --non-interactive' -v /home/core/pipeline:/pipeline derbrobro/flyingit",
    ]
  }
  connection {
    host        = "${aws_eip.concourse_elastic_ip.public_ip}"
    type        = "ssh"
    user        = "core"
    private_key = "${var.instance_key}"
  }
  
  count      = "${var.concourse_pipeline_create}"
  depends_on = ["null_resource.setup"]
}
