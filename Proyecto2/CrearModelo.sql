CREATE TABLE tipo_clientes (
    id_tipocliente INTEGER AUTO_INCREMENT NOT NULL,
    nombre     VARCHAR(40) NOT NULL,
    descripcion VARCHAR(300),
    PRIMARY KEY(id_tipocliente)
);


CREATE TABLE tipo_cuentas (
    id_tipocuenta INTEGER AUTO_INCREMENT NOT NULL,
    nombre        VARCHAR(40) NOT NULL,
    descripcion   VARCHAR(300) NOT NULL,
    PRIMARY KEY(id_tipocuenta)
);

CREATE TABLE tipo_transacciones (
    id_tipotransaccion INTEGER NOT NULL,
    nombre             VARCHAR(40) NOT NULL,
    descripcion        VARCHAR(300) NOT NULL,
    PRIMARY KEY(id_tipotransaccion)
);

CREATE TABLE productoservicios (
    id_productoservicio INTEGER NOT NULL,
    tipo                INTEGER NOT NULL,
    costo               DECIMAL(12, 2) NOT NULL,
    descripcion         VARCHAR(100) NOT NULL,
    PRIMARY KEY(id_productoservicio)
);

CREATE TABLE clientes (
    id_cliente     INTEGER NOT NULL,
    nombre         VARCHAR(40) NOT NULL,
    apellido       VARCHAR(40) NOT NULL,
    usuario        VARCHAR(40) NOT NULL UNIQUE,
    contrasena     VARBINARY(255) NOT NULL,
    fecha          DATE NOT NULL,
    id_tipocliente INTEGER NOT NULL,
    PRIMARY KEY(id_cliente),
    FOREIGN KEY(id_tipocliente) REFERENCES tipo_clientes(id_tipocliente)
);

CREATE TABLE telefonos(
	id_telefono INTEGER NOT NULL auto_increment,
    telefono VARCHAR(8) UNIQUE,
    id_cliente INTEGER,
    PRIMARY KEY(id_telefono),
    FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE correos(
	id_correo INTEGER NOT NULL auto_increment,
    correo VARCHAR(150) UNIQUE,
    id_cliente INTEGER,
    PRIMARY KEY(id_correo),
    FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente)
);
    
CREATE TABLE cuentas (
    id_cuenta      BIGINT NOT NULL,
    monto_apertura DECIMAL(12, 2) NOT NULL,
    saldo_cuenta   DECIMAL(12, 2) NOT NULL,
    descripcion    VARCHAR(50) NOT NULL,
    fecha_apertura DATETIME NOT NULL,
    otros_detalles VARCHAR(100),
    id_tipocuenta  INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    PRIMARY KEY (id_cuenta),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY(id_tipocuenta) REFERENCES tipo_cuentas(id_tipocuenta)
);

CREATE TABLE transacciones (
    id_transaccion     INTEGER NOT NULL,
    fecha              DATE NOT NULL,
    otros_detalles     VARCHAR(40),
    id_tipotransaccion INTEGER NOT NULL,
    id_cuenta  BIGINT NOT NULL,
    id_movimiento INT NOT NULL,
    PRIMARY KEY(id_transaccion),
    FOREIGN KEY(id_tipotransaccion) REFERENCES tipo_transacciones(id_tipotransaccion),
    FOREIGN KEY(id_cuenta) REFERENCES cuentas(id_cuenta)
);

CREATE TABLE compras (
    id_compra           INTEGER NOT NULL,
    fecha               DATE NOT NULL,
    importe_compra      DECIMAL(12, 2),
    id_productoservicio INTEGER NOT NULL,
    id_cliente          INTEGER NOT NULL,
    id_transaccion      INTEGER	,
    PRIMARY KEY(id_compra),
    FOREIGN KEY(id_productoservicio) REFERENCES productoservicios(id_productoservicio),
    FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY(id_transaccion) REFERENCES transacciones(id_transaccion)
);

CREATE TABLE debitos (
    id_debito      INTEGER NOT NULL,
    fecha          DATE NOT NULL,
    monto          DECIMAL(12, 2) NOT NULL,
    otros_detalles VARCHAR(40),
    id_cliente     INTEGER NOT NULL,
    id_transaccion INTEGER,
	PRIMARY KEY(id_debito),
	FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY(id_transaccion) REFERENCES transacciones(id_transaccion)
);

CREATE TABLE depositos (
    id_deposito    INTEGER NOT NULL,
    fecha          DATE NOT NULL,
    monto          DECIMAL(12, 2) NOT NULL,
    otros_detalles VARCHAR(40),
    id_cliente     INTEGER NOT NULL,
    id_transaccion INTEGER,
	PRIMARY KEY(id_deposito),
    FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY(id_transaccion) REFERENCES transacciones(id_transaccion)
);

CREATE TABLE historialTablas(
	id INT AUTO_INCREMENT NOT NULL,
    fecha DATETIME,
    descripcion VARCHAR(200),
    tipo VARCHAR(20),
    PRIMARY KEY(id)
);





