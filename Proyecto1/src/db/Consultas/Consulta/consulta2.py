from db.conexion import crear_conexion
from db.scripts.scripts import script_consulta2
from decimal import Decimal
import json

def Consulta2():
    conexion = crear_conexion()
    try:
        conexion.begin()
        cursor = conexion.cursor()
        scripts = script_consulta2()
        resultado_max = None
        resultado_min = None
        for script in scripts.split(";"):
            if script.strip() != "":
                cursor.execute(script)
                if resultado_max == None:
                    resultado_max = cursor.fetchall()
                else:
                    resultado_min = cursor.fetchall()
 

        # Convierte las cadenas JSON en objetos Python (diccionarios)
        max_json = json.loads(resultado_max[0][0])
        min_json = json.loads(resultado_min[0][0])


        # Combina los objetos JSON en uno solo
        resultado_final = {**max_json, **min_json}

        conexion.commit()
        return resultado_final
    except Exception as e:
        conexion.rollback()
        return f"Error inesperado: {e}"
    finally:
        if cursor:
            cursor.close()
        if conexion:
            conexion.close()