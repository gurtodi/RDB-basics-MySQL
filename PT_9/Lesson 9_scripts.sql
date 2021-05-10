/* 1. Практическое задание по теме 
 * "Транзакции, переменные, представления"
 */

/*
 * Задание 1.1
 * В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
 * Используйте транзакции.
 */
-- создание предусловий, а точнее загрузка дампа таблицы users из базы shop в отсутствующую базу sample
create database sample;
/* далее терминальные команды выгрузки и загрузка дампа
 * mysqldump shop users > shop_users.sql
 * mysql sample < shop_users.sql
 */
-- немного параноидальных проверок во имя подготовки, пусть sample.users будет пуста
use sample; show tables; desc users; select * from users; truncate users;
-- как варинат: каждое значение записать в переменную, после чего присвоить соответстующие значения строке во второй базе

-- варинат решения 1. "в лоб" - перенос через переменные.
-- транзакция нужна для того, чтоб в процессе переноса данные не изменились
start transaction;
use shop;
select * from users;
set @shop_id := (select users.id from users where users.id = '1');
set @shop_name := (select users.name from users where users.id = '1');
set @shop_birthday := (select users.birthday_at from users where users.id = '1');
set @shop_create := (select users.created_at from users where users.id = '1');
set @shop_update := (select users.updated_at from users where users.id = '1');
select @shop_id, @shop_name, @shop_birthday;
select * from users where id = 1;
use sample;
insert into users values
(@shop_id, @shop_name, @shop_birthday, @shop_create, @shop_update);
use shop;
delete from users where id = 1; 
commit;
-- rollback;

-- вариант решения 2. 
-- перенос строки между базами по заданному id, с предварительно очисткой таблицы (во избежание ошибки неуникальности id)
start transaction;
use shop; -- активной делаем базу-исходную
insert into sample.users -- указываем базу.таблицу назначения
select * from users where id = 1; -- выборка по активной базе
delete from users where id = 1; -- удаление перенесенных данных
commit;

/*
 * Задание 1.2
 * Создайте представление, которое выводит 
 * название name товарной позиции из таблицы products 
 * и соответствующее название каталога name из таблицы catalogs. 
 */

use shop;
-- сам запрос отображения названия позиции и соотв. названия из каталога
select p.name, c.name
from products p
join catalogs c on p.catalog_id = c.id;

-- оборачивание этого в представление
create or replace view position_name as
select p.name as product_name, c.name as catalog_name
from products p
join catalogs c on p.catalog_id = c.id;
-- проверка представления
select * from position_name order by product_name;


/*
 * Задание 1.3
 * (по желанию) 
 * Пусть имеется таблица с календарным полем created_at. 
 * В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
 * Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле 
 * значение 1, если дата присутствует в исходном таблице и 
 * 0, если она отсутствует.
 */

use just4test; show tables;
select * from calendar_dates;
drop table calendar_dates;

create table calendar_dates (
	id serial primary key,
	created_at datetime
) comment = 'Таблица с календарным полем';

-- дамп заполненной таблицы прилагается отдельно в файле calendardates_dump.sql

-- простой выбор по совпадению из заданного списка
select id, created_at from calendar_dates where
created_at in ('2018-08-01', '2018-08-04', '2018-08-16', '2018-08-17');
-- и сам запрос на вывод 0 или 1 в зависимости от совпадения с указанным списком
select id, created_at,
(case
	when created_at in ('2018-08-01', '2018-08-04', '2018-08-16', '2018-08-17') then 1
	else 0	
end) as res
from c alendar_dates where DATE_FORMAT(created_at, '%c') like 8;
-- Но! не сходится с темой занятия, подвох?


/*
 * Задание 1.4
 * (по желанию)
 * Пусть имеется любая таблица с календарным полем created_at. 
 * Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
 */

