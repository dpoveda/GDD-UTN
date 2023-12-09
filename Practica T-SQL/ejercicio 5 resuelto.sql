/*5. Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada Fact_table tiene las siguiente definición:
Create table Fact_table
( anio char(4),
mes char(2),
familia char(3),
rubro char(4),
zona char(3),
cliente char(6),
producto char(8),
cantidad decimal(12,2),
monto decimal(12,2)
)
Alter table Fact_table
Add constraint c primary key(anio,mes,familia,rubro,zona,cliente,producto)*/


--creo la tabla propuesta
Create table Fact_table
( anio char(4),
mes char(2),
familia char(3),
rubro char(4),
zona char(3),
cliente char(6),
producto char(8),
cantidad decimal(12,2),
monto decimal(12,2)
)


--creo el sp
alter procedure post_migrar_datos_tabla_FactTable
as
begin

	insert into Fact_table (anio,
	mes,
	producto,
	familia,
	rubro,
	zona,
	cliente,
	cantidad,
	monto) select 
		year(f.fact_fecha),
		month(f.fact_fecha),
		p.prod_codigo,
		p.prod_familia,
		p.prod_rubro,
		d.depo_zona,
		f.fact_cliente,
		sum(i.item_cantidad),
		sum(i.item_cantidad * i.item_precio)
		from Factura f
			join Item_Factura i on f.fact_tipo+f.fact_sucursal+f.fact_numero = i.item_tipo+i.item_sucursal+i.item_numero
			join Producto p on i.item_producto = p.prod_codigo
			join Stock s on p.prod_codigo = s.stoc_producto
			join Deposito d on s.stoc_deposito = d.depo_codigo
		group by p.prod_codigo, 
				month(f.fact_fecha),
				year(f.fact_fecha),
				p.prod_familia,
				p.prod_rubro,
				d.depo_zona,
				f.fact_cliente
		order by year(f.fact_fecha),
				month(f.fact_fecha), 
				prod_codigo
end


exec post_migrar_datos_tabla_FactTable



-----------------------------------------------------------
--consultas que utilice
select * from Fact_table

drop table fact_table