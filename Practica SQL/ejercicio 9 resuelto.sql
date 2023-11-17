--EJERCICIO 9

/*Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.*/

select 
	j.empl_codigo as cod_jefe,
	j.empl_apellido as apellido_jefe,
	j.empl_nombre as nombre_jefe,
	e.empl_codigo as cod_empleado,
	e.empl_apellido as apellido_empleado,
	e.empl_nombre as nombre_empleado,
	count(d.depo_encargado) as deposito_de_ambos
from empleado j 
	join empleado e on j.empl_codigo = e.empl_jefe 
	join DEPOSITO d on (j.empl_codigo = d.depo_encargado or e.empl_codigo = d.depo_encargado)
group by j.empl_codigo,
		j.empl_apellido,
		j.empl_nombre,
		e.empl_codigo,
		e.empl_apellido,
		e.empl_nombre


--ej -- ambos tienen 16
--pedro gonzalez es empleado de juan perez(jefe)

--despues mostrar la cant de depositos que tiene pedro gonzalez -- tiene 10
select count(*) as cant_depositos_pedro from empleado e
join DEPOSITO d on e.empl_codigo = d.depo_encargado
where e.empl_codigo = 2 

--despues mostrar la cant de depositos que tiene el jefe pedro gonzalez -- tiene 6
select count(*) as cant_depositos_pedro_jefe from empleado e
join DEPOSITO d on e.empl_codigo = d.depo_encargado
where e.empl_codigo = 1 

