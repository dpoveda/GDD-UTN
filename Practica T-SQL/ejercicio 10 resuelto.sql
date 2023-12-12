/*10. Crear el/los objetos de base de datos que ante el intento de borrar un artículo
verifique que no exista stock y si es así lo borre en caso contrario que emita un
mensaje de error.*/


alter trigger delete_articulo_a
on producto
instead of delete
as
begin

	if exists(
		select 1 
		from deleted d 
			join STOCK s on d.prod_codigo = s.stoc_producto
		where s.stoc_cantidad > 0
	)
		begin
			rollback transaction
			print 'No se pudo eliminar el articulo pues este aun tiene stock'
		end
	else 
		begin
			DELETE FROM stock 
			WHERE stoc_producto in (select d.prod_codigo from deleted d);

			DELETE FROM Producto 
			WHERE prod_codigo in (select d.prod_codigo from deleted d);	
		end

end



--pruebas que tome de ejemplo

select * from stock
where stoc_producto = '00000030'
order by stoc_cantidad 


select * from producto
where prod_codigo = '00000030'

select * from Item_Factura
where item_producto = '00000030'

update stock 
set stoc_cantidad = 0 
where stoc_producto = '00000030'

DELETE FROM Producto
WHERE prod_codigo = '00000030';


-1.00	1.00	NULL	NULL	NULL	00010134	03
0.00	1.00	NULL	NULL	NULL	00010132	00
10.00	5.00	50.00	NULL	NULL	00009714	02