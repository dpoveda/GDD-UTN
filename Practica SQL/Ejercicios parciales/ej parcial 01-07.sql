--EJERCICIO PARCIAL 1/07

/*1. Realizar una consulta SQL que muestre aquellos clientes que en 2
años consecutivos compraron.
De estos clientes mostrar
i. El código de cliente. 
ii. El nombre del cliente. 
iii. El numero de rubros que compro el cliente. 
iv. La cantidad de productos con composición que compro el cliente en el 2012. 

El resultado deberá ser ordenado por cantidad de facturas
del cliente en toda la historia, de manera ascendente.

Nota: No se permiten select en el from, es decir, select ... from (select ...) as T,*/

SELECT c.clie_codigo, 
	c.clie_razon_social, 
	count(distinct p.prod_rubro) as cant_rubros,
	(select count(distinct(cm.comp_producto))
	 from Composicion cm 
		join Producto p ON p.prod_codigo = cm.comp_producto
		join Item_Factura i ON i.item_producto = p.prod_codigo
		join Factura f ON i.item_tipo+i.item_sucursal+i.item_numero = f.fact_tipo+f.fact_sucursal+f.fact_numero
	where year(f.fact_fecha) = 2012 and f.fact_cliente = c.clie_codigo
	) as cant_prod_comprados_con_composicion_en_2012
FROM Cliente c
	join Factura f ON f.fact_cliente = c.clie_codigo
	join Item_Factura i ON i.item_tipo+i.item_sucursal+i.item_numero = f.fact_tipo+f.fact_sucursal+f.fact_numero
	join Producto p ON p.prod_codigo = i.item_producto
where exists(
		select 1 
		from Factura f
			join Item_Factura i ON i.item_tipo+i.item_sucursal+i.item_numero = f.fact_tipo+f.fact_sucursal+f.fact_numero	
		where year(f.fact_fecha) = year(f.fact_fecha) and f.fact_cliente = c.clie_codigo
	) and exists(
		select 1 
		from Factura f2
			join Item_Factura i2 ON i2.item_tipo+i2.item_sucursal+i2.item_numero = f2.fact_tipo+f2.fact_sucursal+f2.fact_numero	
		where year(f2.fact_fecha) = year(f.fact_fecha) + 1 and f2.fact_cliente = c.clie_codigo
	)
group by c.clie_codigo, c.clie_razon_social
order by count(distinct f.fact_numero) asc


/*Asumo que al decir "cant de productos con composicion..." se trata de aquellos productos que tengan composicion
y la suma de los diferentes productos comprados en el año 2012*/
