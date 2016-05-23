# vi mode
set -o vi

BASETITLE="\[\e]0;\u@\H `uname -m -r -s`\007\]"
SCREEN_TITLE='\[\ek\h\e\\\]'
ST=''

case $TERM in
  rxvt*)
    TITLEBAR=$BASETITLE
    ;;
  xterm*)
    TITLEBAR=$BASETITLE
    ;;
  screen*)
    TITLEBAR=$BASETITLE
    ST=$SCREEN_TITLE
    ;;
  *)
    TITLEBAR=''
    ;;
esac

# If running interactively, then:
if [ "$PS1" ]; then
  C_RESET='\[\e[0m\]'
  C_BLACK='\[\e[30m\]'
  C_RED='\[\e[31m\]'
  C_GREEN='\[\e[32m\]'
  C_YELLOW='\[\e[33m\]'
  C_BLUE='\[\e[34m\]'
  C_PURPLE='\[\e[35m\]'
  C_CYAN='\[\e[36m\]'

  PS1="${ST}${TITLEBAR}${C_GREEN}\u${C_RESET}@${C_YELLOW}\h${C_RESET}:${C_CYAN}\w${C_RESET}[${C_BLUE}\t${C_RESET}](${C_RED}\j${C_RESET},${C_PURPLE}\$?${C_RESET})${C_YELLOW}\$${C_RESET} "

  alias ls='ls -F'
fi

export EDITOR=vi
export EMAIL=pdzwart@atlassian.com
export LESS="--LONG-PROMPT"
export MAVEN_OPTS="-XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+DisableExplicitGC -XX:+UseParallelOldGC"
export GIT_PAGER=""

git_recapitate () {
  local branch="${1:-master}"

  git checkout -b recapitate && git checkout $branch && git merge recapitate && git push && git branch -d recapitate
}

d () {
  local raw=$((($RANDOM % $1) + 1))
  local modifier=${2:-0}
  local modified=$(($raw + $modifier))

  echo -e "$modified ($raw, $modifier)"
}

cvs_up () {
  cvs update
}

svn_up () {
  svn upgrade
  svn update
}

git_up () {
  git pull && git submodule init && git submodule update
}

hg_up () {
  hg pull && hg update
}

# Source Update
supdate () {
  local src_home="$HOME/Documents/Source"

  pushd $src_home

  for dir in *
  do
    if [ -d $dir ]
    then
      pushd $dir

      for vdir in cvs svn git hg
      do
        if [ -d $vdir ]
        then
          pushd $vdir

          for sdir in *
          do
            if [ -d $sdir ]
            then
              pushd $sdir

              echo -e "\nUPDATING ${src_home}/${dir}/${vdir}/${sdir}\n"
              ${vdir}_up

              popd
            fi
          done

          popd
        fi
      done

      popd
    fi
  done

  popd
}

gv2png () {
  local gv=$1
  shift
  local png=$1
  shift

  dot -Tpng -o$png $gv
}

gv2open () {
  local filename=$1
  shift

  local png=`echo $filename | cut -d \. -f 1-1`.png

  gv2png $filename $png

  open $png
}
