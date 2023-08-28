-- Lorenzo Leoncini, Giulio Zingrillo. Progetto di Basi di Dati 2023

-- Questo script implementa le operazioni sui dati descritte nella sezione 4 della Documentazione.

USE plz;

-- -----------------------------------------------------
-- Operazione 1: Rating Assoluto, o Valutazione
-- -----------------------------------------------------


DROP PROCEDURE IF EXISTS rating_assoluto;

DELIMITER $$

CREATE PROCEDURE rating_assoluto (IN _idfilm INT, OUT _rating INT)
	BEGIN
		DECLARE temp, mediacritica, mediautenti, fasciapremialita, sommapesi, fasciaviews, visualizzazioni, celebritaregisti, celebritaattori, fasciapremialitaregisti, fasciaviewsregisti, numregisti, sommapremiregisti, sommaviewsregisti, numattori, fasciapremialitaattori, fasciaviewsattori, sommapremiattori, sommaviewsattori INT;
        SET mediacritica = (SELECT AVG(R.Voto) FROM Recensionecritico R WHERE R.Film = _idfilm);
        SET mediautenti = (SELECT AVG(R.Voto) FROM Recensioneutente R WHERE R.Film = _idfilm);
        SET sommapesi = (SELECT sum(P.Peso) FROM Premio P WHERE P.Id IN (SELECT P1.Premio FROM PremiazioneFilm P1 WHERE P1.Film = _idfilm));
        SET visualizzazioni = (SELECT F.Visualizzazioni FROM Film F WHERE F.Id = _idfilm);
        SET numregisti = (SELECT COUNT(*) FROM Direzione D WHERE D.Film = _idfilm);
        SET sommapremiregisti = (SELECT SUM(P.Peso) FROM Premio P WHERE P.Id IN (SELECT P1.Premio FROM PremiazioneRegista P1 WHERE P1.Regista IN (SELECT D.Artista FROM Direzione D WHERE D.Film = _idfilm)));
        SET sommaviewsregisti = (SELECT SUM(A.Visualizzazioni) FROM (SELECT D.Artista, SUM(F.Visualizzazioni) AS Visualizzazioni FROM Direzione D INNER JOIN Film F ON D.Film = F.Id WHERE D.Artista IN (SELECT D.Artista FROM Direzione D WHERE D.Film = _idfilm) GROUP BY D.Artista) AS A);
        SET numattori = (SELECT COUNT(*) FROM Interpretazione I WHERE I.Film = _idfilm);
        SET sommapremiattori = (SELECT SUM(P.Peso) FROM Premio P WHERE P.Id IN (SELECT P1.Premio FROM PremiazioneAttore P1 WHERE P1.Attore IN (SELECT I.Artista FROM Interpretazione I WHERE I.Film = _idfilm)));
        SET sommaviewsattori = (SELECT SUM(A.Visualizzazioni) FROM (SELECT I.Artista, SUM(F.Visualizzazioni) AS Visualizzazioni FROM Interpretazione I INNER JOIN Film F ON I.Film = F.Id WHERE I.Artista IN (SELECT I.Artista FROM Interpretazione I WHERE I.Film = _idfilm) GROUP BY I.Artista) AS A);
        SET temp = sommapremiregisti/numregisti;
        IF temp < 20 THEN
			SET fasciapremialitaregisti = 0;
		ELSEIF temp >= 20 AND temp < 30 THEN
			SET fasciapremialitaregisti = 1;
		ELSEIF temp >= 30 AND temp < 40 THEN
			SET fasciapremialitaregisti = 2;
		ELSEIF temp >= 40 AND temp < 50 THEN
			SET fasciapremialitaregisti = 3;
		ELSEIF temp >= 50 AND temp < 60 THEN
			SET fasciapremialitaregisti = 4;
		ELSE
			SET fasciapremialitaregisti = 5;
		END IF;
        SET temp = sommaviewsregisti/numregisti;
        IF temp < 30000 THEN
			SET fasciaviewsregisti = 0;
		ELSEIF temp >= 30000 AND temp < 45000 THEN
			SET fasciaviewsregisti = 1;
		ELSEIF temp >= 45000 AND temp < 60000 THEN
			SET fasciaviewsregisti = 2;
		ELSEIF temp >= 60000 AND temp < 75000 THEN
			SET fasciaviewsregisti = 3;
		ELSEIF temp >= 75000 AND temp < 90000 THEN
			SET fasciaviewsregisti = 4;
		ELSE
			SET fasciaviewsregisti = 5;
		END IF;
        SET celebritaregisti = (fasciapremialitaregisti + fasciaviewsregisti)/2;
        
		SET temp = sommapremiattori/numattori;
        IF temp < 5 THEN
			SET fasciapremialitaattori = 0;
		ELSEIF temp >= 5 AND temp < 10 THEN
			SET fasciapremialitaattori = 1;
		ELSEIF temp >= 10 AND temp < 20 THEN
			SET fasciapremialitaattori = 2;
		ELSEIF temp >= 20 AND temp < 30 THEN
			SET fasciapremialitaattori = 3;
		ELSEIF temp >= 30 AND temp < 40 THEN
			SET fasciapremialitaattori = 4;
		ELSE
			SET fasciapremialitaattori = 5;
		END IF;
        SET temp = sommaviewsattori/numattori;
        IF temp < 40000 THEN
			SET fasciaviewsattori = 0;
		ELSEIF temp >= 40000 AND temp < 60000 THEN
			SET fasciaviewsattori = 1;
		ELSEIF temp >= 60000 AND temp < 80000 THEN
			SET fasciaviewsattori = 2;
		ELSEIF temp >= 80000 AND temp < 100000 THEN
			SET fasciaviewsattori = 3;
		ELSEIF temp >= 100000 AND temp < 120000 THEN
			SET fasciaviewsattori = 4;
		ELSE
			SET fasciaviewsattori = 5;
		END IF;
        SET celebritaattori = (fasciapremialitaattori + fasciaviewsattori)/2;
        
        IF sommapesi < 30 THEN
			SET fasciapremialita = 0;
		ELSEIF sommapesi >= 30 AND sommapesi < 50 THEN
			SET fasciapremialita = 1;
		ELSEIF sommapesi >= 50 AND sommapesi < 70 THEN
			SET fasciapremialita = 2;
		ELSEIF sommapesi >= 70 AND sommapesi < 90 THEN
			SET fasciapremialita = 3;
		ELSEIF sommapesi >= 90 AND sommapesi < 110 THEN
			SET fasciapremialita = 4;
		ELSE
			SET fasciapremialita = 5;
		END IF;
        
        IF visualizzazioni < 20000 THEN
			SET fasciaviews = 0;
		ELSEIF visualizzazioni >= 20000 AND visualizzazioni < 30000 THEN
			SET fasciaviews = 1;
		ELSEIF visualizzazioni >= 30000 AND visualizzazioni < 40000 THEN
			SET fasciaviews = 2;
		ELSEIF visualizzazioni >= 40000 AND visualizzazioni < 50000 THEN
			SET fasciaviews = 3;
		ELSEIF visualizzazioni >= 50000 AND visualizzazioni < 60000 THEN
			SET fasciaviews = 4;
		ELSE
			SET fasciaviews = 5;
		END IF;
        
		SET _rating = (mediacritica + 2*mediautenti + fasciapremialita + 4*fasciaviews + celebritaregisti + celebritaattori)/10;
    END $$
