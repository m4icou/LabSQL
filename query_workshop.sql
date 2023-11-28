-------------------------------
------------ DDL --------------
-------------------------------

select * from produtos;

-- CREATE.
create table produtos 
(
    id serial primary key,
    descricao varchar(50),
    preco decimal(10, 2),
    quantidade_estoque int
);

-- Insere os registros na tabela produtos.
insert into produtos 
	(descricao, preco, quantidade_estoque)
values
	('Produto1', 12.5, 10),
	('Produto2', 15.4, 8),
	('Produto3', 18.3, 6),
	('Produto4', 21.2, 4),
	('Produto5', 24.1, 2),
	('Produto6', 27, 0);



-- ALTER.
-- Adiciona a coluna.
alter table produtos add marca varchar(30);

-- alter table itens add marca varchar(30);


-- Preenche os valores para setar not null.
update produtos set marca = 'Marca1';
alter table produtos alter column marca set not null;


-- TRUNCATE.
truncate table produtos;


-- RENAME.
alter table produtos rename to itens;
select * from itens;

insert into itens 
	(descricao, preco, quantidade_estoque)
values
	('Produto1', 12.5, 10),
	('Produto2', 15.4, 8),
	('Produto3', 18.3, 6),
	('Produto4', 21.2, 4),
	('Produto5', 24.1, 2),
	('Produto6', 27, 0);


-- COMMENT.
-- Comentário na tabela.
COMMENT ON TABLE itens IS 'Tabela que armazena informações sobre os itens disponíveis.';

-- Comentário na coluna.
-- Restringir no CHECK.
COMMENT ON COLUMN itens.quantidade_estoque IS 'A quantidade máxima de um item em estoque é 1000.';


-- DROP.
DROP TABLE IF EXISTS itens;



-- PRIMARY KEY + FOREIGN KEY

-- Remove a coluna quantidade_estoque.
alter table itens drop column quantidade_estoque;

create table estoque 
(
    id serial primary key,
    descricao varchar(50)
);

insert into estoque 
	(descricao)
values
	('Estoque Loja 1'),
	('Estoque Loja 2');
	
select * from estoque;	

-- Cria uma tabela que associa um item a um estoque com uma quantidade.
create table itens_estoque 
(
    id serial primary key,
    item_id int,
    estoque_id int,
    quantidade int NOT NULL,
    constraint fk_itens_estoque_item
        foreign key(item_id)
        references itens(id),
    constraint fk_itens_estoque_estoque
        foreign key(estoque_id)
        references estoque(id)
);

-- Realiza a relação de itens x estoque.
insert into itens_estoque
	(item_id, estoque_id, quantidade)
values
	(1, 1, 255),
	(1, 2, 480),
	(2, 1, 189),
	(2, 2, 165),
	(3, 1, 178),
	(3, 2, 235);
	
select * from itens_estoque;


delete from itens where id = 8;

-- Remove a constraint existente
alter table itens_estoque drop constraint fk_itens_estoque_item;

-- Adiciona a constraint de chave estrangeira com ON DELETE CASCADE
alter table itens_estoque
add constraint fk_itens_estoque_itens
    foreign key(item_id)
    references itens(id)
    on delete cascade;
	
delete from itens where id = 8;
delete from itens where id = 9;
select * from itens_estoque;

	



-------------------------------
------------ DML --------------
-------------------------------

-- SELECT

select * from film;

select 
	title as titulo, 
	description as descricao,
	"length" as duracao
from film
where
	release_year = 2006;

select 
	title as titulo, 
	description as descricao,
	concat('Duração: ', "length", ' - ', 'Conteúdos especiais: ', special_features) as duracao_cenas_especiais,
	release_year, 
	category_name as categoria 
from film;

select 
	title as titulo, 
	1 as coluna1,
	2 as coluna2,
	'Texto' as coluna_texto
from film
where 
	release_year <= 2008 and
	"length" >= 90;



-- INSERT
-- "2023-11-26 13:57:34.899732-03"
select now();

-- Inserção básica.
insert into actor 
	(first_name, last_name, last_update)
values
	('Brad', 'Pitty', '2023-11-26 13:57:34.899732-03');

-- Inserção sem colunas.
insert into actor values(202, 'Novo', 'Ator',  '2023-11-26 13:57:34.899732-03');

-- Multi-insert
insert into actor 
	(first_name, last_name, last_update)
values
	('Christian', 'Bale', '2023-11-26 13:57:34.899732-03'),
	('Liam', 'Neeson', '2023-11-26 13:57:34.899732-03'),
	('Ben', 'Affleck', '2023-11-26 13:57:34.899732-03');
	
select * from actor order by actor_id desc;
	
-- Insert apartir de um select.
insert into actor
	(first_name, last_name, last_update)
select
	first_name,
	'Duplicado',
	last_update
