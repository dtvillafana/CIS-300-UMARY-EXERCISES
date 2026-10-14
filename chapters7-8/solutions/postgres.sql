-- POSTGRESQL ONLY. After postgres/setup.sql and both worked companions.
-- PA1/PA2: paper-only templates; no real permission/account changes.
-- CREATE SCHEMA lab_namespace AUTHORIZATION CURRENT_USER
--     CREATE TABLE LAB_NAMESPACE_DEMO (ID INTEGER PRIMARY KEY);
-- GRANT USAGE ON SCHEMA public TO an_existing_analyst;
-- GRANT SELECT ON LAB_PRODUCT TO an_existing_analyst;
-- REVOKE SELECT ON LAB_PRODUCT FROM an_existing_analyst;
-- REVOKE USAGE ON SCHEMA public FROM an_existing_analyst;
-- A database contains schemas; roles can own multiple schemas. Schema USAGE
-- and table SELECT are distinct. Role/PUBLIC inheritance can retain access.

-- PA3: empty ALL true/ANY false. NULL ALL has no true result; ANY may be
-- decisive true from 30. MAX/MIN rewrites lose these edge semantics.
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE > ALL (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 40);
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE > SOME (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 40);
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE > ALL (VALUES (30), (NULL::NUMERIC));
SELECT P_CODE FROM LAB_PRODUCT
WHERE P_PRICE > ANY (VALUES (30), (NULL::NUMERIC));
-- PA4
SELECT POWER(2, 3), DATE '2026-10-11' - DATE '2026-10-01',
       TO_NUMBER('19.95', '99.99'), CAST('19.95' AS DECIMAL(8, 2));
SELECT ABS(-7), ROUND(19.956, 2), SIN(0), LN(1);
SELECT P_CODE, EXTRACT(YEAR FROM P_INDATE), P_INDATE + 10,
       TO_CHAR(P_INDATE, 'YYYY-MM-DD') FROM LAB_PRODUCT ORDER BY P_CODE;
-- PA5: PostgreSQL EXCEPT corresponds to the slides' Oracle MINUS.
SELECT P_CODE FROM LAB_PRODUCT WHERE V_CODE = 20
EXCEPT SELECT P_CODE FROM LAB_PRODUCT WHERE V_CODE = 10;
SELECT P_CODE FROM LAB_PRODUCT WHERE V_CODE = 10
EXCEPT SELECT P_CODE FROM LAB_PRODUCT WHERE V_CODE = 20;
-- PA6: profile data BEFORE enabling constraints or shrinking/converting types.
CREATE TABLE LAB_PART (PART_CODE VARCHAR(10), PART_PRICE NUMERIC(8,2), V_CODE INTEGER);
ALTER TABLE LAB_PART ADD CONSTRAINT LAB_PART_PK PRIMARY KEY (PART_CODE);
ALTER TABLE LAB_PART ADD CONSTRAINT LAB_PART_FK FOREIGN KEY (V_CODE)
    REFERENCES LAB_VENDOR (V_CODE);
ALTER TABLE LAB_PART ADD CONSTRAINT LAB_PART_CK CHECK (PART_PRICE >= 0);
ALTER TABLE LAB_PART ADD COLUMN PART_DESCRIPT VARCHAR(40);
ALTER TABLE LAB_PART ALTER COLUMN PART_DESCRIPT TYPE VARCHAR(80);
ALTER TABLE LAB_PART ALTER COLUMN PART_PRICE SET DEFAULT 0;
ALTER TABLE LAB_PART ALTER COLUMN PART_PRICE SET NOT NULL;
ALTER TABLE LAB_PART DROP COLUMN PART_DESCRIPT;
ALTER TABLE LAB_PART DROP CONSTRAINT LAB_PART_CK;
DROP TABLE LAB_PART;
-- PA7: explicit BEGIN is essential: psql otherwise autocommits each statement.
CREATE VIEW LAB_PRODUCT_PRICES AS SELECT P_CODE, P_PRICE FROM LAB_PRODUCT;
CREATE VIEW LAB_EXPENSIVE AS SELECT P_CODE, P_PRICE FROM LAB_PRODUCT
WHERE P_PRICE > 20 WITH CHECK OPTION;
BEGIN;
UPDATE LAB_PRODUCT_PRICES SET P_PRICE = 50 WHERE P_CODE = 'P2';
SELECT P_PRICE FROM LAB_PRODUCT WHERE P_CODE = 'P2';
ROLLBACK;
-- Run independently: check_option_violation (SQLSTATE 44000), then rollback.
-- BEGIN;
-- UPDATE LAB_EXPENSIVE SET P_PRICE=15 WHERE P_CODE='P2';
-- ROLLBACK;
-- PA8: assumes worked nextval has been called exactly once in this database.
BEGIN;
INSERT INTO LAB_CUSTOMER VALUES (nextval('lab_cus_code_seq'), 'Sequence test');
SELECT * FROM LAB_CUSTOMER; -- 20011.
ROLLBACK;
SELECT nextval('lab_cus_code_seq'); -- 20012, gap despite CACHE 1.
SELECT sequencename, cache_size, last_value FROM pg_sequences
WHERE schemaname = current_schema() AND sequencename LIKE 'lab_%';

