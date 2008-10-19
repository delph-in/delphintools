#!/bin/bash
#
# utils for doing things
#
####################################################################################

usage () {
	echo -n "usage: script [ -c|--count n ] [ -d|--debug ] [ -e|--edges n ]"
	echo -n " [ -l|--limit n ] [ --name <profile> ] [ -p|--processor lkb|pet|lex ]"
	echo " [ -a|--ascii ] < file | skeleton >"
}

logon_get_args () {
	tsdb_options=":error :exit :wait 600"
#	count=1
#	limit=5
#	edges=10000
	while [ $# -gt 0 -a "${1#-}" != "$1" ]; do
		case $1 in
			-a|--ascii)
				ascii=true
				shift 1
			;;
		    -c|--count)
	      		count=$2
	      		shift 2
	      	;;
	      	-d|--debug)
				debug=true
				shift 1
			;;
			-e|--edges)
				edges=$2
				shift 2
			;;
	    	-l|--limit)
	      		limit=$2
	      		shift 2
			;;
			-n|--name)
				name=$2
				shift 2
			;;
			-p|--processor)
				case $2 in
					lex|lkb|pet)
						processor=$2
						shift 2
					;;
					*)
						usage
						exit 1
					esac
            ;;
			*)
				usage
				exit 1
		esac
	done
	
	if [ -z "$1" ]; then 
		usage
		exit 1
	fi
	
	skeleton=$1
	if [ -n "$ascii" ]; then
		if [ "${skeleton#/}" = "$skeleton" ]; then 
			skeleton=$PWD/$skeleton
		fi
		if [ ! -f "$skeleton" ]; then
			echo "ERROR: unable to open '$skeleton'; exit."
			exit 1
		fi
	fi

	if [ -z "$name" ]; then
		name=$(basename $skeleton ".txt")
	fi

	export ascii
	export count
	export debug
	export edges
	export limit
	export name
	export processor
	export skeleton

	export DATE=`date "+%Y-%m-%d"`
	export LOG=$LOGONTMP/$name.fan.log
	export OUTPUT=$LOGONTMP/$name.$DATE.fan
	export XML=$LOGONTMP/$name.$DATE.xml

	export source=$name/smrs
	export transfer=$name/tmrs
	export partial=$name/pmrs
	export generate=$name/gmrs
	export object=$name/omrs
	export igenerate=$name/imrs
	
	if [ -n "$debug" ]; then
		cat 2>&1 <<- DEBUG
		    ;;; skeleton:	$skeleton
			;;; name:		$name
			;;; source:		$source
			;;; transfer:	$transfer
			;;; partial:	$partial
			;;; generate:	$generate
			;;; object:		$object
			;;; limit:		$limit
			;;; edges:		$edges
		DEBUG
	fi
}
