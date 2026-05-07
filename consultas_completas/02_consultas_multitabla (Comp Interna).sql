

--1.4.5 CONSULTAS MULTITABLA (COMPOSICIÓN INTERNA)



--1)

SELECT c.nombre_cliente, 
       e.nombre, 
	   e.apellido1 
FROM cliente c, empleado e
WHERE c.codigo_empleado_rep_ventas = e.codigo_jefe;

-- Utilizando INNER JOIN

SELECT c.nombre_cliente, 
       e.nombre, 
	   e.apellido1 
FROM cliente c 
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_jefe;


--2)

SELECT c.nombre_cliente, 
       e.nombre 
FROM cliente c, 
     pago p, 
	 empleado e
WHERE p.codigo_cliente = c.codigo_cliente 
  AND e.codigo_empleado = c.codigo_empleado_rep_ventas;

-- Utilizando INNER JOIN

SELECT c.nombre_cliente, 
       e.nombre
FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;


--3)

SELECT c.nombre_cliente, 
       e.nombre
FROM cliente c, 
     empleado e
WHERE c.codigo_empleado_rep_ventas = e.codigo_empleado
  AND c.codigo_cliente NOT IN (
    SELECT p.codigo_cliente 
	FROM pago p
);

-- Utilizando INNER JOIN

SELECT c.nombre_cliente, 
       e.nombre
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE NOT EXISTS (
    SELECT 1
    FROM pago p
    WHERE p.codigo_cliente = c.codigo_cliente
);


--4) 

SELECT DISTINCT c.nombre_cliente, 
                e.nombre, 
				o.ciudad 
FROM empleado e
INNER JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE EXISTS (
    SELECT 1 FROM 
	pago p 
	WHERE c.codigo_cliente = p.codigo_cliente
);

-- Utilizando INNER JOIN

SELECT DISTINCT c.nombre_cliente, 
                e.nombre, 
				o.ciudad
FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;


--5)

SELECT DISTINCT c.nombre_cliente, 
                e.nombre, 
				o.ciudad
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE NOT EXISTS (
    SELECT 1 
	FROM pago p 
	WHERE p.codigo_cliente = c.codigo_cliente
);


--6) 

SELECT DISTINCT c.nombre_cliente, 
                o.linea_direccion1
FROM oficina o
INNER JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
INNER JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE c.ciudad = 'Fuenlabrada';


--7)

SELECT DISTINCT c.nombre_cliente, 
                e.nombre, 
				o.ciudad
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;


--8)

SELECT e.nombre AS empleado, 
       q.nombre AS jefe
FROM empleado e
INNER JOIN empleado q ON e.codigo_jefe = q.codigo_empleado;


--9)

SELECT e.nombre AS empleado, 
       q.nombre AS jefe, 
	   k.nombre AS jefedejefe
FROM empleado e
INNER JOIN empleado q ON e.codigo_jefe = q.codigo_empleado
INNER JOIN empleado k ON q.codigo_jefe = k.codigo_empleado;


--10)

SELECT DISTINCT c.nombre_cliente
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_entrega > p.fecha_esperada;


--11)

SELECT DISTINCT c.nombre_cliente, 
                gp.gama
FROM cliente c
INNER JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
INNER JOIN detalle_pedido dp ON dp.codigo_pedido = p.codigo_pedido
INNER JOIN producto pr ON pr.codigo_producto = dp.codigo_producto
INNER JOIN gama_producto gp ON gp.gama = pr.gama;
