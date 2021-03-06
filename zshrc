if [ -d ~/.zplug ]; then
  export ZPLUG_HOME=~/.zplug
elif command -v brew >/dev/null 2>&1 && [ -d "$( brew --prefix )"/opt/zplug ]; then
  export ZPLUG_HOME="$( brew --prefix )"/opt/zplug
else
  echo "zplug not installed"
  return 1
fi
source $ZPLUG_HOME/init.zsh
export PATH="$ZPLUG_BIN:$PATH"

autoload -Uz compinit
compinit -d ~/.zsh/tmp/zcompdump
zstyle ':completion::complete:*' use-cache 1

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chriskempson/base16-shell", use:"scripts/base16-ocean.sh"
zplug "ndbroadbent/scm_breeze", hook-build:"ln -fs \"$ZPLUG_HOME/repos/ndbroadbent/scm_breeze/git.scmbrc.example\" \"$HOME/.git.scmbrc\"", use:"scm_breeze.sh", defer:2
zplug "b4b4r07/enhancd", use:init.sh
zplug "supercrabtree/k"
zplug "lukechilds/zsh-nvm"
  export NVM_NO_USE=true
  export NVM_AUTO_USE=true
zplug "plugins/ssh-agent", from:oh-my-zsh, defer:2
zplug "plugins/history", from:oh-my-zsh
zplug "plugins/thefuck", from:oh-my-zsh
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"
zplug "Russell91/sshrc", as:command, use:"sshrc"
  export SSHHOME="$HOME/.zsh/configs/sshrc"
zplug "tj/git-extras", use:"etc/git-extras-completion.zsh"
zplug "junegunn/fzf", hook-build:"./install --bin", use:"shell/key-bindings.zsh"
  export PATH="$PATH:$ZPLUG_REPOS/junegunn/fzf/bin"
  export FZF_DEFAULT_COMMAND='ag -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_R_OPTS="--reverse"

# Can manage local plugins
zplug "~/.zsh/configs", from:local, use:"*.zsh", defer:1

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
      echo; zplug install
  fi
fi

# Then, source plugins and add commands to $PATH
zplug load

function ruby_version_info() {
  local version;
  if [ "x$RUBY_VERSION" != "x" ]; then
    version="$RUBY_VERSION"
  else
    if command -v ruby >/dev/null 2>&1; then
      version="ruby-$(ruby -e 'puts RUBY_VERSION')"
    fi
  fi

  [ "x$version" != "x" ] && echo "[♦ $version]"
}

function node_version_info() {
  if command -v node >/dev/null 2>&1; then echo "[⬡ node-$(node -v)]"; fi
}

PROMPT='%F{white}%*%f '$PROMPT
RPROMPT='%F{magenta}$(ruby_version_info)$(node_version_info)%f'
