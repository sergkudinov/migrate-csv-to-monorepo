#!/bin/sh

# 1. Configure
repos=(
  https://github.com/adaltas/node-csv
  https://github.com/adaltas/node-csv-generate
  https://github.com/adaltas/node-csv-parse
  https://github.com/adaltas/node-csv-stringify
  https://github.com/adaltas/node-stream-transform
)
monorepoDir=node-csv
packagesDir=packages
# 2. Initialize a new repository
rm -rf $monorepoDir && mkdir $monorepoDir && cd $monorepoDir
git init .
# 3. Migrate repositories
for repo in ${repos[@]}; do
  # 3.1. Get the package name
  splited=(${repo//// })
  package=${splited[${#splited[@]}-1]/node-/}
  # 3.2. Rewrite commit messages via a temporary repository
  rm -rf $TMPDIR/$package && mkdir $TMPDIR/$package && git clone $repo $TMPDIR/$package
  git filter-repo \
    --source $TMPDIR/$package \
    --target $TMPDIR/$package \
    --message-callback "return b'chore(${package}): ' + message"
  # 3.3. Merge the repository into monorepo
  git remote add -f $package $TMPDIR/$package
  git merge --allow-unrelated-histories $package/master -m "chore(${package}): merge branch 'master' of ${repo}"
  # 3.4. Move repository files to the packages folder
  mkdir -p $packagesDir/$package
  files=$(find . -maxdepth 1 | egrep -v ^./.git$ | egrep -v ^.$ | egrep -v ^./${packagesDir}$)
  for file in ${files// /[@]}; do
    mv $file $packagesDir/$package
  done
  git add .
  git commit -m "chore(${package}): move all package files to ${packagesDir}/${package}"
done
# 4. Add the monorepo files
cp -R ../import-files/ .
git add .
git commit -m "chore: add monorepo files"
# 5. Remove outdated packages' files
rm $packagesDir/**/LICENSE
rm $packagesDir/**/CONTRIBUTING.md
rm $packagesDir/**/CODE_OF_CONDUCT.md
rm -rf $packagesDir/**/.github
git add .
git commit -m "chore: remove outdated packages files"
