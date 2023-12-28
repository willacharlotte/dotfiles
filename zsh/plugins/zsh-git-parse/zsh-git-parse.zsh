# MY FIRST ATTEMPT AT A PLUGIN LMAO

# parse porcelain status into STATUSES array
declare STATUS_RAW=$(git status --porcelain 2> /dev/null)
IFS=$'\n' read -rd '' -A STATUSES <<<"$STATUS_RAW"
unset STATUS_RAW

# define ZGP vars
declare -x ZGP_BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
declare -ix ZGP_STATUS_UNTRACKED=0
declare -ix ZGP_STATUS_STAGED=0
declare -ix ZGP_STATUS_UNSTAGED=0

# populate ZGP vars
for STATUS in "${STATUSES[@]}";
do
  local CODE="${STATUS::2}"
  if [[ $CODE =~ ^[[:space:]].$ ]]; then
    ZGP_STATUS_UNSTAGED+=1
  fi
  if [[ $CODE =~ ^.[[:space:]]$ ]]; then
    ZGP_STATUS_STAGED+=1
  fi
  if [[ $CODE =~ ^[?][?]$ ]]; then
    ZGP_STATUS_UNTRACKED+=1
  fi
done
unset STATUSES

# for debugging purposes
# echo "branch: $ZGP_BRANCH"
# echo "untracked: $ZGP_STATUS_UNTRACKED"
# echo "staged: $ZGP_STATUS_STAGED"
# echo "unstaged: $ZGP_STATUS_UNSTAGED"

# TODO unset vars in zsh closing function thing
# unset ZGP_STATUS_UNTRACKED
# unset ZGP_STATUS_STAGED
# unset ZGP_STATUS_UNSTAGED

