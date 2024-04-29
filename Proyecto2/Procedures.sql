-- Tipo Clientes
DELIMITER //

CREATE PROCEDURE registrarTipoCliente(IN par_idTipo INT, IN par_nombre VARCHAR(40), IN par_descripcion VARCHAR(300))
BEGIN
	DECLARE existe INT;
    
    IF par_descripcion NOT REGEXP '^[a-zA-Z[:space:]áéíóúÁÉÍÓÚüÜ]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El parámetro debe contener solo letras y espacios.';
    END IF;
    	
    SELECT id_tipocliente into existe FROM tipo_clientes WHERE par_nombre=nombre;
    IF existe IS NOT NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un tipo de cliente con ese nombre';
    END IF;
    
    IF par_nombre = '' THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nobre no puede ser null';
    END IF;
    INSERT INTO tipo_clientes(nombre, descripcion) VALUES (par_nombre, par_descripcion);
    
END//

DELIMITER ;

-- Tipo Cuentas
DELIMITER //

CREATE PROCEDURE registrarTipoCuenta(IN par_idTipo INT, IN par_nombre VARCHAR(40), IN par_descripcion VARCHAR(300))
BEGIN
	DECLARE existe INT ;
   SELECT id_tipocuenta into existe FROM tipo_cuentas WHERE par_nombre=nombre;
    IF existe IS NOT NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un tipo de cuenta con ese nombre';
    END IF;
    
    IF par_nombre = '' THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nobre no puede ser null';
    END IF;

    INSERT INTO tipo_cuentas(nombre, descripcion) VALUES (par_nombre, par_descripcion);
    
END//

DELIMITER ;

-- Clientes
DELIMITER //

CREATE PROCEDURE registrarCliente(
    IN p_idcliente INT, 
    IN p_nombre VARCHAR(40), 
    IN p_apellido VARCHAR(40),
    IN p_telefono VARCHAR(200),
    IN p_correo VARCHAR(500),
    IN p_usuario VARCHAR(40),
    IN p_contrasena VARCHAR(200),
    IN p_tipocliente INT 
)
BEGIN
    DECLARE v_telefono VARCHAR(12);
    DECLARE pos INT DEFAULT 1;
    DECLARE next_pos INT;
    
    
    DECLARE correo_actual VARCHAR(255);
    DECLARE pos_correo INT DEFAULT 1;
    DECLARE siguiente_pos_correo INT;
    DECLARE formato_correcto BOOLEAN DEFAULT TRUE;
	
    DECLARE existe_tipo INT;
    DECLARE existe_usuario INT;
    DECLARE existe_tel INT;
    DECLARE existe_cor INT;
 
    
    -- Iniciar la transacción
    START TRANSACTION;
    
    
    
    -- Validar nombre y apellido
    IF p_nombre NOT REGEXP '^[a-zA-Z[:space:]áéíóúÁÉÍÓÚüÜ]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Nombre deben ser solo letras';
    END IF;
    
    IF p_apellido NOT REGEXP '^[a-zA-Z[:space:]áéíóúÁÉÍÓÚüÜ]+$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Apellidos deben ser solo letras';
    END IF;
    
    SELECT id_tipocliente INTO existe_tipo FROM tipo_clientes WHERE id_tipocliente = p_tipocliente;
    IF existe_tipo IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de cliente no existe';
	END IF;
    
    SELECT id_cliente INTO existe_usuario  FROM clientes WHERE usuario = p_usuario;
    IF existe_usuario IS NOT NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario existe';
	END IF;
    
    -- Insertar datos del cliente
    INSERT INTO clientes(id_cliente, nombre, apellido, usuario, contrasena, fecha, id_tipocliente) 
    VALUES (p_idcliente, p_nombre, p_apellido, p_usuario, AES_ENCRYPT(p_contrasena, 'proyecto2'), CURDATE(), p_tipocliente);
    
    -- Loop para separar los números de teléfono
    WHILE pos <= LENGTH(p_telefono) DO
        SET next_pos = LOCATE('-', p_telefono, pos);
        IF next_pos = 0 THEN
            SET next_pos = LENGTH(p_telefono) + 1;
        END IF;
        
        SET v_telefono = SUBSTRING(p_telefono, pos, next_pos - pos);
        
        -- Ignorar los primeros 3 dígitos si el número tiene 12 dígitos
        IF LENGTH(v_telefono) = 11 THEN
            SET v_telefono = SUBSTRING(v_telefono, 4);
        END IF;
        
        SELECT id_telefono INTO existe_tel FROM telefonos WHERE telefono = v_telefono;
        IF existe_tel IS NOT NULL THEN
			ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este telefono ya es de otro cliente';
        END IF;
        
        -- Insertar el número de teléfono en la tabla
        INSERT INTO telefonos (telefono, id_cliente) VALUES (v_telefono, p_idcliente);
        
        SET pos = next_pos + 1;
    END WHILE;
    
    -- Loop para separar los correos electrónicos
    WHILE pos_correo <= LENGTH(p_correo) DO
        SET siguiente_pos_correo = LOCATE('|', p_correo, pos_correo);
        IF siguiente_pos_correo = 0 THEN
            SET siguiente_pos_correo = LENGTH(p_correo) + 1;
        END IF;
        
        SET correo_actual = SUBSTRING(p_correo, pos_correo, siguiente_pos_correo - pos_correo);
        
		SELECT id_correo INTO existe_cor FROM correos WHERE correo = correo_actual;
        IF existe_tel IS NOT NULL THEN
			ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este correo ya es de otro cliente';
        END IF;
        
        -- Validar el formato del correo electrónico
        IF correo_actual REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
            INSERT INTO correos (correo, id_cliente) VALUES (correo_actual, p_idcliente);
        ELSE
        
            -- Establecer la bandera para indicar que hay un formato incorrecto
		SET formato_correcto = FALSE;
        END IF;
        
        SET pos_correo = siguiente_pos_correo + 1;
    END WHILE;
    

    IF NOT formato_correcto THEN
		ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Al menos uno de los correos electrónicos no tiene el formato correcto';
    END IF;
    

    COMMIT;
