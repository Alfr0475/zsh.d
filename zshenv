# http://pastak.hatenablog.com/entry/2014/02/21/025836
# system-wide environment settings for zsh(1)
if [ -x /usr/libexec/path_helper ]; then
    PATH=''
    eval `/usr/libexec/path_helper -s`
fi

# DOTPATHの定義
if [ -z $DOTPATH ]; then
    if [ -f $HOME/.zshenv ]; then
        local zshenv_path
        zshenv_path="$HOME/.zshenv"
        zshenv_path="${zshenv_path:A:h}"
        zshenv_path="${zshenv_path%%\/src}"

        if [[ $zshenv_path =~ dotfiles$ ]]; then
            export DOTPATH="$zshenv_path"
        else
            return 1
        fi
    else
        echo "cannot start ZSH, \$DOTPATH not set" 1>&2
        return 1
    fi
fi

# commonライブラリの読み込み
export COMMONPATH="$DOTPATH/etc/lib/common.sh"
if [[ -f $COMMONPATH ]]; then
    source "$COMMONPATH"
fi


# export EDITOR=/usr/local/bin/vim
# export EDITOR='emacsclient -n ""'
# export VISUAL='emacsclient -n ""'
export EDITOR='vim'
export VISUAL='vim'
export GOPATH=$HOME/work/sources
export ZPLUG_HOME=$HOME/.zsh.d/zplug

if which source-highlight > /dev/null; then
    export LESS='-R'
    export LESSOPEN='| $(/opt/homebrew/bin/brew --prefix)/bin/src-hilite-lesspipe.sh %s'
fi

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';

export NDK_ROOT=/usr/local/opt/android-ndk
export ANDROID_SDK_ROOT=/usr/local/opt/android-sdk
export ANDROID_HOME=/usr/local/opt/android-sdk
export ANT_ROOT=/usr/local/opt/ant/bin

export HOMEBREW_GITHUB_API_TOKEN=47838dca4cc5feb4851c7b8569012bbb01641127

if [ -d /opt/cocos2d-x/current ]; then
    export COCOS_CONSOLE_ROOT=/opt/cocos2d-x/current/tools/cocos2d-console/bin
    export COCOS_TEMPLATES_ROOT=/opt/cocos2d-x/current/templates
fi

if is_osx; then
    if [ -x /usr/bin/xcrun ]; then
        export CPPFLAGS=-I`xcrun --show-sdk-path`/usr/include
    fi
fi

#------------------------------------------------------------------------------
# Javaのバージョン指定
if is_osx; then
    if [ -x /usr/libexec/java_home ]; then
        export JAVA_HOME=`/usr/libexec/java_home -v "1.8"`
    fi
fi
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# PHPのビルド時のOpenSSLバージョン問題の対応
if is_osx; then
    export PHP_BUILD_CONFIGURE_OPTS="--with-bz2=$(/opt/homebrew/bin/brew --prefix bzip2) --with-iconv=$(/opt/homebrew/bin/brew --prefix libiconv) --with-pear"
fi
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# PKG_CONFIG_PATH
#------------------------------------------------------------------------------
if is_osx; then
    if [ -x "$(/opt/homebrew/bin/brew --prefix krb5)/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$(/opt/homebrew/bin/brew --prefix krb5)/lib/pkgconfig"
    fi

    if [ -x "$(/opt/homebrew/bin/brew --prefix openssl@1.1)/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$(/opt/homebrew/bin/brew --prefix openssl@1.1)/lib/pkgconfig"
    fi

    if [ -x "$(/opt/homebrew/bin/brew --prefix icu4c)/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$(/opt/homebrew/bin/brew --prefix icu4c)/lib/pkgconfig"
    fi

    if [ -x "$(/opt/homebrew/bin/brew --prefix libedit)/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$(/opt/homebrew/bin/brew --prefix libedit)/lib/pkgconfig"
    fi

    if [ -x "$(/opt/homebrew/bin/brew --prefix libxml2)/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$(/opt/homebrew/bin/brew --prefix libxml2)/lib/pkgconfig"
    fi

    if [ -x "$(/opt/homebrew/bin/brew --prefix libzip)/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$(/opt/homebrew/bin/brew --prefix libzip)/lib/pkgconfig"
    fi

    if [ -x "$(/opt/homebrew/bin/brew --prefix oniguruma)/lib/pkgconfig" ]; then
        export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$(/opt/homebrew/bin/brew --prefix oniguruma)/lib/pkgconfig"
    fi
fi
