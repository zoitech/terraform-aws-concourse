if [ ! -e "/home/core/keys/web/authorized_worker_keys" ]; then
  mkdir -p /home/core/keys/web /home/core/keys/worker
  rm -f /home/core/keys/web/*
  rm -f /home/core/keys/worker/*
  ssh-keygen -t rsa -f /home/core/keys/web/tsa_host_key -N ''
  ssh-keygen -t rsa -f /home/core/keys/web/session_signing_key -N ''
  ssh-keygen -t rsa -f /home/core/keys/worker/worker_key -N ''
  cp -f /home/core/keys/worker/worker_key.pub /home/core/keys/web/authorized_worker_keys
  cp -f /home/core/keys/web/tsa_host_key.pub /home/core/keys/worker
fi