END//


DELIMITER ;

-- Producto y Servicios
DELIMITER //

CREATE PROCEDURE crearProductoServicio(
IN p_id_codigo INT,
IN p_tipo INT,
IN p_costo DECIMAL(12,2),
IN p_descripcion VARCHAR(100)
)
BEGIN
	IF p_tipo <> 1 AND p_tipo <> 2 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Debe ser 1)servicio o 2)producto';
    END IF;

    IF p_tipo = 1 AND p_costo <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Los servicios tiene que tener un precio definido';
    END IF;
    
    IF p_tipo = 2 AND p_costo <> 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Los productos no tienen un precio definido';
    END IF;
    
    INSERT INTO productoservicios(id_productoservicio, tipo, costo, descripcion) VALUES (p_id_codigo, p_tipo, p_costo, p_descripcion);
END//

DELIMITER ;

-- Cuentas
DELIMITER //
CREATE PROCEDURE registrarCuenta(
	IN p_idCuenta BIGINT,
	IN p_montoApertura DECIMAL(12,2),
	IN p_saldo DECIMAL(12,2),
	IN p_descripcion VARCHAR(50),
	IN p_fecha VARCHAR(50),
	IN p_detalles VARCHAR(100),
	IN p_tipoCuenta INT,
	IN p_idCliente INT )
BEGIN

	DECLARE fecha_datetime DATETIME; 
    DECLARE existe_tipo INT;
    DECLARE existe_cliente INT;
	IF p_saldo <>  p_montoApertura THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Monto apertura no es el mismo que el saldo';
    END IF;
    IF p_montoApertura <= 0  THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Monto Apertura no es mayor a 0';
    END IF;
    
    IF p_saldo < 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Saldo es mayor a 0';
	END IF;

    IF p_fecha = '' THEN
        SET fecha_datetime = NOW(); 
    ELSE
        SET fecha_datetime = STR_TO_DATE(p_fecha, '%d/%m/%Y %H:%i:%s'); 
    END IF;
    
	SELECT id_tipocuenta INTO existe_tipo FROM tipo_cuentas WHERE id_tipocuenta = p_tipoCuenta;
    IF existe_tipo IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de cuenta no existe';
	END IF;
    
	SELECT id_cliente INTO existe_cliente FROM clientes WHERE id_cliente = p_idCliente;
    IF existe_cliente IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe';
	END IF;
    
    
    
    
    INSERT INTO cuentas(id_cuenta, monto_apertura, saldo_cuenta, descripcion, fecha_apertura, otros_detalles, id_tipocuenta, id_cliente) 
    VALUES (p_idCuenta, p_montoApertura, p_saldo, p_descripcion, fecha_datetime, p_detalles, p_tipoCuenta, p_idCliente);
    
	
END//

DELIMITER ;

-- Compras
DELIMITER //

