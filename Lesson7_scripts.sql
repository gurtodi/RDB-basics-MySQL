/* Задание 1.
 * Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.*/
use shop;
select * from orders;
-- для начала заполнение таблицы заказов
insert into orders (user_id)
	select id from users order by rand () limit 4;
-- и посмотрим уникальные id
select distinct user_id from orders ;
-- используя exist смотрим результат:
select id, name from users
where exists (select * from orders where user_id = users.id);


/* Задание 2.
 * Выведите список товаров products и разделов catalogs, который соответствует товару.
 * */
select * from products; select * from catalogs;

select prod.name as 'Product name', cat.name as 'Product category'
from products as prod
join catalogs as cat
where prod.catalog_id = cat.id
order by rand();

/* Задание 3.
 * (по желанию)
 * Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
 * Поля from, to и label содержат английские названия городов, поле name — русское.
 * Выведите список рейсов flights с русскими названиями городов.
 * */
use just4test;
create table flights (
	id serial primary key,
	from_IATA varchar (255),
	to_IATA varchar (255)
) comment = 'Таблица рейсов';
create table cities (
	label varchar (255),
	name  varchar (255)
) comment = 'Таблица городов';
-- заполним сначала таблицу городов
insert into cities values
('AFR','Афор'), ('AZD','Йезд'), ('BFU','Бэнбу'), ('BUS','Батуми'),
('BZP','Бизант'), ('DGF','Дуглас Лейк'), ('DYR','Анадырь'),
('FNH','Финча'), ('IGG','Игьюджиг'), ('IXP','Патанкот'),
('NGI','Нгау'), ('SEU','Серонера'), ('YAN','Янгамби'),
('WKA','Ванака'), ('BGO','Берген');

truncate flights;
-- далее таблица рейсов
insert into flights (from_IATA, to_IATA)
	select
		(select label from cities order by rand() limit 1),
		(select label from cities order by rand() limit 1)
	from cities limit 10;
-- для начала просто подставим.. для одного
select f.id, c.name 
from flights as f
join cities as c 
where f.from_IATA = c.label;

-- таблице городов выдадим разные псевдонимы
select f.id, concat (city_from.name, " | " ,f.from_IATA) as 'Город отправления', concat(city_to.name, ' | ', f.to_IATA) as 'Город прибытия'
from flights as f
join cities as city_from on f.from_IATA = city_from.label
join cities as city_to on f.to_IATA = city_to.label;


select * from cities;
select * from flights;
