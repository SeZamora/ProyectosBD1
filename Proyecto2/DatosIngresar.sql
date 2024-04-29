CALL registrarTipoCliente(1, 'Individual Nacional', 'Este tipo de cliente es una persona individual de nacionalidad guatemalteca');
CALL registrarTipoCliente(2, 'Individual Extranjero', 'Este tipo de cliente es una persona individual de nacionalidad extranjera');
CALL registrarTipoCliente(3, 'Empresa PyMe', 'Este tipo de cliente es una empresa de tipo pequena o mediana');
CALL registrarTipoCliente(4, 'Empresa S.C', 'Este tipo de cliente corresponde a las empresas que son sociedad colectiva');

CALL registrarTipoCuenta(1, 'Cuenta de Cheques', 'Este tipo de cuenta ofrece facilidades de emitir cheques para realizar transacciones monetarias.');
CALL registrarTipoCuenta(2, 'Cuenta Ahorro', 'Es una cuenta que genera un interés anual del 2%, lo que la hace ideal para guardar fondos a largo plazo.');
CALL registrarTipoCuenta(3, 'Cuenta Ahorro Plus', 'Con una tasa de interés anual del 10%, esta cuenta de ahorros ofrece mayores rendimientos.');
CALL registrarTipoCuenta(4, 'Pequeña Cuenta', 'Una cuenta de ahorros con un interés semestral del 0.5%, ideal para pequeños ahorros y movimientos.');
CALL registrarTipoCuenta(5, 'Cuenta de Nómina', 'Diseñada para recibir depósitos de sueldos y realizar pagos, con acceso a servicios bancarios básicos.');
CALL registrarTipoCuenta(6, 'Cuenta de Inversión', 'Orientada a inversionistas, ofrece opciones de inversión y rendimiento más altos que una cuenta estándar.');

CALL crearProductoServicio(1, 1, 10.00, 'Servicio de tarjeta de débito');
CALL crearProductoServicio(2, 1, 10.00, 'Servicio de chequera');
CALL crearProductoServicio(3, 1, 400.00, 'Servicio de asesoramiento financiero');
CALL crearProductoServicio(4, 1, 5.00, 'Servicio de banca personal');
CALL crearProductoServicio(5, 1, 30.00, 'Seguro de vida');
CALL crearProductoServicio(6, 1, 100.00, 'Seguro de vida plus');
CALL crearProductoServicio(7, 1, 300.00, 'Seguro de automóvil');
CALL crearProductoServicio(8, 1, 500.00, 'Seguro de automóvil plus');
CALL crearProductoServicio(9, 1, 00.05, 'Servicio de deposito');
CALL crearProductoServicio(10, 1, 00.10, 'Servicio de Debito');
CALL crearProductoServicio(11, 2, 0, 'Pago de energía Eléctrica(EEGSA)');
CALL crearProductoServicio(12, 2, 0, 'Pago de agua potable(Empagua');
CALL crearProductoServicio(13, 2, 0, 'Pago de Matricula USAC');
CALL crearProductoServicio(14, 2, 0, 'Pago de curso vacaciones USAC');
CALL crearProductoServicio(15, 2, 0, 'Pago de servicio de interne');
CALL crearProductoServicio(16, 2, 0, 'Servicio de suscripción plataformas streaming');
CALL crearProductoServicio(17, 2, 0, 'Servicios Cloud');

call registrarTipoTransaccion(1, 'Compra', 'Transacción de compra');
call registrarTipoTransaccion(2, 'Deposito', 'Transacción de deposito');
call registrarTipoTransaccion(3, 'Debito', 'Transacción de debito');
