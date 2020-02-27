# Always fail the script if anything bad happens
set -e

# Boot selenium

java -Dwebdriver.firefox.bin=.bin/firefox/firefox -jar .bin/selenium.jar &
selenium_pid="$!"
trap "kill $selenium_pid" SIGINT SIGTERM EXIT

# Temporarily store uncommited changes
git stash

# Verify correct branch
git checkout develop

# Build new files
stack exec site clean
stack exec site build --use-water-profiles --compress-jpgs

# Get previous files
git fetch --all
git checkout -b master --track origin/master || git checkout -b master

# Overwrite existing files with new files
cp -a _site/. .

# Commit
git add -A
git commit -m "Publish."

# Push
git push origin master:master

# Restoration
git checkout develop
git branch -D master
git stash pop

kill "$selenium_pid"
