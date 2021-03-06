#!/bin/bash

usage()
{
    echo "usage: $0 -v pyenv -s startDOY -e endDOY -y YYYY -r RxType [-h]"
}

if [ $# -ne 10 ]; then
    usage
    exit 1
fi

while [ $# -gt 0 ];
do
    case $1 in
		-v)	shift
        	PYVENV=$1 ;;
		-s)	shift
        	STDOY=$1 ;;
        -e) shift
			ENDOY=$1 ;;
    	-y) shift
			YYYY=$1 ;;
        -r) shift
			RXTYPE=$1 ;;
        *)  usage
            exit 1
    esac
    	shift
done

#source the common shell script
source ${HOME}/amPython/${PYVENV}/scripts/common.sh
# ${PYSBFDAILY} -h

for curDOY in $(seq $STDOY $ENDOY)
do
	DOY=$(leading_zero ${curDOY})
	YY=${YYYY: -2}
	YYDOY=${YY}${DOY}
	# printf ${YY}' '${DOY}' '${YYDOY}

	DIRRAW=${RXTURPROOT}/${RXTYPE}/${YYDOY}
	DIRRIN=${RXTURPROOT}/${RXTYPE}/rinex/${YYDOY}
	DIRIGS=${RXTURPROOT}/${RXTYPE}/igs/

	printf '\nCreating daily SBF file for '${YYDOY}'\n'
	cd ${DIRRAW}

	${NICE} ${PYSBFDAILY} --dir=${DIRRAW}  # --overwrite
done

# return to git branch we had in original shell
cd ${PYHOMEDIR}
cleanup
