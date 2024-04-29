DELIMITER //
CREATE PROCEDURE consultarSaldoCliente(
	IN cuenta BIGINT 
)
BEGIN
	DECLARE existe INT;
    
     SELECT id_cliente INTO existe FROM cuentas WHERE id_cuenta = cuenta;
     
     IF existe IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta no existe';
     END IF;
     
     SELECT CONCAT(clientes.nombre,' ', clientes.apellido) AS nombre, tipo_clientes.nombre AS tipo_cliente , tipo_cuentas.nombre AS  tipo_cuenta, cuentas.saldo_cuenta, cuentas.monto_apertura 
     FROM cuentas
     INNER JOIN clientes ON clientes.id_cliente = cuentas.id_cliente
     INNER JOIN tipo_clientes ON tipo_clientes.id_tipocliente = clientes.id_tipocliente
     INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta 
     WHERE cuentas.id_cuenta = cuenta;
    
END//

DELIMITER ;

DELIMITER //
CREATE PROCEDURE consultarCliente(
    IN cliente INT
)
BEGIN
    DECLARE existe INT;
    
    SELECT id_cliente INTO existe FROM clientes WHERE id_cliente = cliente;
    IF existe IS NULL THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;
    
    SELECT clientes.id_cliente, CONCAT(clientes.nombre,' ', clientes.apellido) AS Nombre_cliente, fecha AS Fecha_creacion, clientes.usuario, 
    GROUP_CONCAT(DISTINCT telefonos.telefono) AS telefonos, GROUP_CONCAT(DISTINCT  correos.correo) AS correos,  
    GROUP_CONCAT(DISTINCT  cuentas.id_cuenta) AS cuentas,  GROUP_CONCAT(DISTINCT  tipo_cuentas.nombre)
    FROM clientes
    INNER JOIN cuentas ON cuentas.id_cliente = clientes.id_cliente
    INNER JOIN telefonos ON telefonos.id_cliente = clientes.id_cliente
    INNER JOIN correos ON correos.id_cliente = clientes.id_cliente
    INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
    WHERE clientes.id_cliente = cliente
    GROUP BY clientes.id_cliente; 
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE consultarMovsCliente(
	IN cliente INT
)
BEGIN 
	DECLARE existe INT;
    
	SELECT id_cliente INTO existe FROM clientes WHERE id_cliente = cliente;
	IF existe IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe';
	END IF;
    
    SELECT compras.id_transaccion, transacciones.id_tipotransaccion, compras.importe_compra AS monto, tipo_transacciones.nombre AS tipo_servicio, transacciones.id_cuenta, tipo_cuentas.nombre AS tipo_cuenta FROM compras
    INNER JOIN transacciones ON transacciones.id_transaccion = compras.id_transaccion
    INNER JOIN cuentas ON cuentas.id_cuenta = transacciones.id_cuenta
    INNER JOIN tipo_transacciones ON tipo_transacciones.id_tipotransaccion = transacciones.id_tipotransaccion
    INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
    WHERE compras.id_cliente = cliente
    UNION
	SELECT depositos.id_transaccion, transacciones.id_tipotransaccion, depositos.monto, tipo_transacciones.nombre, transacciones.id_cuenta, tipo_cuentas.nombre FROM depositos
    INNER JOIN transacciones ON transacciones.id_transaccion = depositos.id_transaccion
    INNER JOIN cuentas ON cuentas.id_cuenta = transacciones.id_cuenta
    INNER JOIN tipo_transacciones ON tipo_transacciones.id_tipotransaccion = transacciones.id_tipotransaccion
	INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
    WHERE depositos.id_cliente = cliente
    UNION
	SELECT debitos.id_transaccion, transacciones.id_tipotransaccion, debitos.monto,tipo_transacciones.nombre , transacciones.id_cuenta, tipo_cuentas.nombre FROM debitos
    INNER JOIN transacciones ON transacciones.id_transaccion = debitos.id_transaccion
    INNER JOIN cuentas ON cuentas.id_cuenta = transacciones.id_cuenta
    INNER JOIN tipo_transacciones ON tipo_transacciones.id_tipotransaccion = transacciones.id_tipotransaccion
	INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
    WHERE debitos.id_cliente = cliente;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE consultarTipoCuentas(
	IN tipo INT
)
BEGIN 
	DECLARE existe INT;
    
	SELECT id_tipocuenta INTO existe FROM tipo_cuentas WHERE id_tipocuenta = tipo;
	IF existe IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo cuenta no existe';
	END IF;
    
    SELECT cuentas.id_tipocuenta, tipo_cuentas.nombre, COUNT(*) AS cantidad FROM cuentas
    INNER JOIN tipo_cuentas ON cuentas.id_tipocuenta = tipo_cuentas.id_tipocuenta
    WHERE cuentas.id_tipocuenta = tipo
    GROUP BY cuentas.id_tipocuenta;
