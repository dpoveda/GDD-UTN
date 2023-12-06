--PARCIAL 01/07/2023

--EJERCICIO 2

/*2. Implementar una regla de negocio para mantener siempre consistente
(actualizada bajo cualquier circunstancia) INSERT UPDATE DELETE

una nueva tabla llamada PRODUCTOS_VENDIDOS. 
En esta tabla debe registrar el periodo (YYYYMM),
 el código de producto,
  el precio máximo de venta 
  y las unidades vendidas. 
  
  Toda esta información debe estar por periodo (YYYYMM).*/

  --1
  --creamos una tabnla llamada productos_vendidos con todos estas columnas, periodo (YYYYMM),
 --el código de producto,
  --el precio máximo de venta 
 -- y las unidades vendidas.
 
 --2
 --migramos esos datos a la tabla productos, vendidos

 --3
--desp de la insercion y preguntar si los datos ya existen, si no existen, los inserto, si no estan modificados, los actualizo



create table PRODUCTOS_VENDIDOS(
	id_productos_vendidos int identity(1,1) primary key,
	periodo char(6),
	cod_prod char(8),
	precio_max_venta decimal(12,2),
	unidades_vendidas decimal(12,2)
)

--drop table PRODUCTOS_VENDIDOS

--select * from PRODUCTOS_VENDIDOS

create procedure migrar_productos_vendidos
as
begin
	insert into PRODUCTOS_VENDIDOS
	select 
	concat(year(f.fact_fecha), month(f.fact_fecha)),
	i.item_producto,
	isnull(max(item_precio),0),
	isnull(sum(i.item_cantidad),0)
	from Item_Factura i 
		join Factura f on f.fact_tipo+f.fact_sucursal+f.fact_numero=i.item_tipo+i.item_sucursal+i.item_numero 
	group by i.item_producto, f.fact_fecha
end

execute migrar_productos_vendidos

--select * from Item_Factura

create trigger actualizarProdVendSegunItem
on Item_Factura
after insert, update
as
begin 
	declare @periodo char(6),
	@cod_prod char(8),
	@precio_max_venta decimal(12,2),
	@unidades_vendidas decimal(12,2)

	declare miCursor cursor for
	select 
	concat(year(f.fact_fecha), month(f.fact_fecha)),
	i.item_producto,
	isnull(max(item_precio),0),
	isnull(sum(i.item_cantidad),0)
	from inserted i 
		join Factura f on f.fact_tipo+f.fact_sucursal+f.fact_numero=i.item_tipo+i.item_sucursal+i.item_numero 
	group by i.item_producto, f.fact_fecha

	
	open miCursor
	fetch miCursor into @periodo, @cod_prod, @precio_max_venta, @unidades_vendidas
	
	while @@FETCH_STATUS = 0
		begin 
			if not exists(
				select 1 
				from PRODUCTOS_VENDIDOS
				where cod_prod = @cod_prod and periodo = @periodo 
				)--si el item no esta presente, entonces lo inserto
				begin
					insert into PRODUCTOS_VENDIDOS values (@periodo, @cod_prod, @precio_max_venta, @unidades_vendidas)
				end
			else
				begin
					update PRODUCTOS_VENDIDOS
					set precio_max_venta = case when precio_max_venta > @precio_max_venta then precio_max_venta else @precio_max_venta end,
					unidades_vendidas = unidades_vendidas + @unidades_vendidas
					where @cod_prod = cod_prod and @periodo = periodo
				end
		
			fetch miCursor into @periodo, @cod_prod, @precio_max_venta, @unidades_vendidas
		end--cursor
	close miCursor
	deallocate miCursor

end--trigger