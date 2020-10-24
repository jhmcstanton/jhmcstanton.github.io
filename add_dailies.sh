#!/usr/local/bin/fish

for f in posts/music/daily/*.markdown posts/music/daily/*.ly posts/music/daily/*.mid
    git add $f
end

./clobber.sh
