-- psql only. Run in an EMPTY disposable database; never resets existing data.
\set ON_ERROR_STOP on
SET plpgsql.check_asserts = on;
\ir setup.sql
\ir 01_dialects.sql
\ir 02_plpgsql.sql

DO $$
BEGIN
    ASSERT (SELECT COUNT(*) FROM LAB_VENDOR) = 4;
    ASSERT (SELECT COUNT(*) FROM LAB_PRODUCT) = 7;
    ASSERT (SELECT SUM(P_PRICE) FROM LAB_PRODUCT) = 237;
    ASSERT (SELECT P_PRICE FROM LAB_PRODUCT WHERE P_CODE = 'P3') = 30;
    ASSERT currval('lab_cus_code_seq') = 20010;
    ASSERT LAB_DISCOUNTED_PRICE(100, .05) = 95;
    ASSERT (SELECT array_agg(P_CODE ORDER BY P_CODE) FROM LAB_PRODUCT
        WHERE P_PRICE > ALL (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 20))
        = ARRAY['P2','P4']::VARCHAR[];
    ASSERT (SELECT COUNT(*) FROM LAB_PRODUCT WHERE P_PRICE > ALL
        (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 40)) = 7;
    ASSERT (SELECT COUNT(*) FROM LAB_PRODUCT WHERE P_PRICE > SOME
        (SELECT P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 40)) = 0;
    ASSERT (SELECT COUNT(*) FROM LAB_PRODUCT
        WHERE P_PRICE > ALL (VALUES (30), (NULL::NUMERIC))) = 0;
    ASSERT (SELECT array_agg(P_CODE ORDER BY P_CODE) FROM LAB_PRODUCT
        WHERE P_PRICE > ANY (VALUES (30), (NULL::NUMERIC)))
        = ARRAY['P2','P4']::VARCHAR[];
END;
$$;

\ir ../solutions/postgres.sql

-- Verify answer-key rollback experiments left baseline data intact.
DO $$
BEGIN
    ASSERT (SELECT COUNT(*) FROM LAB_CUSTOMER) = 0;
    ASSERT (SELECT COUNT(*) FROM LAB_PRICE_AUDIT) = 0;
    ASSERT (SELECT COUNT(*) FROM LAB_PRODUCT) = 7;
    ASSERT (SELECT SUM(P_PRICE) FROM LAB_PRODUCT) = 237;
    ASSERT (SELECT P_MIN FROM LAB_PRODUCT WHERE P_CODE = 'P2') = 5;
    ASSERT currval('lab_cus_code_seq') = 20012;
    ASSERT to_regclass('lab_part') IS NULL;
    ASSERT NOT EXISTS (SELECT FROM pg_trigger
        WHERE tgrelid = 'lab_product'::regclass AND tgname = 'lab_product_audit');
END;
$$;

-- Expected failures caught in subtransactions; unexpected success is fatal.
DO $$
DECLARE
    w_price LAB_PRODUCT.P_PRICE%TYPE;
BEGIN
    BEGIN
        UPDATE LAB_EXPENSIVE SET P_PRICE = 15 WHERE P_CODE = 'P2';
        RAISE EXCEPTION 'CHECK OPTION accepted a hidden row';
    EXCEPTION WHEN with_check_option_violation THEN NULL;
    END;
    BEGIN
        UPDATE LAB_PRODUCT SET P_PRICE = -1 WHERE P_CODE = 'P2';
        RAISE EXCEPTION 'Negative price accepted';
    EXCEPTION WHEN check_violation THEN NULL;
    END;
    BEGIN
        UPDATE LAB_PRODUCT SET V_CODE = 999 WHERE P_CODE = 'P2';
        RAISE EXCEPTION 'Missing vendor accepted';
    EXCEPTION WHEN foreign_key_violation THEN NULL;
    END;
    BEGIN
        UPDATE LAB_PRODUCT SET P_DESCRIPT = NULL WHERE P_CODE = 'P2';
        RAISE EXCEPTION 'NULL description accepted';
    EXCEPTION WHEN not_null_violation THEN NULL;
    END;
    BEGIN
        UPDATE LAB_PRODUCT SET P_CODE = 'P1' WHERE P_CODE = 'P2';
        RAISE EXCEPTION 'Duplicate key accepted';
    EXCEPTION WHEN unique_violation THEN NULL;
    END;
    BEGIN
        SELECT P_PRICE INTO STRICT w_price FROM LAB_PRODUCT WHERE P_CODE = 'P9';
        RAISE EXCEPTION 'Missing scalar row accepted by STRICT';
    EXCEPTION WHEN no_data_found THEN NULL;
    END;
    BEGIN
        SELECT P_PRICE INTO STRICT w_price FROM LAB_PRODUCT WHERE V_CODE = 20;
        RAISE EXCEPTION 'Multiple scalar rows accepted by STRICT';
    EXCEPTION WHEN too_many_rows THEN NULL;
    END;
END;
$$;

