--EJERCICIO PARCIAL 04/07/2023

/*
2. Actualmente el campo fact_vendedor representa al empleado que vendió
la factura. Implementar el/los objetos necesarios para respetar la
integridad referenciales de dicho campo suponiendo que no existe una
foreign key entre ambos.

NOTA: No se puede usar una foreign key para el ejercicio, deberá buscar
otro método
*/


select * from factura

select * from Empleado



--Despues de un insert o un update, verifica que el fact_vendedor, exista en la tabla Empleado
create trigger vendedoresEnFactura 
on Factura
after insert, update
begin
	declare @fact_vendedor numeric(6,0)
	declare miCursor cursor for
		select fact_vendedor from inserted 

	open miCursor 
	fetch next from miCursor into @fact_vendedor

	while @@FETCH_STATUS = 0
		begin
			if not exists ( 
				select * from empleado e where @fact_vendedor = e.empl_codigo
			)
			begin
				rollback transaction
			end	

		fetch next from miCursor into @fact_vendedor
		end
	close miCursor 
	deallocate miCursor

end 



--si se quiere eliminar un empleado, se verifica que ese empleado no exista en la tabla Factura, de ser asi, no se lo elimina

create trigger eliminarEmpleado 
on empleado
instead of delete
begin
	if (delete empl_codigo)
		begin
			if not exists(
				select * from factura f join deleted d on d.empl_codigo = f.fact_vendedor
			)
				begin
				 --eliminar todos los campos de la tabla empleado
				 delete from Empleado e join deleted d where e.empl_codigo = d.empl_codigo
				end
			else
				begin
					raiserror('No se puede eliminar al empleado debido a que esta vinculado a la tabla Factura', 16, 10)
				end
		end
	
end