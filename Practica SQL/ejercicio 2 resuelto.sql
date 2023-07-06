--EJERCICIO 2
/*Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por
cantidad vendida.*/

select p.prod_codigo, p.prod_detalle 
from Producto p
	join Item_Factura i ON i.item_producto = p.prod_codigo
	join Factura f ON f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
where year(f.fact_fecha) = 2012
group by p.prod_codigo, p.prod_detalle
order by sum(i.item_cantidad)