-- 1. Crea el esquema de la BBDD.



/* 2.  Muestra los nombres de todas las películas con una clasificación por
edades de ‘R’. */

select "title" as Titulo_Pelicula , "rating" as Clasificacion_de_edades
from "film"
where "rating"='R';


/* 3.  Encuentra los nombres de los actores que tengan un “actor_id” entre 30
y 40. */

select "first_name" as Nombre_actor
from actor a 
where "actor_id" between 30 and 40;


-- 4.  Obtén las películas cuyo idioma coincide con el idioma original.

SELECT f.title, l.name AS idioma, lo.name AS idioma_original
FROM film AS f
JOIN language AS l  ON f.language_id = l.language_id
LEFT JOIN language AS lo ON f.original_language_id = lo.language_id
WHERE f.original_language_id IS NOT NULL
  AND f.language_id = f.original_language_id;


-- 5.  Ordena las películas por duración de forma ascendente.

select "title" as titulo, "length" as duracion
from film f 
order by "length" asc;


/* 6.   Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su
apellido. */

select "first_name" as nombre, "last_name" as apellido
from actor a 
where "last_name" IN ('ALLEN');


/* 7.   Encuentra la cantidad total de películas en cada clasificación de la tabla
“film” y muestra la clasificación junto con el recuento. */

select count("rating") as total_peliculas_categoria, "rating" as categoria
from film
group by "rating";


/*  8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
duración mayor a 3 horas en la tabla film. */

SELECT "title" as titulo, "rating" as clasificacion, "length" as duracion
FROM film
WHERE "rating" = 'PG-13'
   OR "length" > 180;


--  9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

select variance("replacement_cost")
as "varianza_reemplazo"
from "film";


-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select MIN("length") as "pelicula_menor_duracion", Max("length") as "pelicula_mayor_duracion"
from film f ;


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

select "amount" as "coste_antepenultimo_alquiler"
from "payment"
order by "payment_date" desc
limit 1
offset 2;


--  12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.

select "title" as "titulo", "rating" as "clasificacion"
from film f 
where "rating" not in ('NC-17', 'G');


/* 13. Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración. */

select avg("length") as "promedio_duracion_peliculas", "rating" as "clasificacion"
from film f
group by "rating";


/* 14. Encuentra el título de todas las películas que tengan una duración mayor
a 180 minutos. */

select "title" as "titulo", "length" as "duracion"
from "film"
where "length" >180;


-- 15. ¿Cuánto dinero ha generado en total la empresa?

select sum("amount") as "total_dinero"
from "payment";


-- 16. Muestra los 10 clientes con mayor valor de id.

select concat ("first_name",' ',"last_name") as "nombre_cliente", "customer_id" as "codigo_cliente"
from "customer"
order by "customer_id" desc
limit 10;


/* 17. Encuentra el nombre y apellido de los actores que aparecen en la
película con título ‘Egg Igby’ */


select concat(a.first_name,' ',a.last_name) as "actor", "title" as "pelicula"
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id
inner join film f 
on f.film_id = fa.film_id 
where f.title = 'EGG IGBY';


-- 18. Selecciona todos los nombres de las películas únicos.

select distinct("title") as "titulo"
from "film";


/*19. Encuentra el título de las películas que son comedias y tienen una
duración mayor a 180 minutos en la tabla “film”. */

select f.title  as "titulo", c."name"  as "categoria", f.length as "duracion"
from film f 
inner join film_category fc
on f.film_id = fc.film_id
right join category c
on  c.category_id = fc.category_id
where c."name"='Comedy'and f.length>180;


/*20. Encuentra las categorías de películas que tienen un promedio de 
duración superior a 110 minutos y muestra el nombre de la categoría 
junto con el promedio de duración. */

select  c."name" as "categoria", AVG(f.length ) as "promedio duracion"
from film f 
inner join film_category fc 
on f.film_id = fc.film_id 
inner join category c 
on c.category_id = fc.category_id 
group by c."name" 
having AVG(f.length)>110;


--21.¿Cuál es la media de duración del alquiler de las películas?

select avg(f.rental_duration ) as "duracion media del alquiler"
from film f;


/*22.Crea una columna con el nombre y apellidos de todos los actores y 
actrices. */

select concat(a.first_name ,' ',a.last_name ) as "nombre actores y actrices"
from actor a;



/*23.Números de alquiler por día, ordenados por cantidad de alquiler de 
forma descendente. */

