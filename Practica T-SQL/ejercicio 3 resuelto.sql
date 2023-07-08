--EJERCICIO 3

/*Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que deber�a existir un �nico gerente general
(deber�a ser el �nico empleado sin jefe). Si detecta que hay m�s de un empleado
sin jefe deber� elegir entre ellos el gerente general, el cual ser� seleccionado por
mayor salario. Si hay m�s de uno se seleccionara el de mayor antig�edad en la
empresa. Al finalizar la ejecuci�n del objeto la tabla deber� cumplir con la regla
de un �nico empleado sin jefe (el gerente general) y deber� retornar la cantidad
de empleados que hab�a sin jefe antes de la ejecuci�n.*/



/*Asumo que no es una funcion pues modifica una tabla, tampoco un trigger pues no hay ningun evento que lo desencadene, 
por lo tanto es un SP*/

create procedure ej3 @cantidad int output --declaro la variable cantidad que voy a retornar despues
as
begin
--muestro la cantidad de empleados que no tenian jefe antes de corregir la tabla
set @cantidad = (select count(*) from Empleado where empl_jefe is null)

--actualizo la tabla empleado dejando solamente un gerente general, y a los demas, le pongo como jefe ese gerente general que encontre
update Empleado set empl_jefe = (select top 1 empl_codigo from Empleado where empl_jefe is null order by empl_salario desc, empl_ingreso asc)
from Empleado 
where empl_jefe is null and empl_codigo <> (select top 1 empl_codigo from Empleado where empl_jefe is null order by empl_salario desc, empl_ingreso asc)

return --pongo el return pues quiero retornar la cantidad
end

