/*14. Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que
debe retornar son:
Código del cliente
Cantidad de veces que compro en el último año
Promedio por compra en el último año
Cantidad de productos diferentes que compro en el último año
Monto de la mayor compra que realizo en el último año
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en
el último año.
No se deberán visualizar NULLs en ninguna columna*/


select 
	f.fact_cliente as cod_cliente,
	(select count(f2.fact_numero) from factura f2 where max(FORMAT(f.fact_fecha, 'yyyy')) = FORMAT(f2.fact_fecha, 'yyyy') and f2.fact_cliente = f.fact_cliente) as cant_compras_ult_anio,
	(select cast(AVG(isnull(f2.fact_total,0)) as dec(10,2)) from factura f2 where max(FORMAT(f.fact_fecha, 'yyyy')) = FORMAT(f2.fact_fecha, 'yyyy') and f2.fact_cliente = f.fact_cliente) as prom_compras_ult_anio,
	(select count(distinct item_producto) from factura f2 join Item_Factura on f2.fact_numero+f2.fact_sucursal+f2.fact_tipo = item_numero+item_sucursal+item_tipo where max(FORMAT(f.fact_fecha, 'yyyy')) = FORMAT(f2.fact_fecha, 'yyyy') and f2.fact_cliente = f.fact_cliente) as cant_prod_dif_ult_anio,
	(select max(isnull(f2.fact_total,0)) from factura f2 where max(FORMAT(f.fact_fecha, 'yyyy')) = FORMAT(f2.fact_fecha, 'yyyy') and f2.fact_cliente = f.fact_cliente) as monto_max_compra_ult_anio
from factura f
group by f.fact_cliente
order by (select count(f2.fact_numero) from factura f2 where max(FORMAT(f.fact_fecha, 'yyyy')) = FORMAT(f2.fact_fecha, 'yyyy') and f2.fact_cliente = f.fact_cliente)


--ejemplos con los que me fui ayudando
/*

--cliente de ejemplo --03755
select count(distinct item_producto)
from factura
	join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
where fact_cliente = '03755' and 2012 = FORMAT(fact_fecha, 'yyyy')
group by fact_cliente
order by fact_cliente


--cliente de ejemplo --03691
select * 
from factura
join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
where fact_cliente = '03755'
order by fact_cliente


--cliente de ejemplo --01458 --21
select 
	fact_cliente, 
	COUNT(fact_numero) as cant_compras 
from factura 
where fact_cliente = '01458'
group by fact_cliente
having fact_cliente in (
		select 
		f2.fact_cliente
		--max(FORMAT(f.fact_fecha, 'yyyy')) 
		from Factura f2 
		join Factura f on F.fact_tipo+F.fact_sucursal+F.fact_numero = F2.fact_tipo+F2.fact_sucursal+F2.fact_numero
		where f2.fact_cliente = '01458'
		group by f2.fact_cliente, f.fact_fecha
		having max(FORMAT(f.fact_fecha, 'yyyy')) = FORMAT(f.fact_fecha, 'yyyy') 
	)
order by fact_cliente



select *
from factura
where fact_cliente = '01458'
group by fact_cliente
order by fact_cliente

where exists fact_cliente 
select fact_cliente

from factura
where fact_cliente = '01458' and max(FORMAT(fact_fecha, 'yyyy')) = FORMAT(fact_fecha, 'yyyy')
--group by fact_cliente
order by fact_cliente



select 
		f.fact_cliente,
		max(FORMAT(f.fact_fecha, 'yyyy')),
		(
		select max(isnull(f2.fact_total,0)) from factura f2 where 2012 = FORMAT(f2.fact_fecha, 'yyyy') and f2.fact_cliente = '01458'
		) as algo
		from Factura f 
		--join Factura f on F.fact_tipo+F.fact_sucursal+F.fact_numero = F2.fact_tipo+F2.fact_sucursal+F2.fact_numero
		where f.fact_cliente = '01458'
		group by f.fact_cliente
		having max(FORMAT(f.fact_fecha, 'yyyy')) = FORMAT(f.fact_fecha, 'yyyy') 

*/