-- Reset ONLY this lab's named objects. Never use a production connection.
PRAGMA foreign_keys = ON;
DROP VIEW IF EXISTS expensive_product;
DROP VIEW IF EXISTS vendor_summary;
DROP VIEW IF EXISTS product_prices;
DROP TABLE IF EXISTS price_audit;
DROP TABLE IF EXISTS product_snapshot;
DROP TABLE IF EXISTS price_history;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS part_new;
DROP TABLE IF EXISTS scratch_product;
DROP TABLE IF EXISTS line;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS vendor;
DROP TABLE IF EXISTS employee;

CREATE TABLE vendor (
    V_CODE INTEGER PRIMARY KEY,
    V_NAME VARCHAR(40) NOT NULL UNIQUE,
    V_CONTACT VARCHAR(40) NOT NULL,
    V_AREACODE CHAR(3) NOT NULL,
    V_PHONE CHAR(8) NOT NULL,
    V_STATE CHAR(2) NOT NULL CHECK (length(V_STATE) = 2),
    V_ORDER CHAR(1) NOT NULL DEFAULT 'Y' CHECK (V_ORDER IN ('Y', 'N'))
);
CREATE TABLE product (
    P_CODE VARCHAR(10) NOT NULL PRIMARY KEY,
    P_DESCRIPT VARCHAR(80) NOT NULL,
    P_INDATE DATE NOT NULL,
    P_QOH INTEGER NOT NULL DEFAULT 0 CHECK (P_QOH >= 0),
    P_MIN INTEGER NOT NULL DEFAULT 0 CHECK (P_MIN >= 0),
    P_PRICE NUMERIC(8, 2) NOT NULL CHECK (P_PRICE >= 0),
    P_DISCOUNT NUMERIC(4, 2) NOT NULL DEFAULT 0
        CHECK (P_DISCOUNT BETWEEN 0 AND 1),
    V_CODE INTEGER REFERENCES vendor (V_CODE)
);
CREATE TABLE customer (
    CUS_CODE INTEGER PRIMARY KEY,
    CUS_LNAME VARCHAR(30) NOT NULL,
    CUS_FNAME VARCHAR(30) NOT NULL,
    CUS_INITIAL CHAR(1),
    CUS_BALANCE NUMERIC(8, 2) NOT NULL DEFAULT 0 CHECK (CUS_BALANCE >= 0)
);
CREATE TABLE invoice (
    INV_NUMBER INTEGER PRIMARY KEY,
    CUS_CODE INTEGER NOT NULL REFERENCES customer (CUS_CODE),
    INV_DATE DATE NOT NULL
);
CREATE TABLE line (
    INV_NUMBER INTEGER NOT NULL REFERENCES invoice (INV_NUMBER),
    LINE_NUMBER INTEGER NOT NULL,
    P_CODE VARCHAR(10) NOT NULL REFERENCES product (P_CODE),
    LINE_UNITS INTEGER NOT NULL CHECK (LINE_UNITS > 0),
    LINE_PRICE NUMERIC(8, 2) NOT NULL CHECK (LINE_PRICE >= 0),
    PRIMARY KEY (INV_NUMBER, LINE_NUMBER)
);
CREATE TABLE employee (
    EMP_NUM INTEGER PRIMARY KEY,
    EMP_LNAME VARCHAR(30) NOT NULL,
    EMP_FNAME VARCHAR(30) NOT NULL,
    EMP_MGR INTEGER REFERENCES employee (EMP_NUM)
);

INSERT INTO vendor VALUES
    (10, 'Acme Tools', 'Ana Reed', '701', '555-0100', 'TN', 'Y'),
    (20, 'North Supply', 'Bo Hall', '701', '555-0200', 'ND', 'Y'),
    (30, 'River Hardware', 'Cy Park', '615', '555-0300', 'TN', 'N'),
    (40, 'Unused Supply', 'Dee Fox', '701', '555-0400', 'ND', 'Y');
INSERT INTO product VALUES
    ('P1', 'Pen', '2026-09-30', 100, 20, 2, 0, 10),
    ('P2', 'Drill', '2026-10-01', 2, 5, 45, 0.10, 10),
    ('P3', 'Hand saw', '2026-10-11', 8, 3, 30, 0.05, 20),
    ('P4', 'Chain saw', '2026-10-31', 0, 2, 100, 0, NULL),
    ('P5', 'Hammer', '2026-11-01', 6, 4, 20, 0, 30),
    ('P6', 'Saw blade', '2026-10-15', 4, 4, 30, 0, 20),
    ('0012', '  Rat-tail file  ', '2026-01-01', 3, 5, 10, 0, 30);
INSERT INTO customer VALUES
    (1, 'Brown', 'Amy', 'A', 10),
    (2, 'Brown', 'Ben', NULL, 20),
    (3, 'Adams', 'Zoe', 'Z', 0),
    (4, 'Brown', 'Amy', 'B', 0);
INSERT INTO invoice VALUES
    (1001, 1, '2026-10-01'), (1002, 1, '2026-10-31'),
    (1003, 2, '2026-09-30'), (1004, 3, '2026-11-01'),
    (1005, 2, '2026-10-15');
INSERT INTO line VALUES
    (1001, 1, 'P2', 2, 40), (1001, 2, 'P3', 1, 30),
    (1002, 1, 'P1', 5, 2), (1002, 2, 'P6', 2, 25),
    (1003, 1, 'P5', 1, 20),
    (1004, 1, 'P4', 1, 95), (1004, 2, 'P3', 1, 30);
INSERT INTO employee VALUES
    (100, 'Reed', 'Ana', NULL), (101, 'Hall', 'Bo', 100),
    (102, 'Park', 'Cy', 100), (103, 'Fox', 'Dee', 101);
