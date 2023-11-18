/*13. Realizar una consulta que retorne para cada producto que posea composición nombre
del producto, precio del producto, precio de la sumatoria de los precios por la cantidad
de los productos que lo componen. Solo se deberán mostrar los productos que estén
compuestos por más de 2 productos y deben ser ordenados de mayor a menor por
cantidad de productos que lo componen.*/


--para esto, elegi un producto, y me fije porque estaba compuesto, casualmente, la composicion compone otros productos,
--por lo que cada uno de ellos tiene su propio precio, por eso el join a p2 para conocer los precios de estos

select 
	p1.prod_detalle,
	p1.prod_precio,
	cast(sum(isnull(p2.prod_precio, 0) * isnull(c.comp_cantidad, 0)) as dec(10,2)) as precio_total_compuestos
from Producto p1
	join Composicion c on p1.prod_codigo = c.comp_producto
	join Producto p2 on p2.prod_codigo = c.comp_componente
group by 
	p1.prod_detalle,
	p1.prod_precio
having count(distinct c.comp_componente) >= 2
order by sum(c.comp_cantidad) desc

