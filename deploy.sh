#!/bin/bash
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
stack exec site build -- --use-water-profiles --compress-jpgs

# Get previous files
git fetch --all
git checkout -b main --track origin/main || git checkout -b main

# Overwrite existing files with new files
cp -a _site/. .

# Commit
git add -A
git commit -m "Publish."

# Push
git push origin main:main -f

# Restoration
git checkout develop
git branch -D main
git stash pop

kill "$selenium_pid"
