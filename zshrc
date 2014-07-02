#------------------------------------------------------------------------------
# パス設定
#------------------------------------------------------------------------------
#   typeset
#    -U 重複パスを登録しない
#    -x exportも同時に行う
#    -T 環境変数へ紐付け
#
#   path=xxxx(N-/)
#     (N-/): 存在しないディレクトリは登録しない
#     パス(...): ...という条件にマッチするパスのみ残す
#        N: NULL_GLOBオプションを設定。
#           globがマッチしなかったり存在しないパスを無視する
#        -: シンボリックリンク先のパスを評価
#        /: ディレクトリのみ残す
#        .: 通常のファイルのみ残す

# 重複パスを登録しない
typeset -U path cdpath fpath manpath

if [ `uname` = "Linux" ]; then
elif [ `uname` = "Darwin" ]; then
    fpath=($(brew --prefix)/share/zsh/site-functions ~/.zsh.d/completion(N-/) $fpath)
    path=(~/bin(N-/) /usr/local/bin(N-/) $path)
fi

#------------------------------------------------------------------------------
# 基本
#------------------------------------------------------------------------------
# zshのバージョン判定を使う
autoload -Uz is-at-least

# Emacsライクな操作を有効にする
# Vi ライクな操作の場合は`bindkey -v`とする
bindkey -e

# ビープ音を鳴らさない
setopt nobeep

# Ctrl+S/Ctrl+Qを無効化
setopt NO_flow_control

#------------------------------------------------------------------------------
# ヒストリ
#------------------------------------------------------------------------------
# ヒストリのファイル名
HISTFILE=~/.zsh_history

# 現在の履歴数
HISTSIZE=1000000

# 保存する履歴数
SAVEHIST=1000000

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
setopt hist_ignore_space

# 入力したコマンドが既にコマンド履歴に含まれる場合、履歴から古い方のコマンドを削除する
setopt hist_ignore_all_dups

# ヒストリを共有
setopt share_history

# historyコマンドをヒストリから取り除く
setopt hist_no_store

# historyからコマンドを検索する
# git add[Ctrl+P or Ctrl+N]でgit addから始まるコマンドをhistoryから順に検索する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#------------------------------------------------------------------------------
# 補完
#------------------------------------------------------------------------------
# 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# タブによるファイルの順番切り替えをしない
unsetopt auto_menu

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリにcdする
setopt auto_cd

# cd した先のディレクトリをディレクトリスタックに追加する
setopt auto_pushd

# pushd した時に、ディレクトリが既にスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 拡張 glob を有効にする
setopt extended_glob

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# カッコの対応などを自動的に補完
setopt auto_param_keys

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs

# 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt list_types

# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# 語の途中でもカーソル位置で補完
setopt complete_in_word

# カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt always_last_prompt

# 日本語ファイル名等8ビットを通す
setopt print_eight_bit

# 明確なドットの指定なしで.から始まるファイルをマッチ
setopt globdots

# 補完候補を詰めて表示する設定
setopt list_packed

# 補完候補表示の時にbeep音を鳴らさない
setopt nolistbeep

# 先方予測機能を有効に
# autoload -U predict-on
# predict-on

# カーソルによる補完候補の選択を有効化
zstyle ':completion:*:default' menu select=1

# 色指定にLS_COLORSを使用
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


#---------------------------------------
# 補完候補の追加
#---------------------------------------
# zsh-completions
if is-at-least 4.3.10 && [ -d $HOME/.zsh.d/modules/zsh-completions ]; then
    fpath=($HOME/.zsh.d/modules/zsh-completions/src $fpath)
fi

# rbenv
if is-at-least 4.3.10 && [ -d $HOME/.rbenv/completions/rbenv.zsh ]; then
    fpath=($HOME/.rbenv/completions/rbenv.zsh $fpath)
fi

# 補完機能の初期化
autoload -Uz compinit
compinit -d $HOME/.zsh.d/tmp/$USER-zcompdump

#------------------------------------------------------------------------------
# プロンプト
#------------------------------------------------------------------------------
# 色を使う
# 基本色: 0:black、1:red、2:green、3:yellow、4:blue、5:magenta、6:cyan、7:white
# 8以降は数値指定
autoload -Uz colors

# zshのvcs_infoを使う
autoload -Uz vcs_info

# zshのhookを使う
autoload -Uz add-zsh-hook


# 以下の3つのメッセージをエクスポートする
#   $vcs_info_msg_0_ : 通常メッセージ用 (緑)
#   $vcs_info_msg_1_ : 警告メッセージ用 (黄色)
#   $vcs_info_msg_2_ : エラーメッセージ用 (赤)
zstyle ':vcs_info:*' max-exports 3


# 対応するVCSを定義
zstyle ':vcs_info:*' enable git svn hg cvs bzr


