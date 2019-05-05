CREATE TABLE archive_orderlines (
    orderlineid integer NOT NULL,
    orderid integer NOT NULL,
    prod_id integer NOT NULL,
    quantity smallint NOT NULL,
    orderdate date NOT NULL
) PARTITION BY RANGE (orderdate);


CREATE TABLE archive_orders (
    orderid serial NOT NULL,
    orderdate date NOT NULL,
    customerid integer,
    netamount numeric(12,2) NOT NULL,
    tax numeric(12,2) NOT NULL,
    totalamount numeric(12,2) NOT NULL
) PARTITION BY RANGE (orderdate);
