provider "google" {
  credentials = "${file("${var.key_json}")}"
  project     = "${var.gcp_project_id}"
  region      = "${var.gcp_region}"
}

resource "google_compute_instance" "swarm-manager" {
  name         = "${var.swarm_manager_jenkins}"
  machine_type = "${var.swarm_instance_type}"
  zone         = "${var.gcp_zone}"

  tags = ["swarm-manager"]

  disk {
    image = "${var.master_source_disk_image}"
  }

  network_interface {
    network = "docker-net"
#    subnetwork = "${google_compute_subnetwork.default-asia-northeast1.name}"
    access_config = {}
  }
  provisioner "remote-exec" {
    inline = [
      "if ! ${var.swarm_init}; then docker swarm init; fi",
      "echo ${var.doker_secret_jekins_id} | docker secret create jenkins-user -", 
      "echo ${var.doker_secret_jekins_pass} | docker secret create jenkins-pass -", 
      "echo `-master http://master:8080 -password ${var.doker_secret_jekins_pass} -username ${var.doker_secret_jekins_id}`|docker secret create jenkins -",
      "export FRIST_JENKINS_IMAGE=$(docker images | grep ${var.image_name} |awk '{print $3}')",
      "docker tag $FRIST_JENKINS_IMAGE ${var.gcp_hostname}/${var.gcp_project_id}/${var.image_name}",
      "gcloud docker -- push ${var.gcp_hostname}/${var.gcp_project_id}/${var.image_name}",
      "export JENKINS_IMAGE=$(docker images | grep ${var.gcp_project_id} | awk '{print $1}')",
      "docker stack deploy -c ~/jenkins/docker-compose.yml jenkins"
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
  zone         = "${var.gcp_zone}"

  tags = ["swarm-worker"]

  disk {
    image = "${var.worker_source_disk_image}"
  }

  network_interface {
    network = "docker-net"
#    subnetwork = "${google_compute_subnetwork.default-asia-northeast1.name}"
    access_config = {}
 }
  provisioner "file" {
    source = "${var.ssh_key_file}"
    destination = "/home/ubuntu/key"
}
  provisioner "remote-exec" {
    inline = [
      "gcloud docker -- pull ${var.gcp_hostname}/${var.gcp_project_id}/${var.image_name}",
      "export WORKER=$(sudo ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i key ${var.user_id}@${google_compute_instance.swarm-manager.network_interface.0.address} docker swarm join-token worker -q)",
      "docker swarm join ${google_compute_instance.swarm-manager.network_interface.0.address}:2377 --token $WORKER",
      "rm -f ~/key"
    ]
 }
  connection {
    user     = "${var.user_id}"
    private_key  = "${file("${var.connect_key}")}"
  }
}
