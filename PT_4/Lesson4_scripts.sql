use vk;
-- перенос имени и фамилии в таблицу profiles
ALTER TABLE profiles
ADD first_name varchar(100) not null comment 'Имя пользователя' after user_id,
add last_name varchar(100) not null comment 'Фамилия пользователя' after first_name;
-- добавление признача прочтения сообщения в таблице messages
alter table messages 
add is_read boolean comment 'Признак прочтения' after is_delivered;
-- замена статуса пользователя справочником
CREATE table user_statuses (
	id int unsigned not null auto_increment primary key comment 'Идентификатор строки',
	name varchar(100) not null comment 'Название статуса',
	created_at datetime default current_timestamp comment 'Время создания строки',  
 	updated_at datetime default current_timestamp on update current_timestamp comment 'Время обновления строки'
) comment 'Справочник статусов пользователя';
-- заполнение таблицы статусов
insert into user_statuses (name)  values ('Single'), ('In a relationship'), ('Engaged'), ('Married'), ('Complicated'), ('Open relationship'), ('Widowed'), ('Sparated'), ('Divorced');
-- изменение типа поля статуса на id статуса
alter table profiles rename column status to user_status_id; -- переименование
update profiles set user_status_id = null; -- сброс значения поля для изменения типа
alter table profiles modify column user_status_id int unsigned; -- непосредственно изменение типа
-- Создание справочника полов
CREATE table gender (
	id int unsigned not null auto_increment primary key comment 'Идентификатор строки',
	gender varchar(100) not null comment 'Название пола',
	gender_info varchar(100) not null comment 'Информация о поле',
	created_at datetime default current_timestamp comment 'Время создания строки',  
 	updated_at datetime default current_timestamp on update current_timestamp comment 'Время обновления строки'
) comment 'Справочник полов';
-- заполнение справочника полов
insert into gender (gender, gender_info) values ('M','Male'), ('F','female');
-- изменение типа поля пола на id пола
alter table profiles rename column gender to gender_id; -- переименование
update profiles set gender_id = null; -- сброс значения поля для изменения типа через задание значения 0, т.к. поле непустое
alter table profiles modify column gender_id int unsigned; -- непосредственно изменение типа, после сброс значения на null
/*
приведение данных в порядок
*/
truncate table friendship_statuses; -- очистка таблицы, изменение именно без отката
truncate table media_types;
-- заполнение таблицы статустов отношений
insert into friendship_statuses (name) values ('Requested'), ('Approved'), ('Declined');
-- заполнениие таблицы типов медиафайлов
insert into media_types (name) values ('Image'),('Video'),('Audio');
-- создание временной таблицы для отчетсв (заполненных случайными данными)
create table patronymic (
	id int unsigned not null auto_increment primary key comment 'Идентификатор строки',
	patronymic varchar(100) not null comment 'Отчество'	
);
-- заполнение временной таблицы сгенерированными случайными данными
INSERT INTO `patronymic` VALUES (1,'Daija'),(2,'Alex'),(3,'Jerald'),(4,'Catalina'),(5,'Aurore'),(6,'Richard'),(7,'Irwin'),(8,'Dominic'),(9,'Verner'),(10,'Nia'),(11,'Nelle'),(12,'Rebeca'),(13,'Andrew'),(14,'Chadrick'),(15,'Mariano'),(16,'Mathew'),(17,'Samara'),(18,'Jake'),(19,'Newton'),(20,'Shany'),(21,'Ronaldo'),(22,'Trey'),(23,'Faye'),(24,'Cole'),(25,'Idell'),(26,'Gwendolyn'),(27,'Althea'),(28,'Alisha'),(29,'Brennon'),(30,'Lamont'),(31,'Madyson'),(32,'Gonzalo'),(33,'Cary'),(34,'Winfield'),(35,'Johnathon'),(36,'Sally'),(37,'Percival'),(38,'Lillian'),(39,'Devyn'),(40,'Eveline'),(41,'Eugenia'),(42,'Adolfo'),(43,'Maurice'),(44,'Jamir'),(45,'Antonette'),(46,'Emilia'),(47,'Ashlee'),(48,'Paula'),(49,'Toy'),(50,'Kellie'),(51,'Jakob'),(52,'Fabiola'),(53,'Laverne'),(54,'Monica'),(55,'Cielo'),(56,'Larue'),(57,'Kurtis'),(58,'Lester'),(59,'Dock'),(60,'Cody'),(61,'Maeve'),(62,'Ricardo'),(63,'Wayne'),(64,'Maritza'),(65,'Ambrose'),(66,'Ryder'),(67,'Howard'),(68,'Dillan'),(69,'Delmer'),(70,'Casimir'),(71,'Katelynn'),(72,'Felix'),(73,'Mikayla'),(74,'Jacynthe'),(75,'Tod'),(76,'Tyree'),(77,'Susie'),(78,'Peyton'),(79,'Alaina'),(80,'Lyda'),(81,'Karson'),(82,'Carlee'),(83,'Samson'),(84,'Santiago'),(85,'Elmira'),(86,'Telly'),(87,'Danielle'),(88,'Lukas'),(89,'Kamron'),(90,'Patience'),(91,'Mikayla'),(92,'Katrine'),(93,'Gilda'),(94,'Nicklaus'),(95,'Darian'),(96,'Jeanie'),(97,'Imelda'),(98,'Kaylin'),(99,'Antoinette'),(100,'Zelma');
-- перенос фамилии и имени из users в profiles
update profiles p
set 
	p.first_name = (select first_name from users u where id = p.user_id),
	p.last_name = (select last_name from users u where id = p.user_id),
	p.patronymic_name = (select patronymic from patronymic where id = p.user_id)
