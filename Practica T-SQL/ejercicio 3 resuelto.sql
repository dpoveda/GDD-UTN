/*3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que debería existir un único gerente general
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
de empleados que había sin jefe antes de la ejecución.*/



--SP REALIZADO
alter procedure sp_update_empleados_un_solo_gerente
@cant_empl_sin_jefe decimal(10, 0) output
as 
begin
	set @cant_empl_sin_jefe = (select dbo.cantEmpleadoSinJefe())

	if @cant_empl_sin_jefe > 1 
		begin
			declare @cod_gerente numeric(6,0)
	
			set @cod_gerente = (select dbo.seleccionarGerenteGeneral())

			update empleado 
			set empl_tareas = 'Gerente'
			where empl_codigo = @cod_gerente

			update Empleado
			set empl_jefe = @cod_gerente
			where empl_codigo != @cod_gerente and empl_jefe is null

		end
	
end



--retorno del sp que utiliza las funciones

------------------------------
DECLARE @ValorResultado decimal(10, 0);

-- Ejecutar el procedimiento almacenado y obtener el resultado
EXEC sp_update_empleados_un_solo_gerente @cant_empl_sin_jefe = @ValorResultado OUTPUT;

-- Utilizar el valor obtenido
PRINT @ValorResultado;


----------------------------------------------------

--FUNCIONES REALIZADAS

ALTER function cantEmpleadoSinJefe()
returns decimal (10, 0)
begin
	DECLARE @cantidad decimal (10, 0)
	set @cantidad = 
		(select 
			count(*)
		from empleado 
		where empl_jefe is null
		)
	return @cantidad
end


ALTER function seleccionarGerenteGeneral()
returns numeric(6,0)
begin
	declare @cod_empleado numeric(6,0)

	set @cod_empleado = 
		(select top 1 empl_codigo
		from empleado
		order by empl_salario desc, empl_ingreso)

	return @cod_empleado
end



----------------------------------------------------


--Para hacer pruebas
update empleado 
	set empl_jefe = NULL
	where empl_codigo = 2

SELECT * FROM Empleado

