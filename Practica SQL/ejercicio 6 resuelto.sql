--EJERCICIO 6
/*Mostrar para todos los rubros de art�culos c�digo, detalle, cantidad de art�culos de ese
rubro y stock total de ese rubro de art�culos. Solo tener en cuenta aquellos art�culos que
tengan un stock mayor al del art�culo �00000000� en el dep�sito �00�.*/

select 
r.rubr_id, 
r.rubr_detalle, 
count(prod_codigo) as cant_articulos,
isnull(SUM(s.stoc_cantidad),0) as stock_total
from rubro r
join Producto p ON p.prod_rubro = r.rubr_id
join STOCK s ON s.stoc_producto = p.prod_codigo
group by r.rubr_id, r.rubr_detalle
having SUM(s.stoc_cantidad) > (
	select 
	SUM(s1.stoc_cantidad)
	from STOCK s1 
	where s1.stoc_producto = '00000000' and s1.stoc_deposito = '00'
)


--entiendo que debo mostrar el cod, nombre, cant de articulos, stock de ese rubro en total que tiene un rubro