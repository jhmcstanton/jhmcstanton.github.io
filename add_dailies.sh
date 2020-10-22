#!/usr/local/bin/fish

for f in posts/music/daily/*.markdown posts/music/daily/*.ly
    git add $f
end

./clobber.sh
