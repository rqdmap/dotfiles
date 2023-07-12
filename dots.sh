#!/bin/zsh

SCRIPTS_PATH='scripts'

source $SCRIPTS_PATH/files.sh


function usage(){
	cat << EOF
Usage: $0 <operation>
operations:
	backup [git message]		Rsync files to dotfiles folder
	deploy						Create symlinks to dotfiles folder
EOF
	exit 1
}

if [ -z "$1" ]; then
	usage
fi

case $1 in
    backup)
		source $SCRIPTS_PATH/backup.sh
		;;
	deploy)
		source $SCRIPTS_PATH/deploy.sh
		;;
	*)
		usage
		;;
esac

