-- ORACLE B: server-side procedural SQL, not SQLite SQL.
SET SERVEROUTPUT ON
-- Anonymous block: typed variables, SELECT INTO, IF, and exceptions.
DECLARE
    w_code CHAR(5) := '00501';
    w_label VARCHAR2(15) := 'Drill';
    w_date DATE := DATE '2026-10-14';
    w_delta NUMBER(6, 2) := 5;
    w_price LAB_PRODUCT.P_PRICE%TYPE;
BEGIN
    SELECT P_PRICE INTO w_price FROM LAB_PRODUCT WHERE P_CODE = 'P2';
    IF w_price >= 40 THEN
        DBMS_OUTPUT.PUT_LINE(w_label || ': ' || (w_price + w_delta));
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Product not found');
END;
/

-- A shared operation. Caller owns COMMIT/ROLLBACK; routine does not commit.
CREATE OR REPLACE PROCEDURE LAB_RAISE_PRICE (
    p_vendor IN LAB_VENDOR.V_CODE%TYPE,
    p_fraction IN NUMBER
) AS
BEGIN
    IF p_fraction IS NULL OR p_fraction < 0 OR p_fraction > 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Fraction must be between 0 and 1');
    END IF;
    UPDATE LAB_PRODUCT SET P_PRICE = ROUND(P_PRICE * (1 + p_fraction), 2)
    WHERE V_CODE = p_vendor;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No products for vendor');
    END IF;
END;
/
BEGIN
    LAB_RAISE_PRICE(20, .05);
END;
/
SELECT P_CODE, P_PRICE FROM LAB_PRODUCT WHERE V_CODE = 20; -- both 31.50.
ROLLBACK;

-- Persistent stored function: returns a value; valid for SQL invocation.
CREATE OR REPLACE FUNCTION LAB_DISCOUNTED_PRICE (
    p_price IN NUMBER, p_discount IN NUMBER
) RETURN NUMBER IS
BEGIN
    RETURN p_price * (1 - p_discount);
END;
/
SELECT LAB_DISCOUNTED_PRICE(100, .05) AS NetPrice FROM DUAL; -- 95.

-- Explicit cursor state and row-at-a-time processing.
DECLARE
    CURSOR low_stock IS
        SELECT P_CODE, P_QOH FROM LAB_PRODUCT WHERE P_QOH < P_MIN ORDER BY P_CODE;
    w_code LAB_PRODUCT.P_CODE%TYPE;
    w_quantity LAB_PRODUCT.P_QOH%TYPE;
BEGIN
    OPEN low_stock;
    LOOP
        FETCH low_stock INTO w_code, w_quantity;
        EXIT WHEN low_stock%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(w_code || ': ' || w_quantity ||
                             ' row ' || low_stock%ROWCOUNT);
    END LOOP;
    CLOSE low_stock;
EXCEPTION
    WHEN OTHERS THEN
        IF low_stock%ISOPEN THEN CLOSE low_stock; END IF;
        RAISE;
END;
/
-- Prints 0012:3, P2:2, P4:0, once each.

-- TASK OB1: change the anonymous block to find missing P9 and handle
--   NO_DATA_FOUND; discuss TOO_MANY_ROWS for a nonunique SELECT INTO.
--   What does %TYPE inherit, and which NOT NULL/CHECK rules does it NOT inherit?
-- TASK OB2: call the procedure for vendor 10, .10, verify 2.20/49.50 then
--   ROLLBACK. Test fraction -1, NULL, and vendor 40 errors. Explain shared
--   logic, persistent stored modules, fewer round trips, and commit ownership.
-- TASK OB3: fill a cursor-state table: closed / just opened / three successful
--   fetches / exhausted fetch / closed again. Record %ISOPEN, %ROWCOUNT,
--   %FOUND, %NOTFOUND, including NULL and INVALID_CURSOR cases.
-- TASK OB4: rewrite the low-stock loop as one set-based UPDATE increasing
--   those P_MIN values by 1; inspect SQL%ROWCOUNT (3), then ROLLBACK.
--   Contrast implicit DML cursors with explicit multirow fetch control.
-- TASK OB5: call LAB_DISCOUNTED_PRICE for every product in SELECT; explain
--   function vs procedure and RETURN. Why must SQL-invoked functions obey
--   restrictions on datatypes, side effects, and transaction control?
-- TASK OB6: create one AFTER INSERT OR UPDATE OR DELETE row-level audit
--   trigger using INSERTING/UPDATING/DELETING and :OLD/:NEW. Insert T1,
--   update its price, delete it; verify three audit rows; ROLLBACK -> zero.
--   Contrast row-level three invocations with statement-level timing;
--   update all seven products with one statement and predict seven row events.
--   DROP TRIGGER at end; confirm products and audit table survive.
