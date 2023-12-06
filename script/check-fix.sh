#!/bin/sh

#!/bin/sh

make fix

git config --global user.name "CI"
git config --global user.email CI@brain.im

echo "------ check fix ------"
git status
echo "------ check fix ------"

git commit -a -m 'CI: make fix'

if [ "$?" = "0" ]; then
    exit 1
else
    exit 0
fi
