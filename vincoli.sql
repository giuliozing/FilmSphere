-- Artista(Attore) e Artista(Regista) non possono essere entrambi nulli;
DROP TRIGGER IF EXISTS artista_o_regista;
CREATE TRIGGER artista_o_regista
BEFORE INSERT ON Artista
