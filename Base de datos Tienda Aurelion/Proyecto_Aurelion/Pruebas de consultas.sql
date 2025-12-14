
USE Tienda_Aurelion;

---

SELECT DISTINCT(YEAR(vt.fecha)) FROM ventas vt;

SELECT DISTINCT(MONTH(vt.fecha)) FROM ventas vt;

---

SELECT * FROM ciudades cd;

---

SELECT TOP 10 prod.id_producto, 
		prod.nombre_producto,
		SUM(dv.cantidad) AS 'Cantidad'
FROM productos prod
JOIN detalle_ventas dv ON dv.id_producto = prod.id_producto
GROUP BY prod.id_producto, prod.nombre_producto
ORDER BY SUM(dv.cantidad) DESC;

---

SELECT TOP 10 prod.id_producto, 
		prod.nombre_producto,
		SUM(dv.importe) AS 'Importe total'
FROM productos prod
JOIN detalle_ventas dv ON dv.id_producto = prod.id_producto
GROUP BY prod.id_producto, prod.nombre_producto
ORDER BY SUM(dv.importe) DESC;

--- 

SELECT SUM(dv.importe) AS 'Importe total'
FROM detalle_ventas dv;
-- 2496822

---

SELECT SUM(dv.cantidad) AS 'Cantidad total'
FROM detalle_ventas dv;
--- 981

--- 

SELECT vt.id_cliente, 
		vt.fecha,
		YEAR(vt.fecha) AS 'año',
		MONTH(vt.fecha) AS 'mes',
		vt.id_venta,
		vt.id_medio_pago
FROM ventas vt
JOIN detalle_ventas dv ON dv.id_venta = vt.id_venta;

--- 

SELECT MONTH(vt.fecha) AS 'mes',
		SUM(dv.importe) AS 'imprte total'
FROM ventas vt
JOIN detalle_ventas dv ON dv.id_venta = vt.id_venta
GROUP BY MONTH(vt.fecha);


---

SELECT MONTH(vt.fecha) AS 'mes',
		SUM(dv.cantidad) AS 'cantidad total'
FROM ventas vt
JOIN detalle_ventas dv ON dv.id_venta = vt.id_venta
GROUP BY MONTH(vt.fecha);

---

SELECT vt.id_medio_pago,
		mdp.medio_pago,
		COUNT(vt.id_medio_pago)
FROM ventas vt
JOIN medio_de_pago mdp ON mdp.id_medio_pago = vt.id_medio_pago
GROUP BY vt.id_medio_pago, mdp.medio_pago
ORDER BY COUNT(vt.id_medio_pago) DESC;

---

SELECT  cd.ciudad,
		SUM(dv.importe) AS 'Importe'
FROM clientes cl
JOIN ciudades cd ON cd.id_ciudad = cl.id_ciudad
JOIN ventas vt ON  vt.id_cliente = cl.id_cliente
JOIN  detalle_ventas dv ON dv.id_venta = vt.id_venta
GROUP BY cd.ciudad
ORDER BY SUM(dv.importe) DESC;

---

SELECT  cd.ciudad,
		SUM(dv.cantidad) AS 'Cantidad'
FROM clientes cl
JOIN ciudades cd ON cd.id_ciudad = cl.id_ciudad
JOIN ventas vt ON  vt.id_cliente = cl.id_cliente
JOIN  detalle_ventas dv ON dv.id_venta = vt.id_venta
GROUP BY cd.ciudad
ORDER BY SUM(dv.cantidad) DESC;

--- 

SELECT  cl.id_cliente,
		SUM(dv.importe)
FROM clientes cl
JOIN ventas vt ON  vt.id_cliente = cl.id_cliente
JOIN  detalle_ventas dv ON dv.id_venta = vt.id_venta
GROUP BY cl.nombre_cliente
ORDER BY SUM(dv.importe) DESC;

SELECT  CAST(cl.nombre_cliente AS VARCHAR(MAX)) AS nombre_cliente,
		SUM(dv.importe) AS 'Importe'
FROM clientes cl
JOIN ventas vt ON  vt.id_cliente = cl.id_cliente
JOIN  detalle_ventas dv ON dv.id_venta = vt.id_venta
GROUP BY cl.id_cliente, CAST(cl.nombre_cliente AS VARCHAR(MAX))
ORDER BY SUM(dv.importe) DESC;

SELECT *
FROM clientes cl
JOIN ventas vt ON  vt.id_cliente = cl.id_cliente
JOIN  detalle_ventas dv ON dv.id_venta = vt.id_venta
WHERE CAST(cl.nombre_cliente AS VARCHAR(200)) = 'Bruno Castro';



SELECT * FROM clientes

---  

SELECT prod.id_categoria,
		ct.categoria,
		SUM(dv.cantidad) AS 'Cantidad'
FROM productos prod
JOIN detalle_ventas dv ON dv.id_producto = prod.id_producto
JOIN categorias ct ON ct.id_categoria = prod.id_categoria
GROUP BY prod.id_categoria, ct.categoria
ORDER BY SUM(dv.cantidad) DESC;


---  

SELECT prod.id_categoria,
		ct.categoria,
		SUM(dv.importe) AS 'Importe'
FROM productos prod
JOIN detalle_ventas dv ON dv.id_producto = prod.id_producto
JOIN categorias ct ON ct.id_categoria = prod.id_categoria
GROUP BY prod.id_categoria, ct.categoria
ORDER BY SUM(dv.importe) DESC;

---

SELECT COUNT(*) AS cantidad_clientes FROM clientes;

SELECT COUNT(*) AS cantidad_ventas FROM ventas;

SELECT COUNT(*) AS cantidad_detalle_ventas FROM detalle_ventas;


SELECT COUNT(*) AS cantidad_productos FROM productos;


