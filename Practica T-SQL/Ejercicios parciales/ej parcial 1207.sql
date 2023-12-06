--EJERCICIO PARCIAL 12/07/2023
/*2. Implementar una regla de negocio que registre en una tabla llamada
SEC, cuyos campos son : id, fecha_hora, tipo, sucurusal, numero, la
información de aquellas operaciones que intentan borrar una factura y/o
sus items*/
select * from Item_Factura

--creamos la tabla llamada sec con los campos correspondientes
create table sec (
	id int identity(1,1) primary key,
	fecha_hora smalldatetime,
	tipo char(1),
	sucursal char(4),
	numero char(8)
)

--crear un trigger que cuando borre una factura (after), guarde esos datos en la tabla nueva sec
--hice esto en vez de un instead of porque queria que los registros se borren
create trigger guardarDatosEnTablaSec 
on Factura
after delete
as
begin
	insert into sec
	select 
		fact_fecha,
		fact_tipo,
		fact_sucursal,
		fact_numero
	from deleted
end

--crear un trigger que cuando borre un item_factura (after), guarde esos datos en la tabla nueva sec
--hice esto en vez de un instead of porque queria que los registros se borren
create trigger guardarDatosEnTablaSecDos
on Item_Factura
after delete
as
begin
	insert into sec
	select 
		f.fact_fecha,
		item_tipo,
		item_sucursal,
		item_numero
	from deleted 
		join Factura f on f.fact_tipo+f.fact_sucursal+f.fact_numero = item_tipo+item_sucursal+item_numero
end