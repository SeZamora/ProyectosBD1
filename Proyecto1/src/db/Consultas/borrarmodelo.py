from db.conexion import crear_conexion
from db.scripts.scripts import script_elimodelo

def BorrarModelo():
    conexion = crear_conexion()
    try:
        conexion.begin()
        cursor = conexion.cursor()
        scripts = script_elimodelo()

        for script in scripts.split(";"):
            if script.strip() != "":
                cursor.execute(script)
        
        conexion.commit()
        return "Modelo Borrado con exito"
    except Exception as e:
        conexion.rollback()
        return f"Error inesperado: {e}"
    finally:
        if cursor:
            cursor.close()
        if conexion:
            conexion.close()