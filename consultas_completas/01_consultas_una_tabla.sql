

-- 1.4.4 CONSULTAS SOBRE UNA TABLA



--1)

SELECT codigo_oficina, 
       ciudad
FROM oficina;

--2)

SELECT ciudad,
       telefono
FROM oficina
WHERE pais = 'España';

--3)

SELECT nombre, 
       apellido1, 
	   email
FROM empleado
WHERE codigo_jefe = 7;

--4)

SELECT puesto,
       nombre,
	   apellido1,
	   email
FROM empleado
WHERE codigo_jefe IS NULL;

--5)

SELECT nombre,
       apellido1,
	   puesto
FROM empleado
WHERE puesto <> 'Representante Ventas';

--6)

SELECT nombre_cliente
FROM cliente
WHERE pais = 'Spain';

--7)

SELECT DISTINCT estado
FROM pedido;

--8)

SELECT DISTINCT codigo_cliente
FROM pago
WHERE YEAR(fecha_pago) = 2008;

-- Sin usar "YEAR"

SELECT DISTINCT codigo_cliente
FROM pago
WHERE fecha_pago >= '2008-01-01' 
  AND fecha_pago < '2009-01-01';

--9)

SELECT codigo_pedido, 
       codigo_cliente, 
	   fecha_esperada, 
	   fecha_entrega 
FROM Pedido 
WHERE fecha_entrega > fecha_esperada;

--10)

SELECT codigo_pedido, 
       codigo_cliente, 
	   fecha_esperada, 
	   fecha_entrega
FROM pedido
WHERE fecha_entrega <= DATEADD(DAY, -2, fecha_esperada);

--11)

SELECT * FROM Pedido 
WHERE estado = 'Rechazado' 
  AND YEAR(fecha_pedido) = 2009;

--12)

SELECT *
FROM pedido
WHERE estado = 'Entregado'
  AND MONTH(fecha_entrega) = 01;

--13)

SELECT *
FROM pago
WHERE YEAR(fecha_pago) = 2008
  AND forma_pago = 'Paypal'
ORDER BY total DESC;

--14)

SELECT DISTINCT forma_pago
FROM pago;

--15)

SELECT * 
FROM Producto 
WHERE gama = 'Ornamentales' 
  AND cantidad_en_stock > 100
ORDER BY precio_venta DESC;

--16)

SELECT codigo_cliente, 
       nombre_cliente
FROM cliente
WHERE ciudad = 'Madrid'
  AND codigo_empleado_rep_ventas IN (11,30);
