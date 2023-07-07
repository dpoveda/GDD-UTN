--EJERCICIO 7
/*Generar una consulta que muestre para cada artículo código, detalle, mayor precio
menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio =
10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean
stock.*/

select p.prod_codigo, 
		p.prod_detalle, 
		isnull(max(i.item_precio),0) as mayor_precio, 
		isnull(min(i.item_precio),0) as menor_precio,
		cast((((isnull(max(i.item_precio),0) - isnull(min(i.item_precio),0)) / isnull(min(i.item_precio),0)) * 100)as int) AS dif_de_precios
from Producto p 
	join STOCK s ON s.stoc_producto = p.prod_codigo
	join Item_Factura i ON i.item_producto = p.prod_codigo
group by p.prod_codigo, p.prod_detalle
having sum(s.stoc_cantidad) > 0
