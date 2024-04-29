-- Que no se repita debitos, compras y depositos
DELIMITER $$

CREATE TRIGGER check_primary_key_compras
BEFORE INSERT ON compras
FOR EACH ROW
BEGIN
    DECLARE existing_id_compra INT;

    -- Verificar si el id_cliente ya existe en debitos
    SELECT id_debito INTO existing_id_compra FROM debitos WHERE id_debito = NEW.id_compra LIMIT 1;
    IF existing_id_compra IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id_cliente ya existe en la tabla debitos';
    END IF;

    -- Verificar si el id_cliente ya existe en depositos
    SELECT id_deposito INTO existing_id_compra FROM depositos WHERE id_deposito = NEW.id_compra LIMIT 1;
    IF existing_id_compra IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id_cliente ya existe en la tabla depositos';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER check_primary_key_debitos
BEFORE INSERT ON debitos
FOR EACH ROW
BEGIN
    DECLARE existing_id_debito INT;

    -- Verificar si el id_cliente ya existe en compras
    SELECT id_compra INTO existing_id_debito FROM compras WHERE id_compra = NEW.id_debito LIMIT 1;
    IF existing_id_debito IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id_cliente ya existe en la tabla compras';
    END IF;

    -- Verificar si el id_cliente ya existe en depositos
    SELECT id_deposito INTO existing_id_debito FROM depositos WHERE id_deposito = NEW.id_debito LIMIT 1;
    IF existing_id_debito IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id_cliente ya existe en la tabla depositos';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER check_primary_key_depositos
BEFORE INSERT ON depositos
FOR EACH ROW
BEGIN
    DECLARE existing_id_deposito INT;

    -- Verificar si el id_cliente ya existe en compras
    SELECT id_compra INTO existing_id_deposito FROM compras WHERE id_compra = NEW.id_deposito LIMIT 1;
    IF existing_id_deposito IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id_cliente ya existe en la tabla compras';
    END IF;

    -- Verificar si el id_cliente ya existe en debitos
    SELECT id_debito INTO existing_id_deposito FROM debitos WHERE id_debito = NEW.id_deposito LIMIT 1;
    IF existing_id_deposito IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El id_cliente ya existe en la tabla debitos';
    END IF;
END$$

DELIMITER ;

-- No modificar monto apertura
DELIMITER //
CREATE TRIGGER update_montoCuenta
BEFORE UPDATE ON cuentas
FOR EACH ROW
BEGIN
    IF OLD.monto_apertura <> NEW.monto_apertura THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No puedes modificar el monto apertura de una cuenta';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER ins_clientes AFTER INSERT ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en clientes', 'Inserción');
END;
//
DELIMITER ;

-- Trigger para modificaciones en clientes
DELIMITER //
CREATE TRIGGER upd_clientes AFTER UPDATE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en clientes', 'Modificación');
END;
//
DELIMITER ;

-- Trigger para eliminaciones en clientes
DELIMITER //
CREATE TRIGGER del_clientes AFTER DELETE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en clientes', 'Eliminación');
END;
//
DELIMITER ;

-- Trigger para inserciones en cuentas
DELIMITER //
CREATE TRIGGER ins_cuentas AFTER INSERT ON cuentas
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en cuentas', 'Inserción');
END;
//
DELIMITER ;

-- Trigger para modificaciones en cuentas
DELIMITER //
CREATE TRIGGER upd_cuentas AFTER UPDATE ON cuentas
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en cuentas', 'Modificación');
END;
//
DELIMITER ;

-- Trigger para eliminaciones en cuentas
DELIMITER //
CREATE TRIGGER del_cuentas AFTER DELETE ON cuentas
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en cuentas', 'Eliminación');
END;
//
DELIMITER ;

-- Trigger para compras
DELIMITER //
CREATE TRIGGER trg_compras_ins AFTER INSERT ON compras
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en compras', 'Inserción');
END;
//
CREATE TRIGGER trg_compras_upd AFTER UPDATE ON compras
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en compras', 'Modificación');
END;
//
CREATE TRIGGER trg_compras_del AFTER DELETE ON compras
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en compras', 'Eliminación');
END;
//
DELIMITER ;

