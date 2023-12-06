/*2. Realizar una función que dado un artículo y una fecha, retorne el stock que
existía a esa fecha*/

--creo la funcion
create function stockSegunFecha5(@articulo char(8), @fecha smalldatetime)
returns decimal(12,2)
begin
	DECLARE @stock decimal(12,2)

	set @stock = (select SUM(distinct s.stoc_cantidad)
					from stock s
						join Producto p on s.stoc_producto = p.prod_codigo
						join Item_Factura i on p.prod_codigo = i.item_producto
						join Factura f on i.item_numero+i.item_sucursal+i.item_tipo = f.fact_numero+f.fact_sucursal+f.fact_tipo
				where p.prod_codigo = @articulo and f.fact_fecha = @fecha
				)

	return @stock
end


--ejecuto la funcion
select p.prod_codigo, f.fact_fecha, dbo.stockSegunFecha5(p.prod_codigo,f.fact_fecha)
from stock s
join Producto p on s.stoc_producto = p.prod_codigo
join Item_Factura i on p.prod_codigo = i.item_producto
join Factura f on i.item_numero+i.item_sucursal+i.item_tipo = f.fact_numero+f.fact_sucursal+f.fact_tipo
group by p.prod_codigo, f.fact_fecha
order by f.fact_fecha



/*
select SUM( s.stoc_cantidad)
from stock s
join Producto p on s.stoc_producto = p.prod_codigo
join Item_Factura i on p.prod_codigo = i.item_producto
join Factura f on i.item_numero+i.item_sucursal+i.item_tipo = f.fact_numero+f.fact_sucursal+f.fact_tipo
where p.prod_codigo = '00010104' and f.fact_fecha = '2012-04-30 00:00:00' 
*/