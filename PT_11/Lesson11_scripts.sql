/*
 * 1. Практическое задание по теме 
 * "Оптимизация запросов"
 */

/*
 * Задание 1.1
 * Создайте таблицу logs типа Archive.
 * Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается 
 * время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
 */

use shop;

create table logs (
    id int unsigned not null auto_increment primary key,
    table_name varchar(100),
    field_id int unsigned,
    field_name varchar(255),
    created_at datetime default current_timestamp
) engine = archive;

-- delimiter // --через настроечки

create trigger new_users after insert on users -- триггер на добавление записи в логи при добалении записи в таблицу пользователей
for each row
begin
	insert into logs (table_name, field_id, field_name) values ('users', new.id, new.name);
end //
insert into users (name) values ('Rachel')// -- проверонька

create trigger new_catalogs after insert on catalogs -- триггер на добавление записи в логи при добалении записи в таблицу каталога
for each row
begin
	insert into logs (table_name, field_id, field_name) values ('catalogs', new.id, new.name);
end //
insert into catalogs (name) values ('Блоки питания')// -- проверонька

create trigger new_products after insert on products -- триггер на добавление записи в логи при добалении записи в таблицу продуктов
for each row
begin
	insert into logs (table_name, field_id, field_name) values ('products', new.id, new.name);
end //
insert into products (name) values ('DNP-650 600W')// -- проверонька
