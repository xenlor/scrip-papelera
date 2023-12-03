#!/bin/bash
#papeleraFase2 - Esteban Castillo Loren
papelera=$HOME/papelera
papeleraLog=$HOME/.papelera

if [ ! -d $papelera ];then
    mkdir $papelera
    chmod 777 $papelera
    echo "Se ha creado la papelera."
fi
if [ $# -eq 0 ];then
    echo "Debes ingresar al menos un archivo."
    exit 1
fi
for i in $@;do
    nombreArchivo=$(basename $i)                                                       
        if [ -e $papelera/$nombreArchivo ];then                                            
            echo "ERROR. Ya existe un archivo llamado '$nombreArchivo' en la papelera."
        elif [ -e $i ];then                                                                 
            rutaArchivo=$(realpath $i)                                 
            mv $i $papelera  2> /dev/null
            if [ -e $papelera/$nombreArchivo ];then                                
                echo "$nombreArchivo ${rutaArchivo%/*}" >> $papeleraLog                                                           
                echo "'$nombreArchivo' fue enviado a la papelera"
            else
                echo "Ha ocurrido un error al enviar '$nombreArchivo' a la papelera."
            fi
        elif [ ! -e $i ];then                                                             
            echo "ERROR. '$i' no existe"
        fi
    done