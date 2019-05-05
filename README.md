# pa036-projektdb
## === Spustanie skriptov pomocou conrtabu ===

editovanie zaznamov v crotnabe (-e -> edit):
```sh
$ crontab -e
```

zobrazenie crontabu (-l -> list):
```sh
$ crontab -l
```

zaznami v crontabe maju format:
```<kedy> <linux-command>```

pre formatoanie <kedy> pozri stranku [crontab.guru](https://crontab.guru/)

## === Prikaz na spustanie skriptov na databaze ===

v domovskom adresari je potrebne vytvorit subor .pgpass
```sh
$ vim ~/.pgpass
```

donho vlozit riadok formatu:

```<db-server>:<port>:<db-name>:<db-username>:<db-password>```
e.g.

```db.fi.muni.cz:5432:pgdb:xduchon1:mojeuplnesupertajnehesloktorenemaniktosancizistit```

ak to mate spravne nastavene tak prihlasovanie do db by od vas uz nemalo pytat heslo

prikaz na spustanie skriptu vyzera napr.:
```sh
$ psql -h db.fi.muni.cz -d pgdb -U xduchon1 -f ~/projekt-db/execute_example.sql
```

teda format:
```sh
$ psql -h <hostname-aka-db-server> -d <database-aka-db-name> -U <username> -f <file-to-execute>
```

## === Popis skriptov ===

1-create_db_dellstore2-normal-1.0.sql -> vytvara databazu aj s datami, spusta sa ako prvy

2-create-all-functions-and-triggers.sql -> vytvara vsetky potrebne tabulky, funkcie a triggre pre archivaciu

execute_archivation.sql a execute_partition_archive.sql -> skripty pre crontab ktore spustaju funkciu archivacie a vytvarania tabulky archivu na nasledujuci mesiac

enable/disable_insert/update/delete_triggers.sql  -> vypinanie a zapinanie triggerov
