if [ ! -e "/home/ec2-user/keys/web/authorized_worker_keys" ]; then
  mkdir -p /home/ec2-user/keys/web /home/ec2-user/keys/worker
  rm -f /home/ec2-user/keys/web/*
  rm -f /home/ec2-user/keys/worker/*
  ssh-keygen -t rsa -f /home/ec2-user/keys/web/tsa_host_key -N ''
  ssh-keygen -t rsa -f /home/ec2-user/keys/web/session_signing_key -N ''
  ssh-keygen -t rsa -f /home/ec2-user/keys/worker/worker_key -N ''
  cp -f /home/ec2-user/keys/worker/worker_key.pub /home/ec2-user/keys/web/authorized_worker_keys
  cp -f /home/ec2-user/keys/web/tsa_host_key.pub /home/ec2-user/keys/worker
fi