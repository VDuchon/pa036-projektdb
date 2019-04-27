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