-- Trigger para debitos
DELIMITER //
CREATE TRIGGER trg_debitos_ins AFTER INSERT ON debitos
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en débitos', 'Inserción');
END;
//
CREATE TRIGGER trg_debitos_upd AFTER UPDATE ON debitos
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en débitos', 'Modificación');
END;
//
CREATE TRIGGER trg_debitos_del AFTER DELETE ON debitos
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en débitos', 'Eliminación');
END;
//
DELIMITER ;

-- Trigger para depositos
DELIMITER //
CREATE TRIGGER trg_depositos_ins AFTER INSERT ON depositos
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en depósitos', 'Inserción');
END;
//
CREATE TRIGGER trg_depositos_upd AFTER UPDATE ON depositos
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en depósitos', 'Modificación');
END;
//
CREATE TRIGGER trg_depositos_del AFTER DELETE ON depositos
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en depósitos', 'Eliminación');
END;
//
DELIMITER ;

-- Trigger para inserciones en productoservicios
DELIMITER //
CREATE TRIGGER ins_productoservicios AFTER INSERT ON productoservicios
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en productoservicios', 'Inserción');
END;
//
DELIMITER ;

-- Trigger para modificaciones en productoservicios
DELIMITER //
CREATE TRIGGER upd_productoservicios AFTER UPDATE ON productoservicios
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en productoservicios', 'Modificación');
END;
//
DELIMITER ;

-- Trigger para eliminaciones en productoservicios
DELIMITER //
CREATE TRIGGER del_productoservicios AFTER DELETE ON productoservicios
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en productoservicios', 'Eliminación');
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER ins_tipo_clientes AFTER INSERT ON tipo_clientes
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en tipo_clientes', 'Inserción');
END;
//
DELIMITER ;

-- Trigger para modificaciones en tipo_clientes
DELIMITER //
CREATE TRIGGER upd_tipo_clientes AFTER UPDATE ON tipo_clientes
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en tipo_clientes', 'Modificación');
END;
//
DELIMITER ;

-- Trigger para eliminaciones en tipo_clientes
DELIMITER //
CREATE TRIGGER del_tipo_clientes AFTER DELETE ON tipo_clientes
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en tipo_clientes', 'Eliminación');
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER ins_tipo_cuentas AFTER INSERT ON tipo_cuentas
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en tipo_cuentas', 'Inserción');
END;
//
DELIMITER ;

-- Trigger para modificaciones en tipo_cuentas
DELIMITER //
CREATE TRIGGER upd_tipo_cuentas AFTER UPDATE ON tipo_cuentas
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en tipo_cuentas', 'Modificación');
END;
//
DELIMITER ;

-- Trigger para eliminaciones en tipo_cuentas
DELIMITER //
CREATE TRIGGER del_tipo_cuentas AFTER DELETE ON tipo_cuentas
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en tipo_cuentas', 'Eliminación');
END;
//
DELIMITER ;

-- Trigger para inserciones en tipo_transacciones
DELIMITER //
CREATE TRIGGER ins_tipo_transacciones AFTER INSERT ON tipo_transacciones
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en tipo_transacciones', 'Inserción');
END;
//
DELIMITER ;

-- Trigger para modificaciones en tipo_transacciones
DELIMITER //
CREATE TRIGGER upd_tipo_transacciones AFTER UPDATE ON tipo_transacciones
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en tipo_transacciones', 'Modificación');
END;
//
DELIMITER ;

-- Trigger para eliminaciones en tipo_transacciones
DELIMITER //
CREATE TRIGGER del_tipo_transacciones AFTER DELETE ON tipo_transacciones
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en tipo_transacciones', 'Eliminación');
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER ins_transacciones AFTER INSERT ON transacciones
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Inserción en transacciones', 'Inserción');
END;
//
DELIMITER ;

-- Trigger para modificaciones en transacciones
DELIMITER //
CREATE TRIGGER upd_transacciones AFTER UPDATE ON transacciones
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Modificación en transacciones', 'Modificación');
END;
//
DELIMITER ;

-- Trigger para eliminaciones en transacciones
DELIMITER //
CREATE TRIGGER del_transacciones AFTER DELETE ON transacciones
FOR EACH ROW
BEGIN
    INSERT INTO historialTablas (fecha, descripcion, tipo) VALUES (NOW(), 'Eliminación en transacciones', 'Eliminación');
END;
//
DELIMITER ;


