/*4. Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año.*/


alter procedure put_comision_empleado_ult_anio
@cod_mayor_vendedor numeric(6,0) output
as 
begin
	
	declare @cod_empleado numeric(6,0)
	declare @comision decimal(12,2)
	declare @contador numeric(6,0) = 1

	declare c_cursor cursor global
	for select fact_vendedor, sum(fact_total-fact_total_impuestos) 
		from factura 
		where YEAR(fact_fecha) = (select top 1 year(fact_fecha) from factura order by fact_fecha desc)
		group by fact_vendedor
		order by sum(fact_total-fact_total_impuestos) desc

	open c_cursor

	fetch c_cursor into @cod_empleado, @comision

	while(@@fetch_status=0)
		begin 
			
			if @contador = 1
				begin
					set @cod_mayor_vendedor = @cod_empleado 
				end


			update empleado
			set empl_comision = @comision
			where empl_codigo = @cod_empleado

			set @contador = @contador + 1

		fetch c_cursor into @cod_empleado, @comision

		end

	close c_cursor

	deallocate c_cursor

end


--retorno del sp
declare @cod_mayor_vend numeric(6,0)

exec put_comision_empleado_ult_anio @cod_mayor_vendedor = @cod_mayor_vend output

print @cod_mayor_vend



--------------------------------------------------------------------------

--CONSULTAS QUE UTILICE PARA LLEGAR A LA SOLUCION

select fact_vendedor, sum(fact_total-fact_total_impuestos) 
from factura 
where YEAR(fact_fecha) = (select top 1 year(fact_fecha) from factura order by fact_fecha desc)
group by fact_vendedor
order by sum(fact_total-fact_total_impuestos) desc


select * from Empleado