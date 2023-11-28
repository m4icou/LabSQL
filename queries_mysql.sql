---------------------------------------
----------- UPSERT --------------------
----------------------------------------

select * from usuario;

insert into usuario 
	(nome, email)
values 
	('usuario 1', 'usuario@gmail.com');

-- Verifica pela PK.
insert into usuario 
	(id, nome, email)
values 
	(1, 'usuario 1 editado', 'usuario@gmail.com')
on duplicate key update 
	nome = values(nome);


-- Verifica pelo unique index.
create unique index idx_unique_email on usuario(email);

insert into usuario 
	(nome, email)
values
	('usuario 1 editado email', 'usuario@gmail.com')
on duplicate key update 
	nome = values(nome);

	
