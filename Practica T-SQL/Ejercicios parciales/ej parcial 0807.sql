--Ejercicio parcial 08/07/2023

/*
nota:9 sin comentarios

2. Por un error de programación la tabla item factura le ejecutaron DROP a la primary key y a sus foreign key.
Este evento permitió la inserción de filas duplicadas (exactas e iguales) y también inconsistencias debido a la falta de FK.
Realizar un algoritmo que resuelva este inconveniente depurando los datos de manera coherente y lógica y que deje la estructura de la tabla item factura de manera correcta.
*/

--Solucion dada por mi
--crear un sp que elimine los duplicados con un cursor
create procedure eliminar_duplicados_item_factura
as
begin
	declare 
	@item_tipo char(1), 
	@item_sucursal char(4), 
	@item_numero char(8), 
	@item_producto char(8),
	@item_cantidad decimal(12,2), 
	@item_precio decimal(12,2)

	declare miCursor cursor for
	select 
	item_tipo, 
	item_sucursal, 
	item_numero, 
	item_producto,
	item_cantidad, 
	item_precio
	from Item_Factura

	open miCursor
	fetch next miCursor into @item_tipo, 
	@item_sucursal, 
	@item_numero, 
	@item_producto,
	@item_cantidad, 
	@item_precio

	while @@FETCH_STATUS = 0
		begin 
			if exists(
				select * 
				from Item_Factura i2
				where 
						i2.item_tipo+i2.item_sucursal+i2.item_numero = @item_tipo+@item_sucursal+@item_numero 
						and i2.item_producto = @item_producto 
						and i2.item_cantidad = @item_cantidad 
						and i2.item_precio = @item_precio  
			)
			
			begin
				delete from Item_Factura 
				where item_tipo+item_sucursal+item_numero = @item_tipo+@item_sucursal+@item_numero 
						and item_producto = @item_producto 
			end
			
			fetch next miCursor into @item_tipo, 
			@item_sucursal, 
			@item_numero, 
			@item_producto,
			@item_cantidad, 
			@item_precio
		end

	close miCursor
	deallocate miCursor

end

execute eliminar_duplicados_item_factura

--como no dice nada de que no se puede agregar fk a mano o algo asi, las agrego
alter table Item_Factura
	add foreign key (item_tipo,item_sucursal,item_numero) references Factura(fact_tipo,fact_sucursal,fact_numero),
		foreign key (item_producto) references Producto(prod_codigo)


--solucion que tiene un 9

create table Item_Factura_Nueva(
    item_tipo char(1), 
	item_sucursal char(4), 
	item_numero char(8), 
	item_producto char(8),
	item_cantidad decimal(12,2), 
	item_precio decimal(12,2)
)

insert into Item_Factura_Nueva
select distinct 
	item_tipo, 
	item_sucursal, 
	item_numero, 
	item_producto,
	item_cantidad, 
	item_precio
from Item_Factura

truncate table Item_Factura

insert into Item_Factura
select
	item_tipo, 
	item_sucursal, 
	item_numero, 
	item_producto,
	item_cantidad, 
	item_precio
from Item_Factura_Nueva

alter table item_factura
	add foreign key (item_tipo, item_sucursal, item_numero) references factura(fact_tipo, fact_sucursal, fact_numero),
		foreign key (item_producto) references producto(fact_producto)

drop table Item_Factura_Nueva