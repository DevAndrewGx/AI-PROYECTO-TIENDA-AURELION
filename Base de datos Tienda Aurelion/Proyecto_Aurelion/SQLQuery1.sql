USE Tienda_Aurelion;

-- Categoría

CREATE TABLE categorias(
	id_categoria INT PRIMARY KEY IDENTITY(1,1),
	categoria VARCHAR(50) NOT NULL 
);

INSERT INTO categorias(categoria)
VALUES ('Alimentos'),
	   ('Limpieza');


SELECT * FROM categorias;

DROP TABLE categorias;

-- Productos

CREATE TABLE producto(
id_categoria INT FOREIGN KEY REFERENCES categoria(id_categoria),
id_producto INT PRIMARY KEY IDENTITY(1,1),
nombre_producto VARCHAR(100),
precio_unitario FLOAT(1)
);

INSERT INTO producto (id_categoria, nombre_producto, precio_unitario)
VALUES (3, 'trapo', 30.5);

INSERT INTO producto (id_categoria, nombre_producto, precio_unitario)
VALUES (8, 'trapo', 20.45);

SELECT * FROM producto;

TRUNCATE TABLE producto;

DROP TABLE producto;

DROP TABLE producto;

-- Ciudad

CREATE TABLE ciudades(
id_ciudad INT PRIMARY KEY IDENTITY(1,1),
ciudad VARCHAR(100) NOT NULL
);

INSERT INTO ciudades(ciudad)
VALUES ('Carlos Paz'),
('Rio Cuarto'),
('Cordoba'),
('Villa Maria'),
('Alta Gracia'),
('Mendiolaza');


SELECT * FROM ciudades;

DROP TABLE ciudades;


-- Clientes

CREATE TABLE clientes(
id_cliente INT PRIMARY KEY IDENTITY(1,1),
nombre_cliente TEXT,
email TEXT,
id_ciudad INT FOREIGN KEY REFERENCES ciudad(id_ciudad),
fecha_alta DATE
);

INSERT INTO clientes(nombre_cliente, email, id_ciudad, fecha_alta)
VALUES ('José Santi', 'jos12@gmail.com', 1, '2025-12-12');

INSERT INTO clientes(nombre_cliente, email, id_ciudad, fecha_alta)
VALUES ('Sara Colonia', 'col12@gmail.com', 1, '2025-12-20');


SELECT * FROM clientes;

DELETE FROM clientes;

DROP TABLE clientes;

-- Medio de Pago

CREATE TABLE medio_de_pago(
id_medio_pago INT PRIMARY KEY IDENTITY(1,1),
medio_pago VARCHAR(100) NOT NULL
);

INSERT INTO medio_de_pago(medio_pago)
VALUES ('tarjeta'),
('qr'),
('transferencia'),
('efectivo');


SELECT * FROM medio_de_pago;

DROP TABLE medio_de_pago;


-- Ventas

CREATE TABLE ventas(
id_venta INT PRIMARY KEY IDENTITY(1,1),
fecha DATE,
id_cliente INT FOREIGN KEY REFERENCES clientes(id_cliente),
id_medio_pago INT FOREIGN KEY REFERENCES medio_de_pago(id_medio_pago) 
);

INSERT INTO ventas (fecha, id_cliente, id_medio_pago)
VALUES ('2025-12-25', 5,1);

SELECT * FROM ventas; 

DROP TABLE ventas;

-- Detalle ventas

CREATE TABLE detalle_ventas(
id_venta INT FOREIGN KEY REFERENCES ventas(id_venta),
id_producto INT FOREIGN KEY REFERENCES producto(id_producto),
cantidad INT,
importe FLOAT(1)
);

INSERT INTO detalle_ventas(id_venta, id_producto, cantidad, importe)
VALUES (2, 3, 5, 60);

INSERT INTO detalle_ventas(id_venta, id_producto, cantidad, importe)
VALUES (2, 1, 8, 120);


SELECT * FROM detalle_ventas; 

DROP TABLE detalle_ventas;

-- TRUNCATE TABLE detalle_ventas;