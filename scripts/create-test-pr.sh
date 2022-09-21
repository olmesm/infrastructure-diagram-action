#!/usr/bin/env bash

DIR="_documentation/diagrams"
FILE_TEMPLATE="diagram.example.py"
DATE_STR="`date '+%Y-%m-%d-%Hh%Mm'`"
BRANCH="test-pr-$DATE_STR"
FILE_OUTPUT=`echo $FILE_TEMPLATE | sed "s|example|$DATE_STR|"`

git checkout -b $BRANCH

echo "# Generated from $DIR/$FILE_TEMPLATE
" > $DIR/$FILE_OUTPUT
sed "s|\.\.\.|$DATE_STR|" $DIR/$FILE_TEMPLATE >> $DIR/$FILE_OUTPUT

git add .
git commit -m "Test $DATE_STR"
git push origin $BRANCH

open https://github.com/olmesm/infrastructure-diagram-action/pull/new/$BRANCH