# 標準のフォーマット(git 以外で使用する)
zstyle ':vcs_info:*' formats '(%a)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%m' '<!%a>'
zstyle ':vcs_info:(svn|bzr|cvs):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

if is-at-least 4.3.10; then
    # git用のフォーマット
    # gitの時はステージしているかどうかを表示
    zstyle ':vcs_info:git:*' formats '(%s)-[%b]' '%c%u %m'
    zstyle ':vcs_info:git:*' actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
    zstyle ':vcs_info:git:*' unstagedstr "-"  # %u で表示する文字列
fi

# hooks 設定
if is-at-least 4.3.11; then
    # git のときはフック関数を設定する

    # formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
    # のメッセージを設定する直前のフック関数
    # 今回の設定の場合はformat の時は2つ, actionformats の時は3つメッセージがあるので
    # 各関数が最大3回呼び出される。
    zstyle ':vcs_info:git+set-message:*' hooks \
                                            git-hook-begin \
                                            git-untracked \
                                            git-push-status \
                                            git-stash-count

    # フックの最初の関数
    # git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
    # (.git ディレクトリ内にいるときは呼び出さない)
    # .git ディレクトリ内では git status --porcelain などがエラーになるため
    function +vi-git-hook-begin() {
        if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
            # 0以外を返すとそれ以降のフック関数は呼び出されない
            return 1
        fi

        return 0
    }

    # untracked ファイル表示
    #
    # untracked ファイル(バージョン管理されていないファイル)がある場合は
    # unstaged (%u) に ? を表示
    function +vi-git-untracked() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if command git status --porcelain 2> /dev/null \
            | awk '{print $1}' \
            | command grep -F '??' > /dev/null 2>&1 ; then

            # unstaged (%u) に追加
            hook_com[unstaged]+='?'
        fi
    }

    # push していないコミットの件数表示
    #
    # リモートリポジトリに push していないコミットの件数を
    # pN という形式で misc (%m) に表示する
    function +vi-git-push-status() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if [[ "${hook_com[branch]}" != "master" ]]; then
            # master ブランチでない場合は何もしない
            return 0
        fi

        # push していないコミット数を取得する
        local ahead
        ahead=$(command git rev-list origin/master..master 2>/dev/null \
            | wc -l \
            | tr -d ' ')

        if [[ "$ahead" -gt 0 ]]; then
            # misc (%m) に追加
            hook_com[misc]+="(p${ahead})"
        fi
    }


    # stash 件数表示
    #
    # stash している場合は :SN という形式で misc (%m) に表示
    function +vi-git-stash-count() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        local stash
        stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
        if [[ "${stash}" -gt 0 ]]; then
            # misc (%m) に追加
            hook_com[misc]+=":S${stash}"
        fi
    }
fi


# 表示毎にPROMPTで設定されている文字列を評価する
setopt prompt_subst

# 常に最後の行のみ右プロンプトを表示する
setopt transient_rprompt

# 左側のプロンプトを構成する関数
function left_prompt {
    local formatted_upper_prompt="`prompt_get_path`"$'\n'
    local formatted_under_prompt="`prompt_get_user`@`prompt_get_host`"

    local formatted_tmux_display="`prompt_get_tmux_display`"
    if [ -n "$formatted_tmux_display" ]; then
        formatted_under_prompt="$formatted_under_prompt $formatted_tmux_display"
    fi

    formatted_under_prompt="$formatted_under_prompt `prompt_get_mark`"
    local formatted_prompt=" $formatted_upper_prompt$formatted_under_prompt "

    # 左側のプロンプト
    PROMPT="$formatted_prompt"
}

# 右側のプロンプトを構成する関数
function right_prompt {
    local formatted_prompt="`prompt_get_vcs_info_msg`"

    # 右側のプロンプト
    RPROMPT="$formatted_prompt"
}

#---------------------------------------
# 各種要素を構成する関数
#---------------------------------------
# カレントディレクトリ
function prompt_get_path {
    echo "%F{012}[%~]%f"
}

# ユーザー名
function prompt_get_user {
    echo "%n"
}

# ホスト名
function prompt_get_host {
    echo "%m"
}

# プロンプトマーク
function prompt_get_mark {
    # %(,,)はif...then...else..の意味
    # !はここでは特権ユーザーの判定
    # %B...%bは太字
    # ?はここでは直前のコマンドの返り値
    # %F{color}...%fは色の変更
    echo "%B%(?,%F{green},%F{red})%(!,#,$)%f%b"
}

