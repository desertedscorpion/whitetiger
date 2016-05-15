#!/bin/bash

WORK_DIR=$(mktemp -d) &&
    pass git ls-files | sort --unique > ${WORK_DIR}/all.txt &&
    git log --pretty=format: --name-only --since="${@}" | sort --unique > ${WORK_DIR}/recent.txt &&
    OLDIES=$(diff --new-line-format="" --unchanged-line-format="" ${WORK_DIR}/all.txt ${WORK_DIR}/recent.txt | sort --unique) &&
    if [ -z "${OLDIES}" ]
    then
	echo There are no expired credentials. &&
	    true
    else
	for OLD in ${OLDIES}
	do
	    OLD_PASSWORD=$(pass show ${OLD}) &&
		read -p "Credential \"${OLD}\" with value \"${OLD_PASSWORD}\" has expired.  (S)kip (I)nsert (E)dit (G)enerate (R)m? S " ACTION &&
		case ${ACTION} in
		    I)
			pass insert ${OLD} &&
			    true
			;;
		    E)
			pass edit ${OLD} &&
			    true
			;;
		    G)
			USE_SYMBOLS="default" &&
			    if [ $(echo ${OLD_PASSWORD} | grep "^[A-Za-z0-9]*\$") ]
			    then
				USE_SYMBOLS="--use-symbols" &&
				    true
			    else
				USE_SYMBOLES="" &&
				    true
			    fi &&
			    LENGTH=$(echo ${OLD_PASSWORD} | wc --chars | cut --fields 1 --delimiter " ") &&
			    pass generate ${USE_SYMBOLS} ${OLD} ${LENGTH} &&
			    true
			;;
		    R) pass rm ${OLD} &&
			     true
		       ;;
		    *)
			echo Skipping credential ${OLD} &&
			    true
			;;
		    case &&
		true
	done &&
	    true
    fi &&
    true
