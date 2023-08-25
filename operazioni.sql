USE plz;
DROP PROCEDURE IF EXISTS registrazione_utente;

DELIMITER $$

CREATE PROCEDURE registrazione_utente(IN _nome VARCHAR(255), _cognome VARCHAR(255), _email VARCHAR(255), _password VARCHAR(255), _nazionalita VARCHAR(45), OUT _check BOOL)
	BEGIN
		DECLARE temp1, temp2 INT;
        SET temp1 = (SELECT COUNT(*) FROM Utente U WHERE U.Email = _email);
        SET temp2 = (SELECT COUNT(*) FROM Paese P WHERE P.Nome = _nazionalita);
        IF temp1 = 1 OR temp2 = 0 THEN
			SET _check = FALSE;
		ELSE
			INSERT INTO Utente(Nome, Cognome, Email, Password, Nazionalita)
            VALUES (_nome, _cognome, _email, _password, _nazionalita);
            SET _check = TRUE;
		END IF;
    END $$
DELIMITER ;
