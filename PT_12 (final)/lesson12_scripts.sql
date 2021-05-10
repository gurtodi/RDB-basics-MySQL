create database portal;
use portal;

/*
 * Табличек
 * создание
 */

-- таблица сотрудника, основная информация
create table employers (
	user_id int unsigned not null auto_increment primary key comment 'Сотрудника идентификатор',
	firstname varchar(150) not null comment 'Имя сотрудника', 
	lastname varchar(150) not null comment 'Фамилия сотрудника',
	middlename varchar(150) not null comment 'Отчество сотрудника',
	gender tinyint unsigned not null comment 'Пол: 1 = м, 0 = ж', 
	birthday date not null comment 'Дата рождения',
	work_started date not null comment 'Дата начала работы',
	email varchar(100) not null unique comment 'Почтовый адрес корпоративный',
	avatar varchar(255) comment 'Аватар пользователя, ссылка на файл',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'	
) comment 'Профиль сотрудника';

-- контанты
create table additional_contacts (
	user_id int unsigned not null comment 'Сотрудника идентификатор',
	client_type_id int unsigned not null comment 'Идентификатор клиента связи',
	login varchar(150) not null comment 'Логин пользователя',
	primary key (useri_id, client_type_id) comment 'Составной ключ',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'	
) comment 'Дополнительные способов связи';

-- таблица положения сотрудника в структуре компании
create table employee_position (
	user_id int unsigned not null primary key comment 'Сотрудника идентификатор',
	position_id int unsigned not null comment 'Должность сотрудника',
	team_id int unsigned comment 'Отдел',
	department_id int unsigned comment 'Департамент',
	chief_id int unsigned comment 'Руководитель сотрудника',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'	
) comment 'Положение сотрудника';

-- таблица текущего статуса сотрудника (отпуска, больничные и пр)
create table employee_status (
	id int unsigned not null auto_increment primary key comment 'Идентификатор строки',	
	user_id int unsigned not null comment 'Сотрудника идентификатор',
	status_id int unsigned not null comment 'Идентификатор статуса',
	date_start datetime not null comment 'Начало действия статуса',
	date_end datetime not null comment 'Окончание действия статуса',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'	
) comment 'ТCтатус сотрудника (отпуска, больничные и пр)';

-- таблица проектов
create table projects (
	id int unsigned not null auto_increment primary key comment 'Идентификатор проекта',
	name varchar(255) not null unique comment 'Название проекта',
	description text comment 'Описание проекта',
	status_id int unsigned not null comment 'Ссылка на статус',
	start_date date comment 'Дата начала проекта',
	finish_date date comment 'Дата завершения проекта',
	results text comment 'Результаты проекта',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'
) comment 'Проекты';

-- таблица продуктов
create table products (
	id int unsigned not null auto_increment primary key comment 'Идентификатор продукта',
	name varchar(255) not null unique comment 'Название продукта',
	description text comment 'Описание продукта',
	owner_id int unsigned not null comment 'Ссылка крайнего за продукт',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'
) comment 'Продукты';

-- таблица команды проекта
create table project_team (
	project_id int unsigned not null comment 'Ссылка на проект',
	user_id int unsigned not null comment 'Ссылка на сотрудника',
	role_id int unsigned not null comment 'Ссылка на роль',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки',
	primary key (project_id, user_id, role_id) comment 'Составной ключ'
) comment 'Команда проекта';

-- таблица продуктов, задействованных в проектах
create table projects_products (
	project_id int unsigned not null comment 'Ссылка на проект',
	product_id int unsigned not null comment 'Ссылка на задейтсвованный продукт',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки',
	primary key (project_id, product_id) comment 'Составной ключ проекта и продукта'
) comment 'Продукты, задействованные в проекте';

-- таблица иерархии продуктов
create table product_hierarchy (
	parent_product_id int unsigned not null comment 'Ссылка на родительский продукт',
	children_product_id int unsigned not null comment 'Ссылка на дочерний продукт',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки',
	primary key (parent_product_id, children_product_id) comment 'Составной ключ дочернего и родитеского продкутов'
) comment 'Иерархия продуктов'; 

-- таблица-справочник должностей
create table positions (
	id int unsigned not null auto_increment primary key comment 'Идентификатор должности',
	name varchar(255) not null unique comment 'Именование должности',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'
) comment 'Справочник должностей';

-- таблица-справочник ролей
create table roles (
	id int unsigned not null auto_increment primary key comment 'Идентификатор роли',
	name varchar(255) not null unique comment 'Именование роли',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'
) comment 'Справочник проектных ролей';

-- таблица структурной иерархии (отдел к департаменту)
create table teams (
	id int unsigned not null auto_increment primary key comment 'Идентификатор отдела',
	name varchar(255) not null comment 'Именование отдела',
	lead_id int unsigned not null comment 'Тимлид отдела',
	department_id int unsigned not null comment 'Ссылка на департамент',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'
) comment 'Таблица отделов (комнад) по департаментам';

-- таблица-справочник департаментов
create table departments (
	id int unsigned not null auto_increment primary key comment 'Идентификатор департамента',
	name varchar(255) not null unique comment 'Именование департамента',
	director_id int unsigned not null comment 'Дирктор департамента',	
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'
) comment 'Справочник детартаментов';

-- тбалица-справочник статусов проектов
create table project_statuses (
	id int unsigned not null auto_increment primary key comment 'Идентификатор статуса',
	name varchar(255) not null unique comment 'Именование роли',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'
) comment 'Справочник проектных статусов';

-- таблица-спавочник мессенджеров и прочих клинетов для связи
create table communication_clients (
	id int unsigned not null auto_increment primary key comment 'Идентификатор статуса',
	name varchar(255) not null unique comment 'Именование клинета',	
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'	
) comment 'Справочник способов связи';

-- тбалица-справочник статуса сотрудника (отгул, отпуск, командировка, обучение, больничный, декретный и т.д.)
create table user_statuses (
	id int unsigned not null auto_increment primary key comment 'Идентификатор статуса',
	name varchar(255) not null unique comment 'Именование статуса',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'	
) comment 'Справочник статусов';

-- доп. таблица новостей
create table news (
	id int unsigned not null auto_increment primary key comment 'Идентификатор новости',
	title varchar(255) not null comment 'Заголовок новости',
	body text comment 'Содержание новости',
	-- tag_id int unsigned comment 'Список тегов',
	category_id int unsigned not null comment 'Категория новости',
	user_id int unsigned comment 'Автор новости',
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'	
) comment 'Новости';

-- доп. таблица-справочник категорий новостей
create table categories (
	id int unsigned not null auto_increment primary key comment 'Идентификатор категории',
	name varchar(255) not null unique comment 'Именование категории',	
	created_at datetime default current_timestamp comment 'Дата создания строки',
	updated_at datetime default current_timestamp on update current_timestamp comment 'Дата обновления строки'	
) comment 'Справочник новостных категорий';

/*
 * Внешних
 * ключей
 * создание
 */

-- внешний ключ таблицы product_hierarchy дляя поля родительского и дочернего проекта
alter table product_hierarchy
	add constraint prod_parent_fk_prod_id
		foreign key (parent_product_id) references products(id) on delete cascade,
	add constraint prod_child_fk_prod_id
		foreign key (children_product_id) references products(id) on delete cascade;

-- внешний ключ таблицы departments для поля директорского
alter table departments
	add constraint depatm_fk_user
		foreign key (director_id) references employers(user_id);
	
-- внешний ключ таблицы additional_contacts для полей useri_id, client_type_id
alter table additional_contacts
	add constraint contact_fk_user
		foreign key (user_id) references employers(user_id) on delete cascade,
	add constraint contact_fk_clyent_type
		foreign key (client_type_id) references communication_clients(id) on delete cascade;

-- внешний ключ таблицы employee_status для полей user_id, status_id
alter table employee_status 
	add constraint empl_status_fk_user
		foreign key (user_id) references employers(user_id) on delete cascade,
	add constraint empl_status_fk_status_id
		foreign key (status_id) references user_statuses(id) on delete cascade;	

-- внешний ключ таблицы projects_products для полей project_id, product_id
alter table projects_products
	add constraint proj_prod_fk_proj_id
		foreign key (project_id) references projects(id) on delete cascade,
	add constraint proj_prod_fk_prod_id
		foreign key (product_id) references products(id) on delete cascade;
	
-- внешний ключ таблицы products для поля owner_id
alter table products
	add constraint products_fk_user
		foreign key (owner_id) references employers(user_id);
	
-- внешний ключ таблицы employee_position для полей user_id, position_id, team_id, departament_id, chief_id
alter table employee_position
	add constraint empl_position_fk_user
		foreign key (user_id) references employers(user_id) on delete cascade,
	add constraint empl_position_fk_posit_id
		foreign key (position_id) references positions(id),
	add constraint empl_position_fk_team_id
		foreign key (team_id) references teams(id),
	add constraint empl_position_fk_depatm_id
		foreign key (department_id) references departments(id),
	add constraint empl_position_fk_chief
		foreign key (chief_id) references employers(user_id);
	
-- внешний ключ таблицы projects для поля status_id
alter table projects
	add constraint projects_fk_status_id
		foreign key (status_id) references project_statuses(id);
	
-- внешний ключ таблицы news для полей category_id, user_id
alter table news
	add constraint news_fk_category_id
		foreign key (category_id) references categories(id),
	add constraint news_fk_user
		foreign key (user_id) references employers(user_id);
	
-- внешний клююч таблицы teams для полей lead_id, departament_id
alter table teams
	add constraint teams_fk_lead
		foreign key (lead_id) references employers(user_id),
	add constraint teams_fk_depatm_id
		foreign key (department_id) references departments(id);
	
-- внешний ключ таблицы project_team для полей project_id, user_id, role_id
alter table project_team
	add constraint proj_team_fk_proj_id
		foreign key (project_id) references projects(id) on delete cascade,
	add constraint proj_team_fk_user
		foreign key (user_id) references employers(user_id),
	add constraint proj_team_fk_
		foreign key (role_id) references roles(id);	

/*
 * Заполенеие
 * таблиц
 * данными
 */

-- статусов наименования
insert into user_statuses (name) values 
('Vacation'), ('Sick leave'), ('Day off'), ('Maternity leave'), ('Donor day'), ('Business trip'), ('Training');

-- категории новостей
insert into categories (name) values
('HR'), ('LifeQuality'), ('World'), ('Public'), ('IT-News'), ('Projects & Products'), ('Sell&Buy');

-- способы связи
insert into communication_clients (name) values
('Phone'), ('Telegram'), ('Slack'), ('Skype'), ('Rocket Chat');

-- роли в проекте
insert into roles (name) values ('Project manager'), ('Curator for software development'), 
('Curator for analytics'), ('Curator for software testing'), ('Curator for product'), 
('Curator for software certification'), ('Curator for development and testing');

-- должности
insert into positions (name) values 
('Junior QA Engineer'), ('QA Engineer'), ('Senior QA engineer'), ('Lead QA engineer'), 
('Technical writer'), ('Senior technical writer'), 
('Junior developer'), ('Senior developer'), ('Lead developer'), 
('Architect'), 
('Junior designer'), ('Designer'), ('Senior designer'), 
('Analyst'), ('System analyst'), ('Senior analyst'), 
('Product owner'),
('Support engineer'), ('Operations engineer'), ('Integration engineer'), ('Installation engineer'),
('Junior project manager'), ('Project manager'), ('Senior project manager'), 
('Network engineer'),
('Junior system administrator'), ('System administrator'), ('Senior system administrator'), 
('Deputy Director'), ('Director'), ('Executive director');

-- статусы проектов
insert into project_statuses (name) values
('Planned'), ('Opened'), ('In progress'), ('Finished'), ('Closed'), ('Cancelled'), ('Postponed');

