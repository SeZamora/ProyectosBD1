#### Universidad de San Carlos de Guatemala
#### Facultad de Ingeniería
#### Laboratorio de Base de Datos 1
#### Primer Semestre de 2024

|Nombre  | Carnet | 
|------------- | -------------|
|Jorge Sebastian Zamora Polanco  | 202002591|

## Manual Tecnico

# Proyecto 1

## Modelo de la Base de datos

[![Modelo-Fisico.jpg](https://i.postimg.cc/gJ1dTd11/Modelo-Fisico.jpg)](https://postimg.cc/7G1pCvHN)

### Descripcion del modelo

1. **Paises**:
   - `id_pais` es la clave primaria, que es un identificador único para cada país.
   - `nombre` es el nombre del país.
   - No tiene relaciones con otras tablas.

2. **Categorias**:
   - `id_categoria` es la clave primaria, que es un identificador único para cada categoría.
   - `nombre` es el nombre de la categoría.
   - No tiene relaciones con otras tablas.

3. **Productos**:
   - `id_producto` es la clave primaria, que es un identificador único para cada producto.
   - `nombre` es el nombre del producto.
   - `precio` es el precio del producto.
   - `id_categoria` es una clave externa que hace referencia a la tabla `Categorias`.
   - Tiene una relación de muchos a uno con la tabla `Categorias`.

4. **Vendedores**:
   - `id_vendedor` es la clave primaria, que es un identificador único para cada vendedor.
   - `nombre` es el nombre del vendedor.
   - `id_pais` es una clave externa que hace referencia a la tabla `Paises`.
   - Tiene una relación de muchos a uno con la tabla `Paises`.

5. **Clientes**:
   - `id_cliente` es la clave primaria, que es un identificador único para cada cliente.
   - `nombre`, `apellido`, `direccion`, `telefono`, `tarjeta`, `edad`, `salario` y `genero` son atributos relacionados con la información personal del cliente.
   - `id_pais` es una clave externa que hace referencia a la tabla `Paises`.
   - Tiene una relación de muchos a uno con la tabla `Paises`.

6. **Ordenes**:
   - `id_orden` es la clave primaria, que es un identificador único para cada orden.
   - `fecha_orden` es la fecha en que se realizó la orden.
   - `id_cliente` es una clave externa que hace referencia a la tabla `Clientes`.
   - Tiene una relación de muchos a uno con la tabla `Clientes`.

7. **LineasOrdenes**:
   - `id_lineaOrden` es parte de la clave primaria, identificador único para cada línea de orden dentro de una orden específica.
   - `id_orden` es parte de la clave primaria y una clave externa que hace referencia a la tabla `Ordenes`.
   - `cantidad` es la cantidad de productos en esta línea de orden.
   - `id_vendedor` es una clave externa que hace referencia a la tabla `Vendedores`.
   - `id_producto` es una clave externa que hace referencia a la tabla `Productos`.
   - Tiene relaciones de muchos a uno con las tablas `Ordenes`, `Vendedores` y `Productos`.

