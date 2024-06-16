# go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# Virtual Box
alias vbx="VBoxManage"

# golang
export PATH=$PATH:~/utils/golang/go/bin

# Terraform
export PATH="/Users/hgl/brew/opt/terraform@0.13/bin:$PATH"

_have()
{
    # Completions for system administrator commands are installed as well in
    # case completion is attempted via `sudo command ...'.
    PATH=$PATH:/usr/sbin:/sbin:/usr/local/sbin type $1 &>/dev/null
}

# Backwards compatibility for compat completions that use have().
# @deprecated should no longer be used; generally not needed with dynamically
#             loaded completions, and _have is suitable for runtime use.
have()
{
    unset -v have
    _have $1 && have=yes
}

# Virtual Box
BOX_HOSTNAME=`cat ~/Workspace/dotbash/.hostname`
BOX_HOSTNAME_BASH_PROFILE=~/Workspace/dotbash/configs/$BOX_HOSTNAME/bash_profile.sh
[ -f $BOX_HOSTNAME_BASH_PROFILE ] && source $BOX_HOSTNAME_BASH_PROFILE
