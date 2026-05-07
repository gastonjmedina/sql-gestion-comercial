

-- 1.4.7 CONSULTAS RESUMEN



--1)


SELECT COUNT(*) AS cantidad 
FROM empleado;


--2)

SELECT pais, COUNT(*) AS cantidad 
FROM cliente
GROUP BY pais;


--3)

SELECT AVG(total) AS promedio 
FROM pago
WHERE YEAR(fecha_pago) = 2009;


--4)

SELECT estado, COUNT(*) AS cantidad 
FROM pedido
GROUP BY estado
ORDER BY cantidad DESC;


--5)

SELECT MAX(precio_venta) AS MasCaro, 
       MIN(precio_venta) AS MasBarato 
FROM producto;


--6)

SELECT COUNT(*) AS Cantidad
FROM cliente;


--7)

SELECT COUNT(*) AS Cantidad
FROM cliente
WHERE ciudad = 'Madrid';


--8)

SELECT ciudad, COUNT(*) AS total_clientes
FROM cliente
WHERE ciudad LIKE 'M%'
GROUP BY ciudad;


--9)

SELECT e.nombre, 
       COUNT(c.codigo_cliente) AS total_clientes
FROM empleado e
LEFT JOIN cliente c ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE e.puesto = 'Representante Ventas'
GROUP BY e.nombre
ORDER BY total_clientes DESC;


--10)

SELECT COUNT(*) AS clientes_sin_representante
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;


--11)

SELECT MIN(p.fecha_pago) AS primer_pago,
       MAX(p.fecha_pago) AS ultimo_pago,
       c.nombre_cliente,
	   c.apellido_contacto
FROM pago p
INNER JOIN cliente c ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.nombre_cliente, 
         c.apellido_contacto;


--12)

SELECT codigo_pedido, 
       COUNT(DISTINCT codigo_producto) AS total_productos
FROM detalle_pedido
GROUP BY codigo_pedido;


--13)

SELECT codigo_pedido,
	   SUM(cantidad) AS cantidad_total
FROM detalle_pedido
GROUP BY codigo_pedido;


--14)

SELECT TOP 20
       dp.codigo_producto,
	   pr.nombre,
	   SUM(dp.cantidad) AS unidades
FROM detalle_pedido dp
INNER JOIN producto pr ON pr.codigo_producto = dp.codigo_producto
GROUP BY dp.codigo_producto, 
         pr.nombre
ORDER BY unidades DESC;


--15)

SELECT SUM(dp.cantidad * dp.precio_unidad) AS base_imponible,
       ((SUM(dp.cantidad * dp.precio_unidad) * 21) / 100) AS IVA,
	   SUM(dp.cantidad * dp.precio_unidad) + ((SUM(dp.cantidad * dp.precio_unidad) * 21) / 100) AS total_facturacion
FROM detalle_pedido dp;

--OTRA FORMA SIN REPETIR TANTO

SELECT 
  dp.codigo_producto,
  SUM(dp.cantidad * dp.precio_unidad) AS base_imponible,
  SUM(dp.cantidad * dp.precio_unidad) * 0.21 AS IVA,
  SUM(dp.cantidad * dp.precio_unidad) * 1.21 AS total_facturado
FROM detalle_pedido dp;


--16)

SELECT dp.codigo_producto,
       SUM(dp.cantidad * dp.precio_unidad) AS base_imponible,
       ((SUM(dp.cantidad * dp.precio_unidad) * 21) / 100) AS IVA,
	   SUM(dp.cantidad * dp.precio_unidad) + ((SUM(dp.cantidad * dp.precio_unidad) * 21) / 100) AS total_facturacion
FROM detalle_pedido dp
GROUP BY dp.codigo_producto;


--17)

SELECT dp.codigo_producto,
       SUM(dp.cantidad * dp.precio_unidad) AS base_imponible,
       ((SUM(dp.cantidad * dp.precio_unidad) * 21) / 100) AS IVA,
	   SUM(dp.cantidad * dp.precio_unidad) + ((SUM(dp.cantidad * dp.precio_unidad) * 21) / 100) AS total_facturacion
FROM detalle_pedido dp
WHERE dp.codigo_producto LIKE 'OR%'
GROUP BY dp.codigo_producto;


--18)

SELECT pr.nombre,
       SUM(dp.cantidad) AS unidades_vendidas,
       SUM(dp.cantidad*dp.precio_unidad) AS total_facturado,
	   SUM(dp.cantidad*dp.precio_unidad) * 1.21 AS total_con_iva
FROM detalle_pedido dp
INNER JOIN producto pr ON pr.codigo_producto = dp.codigo_producto
GROUP BY dp.codigo_producto, 
         pr.nombre
HAVING SUM(dp.cantidad * dp.precio_unidad) > 3000;


--19)

SELECT YEAR(fecha_pago) AS año,
       SUM(total) AS total
FROM pago
GROUP BY YEAR(fecha_pago);