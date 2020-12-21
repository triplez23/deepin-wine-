#!/bin/bash

"/opt/deepinwine/apps/Deepin-WeChat/run.sh">/dev/null 2>&1

start_succ=false

for i in {1..5}
do
	xdotool search --onlyvisible --classname "wechat.exe"
	if [ $? == 0 ]
	then
		start_succ=true
		break
	fi
	sleep 1.5
done

if [ $start_succ == false ]
then
	exit 1
fi

windowclose=false

while :
do
	retval=$(xdotool search --onlyvisible --classname "wechat.exe")
	
	if [ $? != 0 ]
	then
		exit 0
	fi
	
	login=true
	
	for id in $retval
	do
		windowname=$(xdotool getwindowname $id)
		if [ "$windowname" == "Log In" ]
		then
			login=false
		fi
		
		if [ $windowclose == true ] && ([ "$windowname" == "" ] || [ "$windowname" == "ChatContactMenu" ])
		then
			xdotool windowclose $id
		fi
	done
	
	if [ $windowclose == true ]
	then
		exit 0
	fi
	
	if [ $login == true ]
	then
		windowclose=true
	fi
	
	sleep 2
done
