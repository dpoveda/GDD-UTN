--EJERCICIO 2

/*Realizar una función que dado un artículo y una fecha, retorne el stock que
existía a esa fecha*/

--creo la funcion
create function stock_segun_fecha(@producto char(8), @fecha date)
returns decimal(12,2)
as
begin
return
	(
	select isnull(sum(i.item_cantidad),0) + 
		(select isnull(sum(stoc_cantidad),0)
		from stock
		where stoc_producto=@producto)
	from Item_Factura i 
		join Factura f ON f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
	where i.item_producto=@producto and f.fact_fecha <= @fecha 
	)
end


--llamo a la funcion 
select stoc_producto, dbo.stock_segun_fecha(stoc_producto, '01/01/2012') from stock
