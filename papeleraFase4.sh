#!/bin/bash

#=======================================================================#
#                       PRÁCTICA PAPELERA - FASE 4                      #                                                                                          
# ESTEBAN CASTILLO LOREN - 2ºASIR - IMPLANTACIÓN DE SISTEMAS OPERATIVOS #
#=======================================================================#

# Limpiar la pantalla
clear

# Definición de variables
papeleraLog=$HOME/.papelera    # Ruta al archivo de registro de la papelera
papelera=$HOME/papelera         # Ruta al directorio de la papelera

# Función para crear la papelera si no existe
crearPapelera(){
    if [ ! -d $papelera ];then  # Verificar si el directorio de la papelera no existe
        mkdir $papelera         # Crear directorio de la papelera
        chmod 777 $papelera     # Establecer permisos 777 para el directorio (permisos amplios)
        clear
        echo "=========================================="
        echo "Se ha creado la papelera."
    fi
}

# Función para enviar archivos a la papelera
enviarPapelera(){
    read -p "Ingresa el nombre del archivo que deseas enviar a la papelera: " archivo
    set -- $archivo
    clear
    if [ $# -eq 0 ];then        # Verificar si no se ingresaron archivos
        echo "ERROR. Debes ingresar al menos un archivo."
    fi
    for i in $archivo;do
        nombreArchivo=$(basename $i)                   # Obtener el nombre del archivo sin la ruta
        if [ -e $papelera/$nombreArchivo ];then       # Verificar si ya existe un archivo con el mismo nombre en la papelera
            echo "ERROR. Ya existe un archivo llamado '$nombreArchivo' en la papelera."
        elif [ -e $i ];then                           # Verificar si el archivo existe
            rutaArchivo=$(realpath $i)                # Obtener la ruta completa del archivo
            mv $i $papelera  2> /dev/null             # Mover el archivo a la papelera y redirigir mensajes de error a /dev/null
            if [ -e $papelera/$nombreArchivo ];then  # Verificar si el archivo se movió correctamente a la papelera
                echo "$nombreArchivo ${rutaArchivo%/*}" >> $papeleraLog  # Registrar el archivo y su ruta en el archivo de registro
                echo "'$nombreArchivo' fue enviado a la papelera"
            else
                echo "Ha ocurrido un error al intentar enviar '$nombreArchivo' a la papelera."
            fi
        elif [ ! -e $i ];then                        # Verificar si el archivo no existe
            echo "ERROR. '$i' no existe"
        fi
    done
}

# Función para restaurar archivos desde la papelera a su ubicación original
restaurarPapelera(){
    read -p "Ingresa el nombre del archivo que deseas restaurar: " archivo
    set -- $archivo
    clear
    if [ $# -eq 0 ];then        # Verificar si no se ingresaron archivos
        echo "ERROR. Debes ingresar al menos un archivo."
    fi
    for i in $archivo;do
        ruta=$(grep -m 1 $i $papeleraLog | awk '{print $2}')  # Obtener la ruta del archivo desde el archivo de registro
        if [ -e "$papelera/$i" ];then
            mv $papelera/$i $ruta 2> /dev/null             # Restaurar el archivo a su ubicación original y redirigir mensajes de error a /dev/null
            if [ -e $ruta/$i ];then                        # Verificar si el archivo se restauró correctamente
                sed -i "/\b${i}\b/d" "$papeleraLog"       # Eliminar la línea correspondiente al archivo restaurado en el archivo de registro
                echo "'$i' fue restaurado en $ruta"
            else
                echo "Ha ocurrido un error al intentar restaurar '$i'."
            fi
        else
            clear
            echo "ERROR. '$i' no se encontró en la papelera"
        fi
    done
}

# Función para eliminar archivos definitivamente de la papelera
eliminarPapelera(){
    read -p "Ingresa el nombre del archivo que deseas eliminar de la papelera: " archivo
    set -- $archivo
    clear
    if [ $# -eq 0 ];then        # Verificar si no se ingresaron archivos
        echo "ERROR. Debes ingresar al menos un archivo."
    fi
    for i in $archivo;do
        if [ -e $papelera/$i ];then
            rm -r $papelera/$i                          # Eliminar el archivo de la papelera (y su contenido si es un directorio)
            if [ ! -e $papelera/$i ];then               # Verificar si el archivo se eliminó correctamente
                sed -i "/\b${i}\b/d" "$papeleraLog"     # Eliminar la línea correspondiente al archivo eliminado en el archivo de registro
                echo "'$i' ha sido eliminado."
            else
                echo "Ha ocurrido un error al intentar borrar '$i'."
            fi
        else
            echo "ERROR. '$i' no se encontró en la papelera"
        fi
    done
}

# Función principal que ejecuta el menú del programa
ejecutarScript(){
    crearPapelera
    while true;do
        echo "=========================================="
        echo "[1] Enviar archivo a la papelera"
        echo "[2] Restaurar archivo de la papelera"
        echo "[3] Borrar de la papelera"
        echo "[4] Salir"
        echo "=========================================="
        echo  
        read -p "Elige una opción: " opcion
        case $opcion in
            1)
                enviarPapelera;;
            2)
                restaurarPapelera;;
            3)
                eliminarPapelera;;
            4)
                clear
                exit 0;;
            *)
                clear
                echo "ERROR. Selecciona una de las opciones disponibles [1-4]."
        esac
    done
}

# Ejecuta la función principal
ejecutarScript
