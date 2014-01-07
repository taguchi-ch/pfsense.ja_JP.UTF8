#!/bin/sh

# awk ' /msgid/ {flag=1;next} /msgstr/{flag=0} flag { print }' ./usr/local/share/locale/ja_JP.UTF8/LC_MESSAGES/pfSense.po |\
#  sed 's/^"//;s/"$//;s/\[//g;s/\]//g;s/%s/foo.s/g' |\
# while read line ; do
# echo "$line"
# trs {en=ja} "$line"
# sleep 1
# done

awk ' /msgid/ {flag=1;next} /msgstr/{flag=0} flag { print }' ./usr/local/share/locale/ja_JP.UTF8/LC_MESSAGES/pfSense.machine.po |\
sed 's/^"//;s/"$//;s/\[/((/g;s/\]/))/g;s/%s/foo.s/g' |\
sed 's/\!/\\\!/g;s/\$/\\\$/g;s/\`/\\\`/g;s/\\/\\\\/g;' |\
while read line ; do
echo "$line" | sed 's/((/\[/g;s/))/\]/g'
trs {en=ja} "$line" | sed 's/((/\[/g;s/))/\]/g'
echo '--'
sleep .25
done