;
drop table patronymic; -- снос временно созданной таблицы после переноса данных из оной
-- заполенение поля gender_id в таблице profiles случайными значениями из справочника
update profiles
set 
	gender_id = (select id from gender order by rand() limit 1)
;
-- удаление статуса c id == 4 для непоследовательности id (выполнено отдельно в представлении таблицы user_statuses)
-- заполенение поля user_status_id в таблице profiles случайными значениями из справочника
update profiles p
set 
	p.user_status_id = (select us.id from user_statuses us order by rand() limit 1)
;
select distinct user_status_id from profiles order by user_status_id;-- запрос уникальных занчений
-- ? отсечение "маленьких" участников под вопросом, заполенение позже
-- заполнение поля media_type_id таблицы media случайными значениями из справочника media_types
update media
set 
	media_type_id = (select id from media_types order by rand() limit 1)
;
-- ? заполенение поля metadata таблицы media остается за рамками
-- При заполнении таблицы через генератор было учтено, что пользователь не должен сам с собой дружить
select * from friendship where user_id = friend_id;-- проверка таблицы fredship, чтоб не было дружбы с самим собой, успешна
-- как можно исправить вариант дружбы с самим собой
update friendship f
set
	friend_id = (select u.id from users u where u.id != f.user_id order by rand() limit 1)
;
-- обновление status_id в таблице friendship случайным значением из справочника
update friendship f
set
	status_id = (select fs.id from friendship_statuses fs order by rand() limit 1)
;
select * from messages where from_user_id = to_user_id; -- и писать самому себе не гоже! Исправляем оное
update messages m
set
	m.to_user_id = (select u.id from users u where u.id != m.from_user_id order by rand() limit 1)
;
-- заполнение поля факта прочтения, значение поля is_red имеет смысл только для отправленных писем (is_delivered)
update messages
set is_read = if (rand() > 0.5, 0, 1 )
where is_delivered  = 1;
/* if (a > b, d, c )
 * условие проверки a > b,
 * если истина - выполняется d
 * если ложь - выполняется c */
-- заполнение photo_id в таблице profile случайными изображениями согласно типу
update profiles p
set p.photo_id = (
	select id from media m 
	where media_type_id = (select id from media_types where name = 'Image')
	and m.user_id = p.user_id
	order by rand() limit 1)
;
select * from profiles where photo_id != '';-- параноидальная проверка, что шалость удалась
update media set user_id = (select us.id from users us order by rand() limit 1);-- немного обновим user_id для медиа
-- удаление пренесеннных полей (имя, фамилия) из таблицы users, вариант удалить через представление
alter table users drop column first_name;
alter table users drop column last_name;

-- просмотр содержимого таблиц (таблицы данных, справочники, таблицы связей, ахивные-исторические таблицы)
select * from friendship_statuses;
select * from media_types;
select * from user_statuses;
select * from users;
select * from profiles;
select * from gender;
select * from media;
select * from friendship;
select * from messages;
select * from communities;
select * from communities_users;
