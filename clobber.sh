#!/usr/local/bin/fish

git checkout -- .
for f in (git status | grep 'posts/' | grep -v "new file" | tr -d '\t')
    rm $f
end
