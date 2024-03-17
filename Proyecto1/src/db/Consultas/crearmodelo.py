from db.conexion import crear_conexion
from db.scripts.scripts import script_modelo


def CrearModelo():
    conexion = crear_conexion()
    try:
        conexion.begin()
        cursor = conexion.cursor()
        scripts = script_modelo()

        for script in scripts.split(";"):
            if script.strip() != "":
                cursor.execute(script)
        
        conexion.commit()
        return "Todos los scripts se ejecutaron exitosamente."
    except Exception as e:
        conexion.rollback()
        return f"Error inesperado: {e}"
    finally:
        if cursor:
            cursor.close()
        if conexion:
            conexion.close()
