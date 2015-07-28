autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn # You can add hg too if needed: `git hg`
zstyle ':vcs_info:git*' formats ' %b'
zstyle ':vcs_info:git*' actionformats ' %b|%a'

# Only show username if not default
[[ ( $USER != "tristankonolige" ) && ( $USER != "tkonolige" ) && ( $USER != "tristan" ) ]] && local username='%n '

# Fastest possible way to check if repo is dirty
git_dirty() {
  if [[ "${PWD##/Network/ipi}" = "${PWD}" ]]; then
    git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo '%F{green}!%f'
  else
    echo "%F{red} _%f"
  fi
}

git_branch() {
  if [[ ! -f ".no_git_status" ]]; then
    D=`git rev-parse --git-dir 2>/dev/null`
    if [[ $? = 0 ]]; then
      if [[ -d $D/annex ]]; then
        echo ' %F{yellow}^%f'
      else
        vcs_info
        print -P '%F{magenta}${vcs_info_msg_0_}%f'
      fi
    fi
  fi
}

function is_ssh {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
      echo "%{$fg[red]%}@%{$reset_color%}%{$fg[yellow]%}$(box_name)%{$reset_color%} "
    else
        echo ""
    fi
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname
}



precmd() {
  print -P '\n$(is_ssh)%{$fg_bold[green]%}%~%{$reset_color%}`git_branch``git_dirty` $username%f'
}

# check for iterm2
ps -p$PPID -o ppid | tail -1 | xargs ps | tail -1 | grep iTerm2
if [ $? -eq 0 ]; then
  PROMPT=' '
else
  PROMPT='> '
fi
