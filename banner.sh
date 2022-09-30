#!/bin/bash

# funkcja zwracająca instrukcję ze sposobem użycia
# znak podajemy bez spacji
function Usage()
{
cat <<EOF
Usage: $0 [-h] [-w] [-c znak] [filename]
 -w ramką otoczone poszczególne słowa
 -c zmień ramkę
 -h pomoc
EOF
}

# wyjście z błędem
function exit_abnormal() {                      
  Usage
  exit 1
}

# flaga kontrolująca czy została wybrana opcja -w
WFLG=0

# domyślna ramka
lower='-'
upper='-'
mid='|'
upcor='.'
locor="'"

# sprawdzamy czy jakaś opcja została wybrana
while getopts ":hwc:" options; do

    case "${options}" in
        h)
            Usage
            exit 0
            ;;
        w)
            WFLG=1
            ;;
        c)
            lower=${OPTARG};
            len=${#lower};
            if [ "$len" -ne "1" ];  then
                exit 1;
            fi
            upper=${OPTARG};
            mid=${OPTARG};
            upcor=${OPTARG};
            locor=${OPTARG};
            CFLG=1
            ;;
        *)
            # jeśli podano niepoprawną opcję
            exit_abnormal
            ;;
    esac
done

# funkcja pomocnicza, która zwraca tekst w odpowiedniej ramce
function banner(){
    # sprzwdzamy czy linia niepusta
    LINE=$1
    if [ "${#LINE}" -eq "0" ]; then
        return
    fi

    # została wybrana opcja -w
    if [ "$WFLG" -eq "1" ];  then
        msg="";
        upper_edge=""
        lower_edge=""
        for WORD in $1
        do  
            msg+="$mid$WORD$mid";
            upper_edge+=$(echo "$WORD" | sed 's/./'$upper'/g'|
                sed 's/^/'$upcor'/g'| sed 's/$/'$upcor'/g')
            lower_edge+=$(echo "$WORD" | sed 's/./'$lower'/g'|
                sed 's/^/'$locor'/g'| sed 's/$/'$locor'/g')
            upper_edge+=" "
            lower_edge+=" "
            msg+=" "
        done
    # nie wybrano opcji -w
    else
        msg="$mid";
        upper_edge="$upcor"
        lower_edge="$locor"
        first=1
        for WORD in $1
        do
            if [ "$first" -eq "1" ]; then
                first=0;
            else
                msg+=" ";
            fi
            msg+="$WORD";
        done
        msg+="$mid";
        upper_edge+=$(echo "$msg" | cut -c3- |
            sed 's/./'$upper'/g'| sed 's/$/'$upcor'/g')
        lower_edge+=$(echo "$msg" | cut -c3- |
            sed 's/./'$lower'/g'| sed 's/$/'$locor'/g')

    fi
    echo "$upper_edge"
    echo "$msg"
    echo "$lower_edge"
}

# jesli podaliśmy plik to trzymamy pod zmienną 
FILENAME=${@:$OPTIND:1}

# czytamy linie z pliku lub ze standardowego wejścia (jeśli nie ma podanego pliku)
while read LINE
do 
    # dla każdej linii wykonujemy funkcję banner
    banner "$LINE"
done < "${FILENAME:-/dev/stdin}"
# jeśli ostatnia linia nie kończy się \n
banner "$LINE"
exit 0