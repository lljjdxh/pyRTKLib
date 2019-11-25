#!/usr/bin/env bash

usage()
{
    echo "usage: $0 -v pyenv-s startDOY -e endDOY -y YYYY -r RxType -g GNSS [-h]"
}

if [ $# -ne 12 ]; then
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
		-g) shift
			GNSS=$1 ;;
        *)  usage
            exit 1
    esac
    	shift
done

echo ${PYVENV}
echo ${STDOY}
echo ${ENDOY}
echo ${YYYY}
echo ${RXTYPE}

#source the common shell script
source ${HOME}/amPython/${PYVENV}/scripts/common.sh
# ${PYRTKPROC} -h


for curDOY in $(seq $STDOY $ENDOY)
do
	DOY=$(leading_zero ${curDOY})
	YY=${YYYY: -2}
	YYDOY=${YY}${DOY}
	# printf ${YY}' '${DOY}' '${YYDOY}

	DIRRIN=${RXTURP}/${RXTYPE}/rinex/${YYDOY}
	DIRIGS=${RXTURP}/${RXTYPE}/igs/${YYDOY}

	echo 'DIRRIN = '${DIRRIN}
	echo 'DIRIGS = '${DIRIGS}

	if [ ${RXTYPE} = 'ASTX' ]
	then
		for i in "${!gnss[@]}"
		do
			# create names for obs / nav file of rover station
			ROVEROBS=${gnssMarker[i]}${DOY}'0.'${YY}O
			ROVERNAV=${gnssMarker[i]}${DOY}'0.'${YY}${gnssNavExt[i]}

			echo ${gnss[i]}' -> '${ROVEROBS}' '${ROVERNAV}

			# create names for igs downloaded nav file

		done
	fi
done

# return to git branch we had in original shell
cd ${PYHOMEDIR}
printf '\n'
if [ ${CURBRANCH} != 'master' ]
then
	${GIT} checkout ${CURBRANCH}
fi
