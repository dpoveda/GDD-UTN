--EJERCICIO 5 
/*Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.*/

select p.prod_codigo, p.prod_detalle, sum(i.item_cantidad) as cant_egresos_2012
--select *
from Producto p 
	join Item_Factura i ON i.item_producto = p.prod_codigo
	join Factura f ON f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
where YEAR(f.fact_fecha) = 2012
group by p.prod_codigo, p.prod_detalle
having p.prod_codigo in (
	select p2.prod_codigo
	from Producto p2 
		join Item_Factura i2 ON i2.item_producto = p2.prod_codigo
		join Factura f2 ON f2.fact_tipo+f2.fact_sucursal+f2.fact_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero
	where YEAR(f2.fact_fecha) = 2011
	group by p2.prod_codigo
	having isnull(sum(i2.item_cantidad),0) < isnull(sum(i.item_cantidad),0)
	)
ORDER BY cant_egresos_2012 DESC



--esta solucion agarra al mismo producto, y trae los datos del 2011, creo que es una mejor solucion
select P.prod_codigo,
	P.prod_detalle,
	SUM(I.item_cantidad) AS cantidad_vendida2012
	from Factura F		
		JOIN Item_Factura I ON I.item_tipo = F.fact_tipo AND I.item_sucursal = F.fact_sucursal AND I.item_numero = F.fact_numero
		JOIN Producto P ON P.prod_codigo = I.item_producto
WHERE YEAR(F.fact_fecha) = 2012
GROUP BY P.prod_codigo,
	P.prod_detalle
HAVING SUM(I.item_cantidad) >  (
	SELECT SUM(I.item_cantidad)
	from Factura F		
		JOIN Item_Factura I ON I.item_tipo = F.fact_tipo AND I.item_sucursal = F.fact_sucursal AND I.item_numero = F.fact_numero
	WHERE YEAR(F.fact_fecha) = 2011 AND I.item_producto = P.prod_codigo
	)
ORDER BY cantidad_vendida2012 DESC