-- основные данные отрудников, рандомные значения
insert into employers(user_id, firstname, lastname, middlename, gender, birthday, work_started, email, avatar) values 
(1,'Coby','Kohler','Carmel',0,'1970-01-01','1974-06-15','fgreen@example.org','http://lorempixel.com/500/500/'),(2,'Delbert','Bauch','Joanne',0,'1970-01-01','1977-01-14','fisher.ally@example.net','http://lorempixel.com/500/500/'),(3,'Verona','Yost','Gayle',1,'1970-01-01','2020-12-18','xschmitt@example.net','http://lorempixel.com/500/500/'),(4,'Ima','Considine','Nannie',1,'1970-01-01','1984-01-04','althea.stroman@example.net','http://lorempixel.com/500/500/'),(5,'Rubie','Lind','Gay',1,'1970-01-01','1983-10-12','welch.elwin@example.org','http://lorempixel.com/500/500/'),(6,'Clinton','Johnson','Lorna',1,'1970-01-01','2014-12-04','yesenia22@example.org','http://lorempixel.com/500/500/'),(7,'Max','Runte','Jettie',0,'1970-01-01','1997-02-10','koss.vita@example.com','http://lorempixel.com/500/500/'),(8,'Rhea','Flatley','Newton',1,'1970-01-01','1982-06-20','shanna00@example.net','http://lorempixel.com/500/500/'),(9,'Dannie','Considine','Stephania',1,'1970-01-01','1992-11-12','sigurd.renner@example.org','http://lorempixel.com/500/500/'),(10,'Neoma','Weimann','Velda',1,'1970-01-01','2002-10-17','zieme.claud@example.org','http://lorempixel.com/500/500/'),(11,'Marlene','Jerde','Adolph',0,'1970-01-01','1978-04-09','oosinski@example.org','http://lorempixel.com/500/500/'),(12,'Constantin','Rodriguez','Mabelle',0,'1970-01-01','2009-06-17','beahan.dena@example.com','http://lorempixel.com/500/500/'),(13,'Jamel','Boehm','Devante',1,'1970-01-01','2020-07-27','bulah.balistreri@example.com','http://lorempixel.com/500/500/'),(14,'Rosella','Jacobi','Clement',0,'1970-01-01','1976-10-23','stoltenberg.wyman@example.org','http://lorempixel.com/500/500/'),(15,'Ludie','Kris','Fabian',0,'1970-01-01','1988-09-28','afritsch@example.com','http://lorempixel.com/500/500/'),(16,'Marta','Barrows','Jackson',1,'1970-01-01','1998-02-06','tmitchell@example.org','http://lorempixel.com/500/500/'),(17,'Sabrina','Schulist','Oliver',0,'1970-01-01','2004-09-23','amie.cummerata@example.org','http://lorempixel.com/500/500/'),(18,'Halle','Schulist','Neal',0,'1970-01-01','2021-01-07','aglae28@example.com','http://lorempixel.com/500/500/'),(19,'Conrad','Stoltenberg','Haskell',1,'1970-01-01','1971-06-26','louvenia32@example.net','http://lorempixel.com/500/500/'),(20,'Darrin','Bogan','Ilene',1,'1970-01-01','2014-12-07','thiel.aniyah@example.com','http://lorempixel.com/500/500/'),(21,'Chester','Kling','Sasha',1,'1970-01-01','2017-03-01','bschmidt@example.org','http://lorempixel.com/500/500/'),(22,'Donato','Blanda','Tatum',0,'1970-01-01','2019-11-12','trey11@example.com','http://lorempixel.com/500/500/'),(23,'Vince','O\'Conner','Sonny',1,'1970-01-01','1984-11-16','cleve43@example.org','http://lorempixel.com/500/500/'),(24,'Beryl','Koch','Fannie',0,'1970-01-01','1991-07-25','raul60@example.net','http://lorempixel.com/500/500/'),(25,'Lon','Mills','Mason',0,'1970-01-01','1991-04-07','idella21@example.com','http://lorempixel.com/500/500/'),(26,'Patrick','Runolfsdottir','Derick',1,'1970-01-01','1993-11-17','ariane.wiegand@example.com','http://lorempixel.com/500/500/'),(27,'Fae','Mertz','Cornell',0,'1970-01-01','1993-12-19','fnitzsche@example.com','http://lorempixel.com/500/500/'),(28,'Amina','Cole','Dejuan',1,'1970-01-01','2013-05-02','corwin.katlyn@example.org','http://lorempixel.com/500/500/'),(29,'Friedrich','Bogan','Kaya',0,'1970-01-01','1972-07-06','beer.jermain@example.com','http://lorempixel.com/500/500/'),(30,'Dalton','Armstrong','Sister',1,'1970-01-01','1977-06-30','creinger@example.org','http://lorempixel.com/500/500/'),(31,'Cory','Stark','Abelardo',1,'1970-01-01','1972-05-25','sarah.ledner@example.net','http://lorempixel.com/500/500/'),(32,'Brady','Osinski','Kitty',0,'1970-01-01','1982-06-26','watson63@example.com','http://lorempixel.com/500/500/'),(33,'Fiona','Prohaska','Braulio',1,'1970-01-01','1997-03-26','cbergstrom@example.net','http://lorempixel.com/500/500/'),(34,'Fidel','Schulist','Krystel',0,'1970-01-01','1981-12-10','bkreiger@example.org','http://lorempixel.com/500/500/'),(35,'Sebastian','Ward','Hilario',1,'1970-01-01','1981-10-15','mkling@example.net','http://lorempixel.com/500/500/'),(36,'Asa','Pollich','Derick',0,'1970-01-01','2014-08-30','kpredovic@example.com','http://lorempixel.com/500/500/'),(37,'Alan','Mohr','Brando',1,'1970-01-01','1981-06-28','dorothea88@example.org','http://lorempixel.com/500/500/'),(38,'Natasha','Gottlieb','Tiffany',0,'1970-01-01','1977-09-02','loy.tillman@example.com','http://lorempixel.com/500/500/'),(39,'Christop','Swift','Camron',0,'1970-01-01','1986-10-12','ottis89@example.org','http://lorempixel.com/500/500/'),(40,'Tabitha','Haag','Cierra',1,'1970-01-01','1999-03-22','kristy81@example.org','http://lorempixel.com/500/500/'),(41,'Marcelo','Runolfsdottir','Will',0,'1970-01-01','2002-04-18','srath@example.net','http://lorempixel.com/500/500/'),(42,'Candida','Frami','Queenie',1,'1970-01-01','1976-06-24','bernard16@example.net','http://lorempixel.com/500/500/'),(43,'Jesus','Mosciski','Abbey',1,'1970-01-01','1986-10-09','eriberto60@example.net','http://lorempixel.com/500/500/'),(44,'Thea','Bayer','Jaycee',1,'1970-01-01','2020-11-12','osinski.otho@example.com','http://lorempixel.com/500/500/'),(45,'Deontae','Wunsch','Elouise',1,'1970-01-01','2017-05-05','leuschke.blaise@example.net','http://lorempixel.com/500/500/'),(46,'Tia','Wyman','Marvin',1,'1970-01-01','1974-07-21','windler.ludie@example.net','http://lorempixel.com/500/500/'),(47,'Ahmad','Lueilwitz','Rollin',1,'1970-01-01','2000-12-27','xruecker@example.org','http://lorempixel.com/500/500/'),(48,'Ibrahim','Welch','Janice',1,'1970-01-01','2011-01-14','wolff.maryse@example.org','http://lorempixel.com/500/500/'),(49,'Frederik','Kuhic','Wayne',0,'1970-01-01','2012-02-15','rstracke@example.com','http://lorempixel.com/500/500/'),(50,'Madge','Simonis','Ines',0,'1970-01-01','1975-04-23','judah53@example.com','http://lorempixel.com/500/500/'),(51,'Autumn','Schuppe','Jessica',1,'1970-01-01','1972-09-02','omiller@example.net','http://lorempixel.com/500/500/'),(52,'Aliza','Quitzon','Noemi',1,'1970-01-01','2002-09-14','linda.yundt@example.net','http://lorempixel.com/500/500/'),(53,'Shanie','Blick','Kamron',0,'1970-01-01','2008-07-15','seffertz@example.org','http://lorempixel.com/500/500/'),(54,'Fleta','Gibson','Heath',1,'1970-01-01','1970-05-05','mueller.linwood@example.com','http://lorempixel.com/500/500/'),(55,'Terrell','Kling','Stanley',0,'1970-01-01','1975-10-19','mona58@example.com','http://lorempixel.com/500/500/'),(56,'Oma','Stark','Eleazar',0,'1970-01-01','1979-02-12','donnie36@example.org','http://lorempixel.com/500/500/'),(57,'Carey','Roberts','Scotty',0,'1970-01-01','1992-11-26','lottie.kuvalis@example.com','http://lorempixel.com/500/500/'),(58,'Krista','Weimann','Llewellyn',1,'1970-01-01','2009-07-20','tromaguera@example.org','http://lorempixel.com/500/500/'),(59,'Kasey','Bode','Christy',0,'1970-01-01','2020-10-18','gerald98@example.org','http://lorempixel.com/500/500/'),(60,'Cecile','Kub','Camilla',0,'1970-01-01','1970-06-02','hollie91@example.org','http://lorempixel.com/500/500/'),(61,'Arianna','Davis','Kasey',0,'1970-01-01','2003-03-02','durgan.abbey@example.net','http://lorempixel.com/500/500/'),(62,'Rosalinda','Renner','Providenci',0,'1970-01-01','1983-01-29','mohr.brody@example.net','http://lorempixel.com/500/500/'),(63,'Laverna','Ortiz','Clemmie',1,'1970-01-01','2009-09-16','vweimann@example.com','http://lorempixel.com/500/500/'),(64,'Keanu','Marquardt','Theo',1,'1970-01-01','2016-04-23','hansen.samir@example.net','http://lorempixel.com/500/500/'),(65,'Easton','Rempel','Eladio',1,'1970-01-01','1995-03-28','nhermann@example.org','http://lorempixel.com/500/500/'),(66,'Katherine','Rempel','Ardith',1,'1970-01-01','2012-12-22','mdicki@example.com','http://lorempixel.com/500/500/'),(67,'Jaren','Huels','Willy',1,'1970-01-01','1995-09-12','conroy.janie@example.org','http://lorempixel.com/500/500/'),(68,'Leonor','Yundt','Nolan',0,'1970-01-01','1984-08-18','frida16@example.org','http://lorempixel.com/500/500/'),(69,'Fritz','Corkery','Silas',1,'1970-01-01','1983-11-15','fanderson@example.com','http://lorempixel.com/500/500/'),(70,'Dominic','Prosacco','Reece',1,'1970-01-01','1990-11-30','ssauer@example.com','http://lorempixel.com/500/500/'),(71,'Scotty','Bernier','Shawna',1,'1970-01-01','2011-04-16','jakubowski.brendon@example.com','http://lorempixel.com/500/500/'),(72,'Isai','Trantow','Jessica',0,'1970-01-01','1978-09-08','daugherty.gayle@example.com','http://lorempixel.com/500/500/'),(73,'Estefania','Pacocha','Gage',1,'1970-01-01','2021-02-01','oberbrunner.lilliana@example.com','http://lorempixel.com/500/500/'),(74,'Jeanette','Becker','Lori',1,'1970-01-01','1981-03-14','austen.langworth@example.com','http://lorempixel.com/500/500/'),(75,'Major','Frami','Efren',0,'1970-01-01','2013-07-25','nicolette22@example.com','http://lorempixel.com/500/500/'),(76,'Kendall','Feil','Alf',1,'1970-01-01','2018-01-03','murphy.kaylin@example.com','http://lorempixel.com/500/500/'),(77,'Wayne','O\'Keefe','Peyton',1,'1970-01-01','2004-06-07','libbie89@example.net','http://lorempixel.com/500/500/'),(78,'Maximo','Hansen','Carter',0,'1970-01-01','1987-01-12','kub.roy@example.com','http://lorempixel.com/500/500/'),(79,'Loma','Conn','Joanne',0,'1970-01-01','1996-05-15','vcrona@example.net','http://lorempixel.com/500/500/'),(80,'Lue','Yost','Desmond',0,'1970-01-01','1986-02-17','mayert.amir@example.org','http://lorempixel.com/500/500/'),(81,'Fredrick','Flatley','Kayla',1,'1970-01-01','1992-12-28','ihartmann@example.org','http://lorempixel.com/500/500/'),(82,'Margret','Hilpert','Katherine',1,'1970-01-01','2001-04-14','noemy94@example.org','http://lorempixel.com/500/500/'),(83,'Cristian','Kemmer','Eugene',0,'1970-01-01','1995-12-11','camilla74@example.com','http://lorempixel.com/500/500/'),(84,'Ryder','Erdman','Joannie',0,'1970-01-01','2016-09-20','deangelo.mayer@example.org','http://lorempixel.com/500/500/'),(85,'Jackie','Daniel','Trinity',0,'1970-01-01','2011-04-19','hermiston.mike@example.org','http://lorempixel.com/500/500/'),(86,'Moriah','Hettinger','Gina',1,'1970-01-01','1995-07-21','eudora46@example.com','http://lorempixel.com/500/500/'),(87,'Kaitlyn','Gulgowski','Hans',0,'1970-01-01','2014-07-26','bradley79@example.net','http://lorempixel.com/500/500/'),(88,'Bryce','Langosh','Abigail',0,'1970-01-01','2014-04-30','bbogan@example.com','http://lorempixel.com/500/500/'),(89,'Dale','Beatty','Liliane',1,'1970-01-01','2019-05-03','jluettgen@example.com','http://lorempixel.com/500/500/'),(90,'Keith','Simonis','Willie',1,'1970-01-01','2012-04-29','hfeil@example.com','http://lorempixel.com/500/500/'),(91,'Anais','Kris','Sheila',0,'1970-01-01','1996-03-20','kamille.ortiz@example.com','http://lorempixel.com/500/500/'),(92,'Merle','Kovacek','Colt',1,'1970-01-01','1984-08-20','torphy.jude@example.net','http://lorempixel.com/500/500/'),(93,'Claudine','Pfannerstill','Rick',0,'1970-01-01','2017-05-04','mireille.lang@example.org','http://lorempixel.com/500/500/'),(94,'Rupert','Yundt','Keshaun',1,'1970-01-01','2012-06-26','vreynolds@example.net','http://lorempixel.com/500/500/'),(95,'Naomie','Ward','Myron',1,'1970-01-01','2015-03-28','mbergnaum@example.com','http://lorempixel.com/500/500/'),(96,'Mateo','Rau','Betsy',0,'1970-01-01','1985-05-29','lilliana.lueilwitz@example.com','http://lorempixel.com/500/500/'),(97,'Elza','O\'Kon','Corbin',1,'1970-01-01','1985-04-01','gutmann.amos@example.org','http://lorempixel.com/500/500/'),(98,'Nova','Kreiger','Addie',0,'1970-01-01','1975-06-05','zboncak.janae@example.net','http://lorempixel.com/500/500/'),(99,'Diego','Cruickshank','Barrett',1,'1970-01-01','1994-11-16','emanuel78@example.net','http://lorempixel.com/500/500/'),(100,'Jarrell','Kuhic','Leopold',0,'1970-01-01','1997-04-18','marguerite83@example.net','http://lorempixel.com/500/500/'),(101,'Jacquelyn','Marquardt','Kailey',1,'1970-01-01','1994-10-17','schneider.dessie@example.net','http://lorempixel.com/500/500/'),(102,'Stella','Rodriguez','Elise',0,'1970-01-01','1990-06-27','ystanton@example.com','http://lorempixel.com/500/500/'),(103,'Holly','Schimmel','Heather',1,'1970-01-01','2018-06-26','bernard.botsford@example.org','http://lorempixel.com/500/500/'),(104,'Cordia','Terry','Braden',1,'1970-01-01','1987-11-19','alison.bayer@example.org','http://lorempixel.com/500/500/'),(105,'Alta','Williamson','Mikayla',0,'1970-01-01','1984-08-04','lenna.ruecker@example.net','http://lorempixel.com/500/500/'),(106,'Greg','Marks','Ryder',0,'1970-01-01','2018-12-19','dooley.rolando@example.org','http://lorempixel.com/500/500/'),(107,'Elisabeth','Lemke','Arvilla',1,'1970-01-01','2004-04-27','brittany02@example.net','http://lorempixel.com/500/500/'),(108,'Demetrius','Altenwerth','Alejandra',0,'1970-01-01','2016-01-01','javier.gutmann@example.net','http://lorempixel.com/500/500/'),(109,'Brigitte','McDermott','Ashlynn',1,'1970-01-01','2007-04-11','conn.yvette@example.net','http://lorempixel.com/500/500/'),(110,'Tiara','Harvey','Nikita',0,'1970-01-01','1979-10-30','fschuster@example.net','http://lorempixel.com/500/500/'),(111,'Ciara','Doyle','Reuben',0,'1970-01-01','1985-07-28','andreane41@example.com','http://lorempixel.com/500/500/'),(112,'Brenden','Ziemann','Adolph',0,'1970-01-01','1980-09-02','kshlerin.fletcher@example.net','http://lorempixel.com/500/500/'),(113,'Whitney','Luettgen','Maggie',0,'1970-01-01','1989-09-25','alia.abernathy@example.net','http://lorempixel.com/500/500/'),(114,'Parker','Gusikowski','Ferne',0,'1970-01-01','2019-02-20','brooke.kihn@example.com','http://lorempixel.com/500/500/'),(115,'Cassandra','Muller','Thalia',1,'1970-01-01','1983-02-24','lbartell@example.com','http://lorempixel.com/500/500/'),(116,'Donald','Kuhic','Kristofer',0,'1970-01-01','1997-10-12','peyton.grant@example.net','http://lorempixel.com/500/500/'),(117,'Freddie','Heller','Jett',1,'1970-01-01','1988-09-14','brooklyn86@example.net','http://lorempixel.com/500/500/'),(118,'Foster','Weissnat','Ollie',0,'1970-01-01','2017-08-20','kelvin.lueilwitz@example.net','http://lorempixel.com/500/500/'),(119,'Dennis','Moen','Fatima',0,'1970-01-01','2004-12-14','mariam62@example.com','http://lorempixel.com/500/500/'),(120,'Nash','Schmeler','Tatum',1,'1970-01-01','2004-05-04','neva54@example.net','http://lorempixel.com/500/500/'),(121,'Addie','Hauck','Elza',0,'1970-01-01','1979-12-10','lrutherford@example.net','http://lorempixel.com/500/500/'),(122,'Domenica','Bruen','Dave',0,'1970-01-01','2007-08-07','efeeney@example.com','http://lorempixel.com/500/500/'),(123,'Wilber','Kihn','Rossie',1,'1970-01-01','1989-12-12','adelbert12@example.com','http://lorempixel.com/500/500/'),(124,'Jaylen','Keeling','Jalyn',0,'1970-01-01','1979-03-24','emilia.mosciski@example.org','http://lorempixel.com/500/500/'),(125,'Ayla','Price','Reid',1,'1970-01-01','1989-10-18','walton39@example.net','http://lorempixel.com/500/500/'),(126,'Alta','O\'Connell','Murl',0,'1970-01-01','2019-07-27','leila.nader@example.com','http://lorempixel.com/500/500/'),(127,'Clare','Metz','Hallie',0,'1970-01-01','2000-05-16','fschneider@example.org','http://lorempixel.com/500/500/'),(128,'Icie','Champlin','Dakota',0,'1970-01-01','1987-03-29','mswift@example.org','http://lorempixel.com/500/500/'),(129,'Santino','Wisoky','Adrian',1,'1970-01-01','2019-07-11','lila.donnelly@example.net','http://lorempixel.com/500/500/'),(130,'Joanne','Hayes','Isaac',0,'1970-01-01','1979-04-22','arolfson@example.net','http://lorempixel.com/500/500/'),(131,'Amos','Brown','Mariane',0,'1970-01-01','1983-11-05','carter.nelle@example.com','http://lorempixel.com/500/500/'),(132,'Leola','Hackett','Avery',1,'1970-01-01','1989-04-11','verda71@example.org','http://lorempixel.com/500/500/'),(133,'Wilmer','McGlynn','Myrtice',1,'1970-01-01','1996-08-20','herman.ernser@example.net','http://lorempixel.com/500/500/'),(134,'Gianni','Graham','Michele',1,'1970-01-01','2012-09-25','quigley.dashawn@example.org','http://lorempixel.com/500/500/'),(135,'Shaun','McClure','Kevon',0,'1970-01-01','1993-02-12','reynolds.garfield@example.org','http://lorempixel.com/500/500/'),(136,'Tomasa','Rosenbaum','Catalina',0,'1970-01-01','2008-08-26','upton.lizeth@example.org','http://lorempixel.com/500/500/'),(137,'Johnnie','Hermiston','Ari',1,'1970-01-01','1970-09-25','spinka.berta@example.net','http://lorempixel.com/500/500/'),(138,'Amaya','Kris','Domingo',0,'1970-01-01','2013-12-15','marlin.witting@example.net','http://lorempixel.com/500/500/'),(139,'Gloria','Reilly','Maxwell',1,'1970-01-01','1973-08-21','tromp.eloisa@example.com','http://lorempixel.com/500/500/'),(140,'Vada','Gusikowski','Chelsie',1,'1970-01-01','1983-11-19','ruecker.walter@example.net','http://lorempixel.com/500/500/'),(141,'Newton','Lebsack','Palma',1,'1970-01-01','2011-04-04','pauer@example.com','http://lorempixel.com/500/500/'),(142,'Ibrahim','Reynolds','Amiya',0,'1970-01-01','1999-12-06','audrey.tillman@example.org','http://lorempixel.com/500/500/'),(143,'Sonya','Bayer','Leland',0,'1970-01-01','1980-12-11','nina34@example.net','http://lorempixel.com/500/500/'),(144,'Wendell','Rau','Rolando',0,'1970-01-01','2012-09-18','walsh.chandler@example.org','http://lorempixel.com/500/500/'),(145,'Elias','Yundt','Jettie',1,'1970-01-01','1988-08-19','orlando.bode@example.org','http://lorempixel.com/500/500/'),(146,'Unique','Kshlerin','Tyra',1,'1970-01-01','1981-06-25','calista25@example.org','http://lorempixel.com/500/500/'),(147,'Jamir','Olson','Van',0,'1970-01-01','1992-02-28','fiona22@example.net','http://lorempixel.com/500/500/'),(148,'Marietta','Crona','Landen',1,'1970-01-01','1991-08-31','khalid.stiedemann@example.net','http://lorempixel.com/500/500/'),(149,'Dameon','Kiehn','Keara',1,'1970-01-01','2008-03-11','delores21@example.net','http://lorempixel.com/500/500/'),(150,'Cristobal','Tillman','Tressie',0,'1970-01-01','1992-06-28','helmer46@example.net','http://lorempixel.com/500/500/'),(151,'Keyon','Bode','Mitchell',0,'1970-01-01','1982-02-10','tbradtke@example.net','http://lorempixel.com/500/500/'),(152,'Rashad','Gislason','Meggie',1,'1970-01-01','1973-05-15','marcos42@example.org','http://lorempixel.com/500/500/'),(153,'Dusty','Frami','Bernard',0,'1970-01-01','1994-02-10','guy.thompson@example.org','http://lorempixel.com/500/500/'),(154,'Gaylord','Runte','Melyssa',0,'1970-01-01','2019-01-07','hildegard.bartoletti@example.com','http://lorempixel.com/500/500/'),(155,'Deven','Koelpin','Paolo',1,'1970-01-01','1973-06-28','mitchell.lonny@example.com','http://lorempixel.com/500/500/'),(156,'Herta','Emard','Erick',0,'1970-01-01','2013-07-17','general19@example.com','http://lorempixel.com/500/500/'),(157,'Mina','Bartoletti','Lisandro',1,'1970-01-01','2001-09-11','imcdermott@example.org','http://lorempixel.com/500/500/'),(158,'Cecilia','Willms','Murl',1,'1970-01-01','2018-07-28','eichmann.kennedi@example.com','http://lorempixel.com/500/500/'),(159,'Cleve','Labadie','Kariane',1,'1970-01-01','1984-05-30','ward.brielle@example.org','http://lorempixel.com/500/500/'),(160,'Marian','Olson','Rene',0,'1970-01-01','1997-05-08','rhoda.prosacco@example.com','http://lorempixel.com/500/500/'),(161,'Lukas','Glover','Ali',0,'1970-01-01','1999-05-08','eledner@example.org','http://lorempixel.com/500/500/'),(162,'Aisha','Kovacek','Gregorio',0,'1970-01-01','2008-04-16','kshlerin.kelsi@example.net','http://lorempixel.com/500/500/'),(163,'Devon','Franecki','Maybelle',0,'1970-01-01','1979-12-11','libbie.torphy@example.com','http://lorempixel.com/500/500/'),(164,'Taya','Nicolas','Beth',1,'1970-01-01','2004-05-14','xgreenholt@example.net','http://lorempixel.com/500/500/'),(165,'Gordon','Cartwright','Ignatius',1,'1970-01-01','2019-03-28','windler.richmond@example.org','http://lorempixel.com/500/500/'),(166,'Florian','Shields','George',1,'1970-01-01','2014-02-22','gabernathy@example.org','http://lorempixel.com/500/500/'),(167,'Simone','Thompson','Pearline',0,'1970-01-01','1973-11-12','hipolito.ondricka@example.net','http://lorempixel.com/500/500/'),(168,'Bartholome','Kris','Ena',1,'1970-01-01','2013-04-22','xdach@example.com','http://lorempixel.com/500/500/'),(169,'Stewart','Hackett','Annabel',1,'1970-01-01','1990-06-09','wkozey@example.com','http://lorempixel.com/500/500/'),(170,'Viva','Wintheiser','Celine',0,'1970-01-01','1985-12-27','arlene.boyer@example.net','http://lorempixel.com/500/500/'),(171,'Marianna','Bartell','Tyrique',1,'1970-01-01','1992-04-04','jskiles@example.com','http://lorempixel.com/500/500/'),(172,'Evans','King','Jamir',0,'1970-01-01','2011-11-02','jerrold45@example.org','http://lorempixel.com/500/500/'),(173,'Deonte','Gaylord','Marion',1,'1970-01-01','2002-05-29','dayana71@example.net','http://lorempixel.com/500/500/'),(174,'Elinor','Conroy','Germaine',0,'1970-01-01','1970-07-25','tyra58@example.org','http://lorempixel.com/500/500/'),(175,'Dorris','Walker','Kirsten',0,'1970-01-01','1987-03-09','winston.hills@example.org','http://lorempixel.com/500/500/'),(176,'Carmela','Volkman','Elva',1,'1970-01-01','1975-07-17','hazel.fay@example.org','http://lorempixel.com/500/500/'),(177,'Guadalupe','Roberts','Rosalee',0,'1970-01-01','2002-04-14','zachary.buckridge@example.net','http://lorempixel.com/500/500/'),(178,'Dennis','Fritsch','Barrett',1,'1970-01-01','1999-06-19','nmoen@example.com','http://lorempixel.com/500/500/'),(179,'Wellington','Lehner','Autumn',0,'1970-01-01','1980-04-13','zsmith@example.com','http://lorempixel.com/500/500/'),(180,'Gideon','Berge','Christelle',0,'1970-01-01','1979-10-06','lindsay.altenwerth@example.org','http://lorempixel.com/500/500/'),(181,'Kacie','Marvin','Ocie',1,'1970-01-01','2012-05-08','cordelia74@example.net','http://lorempixel.com/500/500/'),(182,'Unique','Schuppe','Helena',0,'1970-01-01','1998-07-22','lupe.leannon@example.com','http://lorempixel.com/500/500/'),(183,'Esperanza','Krajcik','Annalise',1,'1970-01-01','2008-11-10','daphnee92@example.net','http://lorempixel.com/500/500/'),(184,'Aglae','Rodriguez','Mathias',1,'1970-01-01','1989-03-30','kiehn.eudora@example.org','http://lorempixel.com/500/500/'),(185,'Benton','Goyette','Damian',1,'1970-01-01','1973-08-04','anabelle99@example.com','http://lorempixel.com/500/500/'),(186,'Giovanna','Corkery','Emmet',0,'1970-01-01','1987-10-07','ilesch@example.net','http://lorempixel.com/500/500/'),(187,'Alexane','Friesen','Velda',1,'1970-01-01','1992-11-18','fhayes@example.org','http://lorempixel.com/500/500/'),(188,'Marisol','Moen','Noelia',0,'1970-01-01','2017-02-10','evangeline72@example.com','http://lorempixel.com/500/500/'),(189,'Amalia','Wiegand','Johnathan',1,'1970-01-01','1999-06-13','carole70@example.org','http://lorempixel.com/500/500/'),(190,'Maye','Jast','Fay',1,'1970-01-01','1975-12-07','esta19@example.com','http://lorempixel.com/500/500/'),(191,'Chanel','Klein','Bradly',1,'1970-01-01','1982-08-05','mathilde.marvin@example.com','http://lorempixel.com/500/500/'),(192,'Hazel','Bartell','Meaghan',0,'1970-01-01','1990-02-26','lue51@example.org','http://lorempixel.com/500/500/'),(193,'Tamia','Kshlerin','Eddie',1,'1970-01-01','1979-10-19','nlindgren@example.org','http://lorempixel.com/500/500/'),(194,'Godfrey','Heathcote','Fanny',1,'1970-01-01','2002-06-29','bcartwright@example.com','http://lorempixel.com/500/500/'),(195,'Sydni','Orn','Sigmund',0,'1970-01-01','1993-02-01','chadd57@example.com','http://lorempixel.com/500/500/'),(196,'Otis','Mann','Bernadette',1,'1970-01-01','1984-07-31','feil.angus@example.org','http://lorempixel.com/500/500/'),(197,'Winfield','Walker','Dejon',0,'1970-01-01','1998-09-01','orunolfsson@example.net','http://lorempixel.com/500/500/'),(198,'Myrtle','Gleason','Quinton',1,'1970-01-01','1992-02-25','schuppe.kraig@example.com','http://lorempixel.com/500/500/'),(199,'Kenyatta','Spinka','Mariana',1,'1970-01-01','1986-03-14','fnader@example.net','http://lorempixel.com/500/500/'),(200,'Anahi','Schuster','Rosamond',0,'1970-01-01','1970-08-07','rosina.hodkiewicz@example.net','http://lorempixel.com/500/500/');

