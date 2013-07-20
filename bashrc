# ~/.bashrc

function bashrc_home_bin_path {
    # if there is a $HOME/bin folder, then add it to PATH
    if [[ (! $PATH =~ "$HOME/bin") && -d "$HOME/bin" ]]; then
        export PATH="$PATH:$HOME/bin"
    fi
}

shopt -s cdspell

which sw_vers > /dev/null 2>&1
OSX=$?
# if this is not OS X
if [[ $OSX != 0 ]]; then

    # load /etc/bashrc
    if [[ -f "/etc/bashrc" ]]; then
        . /etc/bashrc
    fi

    shopt -s dirspell
    shopt -s checkjobs

    ps1_sym=$'\u25b6'
    ps2_sym=$'\u21b3'

fi

# if this is OS X
if [[ $OSX == 0 ]]; then

    bashrc_home_bin_path

    alias ls='ls -G' # ls with colors
    alias which='which -a' # mac 'which'

    ps1_sym='=>'
    ps2_sym='->'

fi

# if this is a raspberry pi or a nitrous.io box
if [[ -f /boot/config.txt || $(whoami) == "action" ]]; then

    bashrc_home_bin_path

    # basic aliases
    alias ls='ls --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias grep='grep --color=auto'
    alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

fi

# source RVM, if RVM is installed
if [[ -d "$HOME/.rvm" ]]; then
    source $HOME/.rvm/scripts/rvm
fi

# modify the manpath so man will pick up my man pages too
# this needs to go after rvm
#if [[ -d "$HOME/.man" ]]; then
#    if [[ ! "$(manpath -q)" =~ "$HOME/.man" ]]; then # not sure why i can't put this into one if-statment
#        export MANPATH="$(manpath -q):$HOME/.man"
#    fi
#fi
# WHY DOESN'T THIS WORK?! this is stupidly complicated
# i still think it's an ordering/timing issue (being loaded before something else, etc)

# check to see if tmux is installed
which tmux > /dev/null 2>&1
TMUX=$?
# if tmux is installed
if [[ $TMUX == 0 ]]; then

    # source tmux bash completion, if it exists
    tmux_completion=$(find /usr/share/ -name bash_completion_tmux.sh 2> /dev/null)
    # this is not particularly efficient
    if [[ -f $tmux_completion ]]; then
        source $tmux_completion
    fi

fi

export EDITOR='vim'

alias ll='ls -lah'
alias tree='tree -C'
alias mkdir='mkdir -pv'
alias grepr='grep --color=always'
alias lessr='less --RAW-CONTROL-CHARS'
alias tiga='tig --all'
alias tigl='tig $(git branch | sed -e "s/[\*\ ]//g")' # local branches
alias vim='vim -p'
alias f='figlet'
alias c='cowsay'

function g {
    if [[ $# > 0 ]]; then
        git $@
    else
        git status --short --branch
    fi
}

# git aliases
alias gg='git status'
alias gd='git diff'
alias ga='git add'
alias gap='git add --patch'
alias gc='git commit'
alias gdw='git diff --word-diff'

# things that i edit often
alias vimrc='$EDITOR ~/.vimrc'
alias gitconfig='$EDITOR ~/.gitconfig'
alias bashrc='$EDITOR ~/.bashrc'

if [[ -f ~/.bash_colors ]]; then
    source ~/.bash_colors
fi

# good prompt article: http://www.askapache.com/linux/bash-power-prompt.html
PS1="$COLOR_YELLOW\h$COLOR_RESET \W\$(\git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/($COLOR_BOLD_LIGHT_CYAN\1$COLOR_RESET)/') $COLOR_BOLD_LIGHT_PURPLE$ps1_sym$COLOR_RESET "
PS2="$COLOR_BOLD_LIGHT_GREEN$ps2_sym$COLOR_RESET "

# cleanup
unset bashrc_home_bin_path TMUX OSX ps1_sym ps2_sym
