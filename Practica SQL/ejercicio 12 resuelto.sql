/*
12. Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del
producto y stock actual del producto en todos los depósitos. Se deberán mostrar
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
ordenarse de mayor a menor por monto vendido del producto.
*/

select 
	p.prod_detalle,
	count(distinct f.fact_cliente) as cant_clientes,
	CAST(ROUND(AVG(i.item_cantidad * i.item_precio),2) AS DEC(10,2)) as importe_promedio,
	(
	select count(distinct stoc_deposito) from stock s where s.stoc_producto = p.prod_codigo and s.stoc_cantidad > 0
	) as cant_depositos_hay_stock,
	isnull((
	select sum(s.stoc_cantidad) from stock s where s.stoc_producto = p.prod_codigo 
	),0) as stock_actual_en_todos_los_depositos
from producto p
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura f on i.item_tipo+i.item_sucursal+i.item_numero =  f.fact_tipo+f.fact_sucursal+f.fact_numero
where format(f.fact_fecha,'yyyy') = 2012
group by 
	p.prod_detalle, 
	p.prod_codigo
order by sum(i.item_cantidad * i.item_precio) desc




--uno de los productos
/*select 
	*

from producto p
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura f on i.item_tipo+i.item_sucursal+i.item_numero =  f.fact_tipo+f.fact_sucursal+f.fact_numero
	left join stock s on s.stoc_producto = p.prod_codigo
where p.prod_codigo = '00010427'



select 
CAST(ROUND(AVG(item_cantidad * item_precio),2) AS DEC(10,2)) 
	
from producto p
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura f on i.item_tipo+i.item_sucursal+i.item_numero =  f.fact_tipo+f.fact_sucursal+f.fact_numero
where p.prod_detalle = 'ADES FRUTILLA KIWI X 1Lt'
group by p.prod_detalle
*/


---otro producto
/*
select 
	*

from producto p
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura f on i.item_tipo+i.item_sucursal+i.item_numero =  f.fact_tipo+f.fact_sucursal+f.fact_numero
where p.prod_detalle = 'CLUB SOCIAL chips BONIFICACION'



select 
CAST(ROUND(AVG(item_cantidad * item_precio),2) AS DEC(10,2)) 
	
from producto p
	join Item_Factura i on p.prod_codigo = i.item_producto
	join factura f on i.item_tipo+i.item_sucursal+i.item_numero =  f.fact_tipo+f.fact_sucursal+f.fact_numero
where p.prod_detalle = 'AFEITA TWIN SENSITIVE'
group by p.prod_detalle

*/
                         