-- "причесывание" таблицы сотрудников
update employers
set
	email = (select concat(lower(firstname), '.',lower(lastname), '@company.com')),
	birthday = (select date_add(now(), INTERVAL - rand() * 999999999 - 18 * 365.25 * 24 * 3600 SECOND)), -- возраст больше 18-ти
	work_started = ( select ( -- задание праведной даты трудоустройства (дата трудоуствройста должна коррелировать с датой основания ('1991-03-15') и датой рождения)
		case 
		-- здесь устанавливаем дату между основанием и сейчас
			when birthday < '1991-03-15'
			then (select FROM_UNIXTIME(RAND( ) * ( UNIX_TIMESTAMP('1991-03-15') - UNIX_TIMESTAMP(now()) ) + UNIX_TIMESTAMP(now())))
		-- здесь устанавливаем дату между рождением и сейчас
			else (select FROM_UNIXTIME(RAND( ) * ( UNIX_TIMESTAMP(birthday) - UNIX_TIMESTAMP(now()) ) + UNIX_TIMESTAMP(now())))
		end)),
	avatar = (select concat('http://company.com/avatars/', lower(firstname), '.', lower(lastname),'.png'));

-- заполнение таблицы employee_status случайными значениями с заданным диапазоном
insert into employee_status (user_id, status_id, date_start, date_end) values (85,6,'1982-07-29 01:06:27','2002-07-18 17:54:09'),(168,4,'2000-01-16 23:23:54','1985-10-09 13:43:15'),(182,4,'1996-08-09 19:27:57','1974-06-25 15:14:16'),(169,4,'1979-02-08 17:28:59','2004-07-28 08:12:49'),(149,2,'1993-04-23 04:36:40','1988-11-19 08:54:56'),(198,5,'1974-09-13 06:50:52','1977-06-23 08:28:32'),(36,2,'2017-05-13 22:40:33','2004-03-09 09:00:31'),(1,3,'1995-10-20 19:12:47','1993-11-10 15:30:24'),(182,1,'2009-08-10 15:29:10','2005-11-20 20:06:32'),(133,1,'2003-11-29 20:52:05','2001-03-31 14:05:19'),(87,4,'1985-10-11 03:53:34','1992-08-13 17:52:27'),(42,2,'1986-10-08 16:52:58','2020-04-01 23:24:55'),(182,3,'1973-11-03 16:41:12','2000-05-24 10:54:58'),(148,2,'1977-11-24 02:49:01','1971-05-19 05:17:12'),(160,1,'1994-11-01 08:32:46','2000-01-03 10:46:51'),(70,7,'2015-09-01 03:18:16','1987-05-22 05:06:37'),(184,7,'1983-07-25 06:30:31','1982-09-14 13:48:38'),(21,1,'2010-10-20 00:27:41','2002-11-18 22:56:12'),(38,1,'1991-01-26 08:04:28','1995-03-28 12:15:12'),(67,1,'1980-02-04 00:12:52','2002-05-30 12:53:52'),(131,2,'2012-09-16 14:11:33','1974-11-05 01:56:24'),(42,7,'1979-09-20 21:50:41','1987-06-23 23:06:20'),(100,3,'1973-10-07 09:56:56','2015-01-01 12:19:57'),(193,5,'2021-02-05 13:10:15','2009-11-28 16:00:16'),(174,6,'2010-02-17 22:50:03','1997-07-05 22:26:20'),(58,4,'2018-02-13 16:24:19','2005-11-06 00:15:57'),(33,7,'1974-08-27 05:57:17','1984-06-17 14:51:14'),(108,6,'1989-03-08 08:13:44','2004-11-16 12:00:25'),(80,1,'1975-07-05 20:05:36','2007-04-01 01:33:58'),(22,3,'1973-10-04 20:01:34','1975-06-01 23:17:05'),(156,5,'2015-02-08 08:19:32','1999-12-08 20:44:13'),(127,1,'1975-08-24 15:36:08','1977-06-25 15:57:36'),(145,2,'2003-09-16 05:24:56','1974-02-02 08:31:03'),(2,6,'1994-08-15 02:02:05','2006-09-03 02:54:46'),(8,2,'1984-08-24 07:59:12','2021-03-29 15:33:52'),(39,4,'1987-05-09 03:36:15','1985-04-20 22:17:41'),(185,7,'2015-02-06 14:05:33','1971-10-11 21:05:18'),(195,4,'1977-03-11 00:23:27','1984-10-09 20:17:36'),(124,4,'1980-10-14 12:11:35','1973-05-13 16:12:42'),(124,5,'1976-10-12 21:12:22','2004-05-21 13:56:23'),(20,3,'2008-03-30 11:30:13','1978-03-13 21:23:18'),(82,6,'2010-07-10 11:45:19','2014-10-12 09:40:34'),(87,4,'1994-09-23 11:13:03','1983-08-02 02:12:44'),(172,2,'1976-09-05 18:57:12','2015-07-21 06:47:07'),(174,3,'2010-07-10 12:53:42','2012-03-30 02:13:36'),(104,4,'1983-10-05 10:36:35','1989-11-20 04:06:10'),(57,1,'2003-08-11 20:09:27','1996-08-04 10:17:30'),(125,2,'1991-08-19 21:44:53','1998-03-04 14:52:09'),(143,2,'2017-11-17 20:36:24','1978-09-08 10:03:02'),(186,2,'1971-04-11 15:28:50','2008-05-23 02:30:55'),(126,5,'1978-11-06 19:28:49','2011-04-19 18:05:02'),(141,7,'2019-01-23 13:41:49','2020-04-09 16:11:00'),(64,1,'2021-02-08 03:29:47','2001-03-18 20:17:05'),(116,1,'1972-01-08 09:51:36','1992-03-14 02:53:44'),(15,6,'1997-06-04 11:47:50','2007-01-23 04:00:19'),(67,2,'1972-03-30 00:52:33','2015-12-26 03:17:01'),(127,4,'2014-03-28 06:07:07','2017-05-05 18:41:16'),(13,2,'2018-06-22 04:51:43','2001-08-03 17:07:50'),(99,2,'1980-07-12 11:11:35','1973-02-06 14:44:47'),(39,4,'1981-04-15 10:11:02','1977-05-31 01:33:35'),(162,2,'2015-12-18 01:05:38','2004-08-15 23:03:24'),(26,5,'1981-06-14 12:18:07','1985-09-05 02:37:15'),(74,6,'1981-06-22 08:44:18','1983-09-12 04:53:33'),(23,7,'2008-08-11 11:00:50','1997-05-25 08:46:11'),(97,5,'1988-03-10 04:14:13','1977-04-15 22:03:28');
-- "причесывание" данных по статусу (хотя б последовательности старта и начала соответсвующие)
update employee_status set employee_status.date_start = (select FROM_UNIXTIME(RAND( ) * ( UNIX_TIMESTAMP(employers.work_started) - UNIX_TIMESTAMP(date_add(date_start, interval 1 year)) ) + UNIX_TIMESTAMP(date_add(date_start, interval 1 year))) from employers where employers.user_id = employee_status.user_id);
update employee_status set date_end = (select FROM_UNIXTIME(RAND( ) * ( UNIX_TIMESTAMP(date_start) - UNIX_TIMESTAMP(date_add(date_start, INTERVAL 30 DAY)) ) + UNIX_TIMESTAMP(date_add(date_start, INTERVAL 30 DAY))));


