-- POSTGRES B: PL/pgSQL equivalents of the slides' Oracle PL/SQL concepts.
-- DO executes an anonymous block; $$ quotes its body, not a client delimiter.
DO $$
DECLARE
    w_code CHAR(5) := '00501';
    w_label VARCHAR(15) := 'Drill';
    w_date DATE := DATE '2026-10-14';
    w_delta NUMERIC(6, 2) := 5;
    w_price LAB_PRODUCT.P_PRICE%TYPE;
BEGIN
    SELECT P_PRICE INTO STRICT w_price FROM LAB_PRODUCT WHERE P_CODE = 'P2';
    IF w_price >= 40 THEN
        RAISE NOTICE '%: %', w_label, w_price + w_delta;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RAISE NOTICE 'Product not found';
END;
$$;

-- Shared operation. Caller owns BEGIN/COMMIT/ROLLBACK; routine never commits.
CREATE OR REPLACE PROCEDURE LAB_RAISE_PRICE (p_vendor INTEGER, p_fraction NUMERIC)
LANGUAGE plpgsql AS $$
BEGIN
    IF p_fraction IS NULL OR p_fraction < 0 OR p_fraction > 1 THEN
        RAISE EXCEPTION 'Fraction must be between 0 and 1';
    END IF;
    UPDATE LAB_PRODUCT SET P_PRICE = ROUND(P_PRICE * (1 + p_fraction), 2)
    WHERE V_CODE = p_vendor;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No products for vendor';
    END IF;
END;
$$;
BEGIN;
CALL LAB_RAISE_PRICE(20, .05);
SELECT P_CODE, P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 20; -- both 31.50.
ROLLBACK;

CREATE OR REPLACE FUNCTION LAB_DISCOUNTED_PRICE (p_price NUMERIC, p_discount NUMERIC)
RETURNS NUMERIC LANGUAGE plpgsql IMMUTABLE AS $$
BEGIN
    RETURN p_price * (1 - p_discount);
END;
$$;
SELECT LAB_DISCOUNTED_PRICE(100, .05) AS NetPrice; -- 95.

-- Explicit cursor control. FOUND describes the last relevant statement, NOT
-- a cursor-specific attribute. Count successful fetches ourselves.
DO $$
DECLARE
    low_stock CURSOR FOR
        SELECT P_CODE, P_QOH FROM LAB_PRODUCT WHERE P_QOH < P_MIN ORDER BY P_CODE;
    w_code LAB_PRODUCT.P_CODE%TYPE;
    w_quantity LAB_PRODUCT.P_QOH%TYPE;
    w_count INTEGER := 0;
BEGIN
    OPEN low_stock;
    LOOP
        FETCH low_stock INTO w_code, w_quantity;
        EXIT WHEN NOT FOUND;
        w_count := w_count + 1;
        RAISE NOTICE '%: % row %', w_code, w_quantity, w_count;
    END LOOP;
    CLOSE low_stock;
END;
$$;
-- Prints 0012:3, P2:2, P4:0, once each; block/transaction end closes cursors.

-- TASK PB1: find missing P9 and handle NO_DATA_FOUND; demonstrate
--   TOO_MANY_ROWS for nonunique SELECT INTO STRICT. Contrast non-STRICT
--   SELECT INTO (NULL/no row, first row/multiple rows). What does %TYPE
--   inherit, and which NOT NULL/CHECK rules does it NOT inherit?
-- TASK PB2: BEGIN; call the procedure for vendor 10, .10, verify 2.20/49.50
--   then ROLLBACK. Test fraction -1, NULL, and vendor 40 errors separately.
--   Explain shared logic, persistent modules, fewer round trips, commit ownership.
-- TASK PB3: trace closed / just opened / three successful fetches / exhausted
--   fetch / closed again. Record FOUND and w_count after FETCH; inspect
--   pg_cursors for open state. Compare Oracle %ISOPEN/%ROWCOUNT/%FOUND/
--   %NOTFOUND: PostgreSQL has no per-cursor versions of these attributes.
-- TASK PB4: one set-based UPDATE increases low-stock P_MIN by 1. Use
--   GET DIAGNOSTICS w_count = ROW_COUNT (3), then ROLLBACK. Contrast DML
--   diagnostics with explicit multirow fetch control. Read FOUND promptly.
-- TASK PB5: call LAB_DISCOUNTED_PRICE per product in SELECT; explain function
--   vs procedure and RETURN. Why is IMMUTABLE accurate here but not for a
--   function that reads changing table data? Functions cannot COMMIT/ROLLBACK.
-- TASK PB6: one AFTER INSERT OR UPDATE OR DELETE row-level audit trigger
--   calls a RETURNS TRIGGER function using TG_OP and OLD/NEW (no colons).
--   Insert T1, update its price, delete it; verify three audit rows;
--   ROLLBACK -> zero. Contrast FOR EACH ROW with FOR EACH STATEMENT;
--   update all seven products in one statement: seven row events.
--   DROP TRIGGER ... ON LAB_PRODUCT; confirm products/audit survive.
