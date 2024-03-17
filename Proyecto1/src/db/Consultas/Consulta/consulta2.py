from db.conexion import crear_conexion
from db.scripts.scripts import script_consulta2
from decimal import Decimal
import json

def Consulta2():
    conexion = crear_conexion()
    try:
        conexion.begin()
        cursor = conexion.cursor()
        consulta = script_consulta2()

        cursor.execute(consulta)
        resultados = cursor.fetchall()
        
        # Convertir la cadena de resultados a un objeto JSON
        resultados_json = json.loads(resultados[0][0])
        

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