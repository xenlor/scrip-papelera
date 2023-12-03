#!/bin/bash
#restaurar - Esteban Castillo Loren

papelera=$HOME/papelera
papeleraLog=$HOME/.papelera

if [ $# -eq 0 ]
then
    echo "Debes ingresar al menos un archivo"
    exit 1
fi
for i in $@;do
    ruta=$(grep -m 1 $i $papeleraLog | awk '{print $2}')
    if [ -e "$papelera/$i" ];then
        mv $papelera/$i $ruta 2> /dev/null
        if [ -e $ruta/$i ];then
            sed -i "/\b${i}\b/d" "$papeleraLog"
            echo "'$i' fue restaurado en $ruta"
        else
            echo "Ha ocurrido un error al restaurar '$i'."
        fi
    else
        clear
        echo "ERROR. '$i' no se encontró en la papelera"
    fi
done