# http://pastak.hatenablog.com/entry/2014/02/21/025836
# system-wide environment settings for zsh(1)
if [ -x /usr/libexec/path_helper ]; then
    PATH=''
    eval `/usr/libexec/path_helper -s`
fi

export EDITOR=/usr/local/bin/vim
export GOPATH=$HOME/work/go