from actor 
order by 
	actor_id desc
limit 3;

select * from actor order by actor_id desc;
	
	
-- UPDATE
select * from film where film_id = 10;
select * from "language";

-- Atualiza o idioma do filme para Mandarin - 4.
update film set
	language_id = 4,
	last_update = now()
where
	film_id = 10;

-- Update com JOIN.

select * from film;
select * from category;
select * from film_category;

-- Adiciona o nome da categoria a tabela film.
alter table film add category_name varchar(100);

-- Preenche o nome da categoria com base na relação da tabela film_category.
update film
	set category_name = category.name
from film_category
inner join category on
	film_category.category_id = category.category_id
where 
	film_category.film_id = film.film_id;
	
select * from film;	


-- DELETE
select * from itens;
delete from itens where id = 10;

delete from estoque where id = 2;
select * from estoque;
select * from itens_estoque
delete from itens_estoque where id_estoque = 2;



-- UPSERT
select * from category;

-- Adiciona uma restrição única a tabela categoria.
alter table category
add constraint unique_category UNIQUE ("name");	

insert into category
	("name", last_update)
values
	('Humor', '2005-11-15');

insert into category
	("name", last_update)
values
	('Humor', now())
on conflict("name") 
do update set
	last_update = EXCLUDED.last_update;





-------------------------------------------------------------
--------------------- DCL -----------------------------------
---------------------------------------------------------------

CREATE USER usuario_novo WITH PASSWORD 'Senha_10';

select * from actor;

grant select on actor TO usuario_novo;
revoke select on actor from usuario_novo;





------------------------------------------------------------------
----------------- FUNÇÕES AGREGADAS ------------------------------
------------------------------------------------------------------

-- COUNT
-- Quantidade de filmes cadastrados.
select count(*) from film;

-- SUM
-- Soma todos os pagamentos já realizados
select * from payment;
select sum(amount) from payment;

-- AVG
-- Calcula a média de duração dos filmes cadastrados (soma/quantidade).
select * from film;
select avg("length") from film;

select (sum("length") / cast(count(*) as decimal)) from film;

-- MIN E MAX.
select min("length") from film;
select max("length") from film;


-- GROUP BY
select * from film f;

-- Seleciona todas as categorias.
select
	f.category_name
from film f 
group by
	f.category_name;

-- Tras um totalizador de filmes por gênero.
select
	f.category_name as genero,
	count(*) as quantidade_filmes,
	cast(sum(f."length") / 60 as decimal) as total_horas,
	avg(f."length") as duracao_media,
	min(f."length") as duracao_minima,
	max(f."length") as duracao_maxima
from film f 
group by
	f.category_name
order by 
	count(*) desc;


-- HAVING
-- Filtrando por quantidade de filmes.
select
	f.category_name as genero,
	count(*) as quantidade_filmes,
	cast(sum(f."length") / 60 as decimal) as total_horas,
	avg(f."length") as duracao_media,
	min(f."length") as duracao_minima,
	max(f."length") as duracao_maxima
from film f 
group by
	f.category_name
having 
	count(*) > 65
order by 
	count(*) desc;



-------------------------------------------------------------------
--------------------- JOINS ---------------------------------------
--------------------------------------------------------------------

-- INNER JOIN.
-- Tras todos os usuários com endereço.
select * from customer c;
select * from address a;

select
	c.first_name,
	c.last_name,
	a.address,
	a.address2,
	a.district,
	a.postal_code
from customer c
inner join address a on
	c.address_id = a.address_id; 



-- LEFT JOIN.
-- Remove o not null da coluna address_id.
alter table customer alter column address_id drop not null;

-- Traz usuários com ou sem endereço.
select
	c.first_name,
	c.last_name,
	a.address,
	a.address2,
	a.district,
	a.postal_code
from customer c
left join address a on
	c.address_id = a.address_id
where
	c.address_id is null;

-- RIGHT JOIN
-- Traz uma lista de lojas com admin + admins sem lojas.
alter table store alter column manager_staff_id drop not null;

select * from store;
select * from staff;

select 
	s.store_id as loja_id,
	s.address_id as endereco_id,
	st.first_name as nome_admin,
	st.last_name as sobrenome_admin,
	st.email as email_admin
from store s 
right join staff st on
	s.manager_staff_id = st.staff_id;

-- FULL JOIN
-- Traz uma lista de lojas com ou sem admin + uma lista de admins com ou sem loja.
select
	s.store_id as loja_id,
	s.address_id as endereco_id,
	st.first_name as nome_admin,
	st.last_name as sobrenome_admin,
	st.email as email_admin
from store s
full join staff st on
	s.manager_staff_id  = st.staff_id;


-----------------------------------------------------------------
------------------- SUBSCONSULTAS -------------------------------
-----------------------------------------------------------------

