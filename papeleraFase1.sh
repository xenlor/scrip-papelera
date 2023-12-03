#!/bin/bash
#papeleraFase1 - Esteban Castillo Loren
if [ ! -d $HOME/papelera ];then #Verifica que la carpeta 'papelera' exista en el home del usuario.
    mkdir $HOME/papelera
    chmod 777 $HOME/papelera
    echo "Se ha creado la papelera."
fi
if [ $# -eq 0 ];then
    echo "Debes ingresar un archivo"
fi
for i in $@;do
    if [ -e $i ];then # Si existe el archivo, lo mueve a la papelera.
        mv $i $HOME/papelera/
        echo "$i fue enviado a la papelera"
    elif [ ! -e $i ];then # Si no existe envia un mensaje diciendo que el archivo no existe
        echo "$i no existe"
    fi
done