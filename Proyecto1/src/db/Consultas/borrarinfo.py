from db.conexion import crear_conexion
from db.scripts.scripts import script_eliminarInfoTablas

def BorrarInfoTablas():
    conexion = crear_conexion()
    try:
        conexion.begin()
        cursor = conexion.cursor()
        scripts = script_eliminarInfoTablas()

        for script in scripts.split(";"):
            if script.strip() != "":
                cursor.execute(script)
        
        conexion.commit()
        return "Informacion de las tablas eliminada exitosamente."
    except Exception as e:
        conexion.rollback()
        return f"Error inesperado: {e}"
    finally:
        if cursor:
            cursor.close()
        if conexion:
            conexion.close()