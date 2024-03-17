
def script_modelo():
    return '''

        CREATE TABLE IF NOT EXISTS proyecto1_bd1.Paises (
            id_pais INT NOT NULL,
            nombre VARCHAR(100) NOT NULL,
            PRIMARY KEY (id_pais)
        );

        CREATE TABLE IF NOT EXISTS proyecto1_bd1.Categorias (
            id_categoria INT NOT NULL,
            nombre VARCHAR(50) NOT NULL,
            PRIMARY KEY (id_categoria)
        );

        CREATE TABLE IF NOT EXISTS proyecto1_bd1.Productos (
            id_producto INT NOT NULL,
            nombre VARCHAR(100) NOT NULL,
            precio DECIMAL(10, 2) NOT NULL,
            id_categoria INT NOT NULL,
            PRIMARY KEY (id_producto),
            FOREIGN KEY (id_categoria) REFERENCES proyecto1_bd1.Categorias(id_categoria)
        );

        CREATE TABLE IF NOT EXISTS proyecto1_bd1.Vendedores (
            id_vendedor INT NOT NULL,
            nombre VARCHAR(200) NOT NULL,
            id_pais INT NOT NULL,
            PRIMARY KEY(id_vendedor),
            FOREIGN KEY (id_pais) REFERENCES proyecto1_bd1.Paises(id_pais)
        );

        CREATE TABLE IF NOT EXISTS proyecto1_bd1.Clientes (
            id_cliente INT NOT NULL,
            nombre VARCHAR(50) NOT NULL,
            apellido VARCHAR(50) NOT NULL,
            direccion VARCHAR(250) NOT NULL,
            telefono BIGINT NOT NULL,
            tarjeta BIGINT NOT NULL,
            edad TINYINT NOT NULL,
            salario INT NOT NULL,
            genero ENUM('F', 'M') NOT NULL,
            id_pais INT NOT NULL,
            PRIMARY KEY (id_cliente),
            FOREIGN KEY (id_pais) REFERENCES proyecto1_bd1.Paises(id_pais)
        );

        CREATE TABLE IF NOT EXISTS proyecto1_bd1.Ordenes (
            id_orden INT NOT NULL,
            fecha_orden DATE NOT NULL,
            id_cliente INT NOT NULL,
            PRIMARY KEY (id_orden),
            FOREIGN KEY (id_cliente) REFERENCES proyecto1_bd1.Clientes(id_cliente)
        );

        CREATE TABLE IF NOT EXISTS proyecto1_bd1.LineasOrdenes (
            id_lineaOrden INT NOT NULL,
            id_orden INT NOT NULL,
            cantidad INT NOT NULL,
            id_vendedor INT NOT NULL,
            id_producto INT NOT NULL,
            PRIMARY KEY (id_lineaOrden, id_orden),
            FOREIGN KEY (id_orden) REFERENCES proyecto1_bd1.Ordenes(id_orden),
            FOREIGN KEY (id_vendedor) REFERENCES proyecto1_bd1.Vendedores(id_vendedor),
            FOREIGN KEY (id_producto) REFERENCES proyecto1_bd1.Productos(id_producto)
        );

        '''


def script_temp():
    return '''

        CREATE TEMPORARY TABLE IF NOT EXISTS proyecto1_bd1.Paises_temp (
            id_pais INT NOT NULL,
            nombre VARCHAR(100) NOT NULL,
            PRIMARY KEY (id_pais)
        );

        CREATE TEMPORARY TABLE IF NOT EXISTS proyecto1_bd1.Categorias_temp (
            id_categoria INT NOT NULL,
            nombre VARCHAR(50) NOT NULL,
            PRIMARY KEY (id_categoria)
        );

        CREATE TEMPORARY TABLE IF NOT EXISTS proyecto1_bd1.Productos_temp (
            id_producto INT NOT NULL,
            nombre VARCHAR(100) NOT NULL,
            precio DECIMAL(10, 2) NOT NULL,
            id_categoria INT NOT NULL,
            PRIMARY KEY (id_producto)
        );

        CREATE TEMPORARY TABLE IF NOT EXISTS proyecto1_bd1.Vendedores_temp (
            id_vendedor INT NOT NULL,
            nombre VARCHAR(200) NOT NULL,
            id_pais INT NOT NULL,
            PRIMARY KEY(id_vendedor)
        );

        CREATE TEMPORARY TABLE IF NOT EXISTS proyecto1_bd1.Clientes_temp (
            id_cliente INT NOT NULL,
            nombre VARCHAR(50) NOT NULL,
            apellido VARCHAR(50) NOT NULL,
            direccion VARCHAR(250) NOT NULL,
            telefono BIGINT NOT NULL,
            tarjeta BIGINT NOT NULL,
            edad TINYINT NOT NULL,
            salario INT NOT NULL,
            genero ENUM('F', 'M') NOT NULL,
            id_pais INT NOT NULL,
            PRIMARY KEY (id_cliente)
        );

        CREATE TEMPORARY TABLE IF NOT EXISTS proyecto1_bd1.Ordenes_temp (
            id_orden INT NOT NULL,
            fecha_orden DATE NOT NULL,
            id_cliente INT NOT NULL,
            PRIMARY KEY (id_orden)
        );

        CREATE TEMPORARY TABLE IF NOT EXISTS proyecto1_bd1.LineasOrdenes_temp (
            id_lineaOrden INT NOT NULL,
            id_orden INT NOT NULL,
            cantidad INT NOT NULL,
            id_vendedor INT NOT NULL,
            id_producto INT NOT NULL,
            PRIMARY KEY (id_lineaOrden, id_orden)
        );

        '''

