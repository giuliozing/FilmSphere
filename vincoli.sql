-- Artista(Attore) e Artista(Regista) non possono essere entrambi nulli;
DROP TRIGGER IF EXISTS artista_o_regista;

DELIMITER $$

CREATE TRIGGER artista_o_regista
BEFORE INSERT ON Artista FOR EACH ROW
IF NEW.Attore == NULL AND NEW.Regista == NULL THEN
  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Attore e Regista non possono essere entrambi nulli'
END IF

END $$
DELIMITER;

-- La data definita dagli attributi CartaDiCredito(Mese) e CartaDiCredito(Anno) deve essere futura
DROP TRIGGER IF EXISTS data_carta_futura;

DELIMITER $$

CREATE TRIGGER data_carta_futura
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
IF NEW.Anno < YEAR(CURRENT_DATE) OR (NEW.Anno == YEAR(CURRENT_DATE) AND NEW.Mese <= MONTH(CURRENT_DATE)) THEN
  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Carta Scaduta'
END IF

END $$
DELIMITER;

-- Paese(InizioIP) deve essere minore di Paese(FineIP)
DROP TRIGGER IF EXISTS ip_paese;

DELIMITER $$

CREATE TRIGGER ip_paese
BEFORE INSERT ON Paese FOR EACH ROW
IF NEW.InizioIP >= NEW.FineIP THEN
  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Paese(InizioIP) deve essere minore di Paese(FineIP)'
END IF

END $$
DELIMITER;
