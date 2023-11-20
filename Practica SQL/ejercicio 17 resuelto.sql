/*17. Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:
PERIODO: Año y mes de la estadística con el formato YYYYMM
PROD: Código de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo
pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el
periodo
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por periodo y código de producto.*/

select  
	format(f.fact_fecha, 'yyyyMM') as periodo,
	p.prod_codigo as prod,
	p.prod_detalle as detalle,
	cast(sum(i.item_cantidad) as dec(10,0)) as cantidad_vendida,
	isnull((select  
		cast(isnull(sum(i.item_cantidad),0) as dec(10,0)) 
	from Producto p2
		join Item_Factura i2 on p2.prod_codigo = i2.item_producto
		join Factura f2 on i2.item_tipo+i2.item_sucursal+i2.item_numero = f2.fact_tipo+f2.fact_sucursal+f2.fact_numero
	where p2.prod_codigo = p.prod_codigo and month(f2.fact_fecha) = MONTH(f.fact_fecha) and YEAR(f2.fact_fecha)= (year(f.fact_fecha))-1),0) as ventas_anio_ant,
	count(distinct f.fact_numero) as cant_facturas
from Producto p
	join Item_Factura i on p.prod_codigo = i.item_producto
	join Factura f on i.item_tipo+i.item_sucursal+i.item_numero = f.fact_tipo+f.fact_sucursal+f.fact_numero
group by 
	f.fact_fecha, 
	p.prod_codigo, 
	p.prod_detalle
order by periodo, p.prod_codigo



--------------------------------------------------------------------
--pruebas para el ejercicio
/*
select  
	concat(year(f.fact_fecha), month(f.fact_fecha)) as periodo,
	p.prod_codigo,
	p.prod_detalle,
	sum(i.item_cantidad),
	count(distinct f.fact_numero)
from Producto p
	join Item_Factura i on p.prod_codigo = i.item_producto
	join Factura f on i.item_tipo+i.item_sucursal+i.item_numero = f.fact_tipo+f.fact_sucursal+f.fact_numero
where year(f.fact_fecha) = 2011 and month(f.fact_fecha) = 1 and p.prod_codigo = '00001121'
group by year(f.fact_fecha), MONTH(f.fact_fecha), p.prod_codigo, p.prod_detalle
order by periodo


select  
	isnull(cast(isnull(sum(i.item_cantidad),0) as dec(10,0)) ,0)
from Producto p
	join Item_Factura i on p.prod_codigo = i.item_producto
	join Factura f on i.item_tipo+i.item_sucursal+i.item_numero = f.fact_tipo+f.fact_sucursal+f.fact_numero
where p.prod_codigo = '00001121' and month(f.fact_fecha) = 01 and YEAR(f.fact_fecha)= 2010 -1



20121	00010308	GELATINA FRUTILLA X 120g.                         	48.00

*/


select format(fact_fecha,'MM') from factura