select date(r.rental_date ) as "fecha", count((date(r.rental_date ))) as "cantidad" 
from rental r 
group by date(r.rental_date )
order by count((date(r.rental_date ))) desc;


--24. Encuentra las películas con una duración superior al promedio.

select f.title as "titulo pelicula", f.length as "duracion"
from film f 
where f.length >(
	select avg(f.length) 
	from film f);


--25. Averigua el número de alquileres registrados por mes.

select extract (month from rental_date) as "mes", count(rental_date ) as "numero alquileres"
from rental r 
group by extract (month from rental_date )
order by "mes";


/*26. Encuentra el promedio, la desviación estándar y varianza del total 
pagado. */

select avg(p.amount ) as "promedio total pagado", stddev(p.amount ) as "desviacion total pagado", variance(p.amount ) as "varianza total pagado"
from payment p ;


--27. ¿Qué películas se alquilan por encima del precio medio?

select f.title as "titulo", p.amount as "precio"
from film f 
inner join inventory i  
on f.film_id = i.film_id 
inner join rental r 
on r.inventory_id = i.inventory_id 
inner join payment p  
on p.rental_id = r.rental_id  
where p.amount > (select avg(p.amount) from payment p );


/*28. Muestra el id de los actores que hayan participado en más de 40 
películas. */

select fa.actor_id as "Id Actor", count(f.title)  as "peliculas"
from film_actor fa 
inner join film f 
on  fa.film_id = f.film_id
group by fa.actor_id 
having count(f.title) >40;


/*29. Obtener todas las películas y, si están disponibles en el inventario, 
mostrar la cantidad disponible. */

select f.title  as "peliculas", count (i.inventory_id ) as "numero disponible"
from film f
left join inventory i 
on f.film_id = i.film_id
group by f.title 
having count (i.inventory_id )>0 ;


--30. Obtener los actores y el número de películas en las que ha actuado.

select concat (a.first_name,' ',a.last_name ) as "actores", count(fa.film_id) as "numero peliculas"
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id 
group by "actores"
order by "numero peliculas" ;


/* 31. Obtener todas las películas y mostrar los actores que han actuado en 
ellas, incluso si algunas películas no tienen actores asociados. */

select f.title as Peliculas, concat (a.first_name,' ', a.last_name) as Actor
From film f 
left join film_actor fa 
on f.film_id = fa.film_id 
left join actor a 
on fa.actor_id = a.actor_id


/* 32. Obtener todos los actores y mostrar las películas en las que han 
actuado, incluso si algunos actores no han actuado en ninguna película. */

select concat(a.first_name,' ',a.last_name) as actor, f.title as pelicula
From actor a 
left join film_actor fa 
on a.actor_id = fa.actor_id 
left join film f 
on fa.film_id = f.film_id 


/*33. Obtener todas las películas que tenemos y todos los registros de 
alquiler. */

select f.title as peliculas, r.rental_date as registro_alquiler
from film f 
full join inventory i 
on f.film_id = i.film_id 
full join rental r
on i.inventory_id = r.inventory_id 
order by peliculas 


--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

select concat(c.first_name ,' ',c.last_name ) as cliente, sum (p.amount ) as dinero_gastado
from customer c 
inner join payment p 
on p.customer_id  = c.customer_id 
group by c.customer_id 
order by dinero_gastado desc
limit 5


--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select a.first_name as Nombre_actor, a.last_name as Apellido_actor
from actor a 
where a.first_name = 'JOHNNY'


/*36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como 
Apellido. */

select a.first_name as Nombre, a.last_name as Apellido
from actor a 


--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

select min(a.actor_id) , Max(a.actor_id )
from actor a 


--38. Cuenta cuántos actores hay en la tabla “actorˮ.

select count(a.actor_id ) as Numero_actores
from actor a 


/*39. Selecciona todos los actores y ordénalos por apellido en orden 
ascendente. */

select a.first_name as Nombre, a.last_name as Apellido
from actor a 
order by apellido asc


--40. Selecciona las primeras 5 películas de la tabla “filmˮ.

select f.title as peliculas
from film f 
limit 5


/*41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el 
mismo nombre. ¿Cuál es el nombre más repetido? */

select a.first_name as nombre, count(a.first_name) as numero_veces_repetido
from actor a 
group by a.first_name 
order by numero_veces_repetido desc


/*42. Encuentra todos los alquileres y los nombres de los clientes que los 
realizaron. */

