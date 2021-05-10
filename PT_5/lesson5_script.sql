create database shop;
use shop;

-- DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

-- DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

-- DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desсription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, desсription, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

-- DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

-- DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

-- DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

-- DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

-- DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

-- заполнение таблицы пользователей
INSERT INTO users(id, name, birthday_at) VALUES 
(1,'Bonita','1987-01-27'),
(2,'Dorcas','1983-09-05'),
(3,'Stanley','2019-12-30'),
(4,'Chaim','2007-07-26'),
(5,'Jace','1982-12-04'),
(6,'Carolina','1977-05-07'),
(7,'Sven','1982-08-30'),
(8,'Damion','1976-07-26'),
(9,'Amy','1991-05-16'),
(10,'Ana','1992-09-26');


/*Практическое задание 
 * по теме 
 * «Операторы, фильтрация, сортировка и ограничение»*/

/*Задание 1. DONE
 * Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
 * Заполните их текущими датой и временем.*/

select * from users; -- смотрим содержимое таблицы users
-- создание незаполненности полей created_at и updated_at путем случайной выборки и удалением выбранного 
-- обнуление значения поля created_at для 3-х случайных строк
update users set created_at = null order by rand() limit 3;
-- аналогичным образом подчищу-ка, пожалуй, поле updated_at
update users set updated_at = null order by rand() limit 4;
-- ищем незаполненные поля посредством безопасного сравнения
select * from users where created_at <=> null or updated_at <=> null;
-- заполняем поочередно created_at и updated_at текущим временем (CURRENT_TIMESTAMP)
update users set created_at = CURRENT_TIMESTAMP() WHERE created_at <=> null;
update users set updated_at = CURRENT_TIMESTAMP() WHERE updated_at <=> null;
-- дамп полученной таблицы в файл lesson5_exercise1_users.sql помещен


/*Задание 2. 
 * Таблица users была неудачно спроектирована. 
 * Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
 * Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.*/

-- для выполнения задания снесём вовсе таблицу users и и спроектируем неудачно с самого начала
drop table users;
show tables; -- параноидальная проверка отсутствия таблицы

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';
--  заполняем случайными данными, дабы оные сохранить при изменении типа
INSERT INTO users VALUES 
(1,'Zackary','2001-05-22','14.11.1996 3:34','07.11.2015 15:18'),
(2,'Domenico','2003-03-26','05.01.2012 2:24','11.03.1970 6:37'),
(3,'Norris','1977-09-05','09.05.2001 0:13','09.12.1992 4:55'),
(4,'Quinton','2019-08-31','16.03.1979 2:08','30.04.2001 20:55'),
(5,'Kory','2011-02-16','30.03.2003 2:43','25.11.2012 1:56'),
(6,'Ellsworth','1994-07-09','06.02.1985 19:06','06.09.1982 5:04'),
(7,'Judah','1998-06-19','21.09.1976 3:02','27.11.1983 3:01'),
(8,'Lisandro','1976-12-29','06.12.2010 3:17','19.12.1973 13:57'),
(9,'Pierce','1992-09-16','18.01.1986 22:10','12.06.2011 14:14'),
(10,'Aaron','1999-05-02','16.10.2020 3:49','11.10.2001 22:13');

select * from users;
desc users;
-- для сохранения данных можно создать 
-- обновляем тип данных для поля created_at
-- вариант переименовать колонку, создать новую и перенести значения в оную через конвертацию строки.
alter table users 
	rename column created_at to created_at_old,
	rename column updated_at to updated_at_old, 
	add created_at datetime after updated_at_old,
	add updated_at datetime after created_at;
update users 
set 
	created_at = str_to_date(created_at_old, '%d.%m.%Y %k:%i'), -- конвертация строки с дату по формату
	updated_at = str_to_date(updated_at_old, '%d.%m.%Y %k:%i');
-- дамп таблицы до удаления колонок %_old в файле lesson5_exercise2_users_alldates.sql
alter table users
	drop column created_at_old, 
	drop column updated_at_old;

/*Задание 3. 
 * В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
 * 0, если товар закончился и выше нуля, если на складе имеются запасы. 
 * Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 * Однако нулевые запасы должны выводиться в конце, после всех записей.*/
