# Importar el módulo PyMySQL
import pymysql

# Definir la función que crea la conexión
def crear_conexion():
    # Reemplaza los valores de host, user, password y database con los tuyos
    conexion = pymysql.connect(host="localhost",
                               user="root",
                               password="root",
                               database="proyecto1_bd1",
                               autocommit=False)
    return conexion