END//

DELIMITER ;

DELIMITER //
CREATE PROCEDURE consultarMovsGenFech(
	IN p_fechain VARCHAR(20),
    IN p_fechafin VARCHAR(20)
)
BEGIN

	 DECLARE fecha_inicio DATE;
     DECLARE fecha_fin DATE;
     
	 IF p_fechain NOT REGEXP '^[0-3][0-9][/](0[1-9]|1[0-2])[/][0-9][0-9]$' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha inicio no esta en formato correcto DD/MM/YY';
     END IF;
	 IF p_fechafin NOT REGEXP '^[0-3][0-9][/](0[1-9]|1[0-2])[/][0-9][0-9]$' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha fin no esta en formato correcto DD/MM/YY';
     END IF;
     
     SET fecha_inicio = STR_TO_DATE(p_fechain, '%d/%m/%Y'); 
     SET fecha_fin = STR_TO_DATE(p_fechafin, '%d/%m/%Y'); 
     
		SELECT transacciones.id_transaccion, transacciones.id_tipotransaccion, tipo_transacciones.nombre AS tipo_servicio , clientes.nombre AS nombre_cliente,
			transacciones.id_cuenta, tipo_cuentas.nombre AS tipo_cuenta, transacciones.fecha, compras.importe_compra AS monto, transacciones.otros_detalles
	 FROM transacciones
     INNER JOIN cuentas ON cuentas.id_cuenta = transacciones.id_cuenta
     INNER JOIN tipo_transacciones ON tipo_transacciones.id_tipotransaccion = transacciones.id_tipotransaccion
     INNER JOIN compras ON compras.id_transaccion = transacciones.id_transaccion
     INNER JOIN clientes ON  clientes.id_cliente = compras.id_cliente
     INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
     WHERE transacciones.fecha BETWEEN fecha_inicio AND fecha_fin
     UNION
		SELECT transacciones.id_transaccion, transacciones.id_tipotransaccion, tipo_transacciones.nombre AS tipo_servicio , clientes.nombre AS nombre_cliente,
			transacciones.id_cuenta, tipo_cuentas.nombre AS tipo_cuenta, transacciones.fecha, depositos.monto AS monto, transacciones.otros_detalles
	 FROM transacciones
     INNER JOIN cuentas ON cuentas.id_cuenta = transacciones.id_cuenta
     INNER JOIN tipo_transacciones ON tipo_transacciones.id_tipotransaccion = transacciones.id_tipotransaccion
     INNER JOIN depositos ON depositos.id_transaccion = transacciones.id_transaccion
     INNER JOIN clientes ON  clientes.id_cliente = depositos.id_cliente
     INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
     WHERE transacciones.fecha BETWEEN fecha_inicio AND fecha_fin
     UNION
          SELECT transacciones.id_transaccion, transacciones.id_tipotransaccion, tipo_transacciones.nombre AS tipo_servicio , clientes.nombre AS nombre_cliente,
			transacciones.id_cuenta, tipo_cuentas.nombre AS tipo_cuenta, transacciones.fecha, debitos.monto AS monto, transacciones.otros_detalles
	 FROM transacciones
     INNER JOIN cuentas ON cuentas.id_cuenta = transacciones.id_cuenta
     INNER JOIN tipo_transacciones ON tipo_transacciones.id_tipotransaccion = transacciones.id_tipotransaccion
     INNER JOIN debitos ON debitos.id_transaccion = transacciones.id_transaccion
     INNER JOIN clientes ON  clientes.id_cliente = debitos.id_cliente
     INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
     WHERE transacciones.fecha BETWEEN fecha_inicio AND fecha_fin;
		
END//

DELIMITER ;

