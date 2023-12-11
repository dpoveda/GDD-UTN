/*8. Realizar un procedimiento que complete la tabla Diferencias de precios, para los
productos facturados que tengan composición y en los cuales el precio de
facturación sea diferente al precio del cálculo de los precios unitarios por
cantidad de sus componentes, se aclara que un producto que compone a otro,
también puede estar compuesto por otros y así sucesivamente, la tabla se debe
crear y está formada por las siguientes columnas:

DIFERENCIAS
Código: Código del articulo
Detalle: Detalle del articulo
Cantidad: Cantidad de productos que conforman el combo 
Precio_generado: Precio que se compone a través de sus componentes 
Precio_facturado: Precio del producto */

--creo la tabla
create table Diferencias(
	codigo char(8),
	detalle char(50),
	cantidad decimal(12,2),
	precio_generado decimal(12,2),
	precio_facturado decimal(12,2)
)

drop table Diferencias

select * from diferencias


--sp creado
alter procedure migrar_datos_tabla_diferencias
as 
begin

	insert into diferencias
	select 
		p.prod_codigo,
		p.prod_detalle,
		count(distinct c.comp_componente), 
		(select cast(sum(c2.comp_cantidad * p2.prod_precio) as dec(10,2))
		from composicion c2
			join Producto p2 on c2.comp_componente = p2.prod_codigo
			where c2.comp_producto = p.prod_codigo
		),
		p.prod_precio
	from factura f
		join Item_Factura i on f.fact_numero+f.fact_sucursal+f.fact_tipo = i.item_numero+i.item_sucursal+i.item_tipo
		join Producto p on i.item_producto = p.prod_codigo
		join Composicion c on p.prod_codigo = c.comp_producto
	group by 
		p.prod_codigo,
		p.prod_detalle,
		p.prod_precio
	having p.prod_precio <> (select cast(sum(c2.comp_cantidad * p2.prod_precio) as dec(10,2))
		from composicion c2
			join Producto p2 on c2.comp_componente = p2.prod_codigo
			where c2.comp_producto = p.prod_codigo
		)

end


--ejecuto el sp
exec migrar_datos_tabla_diferencias

