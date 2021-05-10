/* ������� 1.
 * ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.*/
use shop;
select * from orders;
-- ��� ������ ���������� ������� �������
insert into orders (user_id)
	select id from users order by rand () limit 4;
-- � ��������� ���������� id
select distinct user_id from orders ;
-- ��������� exist ������� ���������:
select id, name from users
where exists (select * from orders where user_id = users.id);


/* ������� 2.
 * �������� ������ ������� products � �������� catalogs, ������� ������������� ������.
 * */
select * from products; select * from catalogs;

select prod.name as 'Product name', cat.name as 'Product category'
from products as prod
join catalogs as cat
where prod.catalog_id = cat.id
order by rand();

/* ������� 3.
 * (�� �������)
 * ����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label, name).
 * ���� from, to � label �������� ���������� �������� �������, ���� name � �������.
 * �������� ������ ������ flights � �������� ���������� �������.
 * */
use just4test;
create table flights (
	id serial primary key,
	from_IATA varchar (255),
	to_IATA varchar (255)
) comment = '������� ������';
create table cities (
	label varchar (255),
	name  varchar (255)
) comment = '������� �������';
-- �������� ������� ������� �������
insert into cities values
('AFR','����'), ('AZD','����'), ('BFU','�����'), ('BUS','������'),
('BZP','������'), ('DGF','������ ����'), ('DYR','�������'),
('FNH','�����'), ('IGG','��������'), ('IXP','��������'),
('NGI','����'), ('SEU','��������'), ('YAN','�������'),
('WKA','������'), ('BGO','������');

truncate flights;
-- ����� ������� ������
insert into flights (from_IATA, to_IATA)
	select
		(select label from cities order by rand() limit 1),
		(select label from cities order by rand() limit 1)
	from cities limit 10;
-- ��� ������ ������ ���������.. ��� ������
select f.id, c.name 
from flights as f
join cities as c 
where f.from_IATA = c.label;

-- ������� ������� ������� ������ ����������
select f.id, concat (city_from.name, " | " ,f.from_IATA) as '����� �����������', concat(city_to.name, ' | ', f.to_IATA) as '����� ��������'
from flights as f
join cities as city_from on f.from_IATA = city_from.label
join cities as city_to on f.to_IATA = city_to.label;


select * from cities;
select * from flights;
