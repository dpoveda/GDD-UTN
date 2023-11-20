/*15. Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.
Ejemplo de lo que retornaría la consulta:
PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2*/

select 
	i1.item_producto,
	p1.prod_detalle,
	i2.item_producto,
	p2.prod_detalle, 
	COUNT(*) as cant_veces_vendidos_juntos
from Factura f
	join Item_Factura i1 on f.fact_tipo+f.fact_sucursal+f.fact_numero=i1.item_tipo+i1.item_sucursal+i1.item_numero
	join Item_Factura i2 on f.fact_tipo+f.fact_sucursal+f.fact_numero=i2.item_tipo+i2.item_sucursal+i2.item_numero
	join Producto p1 on i1.item_producto = p1.prod_codigo
	join Producto p2 on i2.item_producto = p2.prod_codigo
where i1.item_producto < i2.item_producto
group by
	i1.item_producto,
	p1.prod_detalle,
	i2.item_producto,
	p2.prod_detalle
having COUNT(*) > 500
order by COUNT(*) desc