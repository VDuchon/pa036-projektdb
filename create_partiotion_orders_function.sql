CREATE OR REPLACE FUNCTION partition_orders() RETURNS void AS $$
BEGIN
    EXECUTE 'CREATE TABLE orders' ||
            to_char(current_timestamp + interval '1 month', 'YYYY_MM01')  ||
            to_char(current_timestamp + interval '2 month', '_MM01')  ||
            ' partition of orders for values from '  ||
            to_char(current_timestamp + interval '1 month', '(''YYYY-MM-01'')')  ||
            ' to ' ||
            to_char(current_timestamp + interval '2 month', '(''YYYY-MM-01'');');           
END;
$$ LANGUAGE PLPGSQL;
