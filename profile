export LC_ALL=$LANG
export LANG=en_US.UTF-8
export LANGUAGE=en_US

export ERL_AFLAGS="-kernel shell_history enabled"

# for charlock_holmes
export LDFLAGS="-L/usr/local/opt/icu4c/lib"
export CPPFLAGS="-I/usr/local/opt/icu4c/include"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

export EDITOR=`which code`

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

eval "$(hub alias -s)"

source ~/.alias