select f.title as titulo, concat(c.first_name, ' ',c.last_name ) as cliente
from film f 
inner join inventory i 
on f.film_id  =f.film_id 
inner join rental r 
on r.inventory_id =i.inventory_id 
inner join customer c 
on c.customer_id = r.customer_id 
order by titulo 


/*43. Muestra todos los clientes y sus alquileres si existen, incluyendo 
aquellos que no tienen alquileres. */

select concat(c.first_name ,' ',c.last_name ) as cliente, f.title as titulo
from customer c 
left join rental r 
on c.customer_id  = r.customer_id 
left join inventory i 
on r.inventory_id = i.inventory_id 
left join film f 
on i.film_id = f.film_id 
order by titulo asc


/*44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor 
esta consulta? ¿Por qué? Deja después de la consulta la contestación. */

select *
from film f 
cross join category c 

-- Esta consulta no aporta valor ninguno ya que nos está mezclando las tablas de forma cartesiana sin ninguna relación entre ambas tablas


/*45. Encuentra los actores que han participado en películas de la categoría 
'Action'. */

select concat(a.first_name,' ',a.last_name) as actor, c."name" as Categoria
from actor a 
inner join film_actor fa 
on fa.actor_id = a.actor_id 
inner join film f 
on f.film_id = fa.film_id 
inner join film_category fc 
on fc.film_id =f.film_id 
inner join category c 
on c.category_id =fc.category_id 
where c."name" = 'Action'
order by actor 


--46. Encuentra todos los actores que no han participado en películas.

select concat (a.first_name  ,' ',a.last_name ) as actor
from actor a 
left join film_actor fa 
on a.actor_id  = fa.actor_id 
where fa.film_id  = null


/*47. Selecciona el nombre de los actores y la cantidad de películas en las 
que han participado. */

select a.first_name as Actor, count(f.title) as Numero_peliculas
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id 
inner join film f 
on fa.film_id = f.film_id 
group by actor 
order by numero_peliculas asc


/*48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres 
de los actores y el número de películas en las que han participado. */

create view actor_num_peliculas as 
select a.first_name as actor, count(f.title)as num_peliculas
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id
inner join film f 
on fa.film_id = f.film_id
group by a.first_name

-- consulta

select *
from actor_num_peliculas


--49. Calcula el número total de alquileres realizados por cada cliente.

select concat(c.first_name ,' ',c.last_name ) cliente, count(r.rental_id  ) as numero_peliculas
from customer c 
inner join rental r 
on c.customer_id  = r.customer_id 
group by cliente 
order by numero_peliculas desc


--50. Calcula la duración total de las películas en la categoría 'Action'.

select c."name" as categoria, sum(f.length ) as duracion_total
from film f 
inner join film_category fc 
on f.film_id = fc.film_id 
inner join category c 
on fc.category_id = c.category_id 
where c."name" ='Action'
group by c."name" 


/*51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para 
almacenar el total de alquileres por cliente. */

create temp table cliente_rentas_temporal as
select concat(c.first_name ,' ',c.last_name ) cliente, count(r.rental_id  ) as numero_peliculas
from customer c 
inner join rental r 
on c.customer_id  = r.customer_id 
group by cliente 
order by numero_peliculas desc

-- consulta

select *
from cliente_rentas_temporal


/*52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las 
películas que han sido alquiladas al menos 10 veces. */

create temp table peliculas_alquiladas as
select f.title as "peliculas",count(r.rental_id) as "numero_alquileres"
from film as f
inner join inventory as i
on f.film_id = i.film_id
inner join rental as r
on i.inventory_id = r.inventory_id
group by f.title
having count(r.rental_id) >=10

-- consulta

select *
from peliculas_alquiladas


/*53. Encuentra el título de las películas que han sido alquiladas por el cliente 
con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena 
los resultados alfabéticamente por título de película. */

select f.title as Peliculas, concat(c.first_name,' ',c.last_name ) as nombre_cliente
from film f 
inner join inventory i 
on f.film_id = i.film_id 
inner join rental r 
on i.inventory_id = r.inventory_id 
inner join customer c 
on r.customer_id = c.customer_id 
where concat(c.first_name,' ',c.last_name) = 'TAMMY SANDERS' and r.return_date is NULL
order by peliculas 


/*54. Encuentra los nombres de los actores que han actuado en al menos una 
película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados 
alfabéticamente por apellido. */

