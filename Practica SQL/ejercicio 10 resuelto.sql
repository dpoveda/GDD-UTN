/*10 . Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo.*/


--una forma de hacerlo
--productos con mas ventas y menos ventas
select 
	p.prod_codigo, 
	p.prod_detalle, 
	(select top 1 
		c.clie_razon_social 
	from cliente c
	join Factura f on c.clie_codigo = f.fact_cliente
	join Item_Factura i2 on f.fact_tipo+f.fact_sucursal+f.fact_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero
	where i2.item_producto = p.prod_codigo
	group by c.clie_razon_social
	order by isnull(sum(i2.item_cantidad), 0) desc ) as mayor_comprador
from producto p
	where p.prod_codigo in 
	(
		select top 10 item_producto from Item_Factura group by item_producto order by isnull(sum(item_cantidad), 0) desc
	)
	or 
	p.prod_codigo in 
	(
		select top 10 item_producto from Item_Factura group by item_producto order by isnull(sum(item_cantidad), 0) asc
	)



--///////////////////////////////////////////////////////////////////--
-- otra forma de hacerlo


select 
	cod_producto, 
	detalle_producto,
	cant_ventas,
	mayor_comprador
from (
--productos con mas ventas
select top 10 
	p.prod_codigo as cod_producto, 
	p.prod_detalle as detalle_producto, 
	count(p.prod_codigo) as cant_ventas,
	(select top 1 
		c.clie_razon_social 
	from cliente c
	join Factura f on c.clie_codigo = f.fact_cliente
	join Item_Factura i2 on f.fact_tipo+f.fact_sucursal+f.fact_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero
	where i2.item_producto = p.prod_codigo
	group by c.clie_razon_social
	order by count(c.clie_codigo) desc ) as mayor_comprador
from producto p
	join Item_Factura i on i.item_producto = p.prod_codigo
group by 
	p.prod_codigo, 
	p.prod_detalle
order by count(p.prod_codigo) desc

)as c1

union all

select 
	cod_producto, 
	detalle_producto,
	cant_ventas, 
	mayor_comprador
from (
--productos con menos ventas
select top 10 
	p.prod_codigo as cod_producto, 
	p.prod_detalle as detalle_producto, 
	count(p.prod_codigo) as cant_ventas,
	(select top 1 
		c.clie_razon_social 
	from cliente c
	join Factura f on c.clie_codigo = f.fact_cliente
	join Item_Factura i2 on f.fact_tipo+f.fact_sucursal+f.fact_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero
	where i2.item_producto = p.prod_codigo
	group by c.clie_razon_social
	order by count(c.clie_codigo) desc ) as mayor_comprador
from producto p
	join Item_Factura i on i.item_producto = p.prod_codigo
group by 
	p.prod_codigo, 
	p.prod_detalle
order by count(p.prod_codigo) asc

) as c2