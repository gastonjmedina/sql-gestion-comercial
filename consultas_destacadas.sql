

-- 1.4.4 Consultas sobre una tabla

/*
13)
Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. 
Ordene el resultado de mayor a menor. 
*/

SELECT *
FROM pago
WHERE YEAR(fecha_pago) = 2008
  AND forma_pago = 'Paypal'
ORDER BY total DESC;


/*
15)
Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock.
El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio. 
*/

SELECT * 
FROM Producto 
WHERE gama = 'Ornamentales' 
  AND cantidad_en_stock > 100
ORDER BY precio_venta DESC;




-- 1.4.5 Consultas Multitabla (Composición Interna)

/*
5)
Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes
junto con la ciudad de la oficina a la que pertenece el representante
*/

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


/*
7)
Devuelve el nombre de los clientes y el nombre de sus representantes 
junto con la ciudad de la oficina a la que pertenece el representante.
*/

SELECT DISTINCT c.nombre_cliente, 
                e.nombre, 
				o.ciudad
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;


/*
10)
Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
*/

SELECT DISTINCT c.nombre_cliente
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_entrega > p.fecha_esperada;




-- 1.4.6 Consultas Multitabla (Composición Externa)

/*
9)
Devuelve un listado de los productos que nunca han aparecido en un pedido. 
El resultado debe mostrar el nombre, la descripción y la imagen del producto.
*/

SELECT DISTINCT pr.nombre, 
                pr.descripcion, 
				gp.imagen
FROM producto pr
INNER JOIN gama_producto gp ON gp.gama = pr.gama
LEFT JOIN detalle_pedido dp ON dp.codigo_producto = pr.codigo_producto
WHERE dp.codigo_pedido IS NULL;


/*
11)
Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
*/

SELECT DISTINCT c.codigo_cliente, 
                c.nombre_cliente
FROM cliente c
LEFT JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
LEFT JOIN pago pa ON c.codigo_cliente = pa.codigo_cliente
WHERE pe.codigo_cliente IS NOT NULL
  AND pa.codigo_cliente IS NULL;




-- 1.4.7 Consultas Resumen

/*
11)
Calcula la fecha del primer y último pago realizado por cada uno de los clientes. 
El listado deberá mostrar el nombre y los apellidos de cada cliente.
*/

SELECT MIN(p.fecha_pago) AS primer_pago,
       MAX(p.fecha_pago) AS ultimo_pago,
       c.nombre_cliente,
	   c.apellido_contacto
FROM pago p
INNER JOIN cliente c ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.nombre_cliente, 
         c.apellido_contacto;


/*
14)
Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. 
El listado deberá estar ordenado por el número total de unidades vendidas.
*/

SELECT TOP 20
       dp.codigo_producto,
	   pr.nombre,
	   SUM(dp.cantidad) AS unidades
FROM detalle_pedido dp
INNER JOIN producto pr ON pr.codigo_producto = dp.codigo_producto
GROUP BY dp.codigo_producto, 
         pr.nombre
ORDER BY unidades DESC;


/*
18)
Lista las ventas totales de los productos que hayan facturado más de 3000 euros. 
Se mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA).
*/

SELECT pr.nombre,
       SUM(dp.cantidad) AS unidades_vendidas,
       SUM(dp.cantidad*dp.precio_unidad) AS total_facturado,
	   SUM(dp.cantidad*dp.precio_unidad) * 1.21 AS total_con_iva
FROM detalle_pedido dp
INNER JOIN producto pr ON pr.codigo_producto = dp.codigo_producto
GROUP BY dp.codigo_producto, 
         pr.nombre
HAVING SUM(dp.cantidad * dp.precio_unidad) > 3000;




-- 1.4.8 Subconsultas

--1.4.8.1 Con operadores básicos de comparación


/*
3)
Devuelve el nombre del producto del que se han vendido más unidades. 
(Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido 
de cada producto a partir de los datos de la tabla detalle_pedido)
*/

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


/*
4)
Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).
*/

SELECT c.nombre_cliente
FROM cliente c
WHERE c.limite_credito > (
  SELECT SUM(p.total)
  FROM pago p
  WHERE p.codigo_cliente = c.codigo_cliente
);


-- 1.4.8.2 Subconsultas con ALL y ANY

/*
9)
Devuelve el nombre del producto que tenga el precio de venta más caro.
*/

SELECT nombre
FROM producto
WHERE precio_venta >= ALL (
  SELECT precio_venta
  FROM producto
);


--1.4.8.3 Subconsultas con IN y NOT IN

/*
15)
Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados 
que no sean representante de ventas de ningún cliente.
*/

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


/*
16)
Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas 
de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
*/

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


--1.4.8.4 Subconsultas con EXISTS y NOT EXISTS

/*
18)
Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
*/

SELECT c.nombre_cliente
FROM cliente c
WHERE NOT EXISTS (
  SELECT 1
  FROM pago p
  WHERE p.codigo_cliente = c.codigo_cliente
);




--1.4.9 Consultas variadas


/*
1)
Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. 
Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido.
*/

SELECT c.nombre_cliente, 
       COUNT(p.codigo_cliente) as cant_pedidos
FROM cliente c
LEFT JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
GROUP BY c.codigo_cliente,
         c.nombre_cliente;


/*
2)
Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. 
Tenga en cuenta que pueden existir clientes que no han realizado ningún pago.
*/

SELECT c.nombre_cliente, 
       SUM(p.total) AS total_pago
FROM cliente c
LEFT JOIN pago p ON p.codigo_cliente = c.codigo_cliente
GROUP BY c.codigo_cliente, 
         c.nombre_cliente
HAVING SUM(p.total) IS NOT NULL;


/*
4)
Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas 
y el número de teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.
*/

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


/*
7)
Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.
*/

SELECT o.ciudad, 
       COUNT(e.codigo_empleado) AS total_empleados
FROM oficina o
LEFT JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
GROUP BY o.ciudad;


