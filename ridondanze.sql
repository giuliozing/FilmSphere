
-- -----------------------------------------------------
-- Inizializzazione della Ridondanza BandaDisponibile
-- -----------------------------------------------------
drop procedure if exists inizializza_banda_disponibile;
delimiter $$
create procedure inizializza_banda_disponibile()
begin
    declare s int default 0;
    declare lb bigint default 0;
    declare finito tinyint(1) default 0;
    declare c cursor for select Id from server;
    declare continue handler for not found set finito = 1;
    open c;
    scan: loop
        fetch c into s;
        select LarghezzaBanda from server where Id = s into lb;
        update server set BandaDisponibile = (
            select lb -sum(c.Dimensione/c.Lunghezza)
            from erogazione e inner join contenuto c
            on e.Contenuto = c.Id
            where e.Fine is null
            and e.Server = s
            )
        where Id = s;
        if finito = 1
            then leave scan;
        end if;
    end loop;
    close c;
end $$

call inizializza_banda_disponibile();

-- -----------------------------------------------------
-- Inizializzazione degli attributi ridondanti 'SommaCritica', 'TotaleCritica', 'SommaUtenti', 'TotaleUtenti'
-- -----------------------------------------------------

drop procedure if exists inizializza_ridondanze_recensioni;
delimiter $$
create procedure inizializza_ridondanze_recensioni()
begin
    declare finito tinyint(1) default 0;
    declare film_in_aggiornamento int;
    declare c cursor for select Id from film;
    declare continue handler for not found set finito =1;
    open c;
    scan: loop
        fetch c into film_in_aggiornamento;
        update film set SommaUtenti = (
            select sum(Voto) from recensioneutente where film = film_in_aggiornamento
            ),
            TotaleUtenti = (select count(*) from recensioneutente where Film= film_in_aggiornamento),
            SommaCritica = (select sum(Voto) from recensionecritico where Film = film_in_aggiornamento),
            TotaleCritica = (select count(*) from recensionecritico where Film= film_in_aggiornamento)
        where film.Id = film_in_aggiornamento;
        if finito then leave scan;
        end if;
    end loop;
    close c;
end $$
delimiter ;