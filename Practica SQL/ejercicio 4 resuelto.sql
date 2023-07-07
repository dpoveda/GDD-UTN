--EJERCICIO 4

/*Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de
artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock
promedio por depósito sea mayor a 100.*/

--una solucion
select p.prod_codigo, p.prod_detalle, count(distinct c.comp_componente) as cant_articulos_que_lo_componen
from Producto p
	left join Composicion c ON c.comp_producto = p.prod_codigo
	join STOCK s ON s.stoc_producto = p.prod_codigo
group by p.prod_codigo, p.prod_detalle
--having sum(s.stoc_cantidad)/count(distinct(s.stoc_deposito)) > 0
having avg(s.stoc_cantidad) > 0
order by count(distinct c.comp_componente) desc

--Le puse el left porque quiero TODOS los productos por mas que no tengan componentes, 
--tambien agregue un distinct cuando cuento los componentes, porque al joinearlo con stock, 
--me multiplicaba los componentes por la cantidad de depositos que tenia ese producto, 
--cambie que sea mayor a 0 porque o sino no encontraba ningun producto


--otra solucion 
select p.prod_codigo, p.prod_detalle, count(c.comp_componente) as cant_articulos_que_lo_componen
from Producto p
	left join Composicion c ON c.comp_producto = p.prod_codigo
where p.prod_codigo in (select stoc_producto from stock
	group by stoc_producto
	having avg(stoc_cantidad) > 0)
group by p.prod_codigo, p.prod_detalle
order by count(c.comp_componente) desc

--esta es mas performante porque el sub select del where es estatico y se ejecuta una sola
--vez y despues se guarda la info para que la use el sub select mayor