INSERT INTO `calendar_dates` VALUES (1,'2018-08-01 00:00:00'),(2,'2018-08-25 17:18:32'),(3,'2018-10-01 01:15:59'),(4,'2018-10-19 02:24:20'),(5,'2018-08-04 00:00:00'),(6,'2018-09-30 08:13:44'),(7,'2018-08-16 00:00:00'),(8,'2018-05-05 09:55:40'),(9,'2018-06-19 00:57:12'),(10,'2018-04-18 22:58:58'),(11,'2018-08-17 00:00:00'),(12,'2018-02-02 16:03:14');

-- создадим представление самых свежих пяти дат
create or replace view freshly as
select id, created_at from calendar_dates order by created_at desc limit 5;
select * from freshly;
-- и, сравнивая с оным - будем удалять неподходящее

delete from calendar_dates
using calendar_dates, freshly
where calendar_dates.created_at <> freshly.created_at;

select *
from calendar_dates cd
join freshly f on cd.created_at <> f.created_at;

select * from calendar_dates;

/*
 * 2. Практическое задание по теме 
 * "Администрирование MySQL" 
 * (по желанию)
 */

/*
 * Задание 2.1
 * Создайте двух пользователей которые имеют доступ к базе данных shop.
 * Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
 * второму пользователю shop — любые операции в пределах базы данных shop. 
 */

create user 'shop_reader'@'localhost' identified by 'pass'; -- создание пользователя, задание пароля
grant select on shop.* to 'shop_reader'@'localhost'; -- вфдача прав на выборку данных

create user 'shop_omnipotent'@'localhost' identified by 'pass';
grant all on shop.* to 'shop_omnipotent'@'localhost';

select user from mysql.user; -- просмотр всех пользователей

show grants; -- просмотр выданных прав для залогиненного пользователя

/*
 * Задание 2.2
 * (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. 
 * Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name.
 * Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.
 */

use just4test;

-- создание таблицы, заполнение оной
create table accounts(
	id serial primary key,
	name varchar(255),
	pass varchar(255)
);

insert into accounts (name, pass) values 
	('Tobin','OnRvf9NPP3R$'),
	('Myrtie','gQ11z6MKsvhG'),
	('Georgianna','AG2jKoP^{m7t'),
	('Delphine','()h(9umWp%y_'),
	('Dedric','QWYudnTWH5gc'),
	('Aglae','vp!#Lifo7M)9'),
	('Eleanore','<JM*Xc#2a!ph'),
	('Hudson','C3H]k62T4O9ud'),
	('Larissa','7m>$C>tH3K!x'),
	('Jaquelin','QVlOsW^p|w95'),
	('Yazmin','*ZWMCPTNL<5@'),
	('Cale','u|8yJ6^tA%4E');

select * from accounts;
-- создание представления
create view username as select id, name from accounts;

create user 'user_read'@'localhost' identified by 'pass'; -- создание пользователя, задание пароля
grant select on just4test.username to 'user_read'@'localhost'; -- вфдача прав на выборку данных из представления


/*
 * 3. Практическое задание по теме 
 * "Хранимые процедуры и функции, триггеры"
 */

/*
 * Задание 3.1
 * Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток:
 * с 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 * с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 * с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
 */

use just4test;

-- DELIMITER //
-- вместо задания разделителя через консоль, временно изменен оный на // в настройках dbeaver'а

create function hello()
returns text deterministic
begin
case
	when hour(now()) between 0 and 5 then return 'Доброй ночи';
	when hour(now()) between 6 and 11 then return 'Доброе утро';
	when hour(now()) between 12 and 17 then return 'Добрый день';
	when hour(now()) between 18 and 23 then return 'Добрый вечер';
end case;
end //

select hello(), hour(now())//

-- если модифицировать, и просто при вызове средь аргументов передавать текущий час
create function hello_modify(hours int)
returns text deterministic
begin
case
	when hours between 0 and 5 then return 'Доброй ночи';
	when hours between 6 and 11 then return 'Доброе утро';
	when hours between 12 and 17 then return 'Добрый день';
	when hours between 18 and 23 then return 'Добрый вечер';