def script_elimodelo():
    return '''

        DROP TABLE IF EXISTS proyecto1_bd1.LineasOrdenes;
        DROP TABLE IF EXISTS proyecto1_bd1.Ordenes;
        DROP TABLE IF EXISTS proyecto1_bd1.Clientes;
        DROP TABLE IF EXISTS proyecto1_bd1.Vendedores;
        DROP TABLE IF EXISTS proyecto1_bd1.Productos;
        DROP TABLE IF EXISTS proyecto1_bd1.Categorias;
        DROP TABLE IF EXISTS proyecto1_bd1.Paises;

        '''

def script_eliminarInfoTablas():
    return '''

        DELETE FROM proyecto1_bd1.LineasOrdenes;
        DELETE FROM proyecto1_bd1.Ordenes;
        DELETE FROM proyecto1_bd1.Clientes;
        DELETE FROM proyecto1_bd1.Vendedores;
        DELETE FROM proyecto1_bd1.Productos;
        DELETE FROM proyecto1_bd1.Categorias;
        DELETE FROM proyecto1_bd1.Paises;

        '''

def script_consulta1():
    return '''

        SELECT JSON_OBJECT(
            'id_cliente', Ordenes.id_cliente,
            'nombre', Clientes.nombre,
            'apellido', Clientes.apellido,
            'pais', Paises.nombre,
            'monto_total', SUM(Productos.precio)
        ) AS resultado_json
        FROM proyecto1_bd1.ordenes
        JOIN proyecto1_bd1.clientes ON ordenes.id_cliente = clientes.id_cliente
        JOIN proyecto1_bd1.paises ON clientes.id_pais = paises.id_pais
        JOIN proyecto1_bd1.lineasOrdenes ON lineasOrdenes.id_orden = ordenes.id_orden
        JOIN proyecto1_bd1.productos ON lineasOrdenes.id_producto = productos.id_producto
        GROUP BY ordenes.id_cliente
        ORDER BY COUNT(*) DESC
        LIMIT 1;
        '''

def script_consulta2():
    return '''

        SELECT JSON_OBJECT(
        'ID Producto MAX', lineasOrdenes.id_producto, 
        'Nombre MAX',productos.nombre, 
        'Categoria MAX',categorias.nombre, 
        'Cantidad MAX',SUM(lineasOrdenes.cantidad) , 
        'Recaudado MAX',SUM(lineasOrdenes.cantidad*productos.precio) 
        )
        FROM proyecto1_bd1.lineasOrdenes
        join proyecto1_bd1.productos ON lineasOrdenes.id_producto = productos.id_producto
        join proyecto1_bd1.categorias ON categorias.id_categoria = productos.id_categoria
        group by lineasOrdenes.id_producto
        ORDER BY SUM(lineasOrdenes.cantidad) desc
        LIMIT 1
        ;

        SELECT JSON_OBJECT(
        'ID Producto MIN', lineasOrdenes.id_producto, 
        'Nombre MIN',productos.nombre, 
        'Categoria MIN',categorias.nombre, 
        'Cantidad MIN',SUM(lineasOrdenes.cantidad) , 
        'Recaudado MIN',SUM(lineasOrdenes.cantidad*productos.precio) 
        )
        FROM proyecto1_bd1.lineasOrdenes
        join proyecto1_bd1.productos ON lineasOrdenes.id_producto = productos.id_producto
        join proyecto1_bd1.categorias ON categorias.id_categoria = productos.id_categoria
        group by lineasOrdenes.id_producto
        ORDER BY SUM(lineasOrdenes.cantidad)
        LIMIT 1
        ;
    '''

