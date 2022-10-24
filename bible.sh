#!/bin/bash
# https://github.com/ydche3/bibleshell.git

# Proxy Server
#export http_proxy=http://127.0.0.1:7890
#export https_proxy=$http_proxy

version=cunps

while getopts 'v:' OPTION; do
  case "$OPTION" in
    v)
      version=${OPTARG}
      ;;
  esac
done
shift "$(($OPTIND - 1))"

locate=$( echo $@ | sed -E 's/\s{1,}/\./g' )
ulocate=$( echo ${locate} | tr '[:lower:]' '[:upper:]' )

response=$( curl -X GET https://wd.bible/bible/chapterhtml/${version}/${locate} | sed s/"content"/\\n/g | tail -1 )

echo ${response} | sed -E s/${locate}\|${ulocate}\|\"\|"u003".\|"class"\|"href"\|"mark"\|"div"\|"id"\|"bible"\|"verse"\|"."${version}\|"="\|":"\|"微读圣经"\|"200"//g | sed -E 's/\/h5//g' | sed -E 's/\\|\}|\/|\||\.([0-9]|[1-9][0-9]|100)//g' | sed -E 's/","/\n/g' | sed -E 's/h5/\n\n/g' |  sed -E 's/[a-zA-Z]//g' | sed -E 's/\s{5,}|\,/\n/g' | sed -E 's/\s{1,4}//g'
