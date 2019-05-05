
------------ Archivace založená na spouštěčích (triggers) --------------

CREATE TABLE archive_orders (LIKE orders) PARTITION BY RANGE (orderdate);
CREATE TABLE archive_orderlines (LIKE orderlines) PARTITION BY RANGE (orderdate);

---------------- Aktuálni rozdelení archivu -----------------

CREATE TABLE archive_orders2004_0101_0201 partition of archive_orders for values from ('2004-01-01') to ('2004-02-01');
CREATE TABLE archive_orders2004_0201_0301 partition of archive_orders for values from ('2004-02-01') to ('2004-03-01');
CREATE TABLE archive_orders2004_0301_0401 partition of archive_orders for values from ('2004-03-01') to ('2004-04-01');
CREATE TABLE archive_orders2004_0401_0501 partition of archive_orders for values from ('2004-04-01') to ('2004-05-01');
CREATE TABLE archive_orders2004_0501_0601 partition of archive_orders for values from ('2004-05-01') to ('2004-06-01');
CREATE TABLE archive_orders2004_0601_0701 partition of archive_orders for values from ('2004-06-01') to ('2004-07-01');
CREATE TABLE archive_orders2004_0701_0801 partition of archive_orders for values from ('2004-07-01') to ('2004-08-01');
CREATE TABLE archive_orders2004_0801_0901 partition of archive_orders for values from ('2004-08-01') to ('2004-09-01');
CREATE TABLE archive_orders2004_0901_1001 partition of archive_orders for values from ('2004-09-01') to ('2004-10-01');
CREATE TABLE archive_orders2004_1001_1101 partition of archive_orders for values from ('2004-10-01') to ('2004-11-01');
CREATE TABLE archive_orders2004_1101_1201 partition of archive_orders for values from ('2004-11-01') to ('2004-12-01');
CREATE TABLE archive_orders2004_1201_0101 partition of archive_orders for values from ('2004-12-01') to ('2005-01-01');

-- =======

CREATE TABLE archive_orderlines2004_0101_0201 partition of archive_orderlines for values from ('2004-01-01') to ('2004-02-01');
CREATE TABLE archive_orderlines2004_0201_0301 partition of archive_orderlines for values from ('2004-02-01') to ('2004-03-01');
CREATE TABLE archive_orderlines2004_0301_0401 partition of archive_orderlines for values from ('2004-03-01') to ('2004-04-01');
CREATE TABLE archive_orderlines2004_0401_0501 partition of archive_orderlines for values from ('2004-04-01') to ('2004-05-01');
CREATE TABLE archive_orderlines2004_0501_0601 partition of archive_orderlines for values from ('2004-05-01') to ('2004-06-01');
CREATE TABLE archive_orderlines2004_0601_0701 partition of archive_orderlines for values from ('2004-06-01') to ('2004-07-01');
CREATE TABLE archive_orderlines2004_0701_0801 partition of archive_orderlines for values from ('2004-07-01') to ('2004-08-01');
CREATE TABLE archive_orderlines2004_0801_0901 partition of archive_orderlines for values from ('2004-08-01') to ('2004-09-01');
CREATE TABLE archive_orderlines2004_0901_1001 partition of archive_orderlines for values from ('2004-09-01') to ('2004-10-01');
CREATE TABLE archive_orderlines2004_1001_1101 partition of archive_orderlines for values from ('2004-10-01') to ('2004-11-01');
CREATE TABLE archive_orderlines2004_1101_1201 partition of archive_orderlines for values from ('2004-11-01') to ('2004-12-01');
CREATE TABLE archive_orderlines2004_1201_0101 partition of archive_orderlines for values from ('2004-12-01') to ('2005-01-01');

---------------------------------------------------


CREATE OR REPLACE FUNCTION archive_on_delete_orders() RETURNS trigger 
AS $$
BEGIN 
      IF NOT EXISTS (SELECT 1 FROM archive_orders WHERE archive_orders.orderid = OLD.orderid) THEN
            INSERT INTO archive_orders VALUES((OLD).*) ;
      END IF;
      RETURN OLD;
END
$$ LANGUAGE plpgsql; 

CREATE TRIGGER archive_deleted_rows_orders 
AFTER DELETE ON orders 
FOR EACH ROW EXECUTE PROCEDURE archive_on_delete_orders();


CREATE OR REPLACE FUNCTION archive_on_delete_orderlines() RETURNS trigger 
AS $$
BEGIN 
      IF NOT EXISTS (SELECT 1 FROM archive_orderlines WHERE archive_orderlines.orderid = OLD.orderid AND archive_orderlines.orderlineid = OLD.orderlineid ) THEN
            INSERT INTO archive_orderlines VALUES((OLD).*) ;
      END IF;
      RETURN OLD;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_deleted_rows_orderlines 
AFTER DELETE ON orderlines 
FOR EACH ROW EXECUTE PROCEDURE archive_on_delete_orderlines();

---------------------------------------------------

CREATE OR REPLACE FUNCTION archive_on_insert_orders() RETURNS trigger
AS $$
BEGIN 
      IF NOT EXISTS (SELECT 1 FROM archive_orders WHERE archive_orders.orderid = NEW.orderid) THEN
            INSERT INTO archive_orders VALUES((NEW).*);
      END IF;
      RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_inserted_rows_orders 
BEFORE INSERT ON orders 
FOR EACH ROW EXECUTE PROCEDURE archive_on_insert_orders();


