---------------------------------------------
-------------- UPSERT -----------------------
---------------------------------------------

select * from Usuarios;

insert into Usuarios
	(Nome, Email)
values
	('Usuario 1', 'usuario@gmail.com');

-- Upsert apenas com merge.
MERGE INTO Usuarios AS usuDestino
USING (VALUES ('Usuario 1 Editado', 'usuario@gmail.com')) AS usuOrigem (Nome, Email)
	ON usuDestino.Email = usuOrigem.Email
WHEN MATCHED THEN
    UPDATE SET usuDestino.Nome = usuOrigem.Nome
WHEN NOT MATCHED THEN
    INSERT 
    	(Nome, Email)
    VALUES 
   		(usuOrigem.Nome, usuOrigem.Email); 	