def script_consulta3():
    return '''
        SELECT JSON_OBJECT(
        'ID Vendedor', LineasOrdenes.id_vendedor, 
        'Nombre',vendedores.nombre, 
        'Cantidad Vendida',SUM(productos.precio*cantidad)
        ) AS resultado_json
        FROM proyecto1_bd1.lineasOrdenes
        JOIN proyecto1_bd1.productos ON lineasOrdenes.id_producto = productos.id_producto
        JOIN proyecto1_bd1.vendedores ON lineasOrdenes.id_vendedor = vendedores.id_vendedor
        group by lineasOrdenes.id_vendedor
        order by  SUM(productos.precio*cantidad) DESC
        LIMIT 1 ;
    '''

def script_consulta4():
    return '''
SELECT JSON_OBJECT(
		'Nombre MIN',menor_venta.nombre_min,
        'Monto MIN',menor_venta.valor_min,
        'Nombre MAX',mayor_venta.nombre_max,
        'Monto MAX', mayor_venta.valor_max 
        ) AS json_res
FROM (
	Select
	paises.nombre AS nombre_min, SUM(productos.precio*LineasOrdenes.cantidad) AS valor_min
	FROM proyecto1_bd1.LineasOrdenes
	JOIN proyecto1_bd1.productos ON productos.id_producto = LineasOrdenes.id_producto
	JOIN proyecto1_bd1.vendedores ON vendedores.id_vendedor = LineasOrdenes.id_vendedor
	JOIN proyecto1_bd1.paises ON paises.id_pais = vendedores.id_pais
	group by paises.id_pais
	order by SUM(productos.precio*LineasOrdenes.cantidad) ASC
	LIMIT 1
    ) menor_venta,
    (
    Select 
    paises.nombre AS nombre_max, SUM(productos.precio*LineasOrdenes.cantidad)  AS valor_max
	FROM proyecto1_bd1.LineasOrdenes
	JOIN proyecto1_bd1.productos ON productos.id_producto = LineasOrdenes.id_producto
	JOIN proyecto1_bd1.vendedores ON vendedores.id_vendedor = LineasOrdenes.id_vendedor
	JOIN proyecto1_bd1.paises ON paises.id_pais = vendedores.id_pais
	group by paises.id_pais
	order by SUM(productos.precio*LineasOrdenes.cantidad) DESC
	LIMIT 1
    ) AS mayor_venta;

    '''

def script_consulta5():
    return '''
        SELECT JSON_OBJECT(
            'id', id,
            'nombre', nombre,
            'monto', monto
        ) AS resultado_json
        FROM (
            SELECT clientes.id_pais AS id, paises.nombre AS nombre, SUM(LineasOrdenes.cantidad * productos.precio) AS monto
            FROM proyecto1_bd1.LineasOrdenes
            JOIN proyecto1_bd1.ordenes ON ordenes.id_orden = LineasOrdenes.id_orden
            JOIN proyecto1_bd1.clientes ON clientes.id_cliente = ordenes.id_cliente
            JOIN proyecto1_bd1.paises ON paises.id_pais = clientes.id_pais
            JOIN proyecto1_bd1.productos ON productos.id_producto = LineasOrdenes.id_producto
            GROUP BY paises.id_pais
            ORDER BY SUM(LineasOrdenes.cantidad * productos.precio) DESC
            LIMIT 5
        ) AS mayores


    '''


def script_consulta6():
    return '''
    SELECT JSON_OBJECT(
	'Mayor nombre', mayor.nombre,
    'Mayor cantidad', mayor.cantidad,
    'Menor nombre', menor.nombre,
    'Menor cantidad',menor.cantidad
    ) AS resJson
    FROM ( 
	SELECT categorias.nombre AS nombre, SUM(lineasordenes.cantidad) AS cantidad
    FROM proyecto1_bd1.lineasordenes
    JOIN proyecto1_bd1.productos ON productos.id_producto = lineasOrdenes.id_producto
    JOIN proyecto1_bd1.categorias ON categorias.id_categoria = productos.id_categoria
    group by categorias.id_categoria
    order by SUM(lineasordenes.cantidad) DESC
    LIMIT 1
    ) AS mayor,
    ( 
	SELECT categorias.nombre AS nombre, SUM(lineasordenes.cantidad) AS cantidad
    FROM proyecto1_bd1.lineasordenes
    JOIN proyecto1_bd1.productos ON productos.id_producto = lineasOrdenes.id_producto
    JOIN proyecto1_bd1.categorias ON categorias.id_categoria = productos.id_categoria
    group by categorias.id_categoria
    order by SUM(lineasordenes.cantidad) ASC
    LIMIT 1
    ) AS menor;
    
    
    
    '''

