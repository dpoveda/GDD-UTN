--EJERCICIO 8

/*Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
artículo, stock del depósito que más stock tiene.*/

select s.stoc_, p.prod_detalle as nombre_producto,
max(s.stoc_cantidad) as max_stock
from stock s
join Producto p on p.prod_codigo = s.stoc_producto
group by p.prod_detalle
HAVING
count(distinct s.stoc_deposito) = (select count(distinct depo_codigo) FROM DEPOSITO d where depo_codigo is not null)

select stoc_deposito, sum(stoc_cantidad) from stock group by stoc_deposito order by stoc_deposito

select sum(stoc_cantidad) from stock where stoc_deposito = '00'