-- заполение проектов таблицы случайными значениями
insert into projects (name, description, status_id, start_date, finish_date, results) values ('Bartell','Adaptive national firmware',5,'1976-01-13','2000-07-02','Ut placeat aspernatur sunt.'),('Bashirian','Sharable methodical alliance',2,'2011-12-06','1984-04-08','Eum magni perferendis beatae vel fugiat.'),('Beahan','Universal intangible groupware',1,'1978-04-03','1972-03-20','Animi enim rem veniam quis nulla ex eos.'),('Bernhard','Facetoface multi-tasking hub',3,'1998-07-18','1970-08-16','Et quam sint qui quas aut.'),('Blick','Synergistic executive firmware',5,'1982-03-20','1995-01-25','Ea ut temporibus omnis rerum placeat voluptatibus.'),('Boyer','Digitized fault-tolerant GraphicalUserInterface',4,'1983-10-12','2008-09-13','Nam earum eum minus ullam.'),('Carter','Centralized mission-critical utilisation',3,'1970-06-30','1989-01-09','Et temporibus sequi molestias sunt.'),('Cartwright','Integrated exuding encoding',7,'2010-11-02','1986-10-22','Numquam quod vel minima enim impedit quos.'),('Cormier','Polarised human-resource framework',5,'2004-01-29','2006-11-27','Voluptatem placeat et nemo.'),('Crist','Monitored actuating standardization',7,'1980-12-21','1984-07-02','Autem debitis vel optio modi est ut.'),('Cronin','Up-sized needs-based paradigm',5,'2015-03-23','1998-10-21','Voluptatum laboriosam dolores veritatis eos est dolorum ea fuga.'),('Crooks','Implemented full-range attitude',7,'2008-10-02','2016-06-16','Enim dolorem quae deserunt eum consectetur nostrum.'),('Denesik','Realigned directional capability',1,'2011-03-31','1972-12-20','Ea unde impedit incidunt doloremque non ex.'),('Erdman','Programmable discrete contingency',4,'1997-08-24','1976-03-06','Laboriosam tempora cupiditate quidem ab.'),('Farrell','Grass-roots maximized localareanetwork',1,'1980-05-23','1995-05-20','Placeat et veritatis pariatur eligendi officia quibusdam reiciendis non.'),('Feil','Realigned local superstructure',2,'2010-07-10','1996-07-04','Ut molestias voluptates quia laudantium.'),('Funk','Object-based nextgeneration productivity',2,'2018-04-08','1985-08-14','Placeat reprehenderit dolorem provident veniam.'),('Goyette','Multi-lateral object-oriented hardware',5,'2011-08-15','1987-05-31','Ratione aut quia consequatur voluptatem recusandae.'),('Green','Reactive impactful framework',1,'1985-08-15','1997-04-11','Id ea necessitatibus sed nihil voluptatibus fugiat.'),('Grimes','Profound explicit website',2,'1996-04-15','1987-11-20','Velit omnis labore soluta aut voluptatem doloremque modi necessitatibus.'),('Gutkowski','Exclusive bandwidth-monitored analyzer',4,'2016-10-31','2011-03-24','Voluptatem et natus libero assumenda omnis et dolores.'),('Hand','Digitized scalable project',4,'1976-11-27','2004-01-27','Earum voluptatem qui excepturi.'),('Harvey','Synergized 4thgeneration time-frame',2,'1995-07-24','1971-03-25','Vel est quibusdam voluptatibus est suscipit.'),('Hayes','Future-proofed global pricingstructure',4,'1993-04-30','2009-10-13','Occaecati alias pariatur autem veniam autem nihil.'),('Hettinger','Customer-focused systematic archive',1,'1996-10-09','1988-08-21','Tempora rerum veritatis dicta doloremque quasi aperiam error.'),('Hirthe','Right-sized bi-directional capability',5,'1991-04-13','2008-10-07','Commodi voluptates sint ducimus quisquam molestias error.'),('Homenick','Decentralized motivating instructionset',1,'1998-11-18','1978-09-02','Est perspiciatis quis impedit quasi minus aliquid ut voluptate.'),('Howe','Realigned homogeneous instructionset',4,'2002-10-31','1976-09-05','Sit numquam exercitationem fugiat atque consequatur.'),('Jacobson','Progressive cohesive solution',4,'1982-01-25','1972-02-14','Occaecati saepe laboriosam enim quo numquam voluptates eum.'),('Keebler','Right-sized disintermediate protocol',6,'2014-10-17','1990-03-29','Nesciunt quos veritatis est.'),('Keeling','Organized analyzing moderator',5,'2006-08-01','1997-05-01','Aut necessitatibus et porro enim optio.'),('Kerluke','Team-oriented analyzing installation',7,'2005-10-30','2020-08-11','Deleniti eos vero pariatur aspernatur non quaerat voluptatem occaecati.'),('Kertzmann','Balanced fault-tolerant database',4,'1977-12-27','1987-08-07','Quia ut est sit neque architecto mollitia.'),('Kirlin','Persevering 4thgeneration collaboration',4,'1992-09-10','1984-08-10','Nesciunt dolor suscipit consequuntur.'),('Kreiger','Implemented empowering complexity',6,'1999-01-28','1979-03-17','Doloremque illo dolor fugit vitae aperiam ipsam ut architecto.'),('Kub','Focused human-resource time-frame',3,'1981-11-04','1974-02-25','Dolor beatae dignissimos qui repellendus qui quo repellat.'),('Kuhic','Versatile nextgeneration parallelism',1,'1978-06-23','1972-03-25','Ut dolorum qui illo beatae corporis aspernatur numquam.'),('Kutch','Realigned regional function',2,'1988-03-06','1997-04-14','Incidunt doloribus ut et iusto qui est.'),('Little','Innovative full-range methodology',6,'1993-11-30','1982-10-01','Natus eos nobis perferendis aut soluta excepturi.'),('Lockman','Optimized executive leverage',5,'1986-01-22','1975-07-18','Ut omnis aut reiciendis et enim doloribus facilis.'),('Maggio','Multi-lateral national policy',6,'2011-11-06','2002-06-13','Est quidem rerum ab consequatur unde consequatur.'),('Marquardt','Future-proofed fault-tolerant approach',7,'1998-07-29','1975-08-15','Amet officia adipisci omnis maiores aspernatur est.'),('Marvin','Progressive solution-oriented opensystem',5,'1984-09-07','2000-10-10','Laudantium minima enim id earum incidunt.'),('Mayert','Balanced 24/7 utilisation',6,'1999-02-01','1972-01-30','Officiis repellendus vel cum qui.'),('McClure','Synchronised solution-oriented leverage',1,'1989-12-05','2002-07-02','Deserunt beatae nulla voluptas nobis exercitationem voluptatem.'),('Medhurst','Diverse national toolset',5,'2002-01-08','2003-11-10','Ut eaque fuga omnis qui.'),('Morar','Managed object-oriented hardware',1,'1990-07-13','1972-07-09','Fugiat quia ducimus aspernatur quia.'),('Mraz','Multi-channelled optimizing workforce',4,'1991-04-14','1977-09-26','Reiciendis praesentium est dolor rerum explicabo.'),('Mueller','Universal impactful functionalities',5,'2017-01-16','1983-08-20','Eos rerum nulla adipisci distinctio odit et voluptatem.'),('O\'Kon','Quality-focused multimedia capability',4,'2005-04-11','2011-12-06','Ipsum animi id adipisci qui voluptatem.'),('Okuneva','Phased upward-trending matrices',1,'1992-02-09','2005-12-30','Voluptatem consequatur rerum beatae ipsum est molestias sapiente.'),('Ortiz','Decentralized logistical groupware',5,'2004-06-15','1982-11-04','Ut libero dignissimos eos eaque.'),('Osinski','Visionary client-server capacity',3,'2004-09-28','2005-04-21','Ut enim est qui.'),('Padberg','Upgradable regional function',5,'1982-01-26','2003-07-10','Saepe deleniti architecto provident eum.'),('Pfannerstill','Intuitive eco-centric attitude',7,'2013-12-06','1976-10-14','Ipsum quisquam nisi doloremque quia et dolores.'),('Price','Switchable grid-enabled workforce',7,'1987-02-10','1997-12-05','Illo occaecati voluptas eveniet voluptatem facere et quasi.'),('Prohaska','Reduced cohesive adapter',3,'1988-01-20','2002-07-17','Assumenda mollitia aliquam exercitationem sint asperiores voluptatem voluptatem.'),('Quigley','Cloned multimedia emulation',3,'2009-03-13','2003-02-18','Et deserunt in eligendi architecto.'),('Rau','Focused leadingedge securedline',6,'2004-08-05','1998-09-14','Illum similique id ut.'),('Ritchie','Multi-tiered stable extranet',5,'1998-08-04','1997-05-09','Similique asperiores est facere mollitia asperiores ut et.'),('Runolfsdottir','Business-focused clear-thinking intranet',6,'1972-08-15','1970-07-11','Ea assumenda in optio et eos sit voluptas dolorem.'),('Ryan','Pre-emptive static emulation',3,'2020-06-24','1976-06-11','Consequuntur deleniti adipisci est voluptas nulla.'),('Sanford','Configurable background definition',4,'1975-03-17','2017-02-09','Voluptatem id nulla maiores libero incidunt.'),('Satterfield','Adaptive scalable complexity',3,'2000-10-24','2012-11-25','Consectetur minus ea quo.'),('Schneider','Open-source motivating encryption',4,'1999-06-02','1974-04-15','Animi repudiandae voluptas tenetur exercitationem vel quia modi.'),('Shields','Ergonomic holistic service-desk',3,'1976-10-30','2009-11-30','Qui enim enim repellendus.'),('Stamm','Function-based zerodefect paradigm',1,'1986-10-09','2009-02-08','Iusto voluptatem velit quae.'),('Thiel','Intuitive system-worthy access',1,'1985-07-05','1998-10-14','Voluptas at vel ullam iusto.'),('Waelchi','Persevering object-oriented solution',3,'1993-04-25','1990-11-23','Esse et veritatis enim sed nulla.'),('Walker','Exclusive dynamic synergy',6,'1990-08-12','1989-05-16','Aut rerum qui in consequuntur occaecati ex rerum et.'),('Walter','Horizontal zerotolerance portal',3,'1998-08-01','2005-10-26','Repellat delectus veritatis libero ad odio qui est.'),('Williamson','Integrated incremental product',7,'2010-07-25','1998-01-27','Illum quam est suscipit molestias molestiae sed quia.');
-- причёсывание таблицы проектов
update projects set
	results = null where status_id <> 5, -- предполагается наличие результатов только у завершенных проектов
	start_date = (select FROM_UNIXTIME(RAND( ) * ( UNIX_TIMESTAMP('1991-03-15') - UNIX_TIMESTAMP(now()) ) + UNIX_TIMESTAMP(now()))),
	finish_date = (select FROM_UNIXTIME(RAND( ) * ( UNIX_TIMESTAMP(start_date) - UNIX_TIMESTAMP(date_add(start_date, interval 1 year)) ) + UNIX_TIMESTAMP(date_add(start_date, interval 1 year))))
