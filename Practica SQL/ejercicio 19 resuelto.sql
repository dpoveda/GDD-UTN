/*19. En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:
 Codigo de producto
 Detalle del producto
 Codigo de la familia del producto
 Detalle de la familia actual del producto
 Codigo de la familia sugerido para el producto
 Detalla de la familia sugerido para el producto
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres.
En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente*/

select 
	p.prod_codigo,
	p.prod_detalle,
	f.fami_id as cod_fami_actual,
	f.fami_detalle as detalle_fami_actual,
	isnull((select top 1
				f2.fami_id
			from Producto p2
				join Familia f2 on p2.prod_familia = f2.fami_id
			where (SUBSTRING(p2.prod_detalle, 1, 5) != SUBSTRING(f2.fami_detalle, 1, 5))
			group by f2.fami_id, f2.fami_detalle
			having SUBSTRING(p.prod_detalle, 1, 5) = SUBSTRING(f2.fami_detalle, 1, 5)
			order by f2.fami_id), '999') as cod_fami_sugerido,
	isnull((select top 1
				f3.fami_detalle
			from Producto p3
				join Familia f3 on p3.prod_familia = f3.fami_id
			where (SUBSTRING(p3.prod_detalle, 1, 5) != SUBSTRING(f3.fami_detalle, 1, 5))
			group by f3.fami_id, f3.fami_detalle
			having SUBSTRING(p.prod_detalle, 1, 5) = SUBSTRING(f3.fami_detalle, 1, 5)
			order by f3.fami_id), 'SIN ASIGNACION') as detalle_fami_sugerido
from Producto p
	join Familia f on p.prod_familia = f.fami_id
where SUBSTRING(p.prod_detalle, 1, 5) != SUBSTRING(f.fami_detalle, 1, 5)
group by 
	p.prod_codigo,
	p.prod_detalle,
	f.fami_id,
	f.fami_detalle
order by p.prod_detalle



----------------------------------------------------------------
--pruebas que me ayudaron a resolver el ejercicio
/*
--1867
select 
	p.prod_codigo,
	p.prod_detalle,
	f.fami_id as cod_fami_actual,
	f.fami_detalle as detalle_fami_actual
	
from Producto p
	join Familia f on p.prod_familia = f.fami_id
where SUBSTRING(p.prod_detalle, 1, 5) != SUBSTRING(f.fami_detalle, 1, 5) 
group by 
	p.prod_codigo,
	p.prod_detalle,
	f.fami_id,
	f.fami_detalle

select
	f.fami_id, f.fami_detalle
from Producto p
join Familia f on p.prod_familia = f.fami_id
where (SUBSTRING(p.prod_detalle, 1, 5) != SUBSTRING(f.fami_detalle, 1, 5))
group by f.fami_id, f.fami_detalle
having SUBSTRING('DULCE HORA X 500g.', 1, 5) = SUBSTRING(f.fami_detalle, 1, 5)
order by fami_id



00010324	POSTRE LIGHT CHOCOL. X 60g.                       	997	PORTAFOLIO PRIMARIO     
00010338	CREMA CHAMTILLY X 50g.                            	181	POSTRES                                                                     
                                      
BAZOOKA X 120u. MENTA       
BELDENT X 20u. MENTA       
BILLIKEN X 600g. FRUTALES  
PILAS E 95 u.    
BATERIA 1222 u.         
LINTERNA  V 115     
FOSFORO FAMILIAR X 220u.                   


select * from familia order by fami_detalle     
select * from Producto order by prod_detalle                   

fa

413	CIGARRITOS                                        
002	CIGARRITOS DORADOS      


prod
00001703	CIGARRITOS DORADOS                                
00001603	CIGARRO CORONA DAL MOLIN                          
00001604	CIGARRO MEDIACORONA DAL MOLIN                     
00001602	CIGARRO ROBUSTO DAL MOLIN                         
00001601	CIGARRO X 4u. DAL MOLIN                       


*/                                                                                                                                                                           