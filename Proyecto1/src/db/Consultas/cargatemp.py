from db.conexion import crear_conexion
from db.scripts.scripts import script_temp
from datetime import datetime
import csv

def CrearTemp():
    conexion = crear_conexion()
    
    try:
        conexion.begin()
        cursor = conexion.cursor()
        scripts = script_temp()

        for script in scripts.split(";"):
            if script.strip() != "":
                cursor.execute(script)
        #Cargar Paises
        with open('M:\Sebastian Zamora\Documents\\2024 1 Semestre\Bases1\ProyectosBD1_202002591\Proyecto1\src\csv\paises.csv', mode='r') as archivo_csv:
            reader = csv.reader(archivo_csv, delimiter=';')
            next(reader)
            for fila in reader: 
                if fila[0] != "":        
                    consulta = "INSERT INTO proyecto1_bd1.Paises_temp (id_pais, nombre) VALUES (%s, %s)"
                    cursor.execute(consulta, fila)

            ingresar = "INSERT INTO proyecto1_bd1.Paises(id_pais, nombre) select id_pais, nombre from proyecto1_bd1.Paises_temp;"
            cursor.execute(ingresar)
        #Cargar Categorias
        with open('M:\Sebastian Zamora\Documents\\2024 1 Semestre\Bases1\ProyectosBD1_202002591\Proyecto1\src\csv\Categorias.csv', mode='r') as archivo_csv:
            reader = csv.reader(archivo_csv, delimiter=';')
            next(reader)
            for fila in reader: 
                if fila[0] != "":        
                    consulta = "INSERT INTO proyecto1_bd1.Categorias_temp (id_categoria, nombre) VALUES (%s, %s)"
                    cursor.execute(consulta, fila)

            ingresar = "INSERT INTO proyecto1_bd1.Categorias(id_categoria, nombre) select id_categoria, nombre from proyecto1_bd1.Categorias_temp;"
            cursor.execute(ingresar)
        
        #Cargar Productos
        with open('M:\Sebastian Zamora\Documents\\2024 1 Semestre\Bases1\ProyectosBD1_202002591\Proyecto1\src\csv\productos.csv', mode='r') as archivo_csv:
            reader = csv.reader(archivo_csv, delimiter=';')
            next(reader)
            for fila in reader: 
                if fila[0] != "":        
                    consulta = "INSERT INTO proyecto1_bd1.Productos_temp (id_producto, nombre, precio, id_categoria) VALUES (%s, %s, %s, %s)"
                    cursor.execute(consulta, fila)

            ingresar = "INSERT INTO proyecto1_bd1.Productos(id_producto, nombre, precio, id_categoria) select id_producto, nombre, precio, id_categoria from proyecto1_bd1.Productos_temp;"
            cursor.execute(ingresar)
        #Cargar Vendedores
        with open('M:\Sebastian Zamora\Documents\\2024 1 Semestre\Bases1\ProyectosBD1_202002591\Proyecto1\src\csv\\vendedores.csv', mode='r') as archivo_csv:
            reader = csv.reader(archivo_csv, delimiter=';')
            next(reader)
            for fila in reader: 
                if fila[0] != "":        
                    consulta = "INSERT INTO proyecto1_bd1.Vendedores_temp (id_vendedor, nombre, id_pais) VALUES ( %s, %s, %s)"
                    cursor.execute(consulta, fila)

            ingresar = "INSERT INTO proyecto1_bd1.Vendedores(id_vendedor, nombre, id_pais) select id_vendedor, nombre, id_pais from proyecto1_bd1.Vendedores_temp;"
            cursor.execute(ingresar)
        #Cargar Clientes
        with open('M:\Sebastian Zamora\Documents\\2024 1 Semestre\Bases1\ProyectosBD1_202002591\Proyecto1\src\csv\clientes.csv', mode='r') as archivo_csv:
            reader = csv.reader(archivo_csv, delimiter=';')
            next(reader)
            for fila in reader: 
                if fila[0] != "":        
                    consulta = "INSERT INTO proyecto1_bd1.Clientes_temp (id_cliente, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, id_pais) VALUES ( %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                    cursor.execute(consulta, fila)

            ingresar = "INSERT INTO proyecto1_bd1.Clientes(id_cliente, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, id_pais) select id_cliente, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, id_pais from proyecto1_bd1.Clientes_temp;"
            cursor.execute(ingresar)

        #Cargar Ordenes y LineasOrdenes
        with open('M:\Sebastian Zamora\Documents\\2024 1 Semestre\Bases1\ProyectosBD1_202002591\Proyecto1\src\csv\ordenes.csv', mode='r') as archivo_csv:
            reader = csv.reader(archivo_csv, delimiter=';')
            next(reader)
            for fila in reader: 
        
                if fila[0] != "": 

                    datos_a_insertar = (fila[1], fila[0], fila[6], fila[4], fila[5])
                    consulta = "INSERT INTO proyecto1_bd1.LineasOrdenes_temp(id_lineaOrden, id_orden, cantidad, id_vendedor, id_producto) VALUES ( %s, %s, %s, %s, %s)"
                    cursor.execute(consulta, datos_a_insertar)
                              
                    fecha_original = fila[2]
                    fecha = datetime.strptime(fecha_original, '%d/%m/%Y')
                    fechaSQL = fecha.strftime('%Y-%m-%d')
                    
                    datos_a_insertar2 = (fila[0], fechaSQL, fila[3])
                    consulta2 = "INSERT IGNORE  INTO proyecto1_bd1.Ordenes_temp (id_orden, fecha_orden, id_cliente) VALUES ( %s, %s, %s)"
                    cursor.execute(consulta2, datos_a_insertar2)

            ingresar = "INSERT INTO proyecto1_bd1.Ordenes(id_orden, fecha_orden, id_cliente) select id_orden, fecha_orden, id_cliente from proyecto1_bd1.Ordenes_temp;"
            cursor.execute(ingresar)

            ingresar2 = "INSERT INTO proyecto1_bd1.LineasOrdenes(id_lineaOrden, id_orden, cantidad, id_vendedor, id_producto) select id_lineaOrden, id_orden, cantidad, id_vendedor, id_producto from proyecto1_bd1.LineasOrdenes_temp;"
            cursor.execute(ingresar2)



        conexion.commit()
        return "Todos los scripts se ejecutaron exitosamente."

        
    except Exception as e:
        conexion.rollback()
        return f"Error inesperado: {e}"
    finally:

        cursor.close()
        conexion.close()

