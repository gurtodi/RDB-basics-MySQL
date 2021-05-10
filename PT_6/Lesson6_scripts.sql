use vk;
-- создание таблицы лайков
create table likes (
	id int unsigned not null auto_increment primary key comment 'Идентификатор строки',
	user_id int unsigned not null comment 'Идентификатор пользователя',
	target_id int unsigned not null comment 'Идентификатор объекта',
	target_type_id int unsigned not null comment 'Идентификатор типа объекта',
	like_type tinyint unsigned not null comment 'Идентификатор типа лайка (1 - лайк, 0 - дизлайк)',
	created_at datetime default current_timestamp comment 'Время создания строки',  
	updated_at datetime default current_timestamp on update current_timestamp comment 'Время обновления строки'
) comment 'Реакции (лайк/дизлайк)';

-- справочник типов объектов реакций (к чему относится реакция)
create table target_types (
  id int unsigned not null auto_increment primary key comment 'Идентификатор строки',
  name varchar(255) not null unique comment 'Название типа',
  created_at datetime default current_timestamp comment 'Время создания строки',  
  updated_at datetime default current_timestamp on update current_timestamp comment 'Время обновления строки'
) COMMENT "Типы объектов лайков";
-- заполнение справочника типов объектов реакций
insert into target_types (name) values
	('messages'),
	('users'),
	('media'),
	('posts');
-- создание таблицы постов

create table posts (
  id int unsigned not null auto_increment primary key comment 'Идентификатор строки',
  user_id int unsigned not null comment 'Идентификатор пользователя - автора поста',
  community_id int unsigned comment 'Идентификатор сообщества в коем написан пост',
  head varchar(255) comment 'Заголовок поста',
  body text not null comment 'Содержимое поста',
  is_public boolean default true comment 'Признак приватности',
  is_archived boolean default false comment 'Признак архивации',
  created_at datetime default current_timestamp comment 'Время создания строки',  
  updated_at datetime default current_timestamp on update current_timestamp comment 'Время обновления строки'
);
-- заполнение таблицы постов
insert into posts (user_id, head, body)
	select user_id, substring(body, 1, locate(' ', body) - 1), body FROM ( -- первое слово locate по пробелу из строки substring
	select
		(select id from users order by rand() limit 1) as user_id,
		(select body from messages order by rand() limit 1) as body
	FROM messages
	) p;
-- ?? а как же заполнение идентификатора сообщества
-- !
-- !
-- !
-- !
-- Заполенние таблицы реакций по типам
-- реакции на сообщения
insert into likes (user_id, target_id, target_type_id, like_type) 
	select
		(select id from users order by rand() limit 1),
		(select id from messages order by rand() limit 1),
		(select id from target_types where name = 'messages'),
		if(rand() > 0.5, 0, 1) -- случайный 1 иль 0
	from messages limit 20;
-- реакции на пользователей
insert into likes (user_id, target_id, target_type_id, like_type) 
	select
		(select id from users order by rand() limit 1),
		(select id from users order by rand() limit 1),
		(select id from target_types where name = 'users'),
		if(rand() > 0.5, 0, 1)
	from users limit 20;
-- реакции на медиафайлы
insert into likes (user_id, target_id, target_type_id, like_type) 
	select
		(select id from users order by rand() limit 1),
		(select id from media order by rand() limit 1),
		(select id from target_types where name = 'media'),
		if(rand() > 0.5, 0, 1)
	from media limit 20;
-- реации на посты
insert into likes (user_id, target_id, target_type_id, like_type) 
	select
		(select id from users order by rand() limit 1),
		(select id from posts order by rand() limit 1),
		(select id from target_types where name = 'posts'),
		if(rand() > 0.5, 0, 1)
	from messages limit 20;

/* Внешние ключи FOREIGN KEY. Общий синтаксис 
 * [CONSTRAINT имя_ограничения]
 * FOREIGN KEY (столбец1, столбец2, ... столбецN) 
 * REFERENCES главная_таблица (столбец_главной_таблицы1, столбец_главной_таблицы2, ... столбец_главной_таблицыN)
 * [ON DELETE действие]
 * [ON UPDATE действие]
 */
desc profiles; -- просмотр структуры таблицы можно и через представление
-- добавление внешних ключей таблицы profiles для полей user_id, gender_id, photo_id, user_status_id
alter table profiles
	add constraint profiles_fk_user_id -- имя по принципу от и до с указанием внешн ключа (правило хорошего тона..)
		foreign key (user_id) references users(id) on delete cascade, -- при удалении из табл. users запись удалится и в таблице profiles
	add constraint profiles_fk_gender_id
		foreign key (gender_id) references gender(id) on delete set null, -- при удалении из табл. gender поле обнулится в таблице profiles
	add constraint profiles_fk_photo_id
		foreign key (photo_id) references media(id) on delete set null,
	add constraint profiles_fk_user_status_id
		foreign key (user_status_id) references user_statuses(id); -- ошибка удаления user_statuses, если будет ссылаться хоть одна запись из таблицы profiles
-- добавление внешних ключей таблицы communities_users для полей community_id, user_id
alter table communities_users
	add constraint comm_users_fk_comm_id
		foreign key (community_id) references communities(id),
	add constraint comm_users_fk_user_id
		foreign key (user_id) references users(id);
-- добавление внешних ключей таблицы profiles для полей from_user_id, to_user_id
alter table messages
	add constraint message_from_fk_user_id
		foreign key (from_user_id) references users(id),
	add constraint message_to_fk_user_id
		foreign key (to_user_id) references users(id);
-- добавление внешних ключей таблицы friendship для полей user_id, friend_id, status_id
alter table friendship 
	add constraint user_id_fk_user_id
		foreign key (user_id) references users(id),
	add constraint friend_id_fk_user_id
		foreign key (friend_id) references users(id),
	add constraint status_fk_statuses_id
		foreign key (status_id) references friendship_statuses(id);
-- добавление внешних ключей таблицы media для полей user_id, media_type_id
alter table media
	add constraint media_user_fk_user_id
		foreign key (user_id) references users(id),
	add constraint media_fk_media_types
		foreign key (media_type_id) references media_types(id);
-- добавление внешних ключей таблицы posts для полей user_id, community_id
alter table posts 
	add constraint posts_fk_user_id 
		foreign key (user_id) references users(id),
	add constraint posts_fk_community_id
		foreign key (community_id) references communities(id);
-- добавление внешних ключей таблицы likes для полей user_id, target_id, target_type_id
alter table likes 
	add constraint likes_fk_user_id
		foreign key (user_id) references users(id);
alter table likes	
	add constraint likes_fk_target_type
		foreign key (target_type_id) references target_types(id);
/*alter table likes
	add constraint likes_fk_message
		foreign key (target_id) references messages(id), users(id), posts(id), media(id);
!!! когда не удалось побороть связи множественные.. но раберусь.. наверное
*/
alter table likes drop foreign key likes_fk_message; -- удаление связи	
	
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
select * from likes;
select * from target_types;
select * from posts;
