--EJERCICIO 1

/*Hacer una funci�n que dado un art�culo y un deposito devuelva un string que
indique el estado del dep�sito seg�n el art�culo. Si la cantidad almacenada es
menor al l�mite retornar �OCUPACION DEL DEPOSITO XX %� siendo XX el
% de ocupaci�n. Si la cantidad almacenada es mayor o igual al l�mite retornar
�DEPOSITO COMPLETO�.*/


--creo la funcion
create function estado_deposito_por_articulo(@producto char(8), @depo char(2))
returns varchar(50)
as
begin
	return (select 
		case 
			when stoc_cantidad < isnull(stoc_stock_maximo,0) 
			then ('OCUPACION DEL DEPOSITO' + STR(@depo) + STR((stoc_cantidad * 100)/isnull(stoc_stock_maximo,1))+'%')
			else 'DEPOSITO COMPLETO'
		end
	from STOCK
	where stoc_producto = @producto and stoc_deposito = @depo)
end


--llamo a la funcion

select stoc_producto, stoc_deposito, dbo.estado_deposito_por_articulo(stoc_producto, stoc_deposito) from stock


/*Al encontrar que el stock maximo podia ser nulo, decidi ponele 0, pero en el caso de que despues lo necesito al dividir,
como no se puede dividir por cero, le asigno el numero 1*/