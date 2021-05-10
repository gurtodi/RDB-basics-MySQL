-- Практическое задание к уроку 10. На БД vk:

/*
 * Задание 1. 
 * Проанализировать, какие запросы могут выполняться наиболее
 * часто в процессе работы приложения, и добавить необходимые индексы.
 */

-- поиск по фамилии и имени пользователя
create index profiles_fn_ln_idx on profiles(first_name, last_name);

-- поиск сообществ
create index communities_name_idx on communities(name);

-- поиск по постам (как по теме, так и по телу)
create fulltext index posts_head_body_idx on posts(head, body);

-- поиск пользователей расширенный
create index profiles_fn_ln_pn_bd_city_idx on profiles(first_name, last_name, patronymic_name, birthday, city);

/*
 * Задание 2. Оконные функции
 * Построить запрос, который будет выводить следующие столбцы:
 *	имя группы
 * 	среднее количество пользователей в группах
 * 	самый молодой пользователь в группе
 * 	самый старший пользователь в группе
 * 	общее количество пользователей в группе
 * 	всего пользователей в системе
 * 	отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
 */

use vk;

-- количество пользователей в группах
select c.name, count(c.id)
from communities_users cu
join communities c on cu.community_id = c.id
group by c.name;

select distinct 
	c.name as 'Name of group',
  	count(cu.user_id) over w_community as 'Count by group'
    from communities_users cu
	join communities c on cu.community_id = c.id
	window w_community as (partition by c.name);

-- среднее количество
select count(cu.user_id) / (select count(*) from communities) as middle
from communities_users cu
join communities c on cu.community_id = c.id;

-- самый молодой пользователь в группе
select concat(p.first_name, ' ', p.last_name) as 'The youngest'
from profiles p
join communities_users cu on cu.user_id = p.user_id
order by p.birthday desc
limit 1;

-- самый старший пользователь в группе
select concat(p.first_name, ' ', p.last_name) as 'The oldest'
from profiles p
join communities_users cu on cu.user_id = p.user_id
order by p.birthday
limit 1;

-- общее количество пользователей в группе
select count(c.id)
from communities_users cu
join communities c on cu.community_id = c.id;

-- всего пользователей в системе
select count(*) from users;

-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
select c.name as 'Community name', concat(floor(count(c.id) / (select count(*) from users) * 100), '%') as 'pct.'
from communities_users cu
join communities c on cu.community_id = c.id
group by c.name;

-- итоговая оконная

select distinct
	c.name as 'Name of group',
	count(cu.user_id) over() / (select count(*) from communities) as 'Average',
	first_value(concat_ws(" ", p.first_name, p.last_name)) over w_birthdays_desc as 'The youngest',
	first_value(concat_ws(" ", p.first_name, p.last_name)) over w_birthdays_asc as 'The oldest',
	count(cu.user_id) over w_community as 'Count by group',
	(select count(*) from users) as 'Total',
	concat(floor(count(cu.user_id) over w_community / (select count(*) from users) * 100), '%') as 'pct.'
    from communities c
	join communities_users cu on cu.community_id = c.id
	join users u on u.id = cu.user_id
	join profiles p on p.user_id = u.id
	window
		w_community as (partition by c.id),
		w_birthdays_desc as (partition by c.id order by p.birthday desc),
		w_birthdays_asc as (partition by c.id order by p.birthday)
;
