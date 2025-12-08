-- ==========================================================
-- FILE: objects.sql
-- DESCRIPTION: Stored Procedures, Packages, and Triggers
-- ==========================================================

-- 1. AUDIT PACKAGE
CREATE OR REPLACE PACKAGE audit_pkg IS
    PROCEDURE log_action(p_table VARCHAR2, p_op VARCHAR2, p_stat VARCHAR2, p_rem VARCHAR2);
END audit_pkg;
/
CREATE OR REPLACE PACKAGE BODY audit_pkg IS
    PROCEDURE log_action(p_table VARCHAR2, p_op VARCHAR2, p_stat VARCHAR2, p_rem VARCHAR2) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO audit_log (user_id, table_name, operation, status, remarks)
        VALUES (USER, p_table, p_op, p_stat, p_rem);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
END audit_pkg;
/

-- 2. STOCK CHECK FUNCTION
CREATE OR REPLACE FUNCTION check_stock_status(p_prod_id NUMBER) RETURN VARCHAR2 IS
    v_qty NUMBER;
BEGIN
    SELECT Quantity INTO v_qty FROM Products WHERE Product_ID = p_prod_id;
    IF v_qty <= 0 THEN RETURN 'OUT_OF_STOCK';
    ELSIF v_qty < 10 THEN RETURN 'LOW_STOCK';
    ELSE RETURN 'IN_STOCK';
    END IF;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'INVALID';
END;
/

-- 3. REGISTER SALE PROCEDURE
CREATE OR REPLACE PROCEDURE register_sale(
    p_prod_id IN NUMBER,
    p_qty     IN NUMBER,
    p_msg     OUT VARCHAR2
) IS
    v_stock NUMBER;
BEGIN
    SELECT Quantity INTO v_stock FROM Products WHERE Product_ID = p_prod_id;
    
    IF v_stock < p_qty THEN
        p_msg := 'FAILED: Insufficient Stock';
        audit_pkg.log_action('SALES', 'INSERT_FAIL', 'DENIED', 'Low Stock');
    ELSE
        UPDATE Products SET Quantity = Quantity - p_qty, Last_Updated = SYSDATE WHERE Product_ID = p_prod_id;
        INSERT INTO Sales (Product_ID, Quantity_Sold) VALUES (p_prod_id, p_qty);
        COMMIT;
        p_msg := 'SUCCESS: Sale Recorded';
        audit_pkg.log_action('SALES', 'INSERT', 'SUCCESS', 'Sold '||p_qty||' items');
    END IF;
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    p_msg := 'ERROR: ' || SQLERRM;
END;
/

-- 4. SECURITY TRIGGER (The Critical Requirement)
CREATE OR REPLACE TRIGGER trg_audit_products
BEFORE INSERT OR UPDATE OR DELETE ON Products
FOR EACH ROW
DECLARE
    v_day        VARCHAR2(10);
    v_is_holiday NUMBER;
BEGIN
    SELECT TO_CHAR(SYSDATE, 'DY') INTO v_day FROM dual;
    SELECT COUNT(*) INTO v_is_holiday FROM holiday_calendar WHERE holiday_date = TRUNC(SYSDATE);

    IF v_day IN ('MON','TUE','WED','THU','FRI') OR v_is_holiday > 0 THEN
        audit_pkg.log_action('PRODUCTS', 'BLOCKED_DML', 'DENIED', 'Weekday/Holiday Rule');
        RAISE_APPLICATION_ERROR(-20002, '🚫 ACCESS DENIED: Operations allowed on Weekends only.');
    ELSE
        audit_pkg.log_action('PRODUCTS', 'DML', 'ALLOWED', 'Weekend operation.');
    END IF;
END;
/
