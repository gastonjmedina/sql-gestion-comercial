

--1.4.9 CONSULTAS VARIADAS



--1)

SELECT c.nombre_cliente, 
       COUNT(p.codigo_cliente) as cant_pedidos
FROM cliente c
LEFT JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
GROUP BY c.codigo_cliente,
         c.nombre_cliente;


--2)

SELECT c.nombre_cliente, 
       SUM(p.total) AS total_pago
FROM cliente c
LEFT JOIN pago p ON p.codigo_cliente = c.codigo_cliente
GROUP BY c.codigo_cliente, 
         c.nombre_cliente
HAVING SUM(p.total) IS NOT NULL;


--3)

SELECT DISTINCT c.nombre_cliente
FROM cliente c
INNER JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
WHERE YEAR(p.fecha_pedido) = '2008'
ORDER BY c.nombre_cliente ASC;


--4)

SELECT c.nombre_cliente, 
       e.nombre, e.apellido1, 
	   e.codigo_oficina, 
	   o.telefono
FROM cliente c
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o ON o.codigo_oficina = e.codigo_oficina
WHERE NOT EXISTS (
  SELECT 1
  FROM pago p
  WHERE p.codigo_cliente = c.codigo_cliente
);


--5)

SELECT c.nombre_cliente, 
       e.nombre, 
	   e.apellido1, 
	   o.ciudad
FROM cliente c
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o ON o.codigo_oficina = e.codigo_oficina;


--6)

SELECT e.nombre, 
       e.apellido1, 
	   e.puesto, 
	   o.telefono
FROM empleado e
INNER JOIN oficina o ON o.codigo_oficina = e.codigo_oficina
WHERE NOT EXISTS (
  SELECT 1
  FROM cliente c
  WHERE c.codigo_empleado_rep_ventas = e.codigo_empleado
);


--7)

SELECT o.ciudad, 
       COUNT(e.codigo_empleado) AS total_empleados
FROM oficina o
LEFT JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
GROUP BY o.ciudad;

