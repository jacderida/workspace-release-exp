#!/usr/bin/env bash

release-plz update

crates_bumped=""
readarray -t crates < <(git status --porcelain | awk '{if ($1 == "M") print $2}' | \
  xargs -I {} dirname {} | uniq)
for crate in "${crates[@]}"; do
  version=$(cat $crate/Cargo.toml | \
    grep "^version" | awk -F "=" '{ print $2 }' | sed s/\"//g | xargs)
  echo $version
  crates_bumped="${crates_bumped}${crate}-v${version}/"
done

crates_bumped=${crates_bumped%/} # strip off trailing '/' character
commit_message="chore(release): ${crates_bumped}"

git add --all
git commit -m "$commit_message"

echo "Generated release commit: $commit_message"