;

-- заполнение таблицы продуктов
insert into products (name, description, owner_id) values
('MiddleWare','Earum sequi voluptas et iusto unde labore.',11),
('Mobile App','Harum et voluptas veritatis est rerum quos.',117),
('Services','Maiores aperiam aut nobis eligendi et qui.',136),
('Meta Data Server','Adipisci hic voluptas soluta id est in similique.',194),
('WebMain','Impedit laboriosam voluptas veritatis praesentium dolorem architecto aut.',78),
('Profile Data Guide','Cumque tenetur odit enim provident voluptatum.',6),
('TVApp','Commodi dolor et recusandae dolore natus dolor ad.',67),
('SmartTV Application','Est omnis sapiente aliquid at quasi.',99),
('STB MW','Dolorum totam porro assumenda numquam.',167),
('GameConsole','Reprehenderit laudantium voluptatem illum saepe.',72);

-- продуктовая иерархия
insert into product_hierarchy (parent_product_id, children_product_id) values
(1, 9), (1, 10), (2, 7), (2, 8), (3, 4), (3, 5), (3, 6);

-- дополнительных контактов таблица
insert into additional_contacts (user_id, client_type_id, login) values
(153,3,'koss.aglae'),(196,3,'johan.pollich'),(106,3,'osinski.esmeralda'),(121,2,'patience06'),(30,4,'dannie.dibbert'),(195,1,'javon.botsford'),(149,3,'feeney.cheyanne'),(51,1,'dickens.valerie'),(72,4,'marquardt.billy'),(20,4,'jovan35'),(51,2,'vgrimes'),(78,5,'conroy.johanna'),(68,1,'mann.heather'),(12,1,'pkrajcik'),(192,4,'mlegros'),(52,1,'wmurphy'),(184,3,'hildegard69'),(189,1,'nprohaska'),(11,3,'lynch.gabe'),(197,5,'ismael43'),(32,3,'o\'keefe.maximo'),(89,1,'bmetz'),(152,1,'roberts.cathryn'),(72,1,'isac.sporer'),(151,4,'iveum'),(159,1,'fluettgen'),(177,3,'klocko.reuben'),(71,4,'xo\'connell'),(73,2,'fernando59'),(63,1,'dejah82'),(63,4,'arthur80'),(187,1,'tgibson'),(37,2,'jaida.medhurst'),(101,4,'merl.auer'),(137,2,'shaina.green'),(81,5,'kellen.vandervort'),(4,5,'ckilback'),(70,2,'travis52'),(116,5,'murphy.erdman'),(68,5,'deion56'),(150,4,'pframi'),(94,3,'alessandro.jaskolski'),(49,5,'lfeest'),(62,1,'mcglynn.nella'),(140,1,'chadrick40'),(159,5,'huel.frances'),(121,1,'ona.bernier'),(88,4,'grady.stanford'),(38,2,'towne.kianna'),(181,3,'kcorwin'),(142,2,'vida69'),(169,3,'nolson'),(187,3,'fyundt'),(70,4,'wschneider'),(9,3,'aracely.goyette'),(177,5,'athena47'),(11,2,'bernier.jamal'),(103,5,'sofia.ullrich'),(67,1,'greta.auer'),(119,1,'haskell46'),(166,4,'forest71'),(23,1,'vicenta.langworth'),(71,5,'heller.buddy'),(34,1,'mstamm'),(20,5,'christophe.senger'),(167,3,'alisa21'),(100,4,'sipes.justus'),(187,2,'ratke.felton'),(127,4,'little.sim'),(97,3,'ethyl22'),(8,3,'gusikowski.rico'),(17,1,'vena.schowalter'),(6,3,'griffin82'),(146,3,'coty35'),(74,5,'rosenbaum.linnie'),(126,3,'hquitzon'),(128,5,'cschaden'),(97,1,'dach.nya'),(7,1,'o\'conner.jane'),(92,4,'lilla.runte'),(53,4,'jermaine87'),(55,4,'idella16'),(7,2,'schmeler.malachi'),(154,4,'norval.wilkinson'),(88,2,'hilda.conn'),(62,4,'tromp.dimitri'),(23,3,'hoeger.katelyn'),(63,2,'lkunde'),(62,3,'hand.jessie'),(48,1,'domenic.smith'),(101,2,'lonzo15'),(19,1,'jedediah36'),(182,2,'obalistreri'),(182,5,'kvonrueden'),(181,1,'earmstrong'),(14,3,'wmclaughlin'),(198,3,'jazmin60'),(62,5,'connor.o\'conner'),(56,2,'darron57'),(14,2,'lkoepp'),(79,4,'fred59'),(50,2,'barrows.chloe'),(172,4,'tblock'),(199,3,'christiansen.raegan'),(30,2,'emerson.jacobson'),(12,5,'guadalupe.eichmann'),(159,2,'buford.beatty'),(133,4,'quitzon.clyde'),(162,3,'lyla.harber'),(10,1,'alysson.hane'),(8,1,'upton.shaniya'),(99,2,'maritza27'),(152,5,'macejkovic.clare'),(85,2,'emiliano97'),(175,5,'breanna.rowe'),(104,1,'timothy25'),(184,2,'bogisich.dejah'),(183,3,'precious.brakus'),(57,4,'callie.senger'),(141,1,'brooklyn.prosacco'),(116,3,'gsenger'),(138,3,'pat33'),(91,2,'robb15'),(75,5,'yleannon'),(156,3,'towne.hallie'),(185,1,'edgar.schmitt'),(90,3,'zachery40'),(113,2,'bartell.horace'),(80,2,'torp.rashad'),(145,3,'oweissnat'),(189,5,'sunny.cruickshank'),(27,2,'rupert.ratke'),(92,5,'aniyah21'),(199,1,'kimberly.goyette'),(170,4,'tyrel50'),(162,5,'eden.rosenbaum'),(168,5,'abernathy.mae'),(177,2,'fgerlach'),(188,1,'julian.fahey'),(24,3,'mona70');

