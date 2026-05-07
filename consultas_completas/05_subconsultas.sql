

-- 1.4.8 SUBCONSULTAS

-- 1.4.8.1 Con operadores básicos de comparación



--1)

SELECT nombre_cliente, 
       limite_credito
FROM cliente
WHERE limite_credito = (SELECT MAX(limite_credito) FROM cliente);


--2)

SELECT nombre, 
       precio_venta
FROM producto
WHERE precio_venta = (SELECT MAX(precio_venta) FROM producto);


--3)

SELECT p.nombre
FROM producto p
INNER JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
GROUP BY p.codigo_producto, 
         p.nombre
HAVING SUM(dp.cantidad) = (
  SELECT MAX(total_unidades)
  FROM (
    SELECT SUM(cantidad) AS total_unidades
    FROM detalle_pedido
    GROUP BY codigo_producto
  ) tabla
);


--4)

SELECT c.nombre_cliente
FROM cliente c
WHERE c.limite_credito > (
  SELECT SUM(p.total)
  FROM pago p
  WHERE p.codigo_cliente = c.codigo_cliente
);


--5)

SELECT nombre, 
       cantidad_en_stock
FROM producto
WHERE cantidad_en_stock = (
  SELECT MAX(cantidad_en_stock) 
  FROM producto
);


--6)

SELECT nombre, 
       cantidad_en_stock
FROM producto
WHERE cantidad_en_stock = (
  SELECT MIN(cantidad_en_stock) 
  FROM producto
);


--7)

SELECT nombre,
       apellido1,
	   email
FROM empleado
WHERE codigo_empleado = (
  SELECT codigo_jefe
  FROM empleado
  WHERE nombre = 'Alberto'
    AND apellido1 = 'Soria'
);



--1.4.8.2 Subconsultas con ALL y ANY


--8)

SELECT nombre_cliente
FROM cliente
WHERE limite_credito >= ALL (
  SELECT limite_credito
  FROM cliente
);


--9)

SELECT nombre
FROM producto
WHERE precio_venta >= ALL (
  SELECT precio_venta
  FROM producto
);


--10)

SELECT nombre
FROM producto
WHERE cantidad_en_stock <= ALL (
  SELECT cantidad_en_stock
  FROM producto
);



--1.4.8.3 Subconsultas con IN y NOT IN


--11)

SELECT nombre, 
       apellido1
FROM empleado 
WHERE codigo_empleado NOT IN (
  SELECT codigo_empleado_rep_ventas 
  FROM cliente
  WHERE codigo_empleado_rep_ventas IS NOT NULL
);


--12)

SELECT nombre_cliente
FROM cliente
WHERE codigo_cliente NOT IN (
  SELECT codigo_cliente
  FROM pago
);


--13)

SELECT nombre_cliente
FROM cliente
WHERE codigo_cliente IN (
  SELECT codigo_cliente
  FROM pago
);


--14)

SELECT codigo_producto, 
       nombre
FROM producto
WHERE codigo_producto NOT IN (
  SELECT codigo_producto
  FROM detalle_pedido
);


--15)

SELECT e.nombre, 
       e.apellido1, 
	   e.puesto, 
	   o.telefono
FROM empleado e
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE e.codigo_empleado NOT IN (
  SELECT codigo_empleado_rep_ventas
  FROM cliente
  WHERE codigo_empleado_rep_ventas IS NOT NULL
);


--16)

SELECT codigo_oficina, ciudad
FROM oficina
WHERE codigo_oficina NOT IN (

SELECT DISTINCT e.codigo_oficina
FROM empleado e
INNER JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
INNER JOIN detalle_pedido dp ON dp.codigo_pedido = p.codigo_pedido
INNER JOIN producto pr ON pr.codigo_producto = dp.codigo_producto
WHERE pr.gama = 'Frutales'
  AND e.puesto = 'Representante Ventas'

);


--17)

SELECT nombre_cliente
FROM cliente
WHERE codigo_cliente IN (
  SELECT codigo_cliente
  FROM pedido
)
  AND codigo_cliente NOT IN (
    SELECT codigo_cliente
    FROM pago
);



-- 1.4.8.4 Subconsultas con EXISTS y NOT EXISTS


--18)

SELECT c.nombre_cliente
FROM cliente c
WHERE NOT EXISTS (
  SELECT 1
  FROM pago p
  WHERE p.codigo_cliente = c.codigo_cliente
);


--19)

SELECT c.nombre_cliente
FROM cliente c
WHERE EXISTS (
  SELECT 1
  FROM pago p
  WHERE p.codigo_cliente = c.codigo_cliente
);

  
--20)

SELECT pr.codigo_producto, pr.nombre
FROM producto pr
WHERE NOT EXISTS (
  SELECT 1
  FROM detalle_pedido dp
  WHERE dp.codigo_producto = pr.codigo_producto
);


--21)

SELECT pr.codigo_producto, pr.nombre
FROM producto pr
WHERE EXISTS (
  SELECT 1
  FROM detalle_pedido dp
  WHERE dp.codigo_producto = pr.codigo_producto
);