CREATE PROCEDURE realizarCompra(
IN p_idcompra INT,
IN p_fechav VARCHAR(40),
IN p_compra DECIMAL(12,2),
IN p_detalles VARCHAR(40),
IN p_idcodigo INT,
IN p_idcliente INT 

)
BEGIN
	DECLARE p_fecha DATE; 
	DECLARE p_monto DECIMAL(12,2);
	DECLARE p_tipo INT;
    
    DECLARE existe_prod INT;
    DECLARE existe_cliente INT;
    
	SELECT costo, tipo INTO p_monto, p_tipo FROM productoservicios WHERE id_productoservicio = p_idcodigo;
	SET p_fecha = STR_TO_DATE(p_fechav, '%d/%m/%Y'); 

	IF p_tipo = 2 AND p_compra <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Los productos deben traer un precio';
	END IF;
    
	IF p_tipo = 1 AND p_compra <>  0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Los servicio ya tienen un precio';
	END IF;

	SELECT id_cliente INTO existe_cliente FROM clientes WHERE id_cliente = p_idcliente;
    IF existe_cliente IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe';
	END IF;
    
    SELECT id_productoservicio INTO existe_prod FROM productoservicios WHERE id_productoservicio = p_idcodigo;
	IF existe_prod IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto o servicio no existe';
	END IF;
    
    IF p_tipo = 1 THEN
		SET p_compra = p_monto;
	END IF;
    
    INSERT INTO compras(id_compra, fecha, importe_compra, id_productoservicio, id_cliente, id_transaccion) VALUES (p_idcompra, p_fecha, p_compra, p_idcodigo, p_idcliente, null);
        
END//

DELIMITER ;

-- Depositos

DELIMITER //

CREATE PROCEDURE realizarDeposito(
IN p_iddeposito INT,
IN p_fechav VARCHAR(40),
IN p_monto DECIMAL(12,2),
IN p_detalles VARCHAR(40),
IN p_idcliente INT 

)
BEGIN
	DECLARE p_fecha DATE; 
	DECLARE existe_cliente INT;

	SET p_fecha = STR_TO_DATE(p_fechav, '%d/%m/%Y'); 
    
	SELECT id_cliente INTO existe_cliente FROM clientes WHERE id_cliente = p_idcliente;
    IF existe_cliente IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe';
	END IF;
    

	IF p_monto <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El monto debe ser mayor a 0';
    END IF;
    
    INSERT INTO depositos(id_deposito, fecha, monto, otros_detalles, id_cliente, id_transaccion) VALUES (p_iddeposito, p_fecha, p_monto, p_detalles, p_idcliente, null );

END//

DELIMITER ;

-- Debitos
DELIMITER //

CREATE PROCEDURE realizarDebito(
IN p_iddebito INT,
IN p_fechav VARCHAR(40),
IN p_monto DECIMAL(12,2),
IN p_detalles VARCHAR(40),
IN p_idcliente INT 

)
BEGIN
	DECLARE p_fecha DATE; 
	DECLARE existe_cliente INT;
	SET p_fecha = STR_TO_DATE(p_fechav, '%d/%m/%Y'); 
    
	SELECT id_cliente INTO existe_cliente FROM clientes WHERE id_cliente = p_idcliente;
    IF existe_cliente IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe';
	END IF;
    
	IF p_monto <= 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El monto debe ser mayor a 0';
    END IF;
    
    INSERT INTO debitos(id_debito , fecha, monto, otros_detalles, id_cliente, id_transaccion) VALUES (p_iddebito, p_fecha, p_monto, p_detalles, p_idcliente, null );

END//

DELIMITER ;

-- Tipo Transacciones
DELIMITER // 
CREATE PROCEDURE registrarTipoTransaccion(
IN p_idcodigo INT,
IN p_nombre VARCHAR(20),
IN p_detalle VARCHAR(40)
)
BEGIN
	IF p_nombre = '' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre no puede ser null';
    END IF;
	INSERT INTO tipo_transacciones(id_tipotransaccion, nombre, descripcion) VALUES (p_idcodigo, p_nombre, p_detalle);
END//

DELIMITER ;

-- Transacciones
DELIMITER //