CREATE OR REPLACE FUNCTION archive_on_insert_orderlines() RETURNS trigger
AS $$
BEGIN 
      IF NOT EXISTS (SELECT 1 FROM archive_orderlines WHERE archive_orderlines.orderid = NEW.orderid AND archive_orderlines.orderlineid = NEW.orderlineid) THEN
            INSERT INTO archive_orderlines VALUES((NEW).*);
      END IF;
      RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_inserted_rows_orderlines 
BEFORE INSERT ON orderlines 
FOR EACH ROW EXECUTE PROCEDURE archive_on_insert_orderlines();

------------------------------------------------

CREATE OR REPLACE FUNCTION archive_on_update_orders() RETURNS trigger
AS $$
BEGIN
  IF (
    OLD.orderdate IS DISTINCT FROM NEW.orderdate OR
    OLD.customerid IS DISTINCT FROM NEW.customerid OR
    OLD.netamount IS DISTINCT FROM NEW.netamount OR
    OLD.tax IS DISTINCT FROM NEW.tax OR
    OLD.totalamount IS DISTINCT FROM NEW.totalamount
     ) THEN
    UPDATE archive_orders SET
        orderdate = NEW.orderdate,
        customerid = NEW.customerid,
        netamount = NEW.netamount,
        tax = NEW.tax, 
        totalamount = NEW.totalamount 
    WHERE archive_orders.orderid = NEW.orderid;
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_archived_rows_orders 
BEFORE UPDATE ON orders 
FOR EACH ROW EXECUTE PROCEDURE archive_on_update_orders();


CREATE OR REPLACE FUNCTION archive_on_update_orderlines() RETURNS trigger
AS $$
BEGIN
  IF (
    OLD.orderid IS DISTINCT FROM NEW.orderid OR
    OLD.prod_id IS DISTINCT FROM NEW.prod_id OR
    OLD.quantity IS DISTINCT FROM NEW.quantity OR
    OLD.orderdate IS DISTINCT FROM NEW.orderdate
     ) THEN
    UPDATE archive_orderlines SET
        prod_id = NEW.prod_id,
        quantity = NEW.quantity, 
        orderdate = NEW.orderdate 
    WHERE archive_orderlines.orderlineid = NEW.orderlineid AND archive_orders.orderid = NEW.orderid;
  END IF;
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_archived_rows_orderlines 
BEFORE UPDATE ON orderlines 
FOR EACH ROW EXECUTE PROCEDURE archive_on_update_orderlines();

------------ Automatická archivace --------------

CREATE OR REPLACE FUNCTION archive() RETURNS VOID
AS $$
BEGIN

WITH orderlines_rows_to_archive AS (
    DELETE FROM orderlines a
    WHERE orderdate < current_timestamp - interval '3 month' 
    RETURNING a.*
)
INSERT INTO archive_orderlines
SELECT DISTINCT * FROM orderlines_rows_to_archive WHERE orderlines_rows_to_archive.orderlineid NOT IN (select orderlineid from archive_orderlines) AND orderlines_rows_to_archive.orderid NOT IN (select orderid from archive_orderlines);

WITH orders_rows_to_archive AS (
    DELETE FROM orders a
    WHERE orderdate < current_timestamp - interval '3 month' 
    RETURNING a.*
)
INSERT INTO archive_orders
SELECT DISTINCT * FROM orders_rows_to_archive WHERE orders_rows_to_archive.orderid NOT IN (select orderid from archive_orders);

END;
$$ LANGUAGE plpgsql;

---------------- Obnovení -----------------------

CREATE OR REPLACE FUNCTION restore(a date,b date) RETURNS VOID
AS $$
BEGIN
insert into orders select * from archive_orders WHERE orderdate BETWEEN a AND b;
insert into orderlines select * from archive_orderlines WHERE orderdate BETWEEN a AND b;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION restore_order_by_id(a integer) RETURNS VOID
AS $$
BEGIN
insert into orders select * from archive_orders WHERE orderid=a;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION restore_orderline_by_id(a integer) RETURNS VOID
AS $$
BEGIN
insert into orderlines select * from archive_orderlines WHERE orderid=a;
END;
$$ LANGUAGE plpgsql;

---------------- Dělení archivu -----------------

CREATE OR REPLACE FUNCTION partition_archive() RETURNS void AS $$
BEGIN
    EXECUTE 'CREATE TABLE archive_orders' ||
            to_char(current_timestamp + interval '1 month', 'YYYY_MM01')  ||
            to_char(current_timestamp + interval '2 month', '_MM01')  ||
            ' partition of archive_orders for values from '  ||
            to_char(current_timestamp + interval '1 month', '(''YYYY-MM-01'')')  ||
            ' to ' ||
            to_char(current_timestamp + interval '2 month', '(''YYYY-MM-01'');');
    EXECUTE 'CREATE TABLE archive_orderlines' ||
            to_char(current_timestamp + interval '1 month', 'YYYY_MM01')  ||
            to_char(current_timestamp + interval '2 month', '_MM01')  ||
            ' partition of archive_orderlines for values from '  ||
            to_char(current_timestamp + interval '1 month', '(''YYYY-MM-01'')')  ||
            ' to ' ||
            to_char(current_timestamp + interval '2 month', '(''YYYY-MM-01'');');
END;
$$ LANGUAGE PLPGSQL;
