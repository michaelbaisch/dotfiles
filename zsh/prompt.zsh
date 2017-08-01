autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    echo "%{$fg_bold[blue]%}[$(git_prompt_info)]%{$reset_color%}$(git_prompt_status)"
  fi
}

# Get the status of the working tree
git_prompt_status() {
  
  INDEX=$($git status --porcelain 2> /dev/null)
  if [[ INDEX != "" ]]
  then
    STATUS=""
      # Non-staged
    if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
    elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
    fi
    # Staged
    if $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^R' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_RENAMED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^M' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^A' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_ADDED$STATUS"
    fi
    echo " $STATUS%{$reset_color%}"
  fi
}

# Staged
ZSH_THEME_GIT_PROMPT_STAGED_ADDED="%{$fg[blue]%}A"
ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED="%{$fg[blue]%}M"
ZSH_THEME_GIT_PROMPT_STAGED_RENAMED="%{$fg[blue]%}R"
ZSH_THEME_GIT_PROMPT_STAGED_DELETED="%{$fg[blue]%}D"

# Not-staged
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}M"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}D"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}UU"

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

# This assumes that you always have an origin named `origin`, and that you only
# care about one specific origin. If this is not the case, you might want to use
# `$git cherry -v @{upstream}` instead.
need_push () {
  if [ $($git rev-parse --is-inside-work-tree 2>/dev/null) ]
  then
    number=$($git cherry -v origin/$(git symbolic-ref --short HEAD) 2>/dev/null | wc -l | bc)

    if [[ $number == 0 ]]
    then
      echo " "
    else
      echo " with %{$fg_bold[magenta]%}$number unpushed%{$reset_color%}"
    fi
  fi
}

directory_name() {
  #echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
  echo "%{$fg_bold[cyan]%}%~%\/%{$reset_color%}"
}

battery_status() {
  if [[ $(sysctl -n hw.model) == *"Book"* ]]
  then
    $ZSH/bin/battery-status
  fi
}

export PROMPT=$'\n$(directory_name) $(git_dirty)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%n@%m" "%55<...<%~"
  set_prompt
}