-- PB1: STRICT matches Oracle's scalar SELECT INTO cardinality exceptions.
DO $$
DECLARE
    w_price LAB_PRODUCT.P_PRICE%TYPE;
BEGIN
    BEGIN
        SELECT P_PRICE INTO STRICT w_price FROM LAB_PRODUCT WHERE P_CODE = 'P9';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RAISE NOTICE 'No product P9';
    END;
    BEGIN
        SELECT P_PRICE INTO STRICT w_price FROM LAB_PRODUCT WHERE V_CODE = 20;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN RAISE NOTICE 'Scalar query was not unique';
    END;
END;
$$;
-- %TYPE aligns datatype, not column NOT NULL/CHECK/default business rules.
-- PB2
BEGIN;
CALL LAB_RAISE_PRICE(10, .10);
SELECT P_CODE, P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 10 ORDER BY P_CODE;
ROLLBACK;
-- Each error case independently; ROLLBACK clears the failed transaction:
-- BEGIN; CALL LAB_RAISE_PRICE(10,-1); ROLLBACK;
-- BEGIN; CALL LAB_RAISE_PRICE(10,NULL); ROLLBACK;
-- BEGIN; CALL LAB_RAISE_PRICE(40,.10); ROLLBACK;
-- PB3: state              in pg_cursors  w_count  FOUND
-- before OPEN             no             0        false (block initial value)
-- just opened             yes            0        unchanged by OPEN
-- third successful fetch  yes            3        true
-- exhausted fetch         yes            3        false
-- closed again            no             3        unchanged by CLOSE
-- FOUND is block-local, not cursor-specific; other SQL can overwrite it.
-- Oracle per-cursor state: closed -> ISOPEN false, other attributes error;
-- opened -> ISOPEN true, ROWCOUNT 0, FOUND/NOTFOUND NULL; third fetch ->
-- true/3/true/false; exhausted -> true/3/false/true; closed -> as initially.
-- PostgreSQL FETCH on an unopened/closed cursor raises invalid_cursor_name.
-- PB4
BEGIN;
DO $$
DECLARE
    w_count BIGINT;
BEGIN
    UPDATE LAB_PRODUCT SET P_MIN = P_MIN + 1 WHERE P_QOH < P_MIN;
    GET DIAGNOSTICS w_count = ROW_COUNT;
    RAISE NOTICE 'Updated: %', w_count; -- 3; not an Oracle SQL%ROWCOUNT attribute.
END;
$$;
ROLLBACK;
-- PB5: operation via CALL vs value via SELECT; no hidden DML in IMMUTABLE.
SELECT P_CODE, LAB_DISCOUNTED_PRICE(P_PRICE, P_DISCOUNT) AS NetPrice
FROM LAB_PRODUCT ORDER BY P_CODE;
-- PB6: PostgreSQL separates trigger function from event/timing declaration.
CREATE FUNCTION LAB_AUDIT_PRICE() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO LAB_PRICE_AUDIT VALUES (NEW.P_CODE, NULL, NEW.P_PRICE, TG_OP);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO LAB_PRICE_AUDIT VALUES (NEW.P_CODE, OLD.P_PRICE, NEW.P_PRICE, TG_OP);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO LAB_PRICE_AUDIT VALUES (OLD.P_CODE, OLD.P_PRICE, NULL, TG_OP);
    END IF;
    RETURN NULL; -- return value ignored for AFTER row triggers.
END;
$$;
CREATE TRIGGER LAB_PRODUCT_AUDIT
AFTER INSERT OR UPDATE OR DELETE ON LAB_PRODUCT
FOR EACH ROW EXECUTE FUNCTION LAB_AUDIT_PRICE();
BEGIN;
INSERT INTO LAB_PRODUCT (P_CODE, P_DESCRIPT, P_INDATE, P_PRICE)
VALUES ('T1', 'Trigger test', DATE '2026-10-14', 5);
UPDATE LAB_PRODUCT SET P_PRICE = 6 WHERE P_CODE = 'T1';
DELETE FROM LAB_PRODUCT WHERE P_CODE = 'T1';
SELECT * FROM LAB_PRICE_AUDIT; -- three rows.
ROLLBACK;
SELECT COUNT(*) FROM LAB_PRICE_AUDIT; -- zero.
BEGIN;
UPDATE LAB_PRODUCT SET P_PRICE = P_PRICE + 1;
SELECT COUNT(*) FROM LAB_PRICE_AUDIT; -- seven row-trigger invocations.
ROLLBACK;
DROP TRIGGER LAB_PRODUCT_AUDIT ON LAB_PRODUCT;
-- LAB_AUDIT_PRICE() is a separate object and survives DROP TRIGGER too.