end case;
end //

select hello_modify(hour(now()))//

/*
 * Задание 3.2
 * В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 * Допустимо присутствие обоих полей или одно из них. 
 * Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
 * При попытке присвоить полям NULL-значение необходимо отменить операцию.
 */
use shop// desc products// select * from products// -- вспомнили, с чем работаем

drop trigger if exists insert_witout_nulls// -- удаление триггера на случай "а теперь всё заново"

create trigger insert_witout_nulls before insert on products -- триггер, срабатывающий до добавления записи
for each row
begin
	if coalesce(new.name, new.desсription) is null then -- проверяем ненулёвость новых полей
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'INSERT canceled: both name and description cannot be null'; -- задаем ошибку
	end if;
end//

-- и проверка работы триггера
insert into products (price) values ('100501')// -- 
insert into products (name) values ('GIGABYTE GeForce RTX 3060 EAGLE OC')//
insert into products (desсription, price) values ('Материнская плата ASUS ROG MAXIMUS XII FORMULA, LGA 1200, Intel Z490, ATX, Ret', '43090')//

-- а теперь как в задании: при попытке именно присвоить значение (т.е. на UPDATE, а не insert как было воспринято с первого раза)

-- триггер на то, что при обновлении недопустимо осталять значения пустыми (даже если они были пустыми до обновления данных)
create trigger update_witout_nulls before update on products
for each row
begin
	if coalesce(new.name, new.desсription) is null then -- проверяем ненулёвость новых полей
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'UPDATE canceled: both name and description cannot be null';
	elseif coalesce(old.name, new.desсription) is null then
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'UPDATE canceled: both name and description cannot be null';
	elseif coalesce(new.name, old.desсription) is null then
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'UPDATE canceled: both name and description cannot be null';
	elseif coalesce(old.name, old.desсription) is null then
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'UPDATE canceled: both name and description cannot be null';
	end if;
end//

-- проба триггера на обновление
update products set price = '1000' where id = 11//-- здесь до обновления поля name и description нулевые
update products set name = null where id = 13// -- здесь до обновления пустое поле description
update products set desсription = null where id = 13// -- здесь до обновления пустое поле name
update products set desсription = null, name = null where id = 10//


-- ошибку через процудуру, может, выводить? Для компактности, так сказать
create procedure error_viewer(err_numb int)
begin
	if err_numb = 2 then
		SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'UPDATE canceled: both name and description cannot be null';
	elseif err_numb = 1 then
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'INSERT canceled: both name and description cannot be null';
	end if;
end//

-- снесём триггеры и пересоздадим интереса ради
drop trigger insert_witout_nulls// drop trigger update_witout_nulls//
	
create trigger insert_witout_nulls before insert on products
for each row
begin
	if coalesce(new.name, new.desсription) is null then call error_viewer(1);
	end if;
end//

create trigger update_witout_nulls before update on products
for each row
begin
	if coalesce(new.name, new.desсription) is null then call error_viewer(2);
	elseif coalesce(old.name, new.desсription) is null then call error_viewer(2);
	elseif coalesce(new.name, old.desсription) is null then call error_viewer(2);
	elseif coalesce(old.name, old.desсription) is null then call error_viewer(2);
	end if;
end//

-- проверка триггеров осуществляется по примерам выше на добавление и изменени полей


/*
 * Задание 3.3
 * (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
 * Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
 * Вызов функции FIBONACCI(10) должен возвращать число 55.
 */

create function fibonacci(ind int)
returns int deterministic
begin
	declare i , res1, res2, resm int default 1;
	set res2 = 0;
	while i < ind do
		set resm = res1;
		set res1 = res1 + res2;
		set res2 = resm;
		set i = i + 1;
	end while;
	return res1;
end //
	
select fibonacci(10)//
