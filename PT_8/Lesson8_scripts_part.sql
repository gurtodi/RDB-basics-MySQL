use vk;
-- удаление излишка связей, ибо необязательно жестко привязывать комментарий к сообществу
alter table posts drop foreign key posts_fk_community_id;

/* Задание 1.
 * Переписать запросы, заданные к ПЗ урока 6 (п.3,4,5), с использованием JOIN*/


/* Задание 1.3
 * Определить кто больше поставил лайков (всего) - мужчины или женщины?*/
-- исходный запрос:
select (
  select (select gender_info from gender where id = profiles.gender_id)
  from profiles where user_id = likes.user_id
) as gender,
count(*) as total
from likes
group by gender
order by total DESC
limit 1
;

-- количество лайков по гендеру
select p.gender_id, count(*)
from likes l
join profiles p on l.user_id = p.user_id 
group by p.gender_id;
-- сортированный максимум
select p.gender_id, count(*) as sum
from likes l
join profiles p on l.user_id = p.user_id
group by p.gender_id order by p.gender_id
limit 1;
-- подключенный справочник полов для вывода навазния (поле gender_info)
select g.gender_info as 'Gender', count(*) as 'Likes count'
from likes l
join profiles p on l.user_id = p.user_id 
join gender g on p.gender_id = g.id
group by p.gender_id order by p.gender_id
limit 1;

/* Задание 1.4
 * Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.*/
-- исходный запрос
select SUM(likes_total) from (
  select (select COUNT(*) from likes where target_id = profiles.user_id and target_type_id = 2) 
    as likes_total
  from profiles
  order by birthday 
  DESC limit 10
) as user_likes;  


-- общее количество по каждому из молодых пользователей
-- но нулевые не считаем, чорт
select p.user_id, p.first_name, p.birthday, count(*) as sum
from likes l
join profiles p on l.target_type_id = 2
where l.target_id = p.user_id
group by p.user_id order by p.birthday desc
limit 10;

-- лаадно считерствуем
select p.user_id, p.first_name, p.birthday, 
(select COUNT(*) from likes l where l.target_id = p.user_id and l.target_type_id = 2) as likes_total
from likes l join profiles p
where l.target_type_id = 2
-- join profiles p on l.target_id = p.user_id
group by p.user_id order by p.birthday desc
limit 10;


-- но нет..


/* Задание 1.5
 * Найти 10 пользователей, которые проявляют наименьшую активность
 * критерий лайки, медиаконтент и сообщения*/

-- в использовании социальной сети
select 
ConCAT(first_name, ' ', last_name) as user, 
(select COUNT(*) from likes where likes.user_id = profiles.user_id) +
(select COUNT(*) from media where media.user_id = profiles.user_id) +
(select COUNT(*) from messages where messages.from_user_id = profiles.user_id) as overall_activity 
from profiles
order by overall_activity
limit 10;

select
	p.user_id, count (*)
from profiles p
join likes l on l.user_id = p.user_id
join media m on m.user_id = p.user_id
group by p.user_id
;



/* (По желанию) 
 * Доработать запрос "Список медиафайлов пользователя с количеством лайков",
 * чтобы он выводил количество лайков и дизлайков
 */ 
select id,
 (select first_name from profiles where user_id = users.id) as FirstName,
 (select last_name from profiles where user_id = users.id) as LastName,
 (select city from profiles where user_id = users.id) as City,
 (select filename from media where id=
   (select photo_id from profiles where user_id = users.id)
 ) as Photo
from users where id = 10;
