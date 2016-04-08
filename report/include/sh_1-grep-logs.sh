#!/usr/bin/env bash
# ______________________________________________________________________________
#
# DVG001 -- Introduktion till Linux och små nätverk
#                              Inlämningsuppgift #4
# Author:   Jonas Sjöberg
#           tel12jsg@student.hig.se
# Date:     2016-04-06 -- 2016-04-11
# ______________________________________________________________________________

# Program för att hitta alla loggar som nämner datorns IP-adress i klartext.

# Avsluta om programmet körs med otillräckliga rättigheter.
if [ "$EUID" -ne 0 ]
then 
    printf "Must be run with root privileges -- exiting.\n" 2>&1
    exit 126
fi

# Ta reda på aktuell IP-adress.
# Detta är inte särskilt bra metod, förutsätter bl.a. att eth0 används.
IP_ADRESS=$(ip -oneline -family inet addr show eth0 | awk '{print $4}')
IP_ADRESS=${IP_ADRESS//\/[0-9][0-9]}
[ -n "$IP_ADRESS" ] || { printf "IP == NULL -- exiting.\n" 2>&1 ; exit 1 ; }

# Hitta alla textfiler i '/var/log' och sök i dem efter den aktuella IP-adressen.
# Filtypen bedöms efter "magic header bytes" som läses av kommandot "file".
sudo find /var/log -type f | while IFS= read -r f
do 
    [ -f "$f" ] || continue

    if file --brief --mime -- "$f" | grep text >/dev/null 
    then
        printf "Searching through file \"%s\"\n" "$f"
        grep --ignore-case           \
             --dereference-recursive \
             --line-number           \
             --with-filename         \
             --extended-regexp       \
             --color=always          \
             "$IP_ADRESS" "$f"
    fi
done

exit $?