-- Traz uma lista de atores que atuaram no filme.
select	
	f.film_id as id_filme,
	f.title as titulo,
	(
		select 
			json_agg(concat(a.first_name, ' ', a.last_name))
		from actor a
		inner join film_actor fa on
			a.actor_id = fa.actor_id
		where
			fa.film_id = f.film_id
	) as atores
from film f;

-- Traz a listagem de filmes com o idioma (subquery x join).
-- Subquery no SELECT.
select
	f.film_id as id_filme,
	f.title as titulo,
	(
		select 
			l."name"
		from "language" l
		where 
			l.language_id = f.language_id
		limit 1
	)
from film f;

select
	f.film_id as id_filme,
	f.title as titulo,
	l."name"
from film f
inner join "language" l on
	f.language_id = f.language_id;


-- Subquery no WHERE.
select
	ci.*
from city ci
where 
	ci.country_id = 
	(
		select country_id 
		from country c 
		where c.country = 'Brazil'
		limit 1
	);

-- Subquery no FROM.
select 
	cidades_brazil.city_id,
	cidades_brazil.city
from 
(
	select
		ci.city_id,
		ci.city,
		ci.country_id,
		ci.last_update
	from city ci
	where 
		ci.country_id = 
		(
			select country_id 
			from country c 
			where c.country = 'Brazil'
			limit 1
		)
) as cidades_brazil;



-----------------------------------------------------
------------- EXPRESSÕES SQL ------------------------
-----------------------------------------------------

-- LIKE.
select * from city c where c.city like 'An%';
select * from city c where c.city like '%a';
select * from city c where c.city like '%-%';

select * from city c where c.city like 'Hirosh_ma';

select * from city c where lower(c.city) like '%a';
select * from city c where upper(c.city) like '%A';

-- IN.
select * from film f where f.rating in ('PG', 'R', 'G');
select * from address a where a.city_id in (300, 576);

select 
	a.address_id,
	a.address,
	a.address2,
	a.district,
	a.postal_code
from address a
where 
	a.city_id in 
	(
		select
			ci.city_id
		from city ci
		inner join country c on
			ci.country_id = c.country_id
		where
			c.country like 'Brazil'
	);


-- BETWEEN
select * 
from payment p 
where 
	amount between 1 and 2
order by
	amount;





--------------------------------------------------
--------------- STORED PROCEDURE -----------------
--------------------------------------------------


-- Cria a procedure de inserção de atores.
create or replace procedure inserir_ator(
	actor_first_name varchar(50),
	actor_last_name varchar(50)
)
language plpgsql    
as 
$$
begin
	insert into actor
		(first_name, last_name, last_update)
	values
		(actor_first_name, actor_last_name, now());
end;
$$

CALL inserir_ator('Leonardo', 'DiCaprio23');

-- Cria a procedure de inserção de filmes.
create or replace procedure inserir_filme(
	titulo varchar(50),
	descricao varchar(50),
	ano int,
	duracao int
)
language plpgsql    
as 
$$
begin
	insert into film
		(title, description, release_year, language_id, original_language_id, 
		rental_duration, rental_rate, "length", replacement_cost, rating, last_update, special_features, fulltext)
	values
		(titulo, descricao, ano, 1, NULL, 6, 0.99, 86, 20.99, 'PG'::public.mpaa_rating, '2023-11-26 14:32:27.621', 
		'{"Deleted Scenes","Behind the Scenes"}', 
		'''academi'':1 ''battl'':15 ''canadian'':20 ''dinosaur'':2 ''drama'':5 ''epic'':4 ''feminist'':8 ''mad'':11 ''must'':14 ''rocki'':21 ''scientist'':12 ''teacher'':17'::tsvector);
end;
$$

CALL insert_film('Filme Legal', 'Um filme muito bom', 2009, 90);

-- Cria a procedure de inserção de atores em filmes.
create or replace procedure inserir_filme_ator(
	id_ator int,
	id_filme int
)
language plpgsql    
as 
$$
begin
	insert into film_actor
		(actor_id, film_id, last_update)
	values
		(id_ator, id_filme, now());
end;
$$

CALL inserir_filme_ator(215, 1001);

select * from film order by film_id desc;
select * from actor order by actor_id desc;
select * from film_actor order by film_id desc;


CREATE FUNCTION listar_atores_filme(id_filme int)
RETURNS TABLE 
	(id_ator int, nome_completo_ator text) 
AS $$
begin
	
   
	RETURN QUERY
    SELECT
        a.actor_id,
        a.first_name
    from actor a 
   	inner join film_actor fa on
   		a.actor_id = fa.actor_id
   	where
   		fa.film_id = id_filme;
   
   
end; $$ 
LANGUAGE plpgsql;


select * from listar_atores_filme(800);






