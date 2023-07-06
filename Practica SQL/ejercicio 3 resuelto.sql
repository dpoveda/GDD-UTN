--EJERCICIO 3
/*Realizar una consulta que muestre código de producto, nombre de producto y el stock
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por
nombre del artículo de menor a mayor.*/

select p.prod_codigo, p.prod_detalle, sum(s.stoc_cantidad) as stock_total
from Producto p
	join STOCK s on s.stoc_producto=p.prod_codigo
group by p.prod_codigo, p.prod_detalle
order by p.prod_detalle asc

--select sum(stoc_cantidad) from stock where stoc_producto = '00000102' --548