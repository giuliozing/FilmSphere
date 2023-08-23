USE plz;
-- Vincoli intrarelazionali di dominio
-- Numero Carta di Credito
DROP TRIGGER IF EXISTS numero_carta;

DELIMITER $$

CREATE TRIGGER numero_carta
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
BEGIN
  IF NEW.Numero < 1000000000000000 OR NEW.Numero > 9999999999999999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Numero Carta di Credito non valido'
  END IF

END 
DELIMITER $$;

-- CVV Carta di Credito
DROP TRIGGER IF EXISTS cvv_carta;

DELIMITER $$

CREATE TRIGGER cvv_carta
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
BEGIN
  IF NEW.CVV < 100 OR NEW.CVV > 999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'CVV Carta di Credito non valido'
  END IF

END 
DELIMITER $$;

-- Mese di Scadenza Carta di Credito
DROP TRIGGER IF EXISTS mesescadenza_carta;

DELIMITER $$

CREATE TRIGGER mesescadenza_carta
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
BEGIN
  IF NEW.MeseScadenza < 1 OR NEW.MeseScadenza > 12 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Mese di Scadenza Carta di Credito non valido'
  END IF

END 
DELIMITER $$;

-- Anno di Scadenza Carta di Credito
DROP TRIGGER IF EXISTS annoscadenza_carta;

DELIMITER $$

CREATE TRIGGER annoscadenza_carta
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
BEGIN
  IF NEW.AnnoScadenza < 2023 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Mese di Scadenza Carta di Credito non valido'
  END IF

END 
DELIMITER $$;

-- IP Connessione
DROP TRIGGER IF EXISTS ip_connessione;

DELIMITER $$

CREATE TRIGGER ip_connessione
BEFORE INSERT ON Connessione FOR EACH ROW
BEGIN
  IF NEW.IP < 0 OR NEW.IP > 255255255255 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'IP non valido'
  END IF

END 
DELIMITER $$;

-- Carta di Credito della Fattura
DROP TRIGGER IF EXISTS carta_fattura;

DELIMITER $$

CREATE TRIGGER carta_fattura
BEFORE INSERT ON Fattura FOR EACH ROW
BEGIN
  IF NEW.CartaDiCredito < 1000000000000000 OR NEW.CartaDiCredito > 9999999999999999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Numero Carta di Credito non valido'
  END IF

END 
DELIMITER $$;

-- Anno Film
DROP TRIGGER IF EXISTS anno_film;

DELIMITER $$

CREATE TRIGGER anno_film
BEFORE INSERT ON Film FOR EACH ROW
BEGIN
  IF NEW.Anno < 1900 OR NEW.Anno > YEAR(CURRENT_DATE) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Anno non valido'
  END IF

END 
DELIMITER $$;

-- Valore di importanza
DROP TRIGGER IF EXISTS valore_importanza;

DELIMITER $$

CREATE TRIGGER valore_importanza
BEFORE INSERT ON Importanza FOR EACH ROW
BEGIN
  IF NEW.Valore < 1 OR NEW.Valore > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Valore di importanza non valido'
  END IF

END 
DELIMITER $$;

-- Inizio IP Paese
DROP TRIGGER IF EXISTS inizioip_paese;

DELIMITER $$

CREATE TRIGGER inizioip_paese
BEFORE INSERT ON Paese FOR EACH ROW
BEGIN
  IF NEW.InzioIP < 0 OR NEW.InizioIP > 255255255255 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'IP non valido'
  END IF

END 
DELIMITER $$;

-- Fine IP Paese
DROP TRIGGER IF EXISTS fineip_paese;

DELIMITER $$

CREATE TRIGGER fineip_paese
BEFORE INSERT ON Paese FOR EACH ROW
BEGIN
  IF NEW.FineIP < 0 OR NEW.FineIP > 255255255255 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'IP non valido'
  END IF

END 
DELIMITER $$;

-- Peso del Premio
DROP TRIGGER IF EXISTS peso_premio;

DELIMITER $$

CREATE TRIGGER peso_premio
BEFORE INSERT ON Premio FOR EACH ROW
BEGIN
  IF NEW.Peso < 0 OR NEW.Peso > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Peso non valido'
  END IF

END 
DELIMITER $$;

-- Voto recensione del critico
DROP TRIGGER IF EXISTS voto_recensionecritico;

DELIMITER $$

CREATE TRIGGER voto_recensionecritico
BEFORE INSERT ON RecensioneCritico FOR EACH ROW
BEGIN
  IF NEW.Voto < 1 OR NEW.Voto > 5 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Voto non valido'
  END IF

END 
DELIMITER $$;

-- Voto recensione dell'utente
DROP TRIGGER IF EXISTS voto_recensioneutente;

DELIMITER $$

CREATE TRIGGER voto_recensioneutente
BEFORE INSERT ON RecensioneUtente FOR EACH ROW
BEGIN
  IF NEW.Voto < 1 OR NEW.Voto > 5 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Voto non valido'
  END IF

END 
DELIMITER $$;

-- Jitter del Server
DROP TRIGGER IF EXISTS jitter_server;

DELIMITER $$

CREATE TRIGGER jitter_server
BEFORE INSERT ON Server FOR EACH ROW
BEGIN
  IF NEW.Jitter < 1 OR NEW.Jitter > 10 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Jitter non valido'
  END IF