# VCS情報
function prompt_get_vcs_info_msg {
    local -a messages

    LANG=en_US.UTF-8 vcs_info

    if [[ -z ${vcs_info_msg_0_} ]]; then
        # vcs_info で何も取得していない場合はプロンプトを表示しない
        echo ""
    else
        # vcs_info で情報を取得した場合
        # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
        # それぞれ緑、黄色、赤で表示する
        [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
        [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
        [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

        # 間にスペースを入れて連結する
        echo "${(j: :)messages}"
    fi
}

# tmux情報
function prompt_get_tmux_display {
    if [ -n "$TMUX" ]; then
        echo "%F{blue}`tmux display -p "#I-#P"`%f"
    fi
}

left_prompt
add-zsh-hook precmd right_prompt

#------------------------------------------------------------------------------
# エイリアス
#------------------------------------------------------------------------------
if [ `uname` = "Linux" ]; then
    alias ll="ls -l --color=tty"
    alias la="ls -al --color=tty"
elif [ `uname` = "Darwin" ]; then
    alias ll="ls -lG"
    alias la="ls -alG"
    alias vi="vim"
    alias grep="grep --color"

    # phpenvの設定
    if [ -e ~/.phpenv ]; then
        export PATH=$PATH:$HOME/.phpenv/bin
        eval "$(phpenv init -)"
    fi

    # rbenvの設定
    if which rbenv > /dev/null; then
        eval "$(rbenv init -)";
    fi

    # pyenvの設定
    if which pyenv > /dev/null; then
        eval "$(pyenv init -)";
    fi
fi

#------------------------------------------------------------------------------
# ユーティリティ
#------------------------------------------------------------------------------
# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$* "\007"
}

function color256 {
    for code in {000..255};
    do
        print -nP -- "%F{$code}$code %f"; [ $((${code} % 16)) -eq 15 ] && echo;
    done
}

function color16 {
    echo " On White(47)     On Black(40)     On Default     Color Code"

    echo -e "\
\033[47m\033[1;37m  White        \033[0m  \
\033[40m\033[1;37m  White        \033[0m  \
\033[1;37m  White        \033[0m\
  1;37\
"

    echo -e "\
\033[47m\033[37m  Light Gray   \033[0m  \
\033[40m\033[37m  Light Gray   \033[0m  \
\033[37m  Light Gray   \033[0m  \
37\
"

    echo -e "\
\033[47m\033[1;30m  Gray         \033[0m  \
\033[40m\033[1;30m  Gray         \033[0m  \
\033[1;30m  Gray         \033[0m  \
1;30\
"

    echo -e "\
\033[47m\033[30m  Black        \033[0m  \
\033[40m\033[30m  Black        \033[0m  \
\033[30m  Black        \033[0m  \
30\
"

    echo -e "\
\033[47m\033[31m  Red          \033[0m  \
\033[40m\033[31m  Red          \033[0m  \
\033[31m  Red          \033[0m  \
31\
"

    echo -e "\
\033[47m\033[1;31m  Light Red    \033[0m  \
\033[40m\033[1;31m  Light Red    \033[0m  \
\033[1;31m  Light Red    \033[0m  \
1;31\
"

    echo -e "\
\033[47m\033[32m  Green        \033[0m  \
\033[40m\033[32m  Green        \033[0m  \
\033[32m  Green        \033[0m  \
32\
"

    echo -e "\
\033[47m\033[1;32m  Light Green  \033[0m  \
\033[40m\033[1;32m  Light Green  \033[0m  \
\033[1;32m  Light Green  \033[0m  \
1;32\
"

    echo -e "\
\033[47m\033[33m  Brown        \033[0m  \
\033[40m\033[33m  Brown        \033[0m  \
\033[33m  Brown        \033[0m  \
33\
"

    echo -e "\
\033[47m\033[1;33m  Yellow       \033[0m  \
\033[40m\033[1;33m  Yellow       \033[0m  \
\033[1;33m  Yellow       \033[0m  \
1;33\
"

    echo -e "\
\033[47m\033[34m  Blue         \033[0m  \
\033[40m\033[34m  Blue         \033[0m  \
\033[34m  Blue         \033[0m  \
34\
"

    echo -e "\
\033[47m\033[1;34m  Light Blue   \033[0m  \
\033[40m\033[1;34m  Light Blue   \033[0m  \
\033[1;34m  Light Blue   \033[0m  \
1;34\
"

    echo -e "\
\033[47m\033[35m  Purple       \033[0m  \
\033[40m\033[35m  Purple       \033[0m  \
\033[35m  Purple       \033[0m  \
35\
"

    echo -e "\
\033[47m\033[1;35m  Pink         \033[0m  \
\033[40m\033[1;35m  Pink         \033[0m  \
\033[1;35m  Pink         \033[0m  \
1;35\
"

    echo -e "\
\033[47m\033[36m  Cyan         \033[0m  \
\033[40m\033[36m  Cyan         \033[0m  \
\033[36m  Cyan         \033[0m  \
36\
"

    echo -e "\
\033[47m\033[1;36m  Light Cyan   \033[0m  \
\033[40m\033[1;36m  Light Cyan   \033[0m  \
\033[1;36m  Light Cyan   \033[0m  \
1;36\
"
}
