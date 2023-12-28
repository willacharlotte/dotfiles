# MY FIRST ATTEMPT AT A PLUGIN LMAO BE GENTLE

# declare ZGP vars
declare -x ZGP_IS_GIT
declare -x ZGP_BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
declare -ix ZGP_STATUS_UNTRACKED=0
declare -ix ZGP_STATUS_STAGED=0
declare -ix ZGP_STATUS_UNSTAGED=0

# assign ZGP_IS_GIT a value
git rev-parse --is-inside-work-tree > /dev/null 2> /dev/null
if [[ $? -eq 0 ]]; then
  ZGP_IS_GIT=true
else
  ZGP_IS_GIT=false
fi

# parse porcelain status into STATUSES array
declare STATUS_RAW=$(git status --porcelain 2> /dev/null)
IFS=$'\n' read -rd '' -A STATUSES <<<"$STATUS_RAW"
unset STATUS_RAW

# calculate ZGP_STATUS_* values 
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
# echo "is git: $ZGP_IS_GIT"
# echo "branch: $ZGP_BRANCH"
# echo "untracked: $ZGP_STATUS_UNTRACKED"
# echo "staged: $ZGP_STATUS_STAGED"
# echo "unstaged: $ZGP_STATUS_UNSTAGED"

# TODO unset vars in zsh closing function thing
# unset ZGP_IS_GIT
# unset ZGP_BRANCH
# unset ZGP_STATUS_UNTRACKED
# unset ZGP_STATUS_STAGED
# unset ZGP_STATUS_UNSTAGED