DELIMITER //
CREATE PROCEDURE consultarMovsFechClien
(
	IN cliente INT,
    IN p_fechain VARCHAR(20),
    IN p_fechafin VARCHAR(20)
)
BEGIN 
	DECLARE fecha_inicio DATE;
	DECLARE fecha_fin DATE;
    DECLARE existe INT;
    
	SELECT id_cliente INTO existe FROM clientes WHERE id_cliente = cliente;
	IF existe IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe';
	END IF;

	IF p_fechain NOT REGEXP '^[0-3][0-9][/](0[1-9]|1[0-2])[/][0-9][0-9]$' THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha inicio no esta en formato correcto DD/MM/YY';
	END IF;
	IF p_fechafin NOT REGEXP '^[0-3][0-9][/](0[1-9]|1[0-2])[/][0-9][0-9]$' THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha fin no esta en formato correcto DD/MM/YY';
	END IF;

	SET fecha_inicio = STR_TO_DATE(p_fechain, '%d/%m/%Y'); 
	SET fecha_fin = STR_TO_DATE(p_fechafin, '%d/%m/%Y'); 
    
    SELECT transacciones.id_transaccion, transacciones.id_tipotransaccion, tipo_transacciones.nombre AS tipo_servicio , clientes.nombre AS nombre_cliente,
			transacciones.id_cuenta, tipo_cuentas.nombre AS tipo_cuenta, transacciones.fecha, compras.importe_compra AS monto, transacciones.otros_detalles
            FROM transacciones
     INNER JOIN cuentas ON cuentas.id_cuenta = transacciones.id_cuenta
     INNER JOIN tipo_transacciones ON tipo_transacciones.id_tipotransaccion = transacciones.id_tipotransaccion
     INNER JOIN compras ON compras.id_transaccion = transacciones.id_transaccion
     INNER JOIN clientes ON  clientes.id_cliente = compras.id_cliente
     INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
     WHERE transacciones.fecha BETWEEN fecha_inicio AND fecha_fin AND compras.id_cliente = cliente
     UNION
		SELECT transacciones.id_transaccion, transacciones.id_tipotransaccion, tipo_transacciones.nombre AS tipo_servicio , clientes.nombre AS nombre_cliente,
			transacciones.id_cuenta, tipo_cuentas.nombre AS tipo_cuenta, transacciones.fecha, depositos.monto AS monto, transacciones.otros_detalles
	 FROM transacciones
     INNER JOIN cuentas ON cuentas.id_cuenta = transacciones.id_cuenta
     INNER JOIN tipo_transacciones ON tipo_transacciones.id_tipotransaccion = transacciones.id_tipotransaccion
     INNER JOIN depositos ON depositos.id_transaccion = transacciones.id_transaccion
     INNER JOIN clientes ON  clientes.id_cliente = depositos.id_cliente
     INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
     WHERE transacciones.fecha BETWEEN fecha_inicio AND fecha_fin AND depositos.id_cliente = cliente
     UNION
          SELECT transacciones.id_transaccion, transacciones.id_tipotransaccion, tipo_transacciones.nombre AS tipo_servicio , clientes.nombre AS nombre_cliente,
			transacciones.id_cuenta, tipo_cuentas.nombre AS tipo_cuenta, transacciones.fecha, debitos.monto AS monto, transacciones.otros_detalles
	 FROM transacciones
     INNER JOIN cuentas ON cuentas.id_cuenta = transacciones.id_cuenta
     INNER JOIN tipo_transacciones ON tipo_transacciones.id_tipotransaccion = transacciones.id_tipotransaccion
     INNER JOIN debitos ON debitos.id_transaccion = transacciones.id_transaccion
     INNER JOIN clientes ON  clientes.id_cliente = debitos.id_cliente
     INNER JOIN tipo_cuentas ON tipo_cuentas.id_tipocuenta = cuentas.id_tipocuenta
     WHERE transacciones.fecha BETWEEN fecha_inicio AND fecha_fin AND debitos.id_cliente = cliente;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE consultarProductoServicio()
BEGIN
	SELECT productoservicios.id_productoservicio, 
     CASE productoservicios.tipo WHEN 1 THEN 'Servicio' WHEN 2 THEN 'Producto' END AS tipo,
    productoservicios.descripcion AS descripcion
    FROM productoservicios;
    
END//
DELIMITER ;