-- новостей заполнение
insert into news (title, body, category_id, user_id) values
('Ad modi sed accusamus et.','Possimus nemo voluptatem sapiente praesentium praesentium officiis similique. Autem itaque dolorem tenetur dolorum ea debitis quis aperiam. Porro aut velit asperiores nobis.',5,9),('Aperiam blanditiis itaque vitae placeat rerum.','Neque aliquid accusantium nisi pariatur rem. Nemo sequi eius repellendus inventore sed. Et dicta et qui cumque ex laborum cumque eius.',1,172),('Atque nisi ut nihil tempora molestiae magni.','Corrupti aliquid eum sequi qui rerum modi. Delectus veniam ea placeat iusto nulla voluptas est. Sint maxime corrupti id ut magni. Quod animi quibusdam minima unde.',2,198),('Aut atque unde dignissimos non tenetur.','Impedit odio facere ducimus odit accusamus vel. Distinctio quia reiciendis voluptatum explicabo eligendi et. Non assumenda quod asperiores ratione dolor ut. Est soluta esse distinctio quae et quibusdam velit.',1,1),('Aut impedit officia totam alias fuga voluptas.','Est deserunt voluptatibus non ut ex rerum. Aliquam repellendus consectetur neque odit cum optio et. Et dolorum animi soluta deserunt. Nesciunt vel eum suscipit laboriosam veniam. Veniam molestias quia ipsum eos.',6,83),('Aut quidem iste porro molestiae vero.','Sit ut animi atque sit laboriosam quae deserunt. Sit eligendi accusamus velit soluta voluptatem nemo. Reiciendis sequi doloribus voluptas esse reprehenderit consequatur illo.',6,26),('Autem molestias qui consequuntur.','Occaecati voluptas at enim minima. Ex expedita occaecati ea ipsa repellendus iste perspiciatis culpa. Velit reprehenderit voluptates sit ipsum totam et iste.',3,189),('Delectus soluta saepe non porro nesciunt quas.','Architecto non voluptatem aspernatur animi beatae nihil. Commodi voluptates fugit et quis voluptatibus. Id ipsum fugiat necessitatibus aut quam enim impedit. Eos vel doloribus velit dolore quod nam excepturi optio. Nemo dicta voluptates quaerat quis atque quia quaerat.',4,107),('Dolore harum molestias nisi sit aut molestiae illum.','Dignissimos sit magnam qui quis sit et. Distinctio neque consequatur aut.',2,109),('Dolorem et ad ut aut minima maxime qui.','Impedit aut quia repellendus ullam omnis veniam pariatur. Rerum praesentium dolorem tenetur quis voluptatem voluptatem. Facilis quas voluptatum labore rerum quod. Ea voluptatem natus error omnis dolorem expedita ad.',2,136),('Dolorem modi iste nulla quo ab harum officiis.','Aut amet sit aut est aperiam nostrum quia. Voluptas voluptatem ea quibusdam omnis qui quos. Illum similique aut accusamus voluptate soluta harum. Autem dolorum inventore qui voluptatem iure.',2,14),('Dolores dolorem facere at similique.','Cumque ut laborum harum sit rem. Distinctio ut quo mollitia eos fugit consectetur aliquam laborum. Et enim voluptas occaecati sed atque et cumque mollitia. Laudantium saepe officiis hic.',5,179),('Doloribus non praesentium eaque et magnam qui sed.','Illum voluptas incidunt rerum sit pariatur tenetur nisi vel. Ad et et dolorum fuga magnam aut. Explicabo ratione dolor voluptatem molestiae ex omnis illo.',5,56),('Doloribus ut reprehenderit iste quia.','Qui velit eos neque debitis distinctio voluptatem mollitia. Deleniti velit rem voluptates eligendi. Sint ipsam sed officiis laudantium quas.',3,44),('Dolorum facere mollitia animi est.','In dignissimos natus earum quibusdam accusamus quis assumenda laudantium. Dolores ut porro et. Quia tempora accusamus quia culpa.',1,181),('Dolorum rerum facilis ea ea nihil eveniet.','Velit consequatur eius accusamus eos voluptates quia et. Fuga illo dignissimos exercitationem consequuntur velit. Et quod iusto voluptatum accusantium praesentium. Aut fuga consequuntur non est temporibus ut ut.',3,21),('Ea esse voluptate quia totam accusantium nobis numquam.','Aliquid est quis dolor unde esse et. Doloribus et quam vel sint ad reiciendis. Doloremque adipisci blanditiis voluptatem voluptatem. Dolor qui voluptates voluptatibus inventore qui nemo doloribus. Commodi ea provident dolor asperiores consequatur eos.',4,26),('Ea fuga praesentium ut et consequatur.','Consequatur non reprehenderit ullam provident libero aspernatur dolor quidem. Et commodi officia enim. Eligendi qui quia accusantium ea. Mollitia mollitia ipsum quis est sit ut.',6,40),('Earum sit commodi cumque minus deleniti vel.','Asperiores alias dolor ut numquam laudantium omnis. Harum nesciunt saepe libero. Ullam distinctio consequatur dolorem aut quod placeat.',7,149),('Error illum quo occaecati veniam vel eos aperiam.','Natus quidem temporibus autem culpa. Voluptatibus similique animi incidunt velit. Qui voluptas voluptatem quia molestiae. Corrupti voluptas velit deleniti soluta magni temporibus sequi quo.',1,177),('Est eos reprehenderit ut quibusdam ut fugiat.','Temporibus eum iusto aut dolor velit. Magnam recusandae non ut sint nobis nisi et aperiam. Minima totam ut ab ducimus est placeat dolore.',1,185),('Est et nihil cupiditate pariatur occaecati explicabo quia.','Sed excepturi labore repellendus id dolor quia et. Assumenda laboriosam in molestiae. Voluptas est qui ut facere debitis.',2,53),('Est molestiae animi ipsam saepe.','Dicta officia quisquam vero. Ab similique dolores voluptate reiciendis sit et earum amet. Sint ut nesciunt natus iste consequatur.',5,192),('Et sunt neque quidem minima.','Vero placeat occaecati omnis quis et quia. Doloribus provident earum natus omnis voluptatem. Quaerat nobis cupiditate sunt odio consequuntur tempore.',5,137),('Et voluptas iste tempore modi.','Et sed eaque voluptatem ut ipsa quaerat quod. Molestiae similique voluptas id est est voluptate.',6,59),('Facere exercitationem aut corporis repellat eaque labore velit.','Voluptas qui numquam beatae nulla itaque est deserunt. Cum cum commodi totam excepturi. Quo harum suscipit quasi sunt.',4,52),('Fuga eum sed rerum velit eligendi velit.','Et doloribus ut maxime sint nisi. Consequatur debitis optio rem. Recusandae excepturi hic est ut.',6,173),('Fugit dolores molestiae vel veniam.','Recusandae ipsa quod odit eos consequuntur. Possimus unde eius nihil ullam. Ut neque aliquid quas quam est. Deserunt ut ut quia cupiditate blanditiis laboriosam.',2,98),('Harum eius dolor quibusdam recusandae repudiandae.','Unde unde saepe deserunt et aut ipsam. Repellendus aperiam enim eos. Sapiente pariatur magnam fugiat aliquid magnam ducimus. Sunt placeat suscipit iste dolores. Error suscipit incidunt dicta minima blanditiis non eos sed.',7,100),('Harum repudiandae et vitae sed.','Itaque aliquid in dolore tempore dolorem magnam tempora. Cum numquam aut quis quo quo modi nobis culpa. Est officia quo sunt sit voluptatem. Quo aperiam ullam non accusantium consequatur architecto voluptatibus.',6,102),('In quae quia sed sapiente unde aspernatur voluptatibus.','Incidunt in adipisci nihil rem qui veritatis. Perferendis repudiandae magni nihil sed aut. Saepe veritatis velit nihil eligendi consequatur provident. Qui et eum cumque odit porro iusto voluptatem.',5,47),('Incidunt dolorem iure vel quia qui libero et qui.','Corrupti et quo aspernatur omnis perferendis. Sed enim maiores excepturi delectus unde beatae accusantium. Quae eius repudiandae hic eos maiores et animi. Odio voluptas repellat esse autem quia maxime maxime.',2,135),('Ipsa ipsum minima dolores iste qui qui non.','Voluptatem quidem nihil consequatur qui. Voluptatum voluptatem voluptatem quibusdam explicabo deserunt. Eos molestiae repellendus consequatur.',2,142),('Itaque iure voluptatum aut ab.','Velit ipsam quod quibusdam et facere tempore. Dolores sunt ut facere. Ex sapiente eum nulla voluptate quia ea.',5,52),('Libero quam sed ut possimus at quibusdam dolor tempora.','Dolore quia consequatur sed quia possimus nisi reprehenderit. Nam saepe voluptatem laborum labore magnam dicta illo.',3,73),('Libero qui sit qui eveniet dolores.','Officiis quia minima quibusdam et dolorem deleniti non. Placeat voluptatibus sit consequatur id odio.',2,144),('Nam consequatur aspernatur velit qui corporis debitis eius.','Repellendus sint explicabo qui. Dolore et non ut. Molestiae magni repellendus rerum sit ut.',1,48),('Nisi voluptas sit in ipsum laudantium.','Modi consequatur esse officia quisquam. Aut facere nemo non iste et. Quaerat autem sed laudantium quo. Enim explicabo earum laudantium pariatur.',3,8),('Nulla maiores harum dolorem quis vel distinctio.','Quia impedit aliquam assumenda unde beatae illum. Ex asperiores quis earum qui ut voluptas quis. Nesciunt ea consequatur vero qui animi.',1,61),('Pariatur quos et est.','Ipsa voluptas earum rerum atque magni assumenda. Ut aut quis tempore ea maiores eveniet sunt. Optio libero ab quos sint. Corrupti consectetur impedit nemo excepturi asperiores id et maxime.',1,126),('Provident velit suscipit expedita et ullam est rem.','Nisi odit voluptas non quia. Molestiae quam qui quam corporis neque culpa est est. Molestiae quis enim rem ipsum repudiandae nisi doloribus. Ut maiores sed repellat neque sit voluptatem. Perferendis dolore impedit minima officiis beatae quod.',1,167),('Quam esse porro sint quo ullam unde quia.','Qui sed voluptates aspernatur dolorem. Eligendi qui quia soluta et facilis. Assumenda quia sit porro. Quasi aut voluptate explicabo adipisci.',5,10),('Qui explicabo voluptas harum quas quam asperiores.','Sint porro odio ullam rem. Dolorem atque qui praesentium. Sed minima occaecati eos vero voluptatibus. In non consequatur ut magnam itaque iste assumenda.',2,52),('Quia quia vel earum eos magnam cumque.','Itaque eligendi ipsa exercitationem ducimus. Quas est blanditiis sit dignissimos. Omnis reprehenderit voluptas aspernatur voluptatibus magni. Id qui qui consequatur placeat aut.',5,105),('Quis commodi hic hic qui ipsa reiciendis quam.','Debitis quos voluptatibus ipsa nemo. Harum placeat facere occaecati enim architecto voluptas recusandae et. Ut in placeat tenetur nulla.',1,35),('Rem expedita quasi quia adipisci voluptatem eveniet.','Dolor quidem consequatur est quasi velit eos. Tempore aut officiis optio id et et. Rerum aperiam sit eum suscipit deserunt.',2,43),('Rerum magnam incidunt voluptates incidunt consequatur quia enim illo.','Et saepe autem modi explicabo laborum aut. Minima et molestias officiis consectetur dolorum ullam omnis eligendi. Aliquam occaecati voluptatem placeat saepe. Temporibus animi voluptas incidunt fuga inventore.',4,42),('Saepe quidem officia aspernatur perspiciatis eum sed eum.','Aut aut illum quia et. Hic porro autem occaecati aut accusantium qui. Et ut eaque perspiciatis voluptas iusto est ipsum.',3,23),('Sint accusamus temporibus pariatur dolore.','Quasi et quibusdam quia expedita. Eum dolores labore sit dicta quibusdam et quia dolores. Omnis sunt consequuntur iure culpa mollitia.',6,161),('Sint molestiae illum blanditiis voluptates.','Magnam voluptatem sed est blanditiis tenetur. Optio totam minus ducimus amet ducimus maxime commodi. Necessitatibus ad alias soluta omnis possimus veritatis quae.',5,126),('Sunt eum voluptatem quia qui odit quaerat.','Vero est non modi consequatur inventore. Et accusamus qui nostrum dolorem aut fugiat. Sapiente numquam asperiores velit doloribus magnam et tempore libero. Est nobis ipsa et sunt.',3,114),('Tempore porro pariatur vel est aut dolores quas.','Repudiandae nihil tenetur ut in voluptatum saepe. Unde magni illum ullam rerum eaque eum et culpa. Ullam accusamus odio tempore cum perferendis autem iure.',3,65),('Unde eaque dolor sint illo fugiat deleniti accusamus.','Dolores iusto corporis vel aut numquam sit. Dolor eveniet quia iure et repudiandae voluptatem dolorem. Provident qui ipsam molestiae deleniti perferendis. Doloribus itaque corporis laboriosam.',3,126),('Ut eaque quisquam odit esse autem atque sed quis.','Ducimus libero vero molestiae dolorum fugiat. Nesciunt nesciunt possimus voluptas.',1,126),('Ut rerum consequatur recusandae ipsum porro.','Labore ducimus ea quia dignissimos maxime. Accusantium illum provident labore nisi magni rerum officiis ut. Dolore distinctio aperiam illum sed.',4,30),('Vel rerum sed non culpa quo aut labore.','Dolore culpa occaecati nihil asperiores dignissimos est. Eos explicabo repellat exercitationem. Illum fuga sit quia quo ipsum. Dolorum aliquid vero est officia.',7,190),('Velit earum sequi iusto possimus.','Maxime assumenda doloribus quasi a labore impedit qui. Vel aut doloremque at molestias.',3,163);

