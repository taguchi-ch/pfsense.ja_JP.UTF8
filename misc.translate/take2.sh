#!/bin/sh

# machine translation for pfSense gettext .po files using google translate
# compared to awk(1), this is REALLY slow in shell, but way easier to work with.

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }

_translate() {
# function to translate from raw line
echo "${*}"
}

_printprocessed() {
echo "$*"
 # |\
 # try awk '{ gsub("foo.nl",/\\n/);print }'
}

_strippo() {
# strips msgid "", and leading/trailing "
echo "$*" |\
  try sed 's/^msgid "//;s/^msgstr "//;s/"$//;' |\
  try sed 's#<br/>#foo.br#g'
}

## vars

TARGETLANG="${2:-jp}"

## action

# print .po "header", (email style)
try sed '/^$/q' "$1"

####################
# line by line, everything after the "header", (email style)
try sed '1,/^$/d' "$1" | try awk '{ gsub(/\\n/,"foo.nl");print }' |\
while read line ; do

#while line is still quoted, strip leading/trailing whitespace,
_i="`echo ${line} | try sed 's/^[ \t]*//'`"

# if line is empty, print it
echo "${_i}" | grep -v '.'
# if line is comment, '^#', print it
echo "${_i}" | grep '^#'

if echo "${_i}" | grep -lq '^msgid' ; then
   _src=1
    echo "${_i}"
   _transline=""
   _transline="`_strippo ${_transline}${_i}`"
elif echo "${_i}" | grep -lq '^msgstr' ; then
  _src=0
  # TRANSLATE '_transline'
  echo "msgstr \"${_transline}\""
elif echo "${_i}" | grep -lq '^"' ; then
  if [ ${_src} = 1 ] ; then
    echo "${_i}"
    _transline="`_strippo ${_transline}${_i}`"
  #  _transline="${_transline}${_i}"
  fi
fi

# awk ' /msgid/ {flag=1;next} /msgstr/{flag=0} flag { print }' ./usr/local/share/locale/ja_JP.UT
# F8/LC_MESSAGES/pfSense.machine.po |\
# sed 's/^"//;s/"$//;s/\[/((/g;s/\]/))/g;s/%s/foo.s/g' |\
# sed 's/\!/\\\!/g;s/\$/\\\$/g;s/\`/\\\`/g;s/\\/\\\\/g;' |\
# while read line ; do
# echo "$line" | sed 's/((/\[/g;s/))/\]/g'
# trs {en=ja} "$line" | sed 's/((/\[/g;s/))/\]/g'
# echo '--'
# sleep .25
# done 


#done < "$1"
done
###########

true
