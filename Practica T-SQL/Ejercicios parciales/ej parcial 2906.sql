--EJERCICIO PARCIAL 29/06/2023
/*
2. Suponiendo que se aplican los siguientes cambios en el modelo de
datos:

Cambio 1) create table provincia (id 'int primary key, nómbre char(100)) ;
Cambio 2) alter table cliente add pcia_id int null:

Crear el]los objetos necesarios para implementar el concepto de foreign
key entre 2 cliente y provincia,

Nota: No se permite agregar una constraint de tipo FOREIGN KEY entre la
tabla y el campo agregado.

*/

--CAMBIO 1
create table provincia (id int primary key, nómbre char(100))

--CAMBIO 2
alter table cliente add pcia_id int null


create trigger actualizarTablaCliente 
on Cliente
instead of update
begin
	if(update(pcia_id))
		begin
			if exists(
				select * from provincia p join inserted i on i.pcia_id = p.id
			)
			begin
				update cliente
				set pcia_id = i.pcia_id from inserted i where i.clie_codigo =  clie_codigo
			end
			else
				begin
					raiserror('La provincia no existe', 16, 10)
				end
		end
	else
		begin
			update cliente
			set clie_codigo = i.clie_codigo, 
				clie_razon_social = i.clie_razon_social, 
				clie_telefono = i.clie_telefono,
				clie_domicilio = i.clie_domicilio,
				clie_limite_credito = i.clie_limite_credito,
				clie_vendedor = i.clie_vendedor
			from inserted i 
			where clie_codigo = i.clie_codigo
		end
end--trigger



create trigger insertarTablaCliente 
on Cliente
instead of insert
begin
	if exists(
		select * from provincia p join inserted i on i.pcia_id = p.id
	)
		begin
			insert into cliente
				clie_codigo = i.clie_codigo, 
				clie_razon_social = i.clie_razon_social, 
				clie_telefono = i.clie_telefono,
				clie_domicilio = i.clie_domicilio,
				clie_limite_credito = i.clie_limite_credito,
				clie_vendedor = i.clie_vendedor
				pcia_id = i.pcia_id
			from inserted i 
		end
	else
		begin
			raiserror('La provincia no existe', 16, 10)
		end
end



create trigger actualizarTablaProvincia 
on provincia
instead of update
begin
	if(update(nombre))
		begin
			if not exists(select * from inserted i where i.nombre = nombre)
			begin
				update provincia
				set nombre = i.nombre from inserted 
			end
			else
				begin
					raiserror('La provincia que quiere insertar ya existe',16,10)
				end
		end
	else
		begin
			raiserror('La tabla provincia no tiene mas columnas que actualizar',16,10)
		end

end