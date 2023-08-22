-- Vincoli intrarelazionali di n-upla
-- Artista(Attore) e Artista(Regista) non possono essere entrambi nulli;
DROP TRIGGER IF EXISTS artista_o_regista;

DELIMITER $$

CREATE TRIGGER artista_o_regista
BEFORE INSERT ON Artista FOR EACH ROW
BEGIN
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
BEGIN
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
BEGIN
  IF NEW.InizioIP >= NEW.FineIP THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Paese(InizioIP) deve essere minore di Paese(FineIP)'
  END IF

END $$
DELIMITER;

--Premio(Attore), Premio(Film), Premio(Regista) non possono essere tutti nulli
DROP TRIGGER IF EXISTS premio;

DELIMITER $$

CREATE TRIGGER premio
BEFORE INSERT ON Premio FOR EACH ROW
BEGIN
  IF NEW.Attore == NULL AND NEW.Film == NULL AND NEW.Regista == NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Premio(Attore), Premio(Film), Premio(Regista) non possono essere tutti nulli'
  END IF

END $$
DELIMITER;

--Altri vincoli interrelazionali
--Un Artista può comparire nella tabella Interpretazione solo se il suo attributo Attore vale 1
DROP TRIGGER IF EXISTS interpretazione_artista_1;

DELIMITER $$

CREATE TRIGGER interpretazione_artista_1
BEFORE INSERT ON Interpretazione FOR EACH ROW
BEGIN
  DECLARE artista INT DEFAULT 0;
  SET artista = 
    (SELECT A.Attore
     FROM Artista A
     WHERE A.Id = NEW.Artista
    );
  IF artista == 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Artista può comparire nella tabella Interpretazione solo se il suo attributo Attore vale 1'
  END IF

END $$
DELIMITER;















