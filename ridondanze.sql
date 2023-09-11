
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


-- -----------------------------------------------------
-- Aggiornamento delle ridondanze 'SommaUtenti', 'TotaleUtenti'
-- -----------------------------------------------------

drop trigger if exists ridondanza_recensioni_utenti;
delimiter $$
create trigger ridondanza_recensioni_utenti
after insert on recensioneutente
for each row
    begin
        declare somma_utenti, totale_utenti bigint default 0;
        select SommaUtenti, TotaleUtenti from film where Id = new.Film into somma_utenti, totale_utenti;
        update film set SommaUtenti = somma_utenti + new.Voto, TotaleUtenti = totale_utenti+1 where Id = new.Film;
    end $$
delimiter ;

-- -----------------------------------------------------
-- Aggiornamento delle ridondanze 'SommaCritica', 'TotaleCritica'
-- -----------------------------------------------------

drop trigger if exists ridondanza_recensioni_critici;
delimiter $$
create trigger ridondanza_recensioni_critici
after insert on recensionecritico
for each row
    begin
        declare somma_critici, totale_critici bigint default 0;
        select SommaCritica, TotaleCritica from film where Id = new.Film into somma_critici, totale_critici;
        update film set SommaCritica = somma_critici + new.Voto, TotaleCritica = totale_critici+1 where Id = new.Film;
    end $$
delimiter ;

-- -----------------------------------------------------
-- Inizializzazione della ridondanza "Rating Assoluto"
-- -----------------------------------------------------

drop procedure if exists aggiorna_rating_assoluto_procedura;
delimiter $$
create procedure aggiorna_rating_assoluto_procedura()
begin
    declare finito tinyint(1) default 0;
    declare film_in_aggiornamento, RA int;
     declare c cursor for select Id from film;
    declare continue handler for not found set finito = 1;
    open c;
    scan: loop
        fetch c into film_in_aggiornamento;
        call rating_assoluto(film_in_aggiornamento, RA);
        update film set RatingAssoluto = RA where Id = film_in_aggiornamento;
        if finito
            then leave scan;
        end if;
    end loop;
    close c;
end $$
delimiter ;


call aggiorna_rating_assoluto_procedura();

-- -----------------------------------------------------
-- Aggiornamento della ridondanza "Rating Assoluto"
-- -----------------------------------------------------

drop event if exists aggiorna_rating_assoluto;
create event aggiorna_rating_assoluto_evento
on schedule every 1 day starts '2023-09-15-00:00:00' do
begin
    call aggiorna_rating_assoluto_procedura();
end;

-- -----------------------------------------------------
-- Aggiornamento della ridondanza "BandaDisponibile"
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS ridondanza_banda_disponibile_1;
DELIMITER $$
CREATE TRIGGER ridondanza_banda_disponibile_1
AFTER INSERT ON Erogazione FOR EACH ROW
	BEGIN
		DECLARE dim BIGINT;
        DECLARE dur INT;
        SELECT C.Dimensione, C.Lunghezza INTO dim, dur
        FROM Contenuto C
        WHERE C.Id = NEW.Contenuto;
        UPDATE Server S SET S.BandaDisponibile = S.BandaDisponibile - (dim/dur) WHERE S.Id = NEW.Server;
	END $$
DELIMITER ;

DROP TRIGGER IF EXISTS ridondanza_banda_disponibile_2;
DELIMITER $$
CREATE TRIGGER ridondanza_banda_disponibile_2
AFTER UPDATE ON Erogazione FOR EACH ROW
	BEGIN
		DECLARE dim BIGINT;
        DECLARE dur INT;
        SELECT C.Dimensione, C.Lunghezza INTO dim, dur
        FROM Contenuto C
        WHERE C.Id = NEW.Contenuto;
		UPDATE Server S SET S.BandaDisponibile = S.BandaDisponibile + (dim/dur) WHERE S.Id = NEW.Server;
	END $$
DELIMITER ;

-- -----------------------------------------------------
-- Aggiornamento della ridondanza "Visualizzazioni"
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS ridondanza_visualizzazioni;
DELIMITER $$
CREATE TRIGGER ridondanza_visualizzazioni
AFTER INSERT ON Erogazione FOR EACH ROW
	BEGIN
		DECLARE prec, film_prec, film_new INT;
        with tab_1 as (SELECT LAG(E.Contenuto, 1)
                                  OVER (PARTITION BY E.InizioConnessione, E.Dispositivo ORDER BY E.Inizio) as contenuto_precedente,
                              E.Contenuto,
                              E.Id
                       FROM Erogazione E
                       WHERE E.InizioConnessione = NEW.InizioConnessione
                         and E.Dispositivo = NEW.Dispositivo
        )
		select contenuto_precedente into prec from tab_1 where Id = new.Id ;
        SELECT C.Film INTO film_prec
        FROM Contenuto C
        WHERE C.Id = prec;
		SELECT C.Film INTO film_new
        FROM Contenuto C
        WHERE C.Id = NEW.Contenuto;
        IF film_prec <> film_new THEN
			UPDATE Film F SET F.Visualizzazioni = F.Visualizzazioni + 1 WHERE F.Id = film_new;
		END IF;
	END $$
DELIMITER ;


-- -----------------------------------------------------
-- Inizializzazione della Ridondanza Visualizzazioni
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS inizializza_visualizzazioni;

DELIMITER $$

CREATE PROCEDURE inizializza_visualizzazioni ()
	BEGIN
		REPLACE INTO Film
	        SELECT F.Id, F.Titolo, F.Descrizione, F.Anno, F.Durata, F.Paese, F.SommaCritica, F.TotaleCritica, F.SommaUtenti, F.TotaleUtenti, F.RatingAssoluto, V.totale_views_per_film AS Visualizzazioni
		FROM Film F INNER JOIN (
					SELECT C.Film, SUM(V1.vpc) AS totale_views_per_film
					FROM (
					      SELECT N.Contenuto, count(*) AS vpc
					      FROM (
						    SELECT *
						    FROM (
							  SELECT *, LAG(E.Contenuto, 1) OVER(PARTITION BY E.InizioConnessione, E.Dispositivo ORDER BY E.Inizio) AS _prec
							  FROM Erogazione E
							  ) AS Q
						    WHERE Q._prec <> Q.Contenuto
						    ) AS N 
					      GROUP BY N.Contenuto
					      ) AS V1 INNER JOIN Contenuto C ON C.Id = V1.Contenuto
					GROUP BY C.Film
					) AS V ON V.Film = F.Id;
    END $$
DELIMITER ;

call inizializza_visualizzazioni();
