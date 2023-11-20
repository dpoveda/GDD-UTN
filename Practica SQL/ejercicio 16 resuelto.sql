/*16. Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son
inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
Además mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente.
Aclaraciones:
La composición es de 2 niveles, es decir, un producto compuesto solo se compone de
productos no compuestos.
Los clientes deben ser ordenados por código de provincia ascendente.*/


select 
	c.clie_razon_social as nombre_cliente,
	sum(i.item_cantidad) + sum(isnull(cm.comp_cantidad,0)) as cant_unid_vendidas,
	(select top 1 i2.item_producto 
	from Item_Factura i2 
		join Factura f2 on f2.fact_tipo+f2.fact_sucursal+f2.fact_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero
		join Producto p2 on i2.item_producto = p2.prod_codigo
		left join Composicion cm2 on p2.prod_codigo = cm2.comp_producto
	where year(f2.fact_fecha) = 2012 and f2.fact_cliente = c.clie_codigo
	group by i2.item_producto
	order by (sum(i2.item_cantidad) + sum(isnull(cm2.comp_cantidad,0))) desc) as prod_mas_vendido
from Factura f
	join Cliente c on f.fact_cliente = c.clie_codigo
	join Item_Factura i on f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
	join Producto p on i.item_producto = p.prod_codigo
	left join Composicion cm on p.prod_codigo = cm.comp_producto 
where 
	format(f.fact_fecha, 'yyyy') = 2012
group by 
	c.clie_razon_social, 
	c.clie_codigo,
	c.pcia_id
having (sum(i.item_cantidad) + sum(isnull(cm.comp_cantidad,0))) < 3*
	(select top 1 cast(round((avg(i3.item_cantidad)),2) as dec(10,0))
	from Item_Factura i3 
		join Factura f3 on f3.fact_tipo+f3.fact_sucursal+f3.fact_numero = i3.item_tipo+i3.item_sucursal+i3.item_numero
	where year(f3.fact_fecha) = 2012
	group by i3.item_producto
	order by sum(i3.item_cantidad) desc)
order by c.pcia_id


--NOTA
--entendi que se debe mostrar a los clientes cuyas ventas fueron menores a 3 veces el promedio de ventas del producto mas vendido,
--porque si ponia que fuera inferior a la tercera parte del promedio de ventas del producto mas vendido, no habria ningun cliente
--para mostrar



--pruebas para resolver el ejercicio
/*
	select c.clie_razon_social as nombre_cliente,
	sum(i.item_cantidad) + sum(isnull(cm.comp_cantidad,0)) as cant_unid_vendidas,
	(
	case 
		when cm.comp_componente is not null 
			then (select i. from Producto p1 where p1.prod_codigo = cm.comp_componente and p1.prod_codigo = i.item_producto group by p1.prod_codigo) 
			else 1 end
	)as cod_prod_mayor_venta
from Factura f
	join Cliente c on f.fact_cliente = c.clie_codigo
	join Item_Factura i on f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
	join Producto p on i.item_producto = p.prod_codigo
	left join Composicion cm on p.prod_codigo = cm.comp_producto 
where 
	format(f.fact_fecha, 'yyyy') = 2012 and c.clie_razon_social = 'BOUDOT PATRICIA NOEMI'
	group by c.clie_razon_social



--el producto mas comprado por ella 00001420	40.00
	select *
from Factura f
	join Cliente c on f.fact_cliente = c.clie_codigo
	join Item_Factura i on f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
	join Producto p on i.item_producto = p.prod_codigo
	left join Composicion cm on p.prod_codigo = cm.comp_producto 
where 
	format(f.fact_fecha, 'yyyy') = 2012 and c.clie_razon_social = 'BOUDOT PATRICIA NOEMI'
	group by c.clie_razon_social,c.clie_codigo


	select *
from Factura f
	join Cliente c on f.fact_cliente = c.clie_codigo
	join Item_Factura i on f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
	join Producto p on i.item_producto = p.prod_codigo
	left join Composicion cm on p.prod_codigo = cm.comp_producto 
where 
	format(f.fact_fecha, 'yyyy') = 2012 and c.clie_razon_social = 'BOUDOT PATRICIA NOEMI'




select top 1 cast(round((avg(i.item_cantidad)),2) as dec(10,0))
from Item_Factura i 
	join Factura f on f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
where year(f.fact_fecha) = 2012
group by i.item_producto
order by sum(i.item_cantidad) desc



select top 1 *
from Item_Factura i 
	join Factura f on f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
where year(f.fact_fecha) = 2012 and i.item_producto = '00001718'
group by i.item_producto
order by sum(i.item_cantidad) desc

00001718	28800.00

*/