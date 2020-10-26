#!/usr/local/bin/fish

git checkout -- .
for f in (git status | grep 'posts/' | grep -v "new file: " | grep -v "modified:" | tr -d '\t')
    rm $f
end
