

-- 1.4.6 CONSULTAS MULTITABLA (COMPOSICIÓN EXTERNA)



--1)

SELECT c.nombre_cliente, 
       c.codigo_cliente, 
	   p.codigo_cliente 
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;


--2)

SELECT c.nombre_cliente, 
       c.codigo_cliente, 
	   pe.codigo_cliente 
FROM cliente c
LEFT JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
WHERE pe.codigo_cliente IS NULL;


--3)

SELECT c.nombre_cliente, 
       p.codigo_cliente, 
	   pe.codigo_cliente
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pedido pe ON pe.codigo_cliente = c.codigo_cliente
WHERE (p.codigo_cliente IS NULL) 
  AND (pe.codigo_cliente IS NULL);


--4)

SELECT e.nombre
FROM empleado e
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE o.codigo_oficina = NULL;


--5)

SELECT e.nombre, 
       c.codigo_cliente
FROM empleado e
LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE c.codigo_cliente IS NULL;

-- Utilizando RIGHT JOIN

SELECT e.nombre, 
       c.codigo_cliente
FROM cliente c
RIGHT JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE c.codigo_cliente IS NULL;


--6)

SELECT e.nombre, 
       c.codigo_cliente, o.*
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL;


--7)

SELECT e.nombre, 
       c.codigo_cliente, 
	   o.codigo_oficina
FROM empleado e 
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE o.codigo_oficina IS NULL 
  AND c.codigo_cliente IS NULL;


--8)

SELECT DISTINCT pr.nombre, 
                dp.codigo_pedido
FROM producto pr
LEFT JOIN detalle_pedido dp ON pr.codigo_producto = dp.codigo_producto
WHERE dp.codigo_pedido IS NULL;


--9)

SELECT DISTINCT pr.nombre, 
                pr.descripcion, 
				gp.imagen
FROM producto pr
INNER JOIN gama_producto gp ON gp.gama = pr.gama
LEFT JOIN detalle_pedido dp ON dp.codigo_producto = pr.codigo_producto
WHERE dp.codigo_pedido IS NULL;


--11)

SELECT DISTINCT c.codigo_cliente, 
                c.nombre_cliente
FROM cliente c
LEFT JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
LEFT JOIN pago pa ON c.codigo_cliente = pa.codigo_cliente
WHERE pe.codigo_cliente IS NOT NULL
  AND pa.codigo_cliente IS NULL;


--12)

SELECT e.codigo_empleado, 
       e.nombre, 
	   j.nombre AS nombre_jefe
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
WHERE c.codigo_cliente IS NULL;