-- департаментов таблица
insert into departments (name, director_id) values
('Mobile Development Depatment', 182), ('MiddleWare Development Depatment', 6), ('Service Development Depatment', 37);

-- отделы/команды
insert into teams (name, lead_id, department_id) values
('Android/AndroidTV', 12, 1),
('iOS/tviOS', 34, 1),
('Automation', 15, 1),
('QA Team', 49, 1),
('Support Team', 85, 2),
('QA Team', 126, 2),
('Analytics and Design Team', 173, 2),
('SW Core Team', 133, 2),
('HW Integration Team', 175, 2),
('Services team - 1', 107, 3),
('Services team - 2', 45, 3),
('Frontend', 91, 3),
('Analysts Team', 199, 3),
('Design team', 13, 3);

-- команды проектные, случайные значения с заданным диапазоном
insert into project_team (project_id, user_id, role_id) values
(65,162,6),(56,138,7),(30,20,3),(55,97,2),(8,24,6),(9,49,6),(28,137,4),(9,181,7),(38,183,5),(39,104,3),(44,50,4),(35,16,3),(2,85,7),(3,190,4),(11,35,5),(58,155,1),(64,159,3),(33,61,3),(13,173,3),(28,129,1),(45,160,1),(40,199,2),(16,13,5),(22,142,5),(54,104,7),(43,149,4),(22,68,1),(19,146,6),(57,117,3),(54,82,5),(44,29,1),(70,13,4),(17,172,2),(32,154,3),(72,2,7),(21,110,2),(9,29,4),(65,128,6),(66,101,6),(1,106,1),(36,77,5),(60,153,6),(47,20,1),(54,83,3),(7,123,2),(53,125,4),(69,122,3),(71,127,2),(29,175,4),(62,127,3),(39,136,6),(22,99,5),(47,98,5),(71,114,7),(49,13,3),(1,167,4),(66,2,3),(57,167,1),(50,111,2),(24,44,7),(13,184,4),(34,105,3),(17,184,3),(17,181,4),(51,32,1),(47,5,2),(10,167,6),(9,63,2),(50,40,5),(34,72,2),(70,46,1),(52,167,5),(67,142,1),(48,20,3),(47,26,4),(13,22,6),(30,171,4),(5,104,6),(18,95,2),(56,190,7),(57,101,6),(32,168,3),(26,101,5),(53,26,7),(5,89,3),(63,33,2),(6,24,1),(57,1,1),(38,6,1),(59,110,2),(22,28,6),(43,181,3),(65,91,6),(13,86,3),(53,47,2),(65,130,7),(8,65,7),(42,8,2),(34,11,2),(52,139,7),(33,98,4),(65,73,5),(15,125,5),(8,16,6),(43,61,3),(37,175,1),(26,165,6),(43,171,6),(62,187,7),(48,85,6),(18,15,3),(12,49,4),(50,186,4),(53,7,3),(40,35,7),(34,33,1),(15,88,5),(32,37,7),(14,184,7),(34,51,3),(51,154,2),(63,162,6),(50,42,4),(66,38,5),(7,17,5),(35,115,6),(17,41,3),(14,188,3),(12,44,3),(25,8,2),(29,82,4),(69,163,6),(20,12,4),(59,3,7),(44,79,4),(20,126,7),(55,79,5),(11,29,6),(30,33,2),(64,26,6),(27,107,7),(27,104,3),(72,145,7),(63,92,3),(44,114,4),(14,9,3),(59,179,5),(66,104,6),(58,38,1),(71,83,7);

-- продукты, задействованные в проекте
insert into projects_products (project_id, product_id) values
(18,9),(12,5),(38,6),(17,2),(9,10),(42,7),(40,5),(7,5),(16,8),(45,6),(71,8),(46,6),(69,10),(10,4),(64,8),(52,4),(8,9),(50,4),(68,9),(1,2),(36,8),(48,3),(63,8),(19,10),(6,1),(58,8),(47,9),(29,8),(44,4),(15,1),(43,3),(31,9),(27,10),(11,2),(70,6),(13,9),(61,10),(54,6),(30,2),(39,4),(5,5),(49,7),(57,8),(59,7),(24,7),(4,8),(41,7),(35,8),(33,1),(37,7),(56,5),(51,2),(26,5),(34,7),(3,9),(2,2),(53,9),(21,4),(23,9),(22,7),(65,5),(67,3),(28,9),(32,2),(62,1),(14,1),(60,4),(55,10),(20,1),(66,5),(25,10),(72,10);
insert into projects_products (project_id, product_id) values
(1,1),(1,3);

