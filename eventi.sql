-- Lorenzo Leoncini, Giulio Zingrillo. Progetto di Basi di Dati 2023

-- Questo script implementa gli eventi necessari al funzionamento del database.


USE plz;


-- -----------------------------------------------------
-- Rinnova abbonamento, parte dell'operazione 8
-- -----------------------------------------------------

drop event if exists rinnova_abbonamento;
create event rinnova_abbonamento
on schedule every 1 day starts '2023-09-30 03:00:00' do
begin
    declare _user int;
    declare _abbonamento varchar(45);
    declare _durata int;
    declare _inizio date;
    declare _check tinyint(1);
    declare _fine tinyint(1);
    declare c cursor for select Codice from plz.utente where day(utente.Inizio)=day(current_date);
    declare continue handler for not found set _fine = 1;
    set _fine = 0;
    scan: loop
        fetch c into _user;
        select Abbonamento, Inizio from utente where Codice = _user into _abbonamento, _inizio;
        select Durata from abbonamento where Nome = _abbonamento;
        if _inizio + interval _durata month > current_date
            then update utente set Abbonamento=null, Inizio=null where Codice=_user;
        else
            call emissione_fattura(_user, _check);
        end if;
        if _fine=1
            then leave scan;
        end if;
    end loop;
end;
