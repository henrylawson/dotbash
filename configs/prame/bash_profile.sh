# golang
export PATH=$PATH:/usr/local/go/bin

# glcoud
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# ssh agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent` &> /dev/null
    ssh-add ~/.ssh/id_rsa &> /dev/null
    ssh-add ~/.ssh/google_compute_engine &> /dev/null
    ssh-add ~/.ssh/molotius_id_rsa &> /dev/null
fi