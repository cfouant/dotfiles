# ~/.bashrc
# vim:ft=sh
# DISCLAIMER: i am a bash noob

function bashrc_home_bin_path {
    # if there is a $HOME/bin folder, then add it to PATH
    if [[ (! $PATH =~ "$HOME/bin") && -d "$HOME/bin" ]]; then
        PATH="$PATH:$HOME/bin"
    fi
}

# shared bash history
shopt -s histappend
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=9001
export HISTFILESIZE=9001
export PROMPT_COMMAND='history -a; history -c; history -r'

shopt -s cdspell
if [[ $BASH_VERSION > 4 ]]; then
    shopt -s dirspell
    shopt -s checkjobs
fi

# stop the terminal from grabbing CTRL-s so i can forward- and reverse-search
stty -ixon

which sw_vers > /dev/null 2>&1
OSX=$?
# if this is not OS X
if [[ $OSX != 0 ]]; then

    # load /etc/bashrc
    if [[ -f "/etc/bashrc" ]]; then
        . /etc/bashrc
    fi

fi

# if this is OS X
if [[ $OSX == 0 ]]; then

    bashrc_home_bin_path

    alias ls='ls -G' # ls with colors
    alias which='which -a' # mac/bsd 'which'

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

    if [[ -f ~/.timezone ]]; then
        source ~/.timezone
    fi

fi

# include RVM, if RVM is installed
if [[ -d "$HOME/.rvm" ]]; then
    PATH=$PATH:$HOME/.rvm/bin
fi

# modify the manpath so man will pick up my man pages too
# this needs to go after rvm
# if [[ -d "$HOME/.man" ]]; then
#     if [[ ! "$(manpath -q)" =~ "$HOME/.man" ]]; then # not sure why i can't put this into one if-statment
#         export MANPATH="$(manpath -q):$HOME/.man"
#     fi
# fi
# WHY DOESN'T THIS WORK?! this is stupidly complicated
# i still think it's an ordering/timing issue (being loaded before something else, etc)

# check to see if tmux is installed
which tmux > /dev/null 2>&1
TMUX=$?
# if tmux is installed
if [[ $TMUX == 0 ]]; then

    # source tmux bash completion, if it exists
    tmux_completion=$(find /usr/share/**/tmux-* -name bash_completion_tmux.sh 2> /dev/null)
    if [[ -f $tmux_completion ]]; then
        source $tmux_completion
    fi

fi

export EDITOR='vim'
export PAGER='less'

alias l='ls'        # catch
alias s='ls'        # all
alias sl='ls'       # the
alias xit='exit'    # typos
alias ll='ls -lah'
alias tree='tree -C'
alias mv='mv -i'
alias cp='cp -i'
alias mkdir='mkdir -pv'
alias grepr='grep --color=always'
alias lessr='less --RAW-CONTROL-CHARS'
alias tiga='tig --all'
alias tigl='tig $(git branch | sed -e "s/[\*\ ]//g")' # local branches
alias vim='vim -p'
alias wq="cowsay you\'re not in vim, bro"
alias q="cowsay you\'re not in vim, bro"

# TODO: alias some very common vim commands to spit out a random cowsay through lolcat
# TODO: a couple functions for simple shell outputs (ls, cat, etc) to pipe through lolcat

alias git='hub' # hook into hub

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
alias girt='git' # typo catch

# things that i edit often
alias vimrc='$EDITOR ~/.vimrc'
alias gitconfig='$EDITOR ~/.gitconfig'
alias bashrc='$EDITOR ~/.bashrc'

if [[ -f ~/.bash_colors ]]; then
    source ~/.bash_colors
fi

# source bash-completion files
for f in ~/.completion/**; do source $f; done

# good prompt article: http://www.askapache.com/linux/bash-power-prompt.html
PS1="$COLOR_YELLOW\W$COLOR_RESET \
\$(\git branch 2> /dev/null | grep -e '^\* ' | sed 's/^..\(.*\)/| $COLOR_BOLD_LIGHT_CYAN\1$COLOR_RESET /')\
$COLOR_LIGHT_PURPLE=>$COLOR_RESET "
PS2="$COLOR_LIGHT_GREEN-->$COLOR_RESET "

# cleanup
unset bashrc_home_bin_path TMUX tmux_completion OSX ps1_sym ps2_sym ps1_div f
