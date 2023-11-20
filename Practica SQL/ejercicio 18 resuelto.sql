/*18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30
días
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.*/



select 
	r.rubr_detalle as detalle_rubro,
	cast(sum(i.item_cantidad * i.item_precio) as dec(10,2)) as ventas,
	(select top 1 p2.prod_codigo 
	from rubro r2
		join Producto p2 on r2.rubr_id = p2.prod_rubro
		join Item_Factura i2 on p2.prod_codigo = i2.item_producto
	where r2.rubr_id = r.rubr_id
	group by p2.prod_codigo
	order by count(p2.prod_codigo) desc
	) as prod1,
	(select top 1 prod 
	from (select top 2 
			p3.prod_codigo as prod,
			count(p3.prod_codigo) as cant
		from rubro r3
			join Producto p3 on r3.rubr_id = p3.prod_rubro
			join Item_Factura i3 on p3.prod_codigo = i3.item_producto
		where r3.rubr_id = r.rubr_id 
		group by p3.prod_codigo
		order by cant desc) as t 
	order by t.cant) as prod2,
	isnull((select top 1 f4.fact_cliente
	from rubro r4
		join Producto p4 on r4.rubr_id = p4.prod_rubro
		join Item_Factura i4 on p4.prod_codigo = i4.item_producto
		join factura f4 on f4.fact_sucursal+f4.fact_numero+f4.fact_tipo = i4.item_sucursal+i4.item_numero+i4.item_tipo
	where r4.rubr_id = r.rubr_id and (max(f.fact_fecha)-30  <= f4.fact_fecha) and (f4.fact_fecha <= max(f.fact_fecha))
	--where r4.rubr_id = r.rubr_id and (GETDATE()-30  <= f4.fact_fecha) and (f4.fact_fecha <= GETDATE())
	group by f4.fact_cliente
	order by count(f4.fact_cliente) desc), 'N/A') as cliente
from rubro r
	join Producto p on r.rubr_id = p.prod_rubro
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura f on f.fact_sucursal+f.fact_numero+f.fact_tipo = i.item_sucursal+i.item_numero+i.item_tipo
group by 
	r.rubr_detalle, 
	r.rubr_id
order by count(distinct i.item_producto)


--otra forma contemplando que no haya top 2 de un producto
select 
	r.rubr_detalle as detalle_rubro,
	cast(sum(i.item_cantidad * i.item_precio) as dec(10,2)) as ventas,
	(select top 1 p2.prod_codigo 
	from rubro r2
		join Producto p2 on r2.rubr_id = p2.prod_rubro
		join Item_Factura i2 on p2.prod_codigo = i2.item_producto
	where r2.rubr_id = r.rubr_id
	group by p2.prod_codigo
	order by count(p2.prod_codigo) desc
	) as prod1,
	isnull((select prod 
	from (select 
			ROW_NUMBER() over (order by count(p3.prod_codigo) desc) as orden,
			p3.prod_codigo as prod,
			count(p3.prod_codigo) as cant
		from rubro r3
			join Producto p3 on r3.rubr_id = p3.prod_rubro
			join Item_Factura i3 on p3.prod_codigo = i3.item_producto
		where r3.rubr_id =  r.rubr_id 
		group by p3.prod_codigo) as t 
	where orden = '2'), 'N/A') as prod2,
	isnull((select top 1 f4.fact_cliente
	from rubro r4
		join Producto p4 on r4.rubr_id = p4.prod_rubro
		join Item_Factura i4 on p4.prod_codigo = i4.item_producto
		join factura f4 on f4.fact_sucursal+f4.fact_numero+f4.fact_tipo = i4.item_sucursal+i4.item_numero+i4.item_tipo
	where r4.rubr_id = r.rubr_id and (max(f.fact_fecha)-30  <= f4.fact_fecha) and (f4.fact_fecha <= max(f.fact_fecha))
	--where r4.rubr_id = r.rubr_id and (GETDATE()-30  <= f4.fact_fecha) and (f4.fact_fecha <= GETDATE())
	group by f4.fact_cliente
	order by count(f4.fact_cliente) desc), 'N/A') as cliente
from rubro r
	join Producto p on r.rubr_id = p.prod_rubro
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura f on f.fact_sucursal+f.fact_numero+f.fact_tipo = i.item_sucursal+i.item_numero+i.item_tipo
group by 
	r.rubr_detalle, 
	r.rubr_id
order by count(distinct i.item_producto)


--NOTA: Entendi que el cliente a mostrar eran aquel que desde la fecha maxima que se hizo una compra del producto de determinado rubro,
--se contabilizaba 30 dias para atras, y en ese lapso de tiempo encontrar aquel cliente que haya tenido mas compras
--Caso aparte, tambien deje un comentario con la otra opcion, la cual era que desde la fecha actual y 30 dias para atras, encontrar esos
--clientes que mas habian comprado un producto de determinado rubro

	
-------------------------------------------------------------
--todo esto fueron pruebas para poder sacar el ejercicio
/*
select top 1 f.fact_cliente

from rubro r
	join Producto p on r.rubr_id = p.prod_rubro
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura f on f.fact_sucursal+f.fact_numero+f.fact_tipo = i.item_sucursal+i.item_numero+i.item_tipo
where r.rubr_id = '0021'
group by f.fact_cliente, fact_fecha
having (max(f.fact_fecha)-30  <= f.fact_fecha) and (f.fact_fecha <= max(f.fact_fecha))
order by count(f.fact_cliente) desc


---03342 ese debe ser el cliente
select --top 1 f.fact_cliente
cast(max(f.fact_fecha)-30 as date)
--max(cast(f.fact_fecha as date))

from rubro r
	join Producto p on r.rubr_id = p.prod_rubro
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura f on f.fact_sucursal+f.fact_numero+f.fact_tipo = i.item_sucursal+i.item_numero+i.item_tipo
where r.rubr_id = '0021' 
*/