BEGIN;
CALL LAB_RAISE_PRICE(10, .10);
DO $$
BEGIN
    ASSERT (SELECT P_PRICE FROM LAB_PRODUCT WHERE P_CODE = 'P1') = 2.20;
    ASSERT (SELECT P_PRICE FROM LAB_PRODUCT WHERE P_CODE = 'P2') = 49.50;
END;
$$;
ROLLBACK;

DO $$
DECLARE
    w_case RECORD;
    w_message TEXT;
BEGIN
    FOR w_case IN SELECT * FROM (VALUES
        (10, -1::NUMERIC, 'Fraction must be between 0 and 1'),
        (10, NULL::NUMERIC, 'Fraction must be between 0 and 1'),
        (40, .10, 'No products for vendor')) AS t(vendor, fraction, message)
    LOOP
        w_message := NULL;
        BEGIN
            CALL LAB_RAISE_PRICE(w_case.vendor, w_case.fraction);
        EXCEPTION WHEN raise_exception THEN
            GET STACKED DIAGNOSTICS w_message = MESSAGE_TEXT;
        END;
        ASSERT w_message IS NOT DISTINCT FROM w_case.message,
            'Procedure must reject invalid input';
    END LOOP;
END;
$$;

-- PB3/PB4: cursor state and DML diagnostics, not Oracle cursor attributes.
BEGIN;
DO $$
DECLARE
    check_low_stock CURSOR FOR
        SELECT P_CODE FROM LAB_PRODUCT WHERE P_QOH < P_MIN ORDER BY P_CODE;
    w_code VARCHAR(10);
    w_codes VARCHAR[] := ARRAY[]::VARCHAR[];
    w_count BIGINT;
BEGIN
    ASSERT NOT FOUND;
    OPEN check_low_stock;
    ASSERT NOT FOUND; -- OPEN does not set FOUND.
    ASSERT EXISTS (SELECT FROM pg_cursors WHERE name = check_low_stock::TEXT);
    LOOP
        FETCH check_low_stock INTO w_code;
        EXIT WHEN NOT FOUND;
        w_codes := array_append(w_codes, w_code);
    END LOOP;
    ASSERT NOT FOUND;
    ASSERT w_codes = ARRAY['0012','P2','P4']::VARCHAR[];
    CLOSE check_low_stock;
    ASSERT NOT EXISTS (SELECT FROM pg_cursors WHERE name = check_low_stock::TEXT);
    UPDATE LAB_PRODUCT SET P_MIN = P_MIN + 1 WHERE P_QOH < P_MIN;
    GET DIAGNOSTICS w_count = ROW_COUNT;
    ASSERT FOUND AND w_count = 3;
END;
$$;
ROLLBACK;

-- Reuse the answer's trigger function to assert actual audit content/timing.
BEGIN;
CREATE TRIGGER LAB_PRODUCT_AUDIT
AFTER INSERT OR UPDATE OR DELETE ON LAB_PRODUCT
FOR EACH ROW EXECUTE FUNCTION LAB_AUDIT_PRICE();
INSERT INTO LAB_PRODUCT (P_CODE, P_DESCRIPT, P_INDATE, P_PRICE)
VALUES ('T1', 'Trigger test', DATE '2026-10-14', 5);
UPDATE LAB_PRODUCT SET P_PRICE = 6 WHERE P_CODE = 'T1';
DELETE FROM LAB_PRODUCT WHERE P_CODE = 'T1';
DO $$
BEGIN
    ASSERT (SELECT COUNT(*) FROM LAB_PRICE_AUDIT) = 3;
    ASSERT EXISTS (SELECT FROM LAB_PRICE_AUDIT WHERE ACTION = 'INSERT'
        AND P_CODE = 'T1' AND OLD_PRICE IS NULL AND NEW_PRICE = 5);
    ASSERT EXISTS (SELECT FROM LAB_PRICE_AUDIT WHERE ACTION = 'UPDATE'
        AND P_CODE = 'T1' AND OLD_PRICE = 5 AND NEW_PRICE = 6);
    ASSERT EXISTS (SELECT FROM LAB_PRICE_AUDIT WHERE ACTION = 'DELETE'
        AND P_CODE = 'T1' AND OLD_PRICE = 6 AND NEW_PRICE IS NULL);
END;
$$;
UPDATE LAB_PRODUCT SET P_PRICE = P_PRICE + 1;
DO $$
BEGIN
    ASSERT (SELECT COUNT(*) FROM LAB_PRICE_AUDIT WHERE ACTION = 'UPDATE') = 8;
END;
$$;
ROLLBACK;
DO $$
BEGIN
    ASSERT (SELECT COUNT(*) FROM LAB_PRICE_AUDIT) = 0;
    ASSERT (SELECT SUM(P_PRICE) FROM LAB_PRODUCT) = 237;
    ASSERT (SELECT P_MIN FROM LAB_PRODUCT WHERE P_CODE = 'P2') = 5;
END;
$$;
\echo PostgreSQL companion examples, answers, and invariants passed.
