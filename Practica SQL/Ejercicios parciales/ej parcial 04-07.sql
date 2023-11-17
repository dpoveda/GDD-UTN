--EJERCICIO PARCIAL 04/07/2023

/*1. Se solicita estadística por Año y familia, para ello se deberá mostrar.
Año, Código de familia, Detalle de familia, cantidad de facturas, cantidad
de productos con COmposición vendidOs, monto total vendido.
 Solo se deberán considerar las familias que tengan al menos un producto con
composición y que se hayan vendido conjuntamente (en la misma factura)
con otra familia distinta.
NOTA: No se permite el uso de sub-selects en el FROM ni funciones
definidas por el usuario para este punto,*/

--me faltaron estos tres puntos donde se debe mirar por año
--cantidad de facturas, cantidad de productos con COmposición vendidOs, monto total vendido.

select 
year(f.fact_fecha) as anio,
p.prod_familia as cod_familia, 
fm.fami_detalle as detalle_familia,
count(distinct f.fact_numero+f.fact_sucursal+f.fact_tipo) as cant_facturas
from producto p
	join Familia fm on fm.fami_id = p.prod_familia
	join Item_Factura i on i.item_producto = p.prod_codigo
	join factura f on f.fact_numero+f.fact_sucursal+f.fact_tipo = i.item_numero+i.item_sucursal+i.item_tipo
	join Composicion c1 on p.prod_codigo = c1.comp_producto
where exists (
	select 1 from producto p2
	join Item_Factura i2 on i2.item_producto = p2.prod_codigo
	join factura f2 on f2.fact_numero+f2.fact_sucursal+f2.fact_tipo = i2.item_numero+i2.item_sucursal+i2.item_tipo 
	where p2.prod_familia <> p.prod_familia and f2.fact_numero+f2.fact_sucursal+f2.fact_tipo = f.fact_numero+f.fact_sucursal+f.fact_tipo
)
group by p.prod_familia, fm.fami_detalle, year(f.fact_fecha)