DELIMITER ;

-- -----------------------------------------------------
-- Operazione 6: Registrazione di un Utente
-- -----------------------------------------------------


DROP PROCEDURE IF EXISTS registrazione_utente;

DELIMITER $$

CREATE PROCEDURE registrazione_utente (IN _nome VARCHAR(255), _cognome VARCHAR(255), _email VARCHAR(255), _password VARCHAR(255), _nazionalita VARCHAR(45), _datanascita DATE, OUT _check BOOL)
	BEGIN
		DECLARE temp1, temp2, temp3 INT;
        SET temp1 = (SELECT COUNT(*) FROM utente U WHERE U.Email = _email);
        SET temp2 = (SELECT COUNT(*) FROM paese P WHERE P.Nome = _nazionalita);
        SET temp3 = 1 + (SELECT max(U.Codice) FROM utente);

        IF temp1 = 1 OR temp2 = 0 OR _datanascita > CURRENT_DATE THEN
			SET _check = FALSE;
		ELSE
			INSERT INTO Utente(Nome, Cognome, Email, Password, Nazionalita, DataNascita, Codice)
            VALUES (_nome, _cognome, _email, _password, _nazionalita, _datanascita, temp3);
            SET _check = TRUE;
		END IF;
    END $$
DELIMITER ;

-- -----------------------------------------------------
-- Operazione 7: Sottoscrizione del Servizio da parte di un utente
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sottoscrizione_servizio;

DELIMITER $$