select a.first_name as nombre,a.last_name as apellido, f.title as titulo, c."name" as categoria
from actor a 
inner join film_actor fa 
on a.actor_id =fa.actor_id 
inner join film f 
on fa.film_id = f.film_id 
inner join film_category fc 
on f.film_id = fc.film_id 
inner join category c 
on fc.category_id = c.category_id 
where c."name" = 'Sci-Fi'
order by apellido 


/*55. Encuentra el nombre y apellido de los actores que han actuado en 
películas que se alquilaron después de que la película ‘Spartacus 
Cheaperʼ se alquilara por primera vez. Ordena los resultados 
alfabéticamente por apellido. */

select a.first_name as nombre, a.last_name as apellido, f.title as pelicula, r.rental_date as fecha_alquiler
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id 
inner join film f 
on fa.film_id = f.film_id 
inner join inventory i 
on f.film_id = i.film_id 
inner join rental r 
on i.inventory_id = r.inventory_id 
where r.rental_date > (select min(r.rental_date) as fecha_alquil
	from rental r 
	inner join inventory i 
	on r.inventory_id =i.inventory_id 
	inner join film f 
	on i.film_id = f.film_id 
	where f.title = 'SPARTACUS CHEAPER')
order by a.last_name  


/*56. Encuentra el nombre y apellido de los actores que no han actuado en 
ninguna película de la categoría ‘Musicʼ. */

select a.first_name as nombre, a.last_name as apellido, c."name" as categoria
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id 
inner join film f 
on fa.film_id = f.film_id 
inner join film_category fc 
on f.film_id = fc.film_id 
inner join category c 
on fc.category_id = c.category_id 
where c."name" <> 'Music'

/*57. Encuentra el título de todas las películas que fueron alquiladas por más 
de 8 días. */

select f.title as titulo
from film f 
where f.rental_duration >8


/*58. Encuentra el título de todas las películas que son de la misma categoría 
que ‘Animationʼ. */

select f.title as titulo, c."name" as categoria
from film f 
inner join film_category fc 
on f.film_id = fc.film_id 
inner join category c 
on fc.category_id = c.category_id 
where c."name" = 'Animation'
order by titulo 


/*59. Encuentra los nombres de las películas que tienen la misma duración 
que la película con el título ‘Dancing Feverʼ. Ordena los resultados 
alfabéticamente por título de película. */

select f.title as titulo, f.length as duracion
from film f 
where f.length  = (select f.length
	from film f 
	where f.title = 'DANCING FEVER')
order by titulo 


/*60. Encuentra los nombres de los clientes que han alquilado al menos 7 
películas distintas. Ordena los resultados alfabéticamente por apellido. */

select c.first_name as nombre,c.last_name as apellido, count(distinct f.film_id ) as numero_peliculas_distintas
from customer c 
inner join rental r 
on c.customer_id = r.customer_id 
inner join inventory i 
on r.inventory_id = i.inventory_id 
inner join film f 
on i.film_id = f.film_id
group by nombre , apellido 
having count(distinct f.film_id )>=7
order by c.last_name 


/*61. Encuentra la cantidad total de películas alquiladas por categoría y 
muestra el nombre de la categoría junto con el recuento de alquileres. */

select count( f.film_id ) as Total_peliculas, c."name" as categoria, count(r.rental_id ) as recuento_alquileres
from film f 
inner join film_category fc 
on f.film_id = fc.film_id 
inner join category c 
on fc.category_id = c.category_id 
inner join inventory i 
on f.film_id = i.film_id 
inner join rental r 
on i.inventory_id = r.inventory_id 
group by c.category_id 


--*62. Encuentra el número de películas por categoría estrenadas en 2006.

select c."name" as categoria, count(f.film_id ) as numero_peliculas,f.release_year as año_estreno
from film f 
inner join film_category fc 
on f.film_id = fc.film_id 
inner join category c 
on fc.category_id = c.category_id 
group by c."name" , f.release_year 
having f.release_year =2006


/*63. Obtén todas las combinaciones posibles de trabajadores con las tiendas 
que tenemos. */

select *
from staff s 
full join store s2 
on s.store_id = s2.store_id 


/*64. Encuentra la cantidad total de películas alquiladas por cada cliente y 
muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
películas alquiladas. */

select c.customer_id as ID_cliente, c.first_name as nombre, c.last_name as apellido, count(r.rental_id ) as numero_alquileres
from customer c 
inner join rental r 
on c.customer_id = r.customer_id 
group by c.customer_id 