END 
DELIMITER $$;

-- Carta di Credito dell'Utente
DROP TRIGGER IF EXISTS carta_utente;

DELIMITER $$

CREATE TRIGGER carta_utente
BEFORE INSERT ON Utente FOR EACH ROW
BEGIN
  IF NEW.CartaDiCredito < 1000000000000000 OR NEW.CartaDiCredito > 9999999999999999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Numero Carta di Credito non valido'
  END IF

END 
DELIMITER $$;

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

END 
DELIMITER $$;

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

END 
DELIMITER $$;

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

END 
DELIMITER $$;

-- Premio(Attore), Premio(Film), Premio(Regista) non possono essere tutti nulli
DROP TRIGGER IF EXISTS premio;

DELIMITER $$

CREATE TRIGGER premio
BEFORE INSERT ON Premio FOR EACH ROW
BEGIN
  IF NEW.Attore == NULL AND NEW.Film == NULL AND NEW.Regista == NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Premio(Attore), Premio(Film), Premio(Regista) non possono essere tutti nulli'
  END IF

END 
DELIMITER $$;

-- Altri vincoli interrelazionali
-- Un Artista può comparire nella tabella Interpretazione solo se il suo attributo Attore vale 1
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

END 
DELIMITER $$;

-- Un Artista può comparire nella tabella Direzione solo se il suo attributo Regista vale 1
DROP TRIGGER IF EXISTS direzione_regista_1;

DELIMITER $$

CREATE TRIGGER direzione_regista_1
BEFORE INSERT ON Direzione FOR EACH ROW
BEGIN
  DECLARE artista INT DEFAULT 0;
  SET artista = 
    (SELECT A.Regista
     FROM Artista A
     WHERE A.Id = NEW.Artista
    );
  IF artista == 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Artista può comparire nella tabella Direzione solo se il suo attributo Regista vale 1'
  END IF

END 
DELIMITER $$;

-- Un Artista può comparire nella tabella PremiazioneAttore solo se il suo attributo Attore vale 1
DROP TRIGGER IF EXISTS premiazione_attore_attore_1;

DELIMITER $$

CREATE TRIGGER premiazione_attore_attore_1
BEFORE INSERT ON PremiazioneAttore FOR EACH ROW
BEGIN
  DECLARE artista INT DEFAULT 0;
  SET artista = 
    (SELECT A.Attore
     FROM Artista A
     WHERE A.Id = NEW.Artista
    );
  IF artista == 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Artista può comparire nella tabella PremiazioneAttore solo se il suo attributo Attore vale 1'
  END IF

END 
DELIMITER $$;

-- Un Premio può comparire nella tabella PremiazioneAttore solo se il suo attributo Attore vale 1
DROP TRIGGER IF EXISTS premiazione_attore_premio_1;

DELIMITER $$

CREATE TRIGGER premiazione_attore_premio_1
BEFORE INSERT ON PremiazioneAttore FOR EACH ROW
BEGIN
  DECLARE premio INT DEFAULT 0;
  SET premio = 
    (SELECT P.Attore
     FROM Premio P
     WHERE P.Id = NEW.Premio
    );
  IF premio == 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Premio può comparire nella tabella PremiazioneAttore solo se il suo attributo Attore vale 1'
  END IF

END 
DELIMITER $$;

-- Un Premio può comparire nella tabella PremiazioneFilm solo se il suo attributo Film vale 1
DROP TRIGGER IF EXISTS premiazione_film_1;

DELIMITER $$

CREATE TRIGGER premiazione_film_1
BEFORE INSERT ON PremiazioneFilm FOR EACH ROW
BEGIN
  DECLARE premio INT DEFAULT 0;
  SET premio = 
    (SELECT P.Film
     FROM Premio P
     WHERE P.Id = NEW.Premio
    );
  IF premio == 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Premio può comparire nella tabella PremiazioneFilm solo se il suo attributo Film vale 1'
  END IF

END 
DELIMITER $$;

-- Un Artista può comparire nella tabella PremiazioneRegista solo se il suo attributo Regista vale 1
DROP TRIGGER IF EXISTS premiazione_regista_regista_1;

DELIMITER $$

CREATE TRIGGER premiazione_regista_regista_1
BEFORE INSERT ON PremiazioneRegista FOR EACH ROW
BEGIN
  DECLARE artista INT DEFAULT 0;
  SET artista = 
    (SELECT A.Regista
     FROM Artista A
     WHERE A.Id = NEW.Artista
    );
  IF artista == 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Artista può comparire nella tabella PremiazioneRegista solo se il suo attributo Regista vale 1'
  END IF

END 
DELIMITER $$;

-- Un Premio può comparire nella tabella PremiazioneRegista solo se il suo attributo Regista vale 1
DROP TRIGGER IF EXISTS premiazione_regista_premio_1;

DELIMITER $$

CREATE TRIGGER premiazione_regista_premio_1
BEFORE INSERT ON PremiazioneRegista FOR EACH ROW
BEGIN
  DECLARE premio INT DEFAULT 0;
  SET premio = 
    (SELECT P.Regista
     FROM Premio P
     WHERE P.Id = NEW.Premio
    );
  IF premio == 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Premio può comparire nella tabella PremiazioneRegista solo se il suo attributo Regista vale 1'
  END IF

END 
DELIMITER $$;





