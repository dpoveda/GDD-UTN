--EJERCICIO 1
/*Mostrar el c�digo, raz�n social de todos los clientes cuyo l�mite de cr�dito sea mayor o
igual a $ 1000 ordenado por c�digo de cliente.*/

select clie_codigo, clie_razon_social
from cliente
where clie_limite_credito >= 1000
order by clie_codigo asc
