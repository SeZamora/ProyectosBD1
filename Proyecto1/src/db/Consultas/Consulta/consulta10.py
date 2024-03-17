from db.conexion import crear_conexion
from db.scripts.scripts import script_consulta10
import json

def Consulta10():
    conexion = crear_conexion()
    try:
        conexion.begin()
        cursor = conexion.cursor()
        consulta = script_consulta10()

        cursor.execute(consulta)
        resultados = cursor.fetchall()
        resultados_json = []

        # Procesar cada fila y crear un objeto JSON
        for fila in resultados:
            # Convertir la cadena JSON en un diccionario
            fila_dict = json.loads(fila[0])
            resultados_json.append(fila_dict)
        

        conexion.commit()
        return resultados_json
    except Exception as e:
        conexion.rollback()
        return f"Error inesperado: {e}"
    finally:
        if cursor:
            cursor.close()
        if conexion:
            conexion.close()