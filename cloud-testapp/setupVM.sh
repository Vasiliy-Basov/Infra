gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image ubuntu-1604-xenial-v20170815a \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure