variable public_key {
  type    = string
  # Значение переменной
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCh+N8FE9V6QZNxLPG+Lh8nRoYajk0kohXdHVpDhApCoPHO9uO7mVRGzK4A6NFXXa3Yh90SC0BJnFh/f70urvPWVli4l+S8nIMtnZk5r0GBtSrPCl0MIOD8XnO8B6gWkbWxIJMwXxs/Dz/biAR4CVqJfaDr93+W53eD8MC9CKFK6u/00wb6RMJMx07ip7NakcUzfrC3TAl7d8VTSmRGAkLq6w/mxqix2/auDUWKECQ+gL4m3epmiy7YrVQ+LjBwrB5sf1mHkcVXB6uQhXvyruyr71kcQJGjUMmj8vlZy75SYcgAwmIKzfFFRTP2TaT0Rlixey3hfJ4ot6dtwYc1AUvFvdhN+dj3Dhh+xyV10y+H5BxEfBOWOYbWZDxbsiyAb4ogwbyro+gupY8rjD5yU8UhMBF73YvWtqzG+n9RHUcnhwLpKE57OJ1Brvbr7uqLyyadFYSKKQuyGgW3k3CDib/XvbL2K5bx1jVWLh5s0vLZaCAEuc9ni9MVUm88KQhxXy8="
}

variable project {
  # Описание переменной
  description = "Project ID"
  default = "infra-368512"
}

variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}

variable private_key {
  # Значение
  default = file("id_rsa")
}

variable zone {
	# zone location for google_compute_instance app
  description = "Zone location"
  default = "europe-west1-b"
}