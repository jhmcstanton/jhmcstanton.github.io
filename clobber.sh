#!/usr/local/bin/fish

git checkout -- .
for f in (git status | grep 'posts/' | tr -d '\t')
    rm $f
end
