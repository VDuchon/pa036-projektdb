CREATE OR REPLACE FUNCTION example() RETURNS void AS $$
BEGIN
    EXECUTE 'CREATE TABLE someNewTable' || 
            to_char(current_timestamp, 'YYYYMMDDHHMMSS')  || 
            '(col1 integer, col2 integer);';
END;
$$ LANGUAGE PLPGSQL;
