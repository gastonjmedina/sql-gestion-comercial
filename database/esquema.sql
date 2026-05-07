IF DB_ID('jardineria') IS NOT NULL
    DROP DATABASE jardineria;
GO

CREATE DATABASE jardineria;
GO

USE jardineria;
GO

CREATE TABLE oficina (
  codigo_oficina VARCHAR(10) NOT NULL PRIMARY KEY,
  ciudad VARCHAR(30) NOT NULL,
  pais VARCHAR(50) NOT NULL,
  region VARCHAR(50) NULL,
  codigo_postal VARCHAR(10) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50) NULL
);
GO

CREATE TABLE empleado (
  codigo_empleado INT NOT NULL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(50) NOT NULL,
  apellido2 VARCHAR(50) NULL,
  extension VARCHAR(10) NOT NULL,
  email VARCHAR(100) NOT NULL,
  codigo_oficina VARCHAR(10) NOT NULL,
  codigo_jefe INT NULL,
  puesto VARCHAR(50) NULL,
  CONSTRAINT FK_empleado_oficina FOREIGN KEY (codigo_oficina)
    REFERENCES oficina(codigo_oficina)
);
GO

ALTER TABLE empleado
ADD CONSTRAINT FK_empleado_jefe
FOREIGN KEY (codigo_jefe) REFERENCES empleado(codigo_empleado);
GO

CREATE TABLE gama_producto (
  gama VARCHAR(50) NOT NULL PRIMARY KEY,
  descripcion_texto VARCHAR(MAX),
  descripcion_html VARCHAR(MAX),
  imagen VARCHAR(256)
);
GO

CREATE TABLE cliente (
  codigo_cliente INT NOT NULL PRIMARY KEY,
  nombre_cliente VARCHAR(50) NOT NULL,
  nombre_contacto VARCHAR(30) NULL,
  apellido_contacto VARCHAR(30) NULL,
  telefono VARCHAR(15) NOT NULL,
  fax VARCHAR(15) NOT NULL,
  linea_direccion1 VARCHAR(50) NOT NULL,
  linea_direccion2 VARCHAR(50) NULL,
  ciudad VARCHAR(50) NOT NULL,
  region VARCHAR(50) NULL,
  pais VARCHAR(50) NULL,
  codigo_postal VARCHAR(10) NULL,
  codigo_empleado_rep_ventas INT NULL,
  limite_credito NUMERIC(15,2) NULL,
  CONSTRAINT FK_cliente_empleado FOREIGN KEY (codigo_empleado_rep_ventas)
    REFERENCES empleado(codigo_empleado)
);
GO

CREATE TABLE pedido (
  codigo_pedido INT NOT NULL PRIMARY KEY,
  fecha_pedido DATE NOT NULL,
  fecha_esperada DATE NOT NULL,
  fecha_entrega DATE NULL,
  estado VARCHAR(15) NOT NULL,
  comentarios VARCHAR(MAX),
  codigo_cliente INT NOT NULL,
  CONSTRAINT FK_pedido_cliente FOREIGN KEY (codigo_cliente)
    REFERENCES cliente(codigo_cliente)
);
GO

CREATE TABLE producto (
  codigo_producto VARCHAR(15) NOT NULL PRIMARY KEY,
  nombre VARCHAR(70) NOT NULL,
  gama VARCHAR(50) NOT NULL,
  dimensiones VARCHAR(25) NULL,
  proveedor VARCHAR(50) NULL,
  descripcion VARCHAR(MAX) NULL,
  cantidad_en_stock SMALLINT NOT NULL,
  precio_venta NUMERIC(15,2) NOT NULL,
  precio_proveedor NUMERIC(15,2) NULL,
  CONSTRAINT FK_producto_gama FOREIGN KEY (gama)
    REFERENCES gama_producto(gama)
);
GO

CREATE TABLE detalle_pedido (
  codigo_pedido INT NOT NULL,
  codigo_producto VARCHAR(15) NOT NULL,
  cantidad INT NOT NULL,
  precio_unidad NUMERIC(15,2) NOT NULL,
  numero_linea SMALLINT NOT NULL,
  PRIMARY KEY (codigo_pedido, codigo_producto),
  CONSTRAINT FK_detalle_pedido FOREIGN KEY (codigo_pedido)
    REFERENCES pedido(codigo_pedido),
  CONSTRAINT FK_detalle_producto FOREIGN KEY (codigo_producto)
    REFERENCES producto(codigo_producto)
);
GO

CREATE TABLE pago (
  codigo_cliente INT NOT NULL,
  forma_pago VARCHAR(40) NOT NULL,
  id_transaccion VARCHAR(50) NOT NULL,
  fecha_pago DATE NOT NULL,
  total NUMERIC(15,2) NOT NULL,
  PRIMARY KEY (codigo_cliente, id_transaccion),
  CONSTRAINT FK_pago_cliente FOREIGN KEY (codigo_cliente)
    REFERENCES cliente(codigo_cliente)
);
GO