-- позиции сотрудника
insert into employee_position (user_id, position_id, team_id, department_id, chief_id) values 
(1,2,10,2,157),(2,4,13,1,7),(3,13,5,1,13),(4,4,6,3,193),(5,21,12,2,136),(6,21,12,3,15),(7,15,7,3,104),(8,20,5,2,69),(9,20,14,1,11),(10,15,1,3,155),(11,5,1,2,48),(12,5,13,3,97),(13,16,5,3,189),(14,20,4,2,65),(15,25,2,3,96),(16,13,12,2,55),(17,15,13,2,130),(18,23,5,1,36),(19,2,11,1,109),(20,12,10,3,95),(21,29,9,3,69),(22,29,7,3,15),(23,3,13,3,155),(24,30,12,3,197),(25,12,9,1,199),(26,8,10,1,21),(27,26,14,1,140),(28,16,4,2,71),(29,10,11,2,23),(30,19,12,1,57),(31,12,1,3,146),(32,15,1,1,13),(33,28,12,2,184),(34,13,14,3,132),(35,6,4,1,79),(36,28,1,2,62),(37,13,8,1,60),(38,17,1,2,140),(39,7,9,3,8),(40,23,13,1,108),(41,13,11,2,87),(42,24,10,2,88),(43,31,12,3,46),(44,21,9,1,113),(45,10,14,3,11),(46,18,2,3,168),(47,17,12,1,188),(48,9,10,1,125),(49,25,2,3,95),(50,7,14,1,70),(51,19,9,1,126),(52,14,13,3,133),(53,15,13,3,105),(54,9,4,3,77),(55,17,10,1,23),(56,5,12,2,103),(57,11,7,2,60),(58,11,4,2,123),(59,6,4,1,158),(60,22,4,2,125),(61,22,14,2,36),(62,24,11,2,108),(63,6,9,2,49),(64,25,10,1,32),(65,1,2,3,49),(66,16,3,3,52),(67,9,1,2,108),(68,4,13,1,169),(69,23,14,1,18),(70,7,1,2,137),(71,24,1,3,175),(72,15,13,2,95),(73,4,4,2,25),(74,4,1,2,92),(75,2,8,2,135),(76,18,14,1,149),(77,16,10,1,158),(78,19,7,2,151),(79,10,3,1,184),(80,11,2,2,124),(81,18,4,2,52),(82,7,14,2,186),(83,5,14,3,146),(84,19,6,1,169),(85,12,12,2,53),(86,21,3,2,179),(87,20,11,3,152),(88,24,10,1,88),(89,15,6,3,42),(90,22,6,3,144),(91,27,12,3,113),(92,30,5,2,158),(93,10,8,1,7),(94,29,10,2,197),(95,17,10,3,83),(96,5,7,1,131),(97,16,9,1,122),(98,12,9,2,26),(99,19,10,2,45),(100,26,5,3,53),(101,14,10,2,63),(102,20,1,2,30),(103,25,11,3,58),(104,4,2,3,136),(105,23,13,1,109),(106,28,6,2,114),(107,17,1,2,167),(108,15,1,2,34),(109,20,9,2,36),(110,2,5,2,156),(111,15,2,2,172),(112,12,7,2,24),(113,1,3,1,61),(114,4,10,1,76),(115,2,2,3,64),(116,25,14,1,74),(117,17,9,2,54),(118,8,13,2,17),(119,14,4,3,167),(120,26,1,3,13),(121,2,11,1,73),(122,4,4,3,114),(123,28,11,1,34),(124,16,12,2,174),(125,23,3,2,49),(126,11,4,3,165),(127,21,4,3,63),(128,7,13,1,121),(129,5,9,3,169),(130,29,13,1,142),(131,5,12,1,2),(132,12,11,3,23),(133,15,10,3,76),(134,22,6,3,110),(135,3,14,3,30),(136,11,13,1,32),(137,8,6,3,99),(138,4,4,1,153),(139,31,9,1,142),(140,6,9,1,150),(141,6,13,1,92),(142,29,14,1,86),(143,21,7,3,200),(144,8,6,2,181),(145,19,8,3,179),(146,14,2,1,19),(147,6,6,3,42),(148,16,1,3,138),(149,19,4,1,166),(150,13,11,2,146),(151,29,9,3,93),(152,31,13,1,117),(153,10,4,2,163),(154,14,10,1,124),(155,7,8,3,1),(156,20,12,3,148),(157,12,12,1,12),(158,1,11,3,53),(159,27,13,3,20),(160,28,3,3,157),(161,1,6,3,135),(162,5,1,3,6),(163,21,6,3,118),(164,21,10,1,163),(165,19,10,3,192),(166,5,5,2,94),(167,10,10,3,54),(168,13,12,1,110),(169,7,6,2,124),(170,26,4,2,27),(171,26,5,2,127),(172,15,11,1,134),(173,30,2,3,125),(174,4,4,2,74),(175,4,2,3,149),(176,13,12,3,118),(177,21,1,3,155),(178,17,11,1,183),(179,31,4,2,106),(180,23,9,2,41),(181,23,6,3,63),(182,11,14,2,128),(183,3,14,1,199),(184,27,2,3,43),(185,24,5,3,75),(186,8,11,2,87),(187,1,11,2,84),(188,2,8,2,161),(189,3,7,2,142),(190,4,12,2,170),(191,31,8,2,47),(192,3,14,1,86),(193,20,1,2,107),(194,14,9,3,24),(195,12,11,3,159),(196,11,7,2,117),(197,28,13,1,41),(198,23,3,2,58),(199,19,8,1,33),(200,2,8,2,103);
-- "причесывание" созданной таблицы (в основном по директорам)
update employee_position set position_id = 30 where user_id in (select director_id from departments); -- директоров директорами назначим
update employee_position set team_id = null where position_id in (30, 31); -- обнулим команду для директоров, ибо они по иерархии люди департаментов
update employee_position set chief_id = (select user_id where position_id = 31 order by rand() limit 1) where position_id in (30, 31); -- иерархически директорам назначим исполнительных в начальники
update employee_position set department_id = null where position_id not in (30); -- исполнительным принадлежность к департаменту уберём, ибо они люди компании, берем департамент для всех остальных, ибо команды указания достаточно


/*
 * Характерные
 * выборки
 */


-- Карточка пользователя
select 
	e.user_id,
	concat_ws(' ', e.lastname, e.firstname, e.middlename) as 'Ф. И. О.',
	date_format(e.birthday, '%e %M') as 'День рождения',
	date_format(e.work_started, '%e %M %Y') as 'Дата начала работы',
	p.name as 'Должность',
	concat(ch.lastname, ' ', ch.firstname) as 'Руководитель',
	concat_ws(' | ', t.name, d.name) as 'Подразделение',
	e.email as 'E-mail',
	ac1.login as 'Телефон',
	ac2.login as 'Telegram',
	ac3.login as 'Slack',
	ac4.login as 'Skype',
	ac5.login as 'Rocket Chat'
from employers e
join employee_position ep on ep.user_id = e.user_id 
join positions p on p.id = ep.position_id 
left join employers ch on ch.user_id = ep.chief_id -- имя начальника
left join teams t on ep.team_id = t.id -- имя команды
left join departments d on d.id = ep.department_id and ep.user_id = e.user_id  -- имя департамента
left join additional_contacts ac1 on ac1.user_id = e.user_id and ac1.client_type_id = 1 -- phone
left join additional_contacts ac2 on ac2.user_id = e.user_id and ac2.client_type_id = 2 -- Telegram
left join additional_contacts ac3 on ac3.user_id = e.user_id and ac3.client_type_id = 3 -- phone
left join additional_contacts ac4 on ac4.user_id = e.user_id and ac4.client_type_id = 4 -- phone
left join additional_contacts ac5 on ac5.user_id = e.user_id and ac5.client_type_id = 5 -- phone
order by e.user_id;

-- Карточка проекта

select 
	p.name as 'Проект',-- именование проекта
	ps.name as 'Статус',-- статус проекта
	p.description as 'Описание проекта',-- описание проекта
	group_concat(' ', e.firstname,' ',e.lastname, ' - ', r.name) as 'Команда',-- команда проекта
	concat(date_format(p.start_date, '%e %b %Y'), ' - ', date_format(p.finish_date, '%e %b %Y')) as 'Сроки проекта', -- сроки проекта
	group_concat(pd.name) as 'Продукты',-- продукты
	p.results as 'Результаты проекта'-- результаты
from projects p
join project_statuses ps on ps.id = p.status_id -- именование статуса
left join projects_products pp on pp.project_id = p.id -- связи проектов и продуктов
left join products pd on pd.id = pp.product_id and pp.project_id = p.id -- имя связного продукта
join project_team pt on pt.project_id = p.id -- команда проекта
join employers e on e.user_id = pt.user_id
join roles r on r.id = pt.role_id
group by p.id;


-- ближайшие дни рождения (по порядковому номеру дня в текущем году)
select
	concat_ws(' ', lastname, firstname) as 'Сотрудник',
	date_format(birthday, '%e %M') as 'День рождения'
from employers
where dayofyear(date_add(birthday, interval (select TIMESTAMPDIFF(year, birthday, (date_format(now(),'%Y-12-31')))) year)) >= dayofyear(now())
order by dayofyear(birthday) limit 10;


-- Новостная лента
select
	c.name as 'Категория новости',
	n.title as 'Заголовок',
	concat(left (n.body, 50), ' ...') as 'Превью тела',
	date_format(n.created_at, '%e %b %Y') as 'Дата публикации',
	concat_ws(' ', e.lastname, e.firstname)'Автор'
from news n
join categories c on c.id = n.category_id
join employers e on e.user_id = n.user_id 
order by c.id, n.created_at;


/*
 * Представления
 */

-- Основная выборка проектов (список основных данных)
create view project_list as
	select 
		p.name as 'Проект',-- именование проекта
		ps.name as 'Статус',-- статус проекта
		group_concat(' ', e.firstname,' ',e.lastname) as 'МП',-- менеджер проекта
		date_format(p.start_date, '%e %b %Y') as 'Начало',-- начало проекта
		date_format(p.finish_date, '%e %b %Y') as 'Конец', -- завершение проекта
		group_concat(pd.name) as 'Продукты'-- продукты
	from projects p
	join project_statuses ps on ps.id = p.status_id -- именование статуса
	left join projects_products pp on pp.project_id = p.id -- связи проектов и продуктов
	left join products pd on pd.id = pp.product_id and pp.project_id = p.id -- имя связного продукта
	left join project_team pt on pt.project_id = p.id and pt.role_id = 1-- команда проекта
	join employers e on e.user_id = pt.user_id
	group by p.id;

-- основная выборка сотрудников (представление списка минимальных данных, по департаментам)
create view employee_depart_list as
	select
		e.avatar as 'Фото',-- автар
		concat_ws(' ', e.lastname, e.firstname) as 'Имя, фамилия',
		e.email as 'E-mail',-- email
		p.name as 'Должность',-- должность
		d.name as 'Подразделение'
	from employers e
	join employee_position ep on ep.user_id = e.user_id 
	join positions p on p.id = ep.position_id
	left join teams t on ep.team_id = t.id
	left join departments d on (d.id = t.department_id or d.id = ep.department_id) and ep.user_id = e.user_id
	order by d.id;

-- структурное представление (маленькая иерархичность)
create view depart_structure as
	select
		d.name as 'Департамент',
		group_concat(' ',t.name) as 'Отделы',
		concat_ws(' ', e.lastname, e.firstname) as 'Директор'
	from departments d
	join teams t on t.department_id = d.id
	left join employers e on e.user_id = d.director_id
	group by d.id;

/*
 * Процедуры
 * Функции
 */

-- delimiter // -- в настройках среды

-- дата выслуги лет. Может использоваться для поздравительных оповещениях
create procedure seniority(check_id int)
begin
	declare start_date date; declare name varchar(150);
	select work_started into start_date from employers where user_id = check_id;
	select firstname into name from employers where user_id = check_id;
	if  date_format(start_date, '%e %M') = date_format(now(), '%e %M') then 
		select concat('Поздравляем тебя,', name, '! Ты уж с нами целых ', (year(now()) - year(start_date)),' годиков!');
	end if;
end //

call seniority(24)//
update employers set work_started = '2007-04-18' where user_id = 24// -- измение значения проверки ради


/*
 * Триггеры
 */

-- delimiter // -- в настройках среды

-- необходимость заполнения релузльтатов при завершении проекта
create trigger closed_project_without_results before update on projects
for each row
begin
	if coalesce(new.results, new.status_id) = 5 then signal sqlstate '45001' set message_text = 'UPDATE canceled: project cannot be closed without results';
	end if;
end//

update projects set status_id = 5 where id = 2 // -- проверочный апдейт

-- отсутствие привязки к отделу для директоров, отсутствие привязки исполнительных директоров к департаментам
-- обнуляем принудительно
create trigger director_in_team before update on employee_position
for each row
begin
	if new.position_id in (30, 31) then
		set new.team_id = null;
	end if;
end//

create trigger exdirector_in_department before update on employee_position
for each row
begin
	if new.position_id = 31 then
		set new.department_id = null;
	end if;
end//

update employee_position set position_id = 1, team_id = 1, department_id = 1 where user_id = 54// -- во имя проверок
update employee_position set position_id = 31 where user_id = 54 // -- во имя проверок триггеров
