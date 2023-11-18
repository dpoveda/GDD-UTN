/*11. Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para
el año 2012.*/

select 
	f.fami_detalle,
	count(distinct p.prod_codigo) as cant_dif_prod_vendidos,
	sum(isnull(fc.fact_total,0)) - sum(isnull(fc.fact_total_impuestos,0)) as ventas
from familia f
	join Producto p on f.fami_id = p.prod_familia
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura fc on i.item_tipo+i.item_sucursal+i.item_numero = fc.fact_tipo+fc.fact_sucursal+fc.fact_numero
where FORMAT(fc.fact_fecha,'yyyy') = '2012'
group by fami_detalle
having sum(isnull(fc.fact_total,0)) > 20000
order by count(distinct p.prod_codigo) desc


--con familia smith kline solo 3 productos diferentes vendidos
/*select 
	count(distinct p.prod_codigo)
from familia f
	join Producto p on f.fami_id = p.prod_familia
	join Item_Factura i on p.prod_codigo = i.item_producto
where f.fami_detalle = 'smith kline'
group by fami_detalle
order by fami_detalle*/




--con familia smith kline el total sin impuestos
/*select
	f.fami_detalle,
	count(distinct p.prod_codigo),
	sum(isnull(fc.fact_total,0)),sum(isnull(fc.fact_total_impuestos,0)),
	sum(isnull(fc.fact_total,0)) - sum(isnull(fc.fact_total_impuestos,0))
from familia f
	join Producto p on f.fami_id = p.prod_familia
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura fc on i.item_tipo+i.item_sucursal+i.item_numero = fc.fact_tipo+fc.fact_sucursal+fc.fact_numero
where f.fami_detalle = 'smith kline'
group by fami_detalle
order by fami_detalle*/


--obtengo el formato de fecha deseado
/*
select 
		FORMAT(fc.fact_fecha,'yyyy') 
	--cast(fc.fact_fecha as date)
from familia f
	join Producto p on f.fami_id = p.prod_familia
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura fc on i.item_tipo+i.item_sucursal+i.item_numero = fc.fact_tipo+fc.fact_sucursal+fc.fact_numero
*/