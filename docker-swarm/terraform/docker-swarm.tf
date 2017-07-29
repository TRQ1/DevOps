provider "google" {
  credentials = "${file("${var.key_json}")}"
  project     = "${var.gcp-project-id}"
  region      = "${var.resource_zone}"
}

resource "google_compute_instance" "swarm-manager" {
  name         = "${var.swarm_manager_jenkins}"
  machine_type = "${var.swarm_instance_type}"
  zone         = "${var.resource_zone}"

  tags = ["swarm-manager"]

  disk {
    image = "${var.master_source_disk_image}"
  }

  network_interface {
    network = "docker-net"
    access_config = {}
  }
  provisioner "remote-exec" {
    inline = [
      "if ! ${var.swarm_init}; then docker swarm init; fi",
#      "if ! ${var.swarm_init}; then docker swarm join --token ${var.swarm_manage\ r_token} --advertise-addr ${self.private_ip} ${var.swarm_manager_ip}:2377; fi"
      "echo ${var.doker_secret_jekins_id} | docker secret create jenkins-user -", 
      "echo ${var.doker_secret_jekins_pass} | docker secret create jenkins-pass -", 
      "echo `-master http://master:8080 -password ${var.doker_secret_jekins_pass} -username ${var.doker_secret_jekins_id}`|docker secret create jenkins -",
      "export JENKINS_IMAGE=$(docker images | grep my/jenkins |awk '{print $3}')",
      "docker tag $JENKINS_IMAGE ${var.gcp_hostname}/${var.gcp-project-id}/${var.image_name}",
      "gcloud docker -- push ${var.gcp_hostname}/${var.gcp-project-id}/${var.image_name}",
      "docker stack deploy -c ~/jenkins/docker-compose.yml jenkins;"
    ]
  }
  
  connection {
    user     = "${var.user_id}"
    private_key  = "${file("${var.connect_key}")}"
  }
}

resource "google_compute_instance" "swarm-worker" {
  name         = "${var.swarm_workers_name}"
  machine_type = "${var.swarm_instance_type}"
  zone         = "${var.resource_zone}"

  tags = ["swarm-worker"]

  disk {
    image = "${var.worker_source_disk_image}"
  }

  network_interface {
    network = "docker-net"
    access_config = {}
 }
  provisioner "remote-exec" {
    inline = [
      "gcloud docker -- pull ${var.gcp_hostname}/${var.gcp-project-id}/${var.image_name}",
      "docker swarm join ${google_compute_instance.swarm-manager.network_interface.0.address}:2377 --token $(docker -H ${google_compute_instance.swarm-manager.network_interface.0.address} swarm join-token -q worker)"
    ]
 }
  connection {
    user     = "${var.user_id}"
    private_key  = "${file("${var.connect_key}")}"
  }
}
