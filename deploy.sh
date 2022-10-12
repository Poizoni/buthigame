#!/usr/bin/env sh

set -e

npm run build

cd dist

git init
git add -A 
git commit -m 'V7 bug fixes Deployment'
git push -f git@github.com:Poizoni/ButhiGame.git master:gh-pages

cd -