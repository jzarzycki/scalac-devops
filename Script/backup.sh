#!/bin/bash

show_help() {
	echo "Usage: $0 FILES... [-p PASSWORD] -h HOST@IP_ADDR -d DEST"
}

files=""

while [[ -n "$@" ]]; do
	case $1 in
		"-p")
			shift
			password=$1
			;;
		"-h")
			shift
			host=$1
			;;
		"-d")
			shift
			dest=$1
			;;
		*)
			files+=$1
			files+=" "
	esac
	shift
done

if [[ -z $host ]]; then
	echo "Error: no host specified"
	show_help
	exit 1
elif [[ -z $files ]]; then
	echo "Error: no files specified"
	show_help
	exit 1
elif [[ -z $dest ]]; then
	echo "Error: no destination path specified"
	show_help
	exit 1
fi

if [[ -n $password ]]; then
	pass_opt="-k \"$password\""
fi

echo "tar -cf - $files | gzip --best | openssl aes-256-cbc -salt -pbkdf2 $pass_opt | ssh $host \"cat > $dest\"" | sh -x

