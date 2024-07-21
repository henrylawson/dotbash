# golang
export PATH=$PATH:/usr/local/go/bin

# glcoud
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# ssh agent
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
ssh-add ~/.ssh/google_compute_engine
ssh-add ~/.ssh/molotius_id_rsa