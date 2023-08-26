USE plz;
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