CREATE PROCEDURE sottoscrizione_servizio (IN _codice INT, _abbonamento VARCHAR(45), _numero BIGINT, _cvv INT, _nome VARCHAR(255), _cognome VARCHAR(255), _mese INT, _anno INT, OUT _check BOOL)
	BEGIN
		DECLARE temp1, temp2, etautente, etamin INT;
        DECLARE datanascita DATE;
        SET datanascita = (SELECT U.DataNascita FROM utente U WHERE U.Codice = _codice);
        SET temp1 = (SELECT COUNT(*) FROM abbonamento A WHERE A.Nome = _abbonamento);
        SET temp2 = (SELECT COUNT(*) FROM restrizioneabbonamento R WHERE R.Abbonamento = _abbonamento AND R.Paese = (SELECT Nazionalita FROM utente U WHERE U.Codice = _codice));
        SET etamin = (SELECT A.EtaMinima FROM abbonamento A WHERE A.Nome = _abbonamento);
        SET etautente = YEAR(CURRENT_DATE) - YEAR(datanascita);
        IF temp1 = 0 OR temp2 = 1 OR _numero < 1000000000000000 OR _numero > 9999999999999999 OR _cvv < 100 OR _cvv > 999 OR _mese < 1 OR _mese > 12 OR _anno < YEAR(CURRENT_DATE) OR (_anno = YEAR(CURRENT_DATE) AND _mese <= MONTH(CURRENT_DATE)) OR etautente < etamin THEN
			SET _check = FALSE;
		ELSE
			UPDATE Utente U
            SET U.Abbonamento = _abbonamento, U.CartaDiCredito = _numero
            WHERE U.Codice = _codice;
			INSERT INTO cartadicredito
            VALUES (_numero, _cvv, _nome, _cognome, _mese, _anno);
            SET _check = TRUE;
		END IF;
    END $$
DELIMITER ;

-- -----------------------------------------------------
-- Operazione 8: Emissione di una Fattura
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS emissione_fattura;

DELIMITER $$

CREATE PROCEDURE emissione_fattura(in _utente int, out _check tinyint(1))
begin
    DECLARE abbonamento VARCHAR(45);
    DECLARE carta_di_credito BIGINT;
    DECLARE mese_scadenza INT;
    DECLARE anno_scadenza INT;
    DECLARE max_id INT;
    -- recuperiamo i dati di abbonamento e carta di credito associati all'utente
    select Nome, CartaDiCredito from plz.utente where Codice=_utente into abbonamento, carta_di_credito;
    -- verifichiamo che la carta di credito non sia scaduta
    select MeseScadenza, AnnoScadenza from cartadicredito where Numero=carta_di_credito into mese_scadenza, anno_scadenza;
    if anno_scadenza<year(current_date) or (anno_scadenza=year(current_date)and mese_scadenza<month(current_date))
        then set _check=false;
    else
        select max(Id) from fattura into max_id;
        insert into fattura values(max_id+1, null, current_date+interval 30 day, current_date, _utente, carta_di_credito, abbonamento);
        set _check = true;
    end if;
end $$

DELIMITER ;

-- -----------------------------------------------------
-- Operazione 12: Lingue per tempo di fruizione, come audio e come sottotitoli
-- -----------------------------------------------------


DROP PROCEDURE IF EXISTS lingue_analytics;

DELIMITER $$

CREATE PROCEDURE lingue_analytics()
BEGIN
with fruizione_trimestre_precedente_sottotitoli as(
        select Lingua, sum(timediff( Fine, Inizio)) as sottotitoli_prec
        from erogazione natural join sottotitoli s
        where erogazione.Inizio +interval 3 month < current_date
        and erogazione.inizio + interval 6 month >= current_date
        group by Lingua
        ),
    fruizione_trimestre_precedente_audio as (
        select c.LinguaAudio as Lingua, sum(timediff(e.Fine, e.Inizio)) as audio_prec
        from erogazione e inner join contenuto c on e.Contenuto = c.Id
        where e.Inizio +interval 3 month < current_date
        and e.inizio + interval 6 month >= current_date
        and c.LinguaAudio is not null
        group by  c.LinguaAudio
        ),
    fruizione_trimestre_attuale_sottotitoli as(
        select Lingua, sum(timediff(Fine, Inizio)) as sottotitoli_attuali
        from erogazione natural join sottotitoli s
        where erogazione.Inizio +interval 3 month >= current_date
        and erogazione.Fine is not null
        group by Lingua
        ),
    fruizione_trimestre_attuale_audio as (
        select c.LinguaAudio as Lingua, sum(timediff(e.Fine, e.Inizio)) as audio_attuale
        from erogazione e inner join contenuto c on e.Contenuto = c.Id
        where e.Inizio +interval 3 month >= current_date
        and e.Fine is not null
        and c.LinguaAudio is not null
        group by  c.LinguaAudio)
    select Lingua, sottotitoli_attuali/3600 as ore_riproduzione_sottotitoli, audio_attuale/3600 as ore_riproduzione_audio,
           (sottotitoli_attuali/sottotitoli_prec -1)*100 as incremento_percentuale_sottotitoli, ((audio_attuale/audio_prec) -1)*100 as incremento_percentuale_audio from
    fruizione_trimestre_attuale_audio
    natural  join fruizione_trimestre_attuale_sottotitoli
    natural join fruizione_trimestre_precedente_audio
    natural join fruizione_trimestre_precedente_sottotitoli;
END $$








-- -----------------------------------------------------
-- Operazione 14: Fine Erogazione
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS fine_erogazione;

DELIMITER $$

CREATE PROCEDURE fine_erogazione (IN _id INT, _fine DATETIME)
	BEGIN
		UPDATE Erogazione E
        SET E.Fine = _fine
        WHERE E.Id = _id;
    END $$
DELIMITER ;