CREATE PROCEDURE asignarTransaccion(
	IN p_idtransaccion INT,
	IN p_vfecha VARCHAR(100),
    IN p_detalles VARCHAR(40),
    IN p_tipotransaccion INT,
    IN p_movimiento INT,
    IN p_idcuenta BIGINT
)
BEGIN 
	DECLARE clientemov INT;
    DECLARE montomov DECIMAL(12,2);
    DECLARE transaccionmov INT;
    
    DECLARE clientecuenta INT;
    DECLARE montocuenta DECIMAL(12,2);
    
    DECLARE id_count INT;
    DECLARE  existe_tipo INT;
    DECLARE existe_cuenta INT;
    
    DECLARE p_fecha DATE; 

	SET p_fecha = STR_TO_DATE(p_vfecha, '%d/%m/%Y'); 
    
	SELECT  id_tipotransaccion INTO existe_tipo FROM tipo_transacciones WHERE id_tipotransaccion = p_tipotransaccion;
    IF existe_tipo IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo de transaccion no existe';
	END IF;
    
    SELECT  id_cliente INTO existe_cuenta FROM cuentas WHERE id_cuenta = p_idcuenta;
    IF existe_cuenta IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta no existe';
	END IF;
    
    IF p_tipotransaccion = 1 THEN
		SELECT COUNT(*) INTO id_count FROM compras WHERE id_compra = p_movimiento;
		IF id_count = 0 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID no existe en compras';
		END IF;
        
        SELECT importe_compra, id_cliente, id_transaccion INTO montomov, clientemov, transaccionmov FROM compras WHERE id_compra = p_movimiento;
        SELECT saldo_cuenta, id_cliente INTO montocuenta, clientecuenta FROM cuentas WHERE id_cuenta = p_idcuenta;
        
        IF montocuenta IS NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta no existe';
        END IF;
        
        IF transaccionmov IS NOT NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta compra ya fue realizada';
        END IF;
        
        IF clientemov <> clientecuenta THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id cliente no es el mismo entre cuanta y compra';
        END IF;
        
        
        IF montomov > montocuenta THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No saldo suficiente';
        END IF;
	   INSERT INTO transacciones(id_transaccion, fecha, otros_detalles, id_tipotransaccion, id_cuenta, id_movimiento) VALUES (p_idtransaccion, p_fecha, p_detalles, p_tipotransaccion, p_idcuenta, p_movimiento);
       UPDATE cuentas SET saldo_cuenta = montocuenta - montomov WHERE id_cuenta = p_idcuenta;
       UPDATE compras SET id_transaccion = p_idtransaccion WHERE id_compra = p_movimiento;
    END IF;
    
	IF p_tipotransaccion = 2 THEN
		SELECT COUNT(*) INTO id_count FROM depositos WHERE id_deposito = p_movimiento;
		IF id_count = 0 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID no existe en deposito';
		END IF;
        
        SELECT monto, id_cliente, id_transaccion INTO montomov, clientemov, transaccionmov FROM depositos WHERE id_deposito = p_movimiento;
        SELECT saldo_cuenta, id_cliente INTO montocuenta, clientecuenta FROM cuentas WHERE id_cuenta = p_idcuenta;
        
        IF montocuenta IS NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta no existe';
        END IF;
        
                IF transaccionmov IS NOT NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este deposito ya fue realizado';
        END IF;
        

	   INSERT INTO transacciones(id_transaccion, fecha, otros_detalles, id_tipotransaccion, id_cuenta, id_movimiento) VALUES (p_idtransaccion, p_fecha, p_detalles, p_tipotransaccion, p_idcuenta, p_movimiento);
       UPDATE cuentas SET saldo_cuenta = montocuenta + montomov WHERE id_cuenta = p_idcuenta;
       UPDATE depositos SET id_transaccion = p_idtransaccion WHERE id_deposito = p_movimiento;
    END IF;
	
	IF p_tipotransaccion = 3 THEN
		SELECT COUNT(*) INTO id_count FROM debitos WHERE id_debito = p_movimiento;
		IF id_count = 0 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ID no existe en debito';
		END IF;
        
        SELECT monto, id_cliente, id_transaccion INTO montomov, clientemov, transaccionmov FROM debitos WHERE id_debito = p_movimiento;
        SELECT saldo_cuenta, id_cliente INTO montocuenta, clientecuenta FROM cuentas WHERE id_cuenta = p_idcuenta;
        IF montocuenta IS NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta no existe';
        END IF;
        
		IF transaccionmov IS NOT NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este debito ya fue realizado';
        END IF;
        
        
        IF clientemov <> clientecuenta THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id cliente no es el mismo entre cuenta y debito';
        END IF;
        
        
        IF montomov > montocuenta THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No saldo suficiente';
        END IF;
        
	   INSERT INTO transacciones(id_transaccion, fecha, otros_detalles, id_tipotransaccion, id_cuenta, id_movimiento) VALUES (p_idtransaccion, p_fecha, p_detalles, p_tipotransaccion, p_idcuenta, p_movimiento);
       UPDATE cuentas SET saldo_cuenta = montocuenta - montomov WHERE id_cuenta = p_idcuenta;
       UPDATE debitos SET id_transaccion = p_idtransaccion WHERE id_debito = p_movimiento;
       
       
    END IF;
    

END//

DELIMITER ;






