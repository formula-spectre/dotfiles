#!/bin/env bash

echo "copying files.."
FILES=$(ls config)
LOCAL $(ls local)
for file in $FILES; do
	cp $file ~/.config/

done

for file in $LOCAL; do
	cp $file ~/.local/
done