def script_consulta7():
    return '''
    SELECT JSON_OBJECT(
    'Nombre' ,ranked_rows.nombre_pais, 
    'Categoria',ranked_rows.nombre_categoria, 
    'Cantidad Total',ranked_rows.total_cantidad 
    ) AS json_object
    FROM (
        SELECT paises.nombre AS nombre_pais, categorias.nombre AS nombre_categoria, SUM(lineasordenes.cantidad) AS total_cantidad,
            ROW_NUMBER() OVER (PARTITION BY paises.nombre ORDER BY SUM(lineasordenes.cantidad) DESC) AS row_num
        FROM proyecto1_bd1.lineasordenes
        JOIN proyecto1_bd1.productos ON productos.id_producto = lineasordenes.id_producto
        JOIN proyecto1_bd1.categorias ON categorias.id_categoria = productos.id_categoria
        JOIN proyecto1_bd1.ordenes ON ordenes.id_orden = lineasordenes.id_orden
        JOIN proyecto1_bd1.clientes ON clientes.id_cliente = ordenes.id_cliente
        JOIN proyecto1_bd1.paises ON paises.id_pais = clientes.id_pais
        GROUP BY paises.nombre, categorias.nombre
    ) AS ranked_rows
    WHERE row_num = 1 ;
    '''

def script_consulta8():
    return '''
    SELECT JSON_OBJECT (
    'Mes', res.mes,
    'monto', res.monto
    ) FROM(
        select
        month(ordenes.fecha_orden) as mes, 
        SUM(lineasordenes.cantidad * productos.precio)  AS monto
        FROM proyecto1_bd1.lineasordenes
        JOIN proyecto1_bd1.productos ON productos.id_producto = lineasordenes.id_producto
        JOIN proyecto1_bd1.vendedores ON vendedores.id_vendedor = lineasordenes.id_vendedor
        JOIN proyecto1_bd1.paises ON paises.id_pais = vendedores.id_pais
        JOIN proyecto1_bd1.ordenes ON ordenes.id_orden = lineasordenes.id_orden
        WHERE paises.id_pais = 10
        group by month(ordenes.fecha_orden)
        order by month(ordenes.fecha_orden) asc
    ) AS res ;
    
    '''

def script_consulta9():
    return '''
    SELECT JSON_OBJECT(
    'MAX mes',mas.num,
    'MAX monto', mas.monto,
    'MIN mes', men.num,
    'MIN monto', men.monto
    )FROM
        (
	select month(ordenes.fecha_orden) AS num, SUM(lineasordenes.cantidad * productos.precio) AS monto
	FROM proyecto1_bd1.lineasordenes
	JOIN proyecto1_bd1.productos ON productos.id_producto = lineasordenes.id_producto
	JOIN proyecto1_bd1.vendedores ON vendedores.id_vendedor = lineasordenes.id_vendedor
	JOIN proyecto1_bd1.paises ON paises.id_pais = vendedores.id_pais
	JOIN proyecto1_bd1.ordenes ON ordenes.id_orden = lineasordenes.id_orden
	group by month(ordenes.fecha_orden)
	order by SUM(lineasordenes.cantidad * productos.precio) asc
    LIMIT 1
    ) AS mas,
    (select month(ordenes.fecha_orden) AS num, SUM(lineasordenes.cantidad * productos.precio) AS monto
	FROM proyecto1_bd1.lineasordenes
	JOIN proyecto1_bd1.productos ON productos.id_producto = lineasordenes.id_producto
	JOIN proyecto1_bd1.vendedores ON vendedores.id_vendedor = lineasordenes.id_vendedor
	JOIN proyecto1_bd1.paises ON paises.id_pais = vendedores.id_pais
	JOIN proyecto1_bd1.ordenes ON ordenes.id_orden = lineasordenes.id_orden
	group by month(ordenes.fecha_orden)
	order by SUM(lineasordenes.cantidad * productos.precio) desc
    LIMIT 1
    ) AS men;
    '''

def script_consulta10():
    return '''
    SELECT JSON_OBJECT(
    'id',productos.id_producto,
    'nombre', productos.nombre,
    'monto', SUM(lineasordenes.cantidad * productos.precio)
    )AS res
    FROM proyecto1_bd1.lineasordenes
	JOIN proyecto1_bd1.productos ON productos.id_producto = lineasordenes.id_producto
    JOIN proyecto1_bd1.categorias ON categorias.id_categoria = productos.id_categoria
    WHERE categorias.id_categoria = 15
    group by lineasordenes.id_producto 
    order by SUM(lineasordenes.cantidad * productos.precio) ASC;


    '''