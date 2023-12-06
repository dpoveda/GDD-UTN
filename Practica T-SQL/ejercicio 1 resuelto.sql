/*1. Hacer una funci�n que dado un art�culo y un deposito devuelva un string que
indique el estado del dep�sito seg�n el art�culo. Si la cantidad almacenada es
menor al l�mite retornar �OCUPACION DEL DEPOSITO XX %� siendo XX el
% de ocupaci�n. Si la cantidad almacenada es mayor o igual al l�mite retornar
�DEPOSITO COMPLETO�.*/

--creo la funcion
create function estadoDeposito6(@articulo char(8), @deposito char(2))
returns char(50)
begin
	
	declare @resultado char(50)

	set @resultado =
	(select  
		case 
			when stoc_cantidad >= stoc_punto_reposicion then 'DEPOSITO COMPLETO' 
			else 'OCUPACION DEL DEPOSITO ' + convert(char(10), cast ((stoc_cantidad * 100) / stoc_punto_reposicion as dec(10,0))) + '%' 
		end
	 from stock where stoc_producto = @articulo and stoc_deposito = @deposito)

	 return @resultado
end


--ejecuto la funcion
select dbo.estadoDeposito6(stoc_producto, stoc_deposito) from stock



--siendo stoc_punto_reposicion = limite
---cant mayor al limte
--00001471  00


--cant menor al limite


/*select 
		cast ((stoc_cantidad * 100) / stoc_punto_reposicion as dec(10,0))
	 from stock where stoc_producto = '00014126' and stoc_deposito = '16'*/
--00014126    16


