-- 8.5 Goal: identify timing/event/level/action and transactional side effects.
PRAGMA foreign_keys = ON;
CREATE TABLE price_audit (
    AuditID INTEGER PRIMARY KEY,
    P_CODE TEXT NOT NULL,
    OldPrice NUMERIC,
    NewPrice NUMERIC,
    Action TEXT NOT NULL,
    ChangedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TRIGGER price_audit_update
AFTER UPDATE OF P_PRICE ON product
FOR EACH ROW WHEN OLD.P_PRICE <> NEW.P_PRICE
BEGIN
    INSERT INTO price_audit (P_CODE, OldPrice, NewPrice, Action)
    VALUES (NEW.P_CODE, OLD.P_PRICE, NEW.P_PRICE, 'UPDATE');
END;
BEGIN TRANSACTION;
UPDATE product SET P_PRICE = P_PRICE + 1 WHERE V_CODE = 20;
SELECT P_CODE, OldPrice, NewPrice, Action FROM price_audit ORDER BY AuditID;
ROLLBACK;
SELECT COUNT(*) AS AuditRowsAfterRollback FROM price_audit; -- 0.

-- Business question: When should a price audit run, what change activates it,
--   and should it record each changed product or just the overall statement?
-- TASK 8.5a: label AFTER, UPDATE OF, FOR EACH ROW, WHEN, BEGIN/END;
--   contrast BEFORE/AFTER/INSTEAD OF and row/statement levels.
--   SQLite supports row-level triggers, not PostgreSQL statement-level triggers.
-- Business question: Can the audit track product creation and removal as well
--   as price edits, while discarding audit entries for rolled-back changes?
-- TASK 8.5b: add separate INSERT and DELETE audit triggers. Insert then
--   delete an unsold T1 within BEGIN/ROLLBACK; two audit rows then none.
-- Business question: Does a catalog-wide price change record every affected
--   item while a no-change price assignment avoids a misleading audit entry?
-- TASK 8.5c: update all seven products by +1: seven UPDATE audit rows;
--   set a price to itself: zero new audit rows. Explain the WHEN guard.
-- Business question: What happens to price-change tracking if its trigger is
--   retired, and do the product and existing audit tables remain available?
-- TASK 8.5d: DROP TRIGGER price_audit_update, update P2 within a transaction,
--   verify no audit row but price changed; ROLLBACK. Table/audit survive.
-- Business question: How can one PostgreSQL audit mechanism distinguish
--   product additions, edits, and removals and capture the appropriate values?
-- TASK 8.5e: in Postgres B write one multi-event trigger using TG_OP,
--   OLD/NEW and a RETURNS TRIGGER function. Trace which images exist per event.
-- REFLECT: CHECK is preferable to a trigger for a simple nonnegative price;
--   a rolled-back audit is not a durable record of failed attempts.