-- заполним табличку случайностями
insert into storehouses_products (id, storehouse_id, product_id, value) values
(1,7,1,5),(2,4,6,5),(3,0,4,1),(4,4,8,8),(5,2,2,6),(6,6,0,2),(7,2,5,8),(8,0,9,7),(9,9,5,0),(10,5,5,10),(11,9,7,1),(12,7,4,10),(13,8,3,0),(14,0,3,7),(15,9,2,10),(16,8,0,6),(17,1,3,4),(18,9,1,1),(19,5,2,2),(20,3,6,3),(21,9,5,1),(22,7,6,3),(23,6,3,1),(24,5,7,8),(25,3,7,5),(26,3,0,4),(27,3,5,0),(28,8,1,6),(29,5,9,1),(30,2,6,1),(31,2,5,0),(32,5,7,0),(33,9,0,10),(34,6,0,7),(35,1,8,7),(36,2,6,2),(37,5,5,3),(38,1,9,9),(39,2,7,6),(40,9,7,4),(41,7,7,8),(42,2,1,8);
select * from storehouses_products where value = 0;
-- CASE WHEN условие THEN true_значение ELSE false_значение END
-- то есть нулевые явно помещаем в конец списка, остальные сортируем по значению.
-- И ещё этим образом можно сортировать по разным столбцам! Крутая штука
select * from storehouses_products
order by case value
	when 0 then 100
	else value
	end;

/*Задание 4.
 * (по желанию)
 * Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
 * Месяцы заданы в виде списка английских названий (may, august)*/
-- а где то список имеется? Если это отдельная строка при вводе..


-- если на входе, то можно просто по сути преобразовать строку [[may]]//,[[:]]
select * from users where date_format(birthday_at, '%M') rlike 'may|august';

/*Задание 5.
 * (по желанию)
 * Из таблицы catalogs извлекаются записи при помощи запроса 
 * SELECT * FROM catalogs WHERE id IN (5, 1, 2);
 * Отсортируйте записи в порядке, заданном в списке IN.*/
insert into catalogs values (1,'aliquam'),(2,'quo'),(3,'explicabo'),(4,'eum'),(5,'rerum'),(6,'non'),(7,'commodi'),(8,'vel'),(9,'harum'),(10,'cupiditate'),(11,'quam'),(12,'voluptatem'),(13,'earum'),(14,'quis'),(15,'animi'),(16,'neque'),(17,'sapiente'),(18,'amet'),(19,'qui'),(20,'praesentium');

select * from catalogs where id in (5, 1, 2);
-- вариантов вывода, кроме как в "тупую" по условию задания позиции вывода, не смоглось обнаружится
select * from catalogs
where id in (5, 1, 2)
order by case id 
  when 5 then 1
  when 1 then 2
  when 2 then 3
end;

/*Практическое задание
 * по теме
 * «Агрегация данных»*/

/*Задание 1.
 * Подсчитайте средний возраст пользователей в таблице users.*/

select * from users;
-- просмотр возрастов пользователей
select name, floor((TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25) AS age FROM users; 
select name, TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS age from users; 

/* Функция AVG()
 * вычисляет среднее значение столбца путем 
 * суммирования всех значений записей столбца и деления на количество записей.*/

SELECT floor(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS age FROM users; -- итог округленный

/*Задание 2.
 * Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/
 
/* получение дня недели
DAYOFWEEK() - номер недели, отсчёт от ВС
DAYNAME() - именование дня недели*/

select 
	count(*) as total,
	DAYNAME(birthday_at) as day_of_birthday
	from users group by day_of_birthday order by total; -- для недели дня рождения в год рождения
	
-- для дня недели в текущем году, надо проделать то же самое, только прибавить к каждой дате рождения разницу в годах
select -- вот и для текущего года
	name,	
	birthday_at,
	DAYNAME(birthday_at) as day_n,
	DATE_ADD(birthday_at, interval (select TIMESTAMPDIFF(year, birthday_at, '2021-12-31')) year) as days,
	DAYNAME(DATE_ADD(birthday_at, interval (select TIMESTAMPDIFF(year, birthday_at, '2021-12-31')) year)) as day_n
	from users;
-- усложним-ка интересными значениями
insert into users (id, name, birthday_at) values
	(11,'60thDayOfYear','2000-02-29'),
	(12,'FirstDayOfYear','1991-01-01'),
	(13,'60thDayOfYear','1987-12-31');
-- и получается, что человек, рожденный 29 февраля празднует 28-го (что соответтсвует действительности по опросам).

-- и выводим день недели в текущем году
-- вот оно - решение!
select 
	count(*) as total,
	DAYNAME(DATE_ADD(birthday_at, interval (select TIMESTAMPDIFF(year, birthday_at, '2021-12-31')) year)) as day_of_birthday
	from users group by day_of_birthday order by total;

/*Задание 3.
 * (по желанию)
 * Подсчитайте произведение чисел в столбце таблицы.*/

-- сделаем-ка, пожалуй, эту таблицу

CREATE table multiply (value INT);
insert into multiply values (1), (2), (3), (4), (5);
select * from multiply;
-- занятно, ведь дейтсвительно сумма логарифмов есть логарифм суммы, вопрос погорешности есть, но не для данного примера
-- log() - вычисление логарифма, sum() - сумма, exp() - значение экспоненты
select EXP(SUM(LOG(value))) from multiply;

