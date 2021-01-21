DECLARE
  TYPE trans_table is table of Transactions%rowtype index by pls_integer;
  trans_temp trans_table;
  --save masterdata into memory
  v_Product_name Masterdata.product_name%TYPE := null;
  v_Product_id Masterdata.product_id%TYPE := null;
  v_Supplier_name Masterdata.supplier_name%TYPE := null;
  v_Supplier_id Masterdata.supplier_id%TYPE := null;
  v_Price Masterdata.price%TYPE :=0;
  v_Date    number := 0;
  v_YEAR    number := 0;
  v_QUARTER number := 0;
  v_MONTH   number := 0;
  V_WEEK    number := 0;
  v_DAY     varchar2(10) := '0';
  t_pid int;
  t_suid int;
  t_did int;
  t_cid int;
  t_fact_sale int;
  
  CURSOR trans_cursor is
    SELECT * FROM Transactions;
--start
BEGIN
  OPEN trans_cursor;
  LOOP
    FETCH trans_cursor
    BULK COLLECT INTO trans_temp LIMIT 50;
    EXIT WHEN trans_cursor%notfound;

      FOR i IN trans_temp.FIRST .. trans_temp.LAST LOOP

        SELECT  product_name, product_id, supplier_name, supplier_id, price 
        INTO v_Product_name, v_Product_id, v_Supplier_name, v_Supplier_id, v_Price 
        FROM Masterdata 
        WHERE product_id = trans_temp(i).product_id;

 -- product dimension 
        BEGIN
          INSERT INTO Dimension_Product VALUES (trans_temp(i).product_id, v_Product_name, v_Price);
          EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN null;
        END;  

  -- supplier dimension 
        BEGIN
          INSERT INTO Dimension_Supplier VALUES (v_Supplier_id, v_Supplier_name);
          EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN null;
        END;
       
 -- customer dimension 
        BEGIN     
          INSERT INTO Dimension_Customer VALUES (trans_temp(i).customer_id, trans_temp(i).customer_name);
          EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN null;   /*check dup*/
        END;

 -- store dimension 
        BEGIN
          INSERT INTO Dimension_Store VALUES (trans_temp(i).store_id, trans_temp(i).store_name);
          EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN null;
        END;
        
 -- date dimension 
        BEGIN
          v_DATE := TO_CHAR(trans_temp(i).t_date,'ddd');
          v_DAY := TO_CHAR(trans_temp(i).t_date,'day');
          v_YEAR := TO_CHAR(trans_temp(i).t_date,'YYYY');
          v_QUARTER := TO_CHAR(trans_temp(i).t_date,'Q');
          v_MONTH := TO_CHAR(trans_temp(i).t_date,'MM');
          v_WEEK := TO_CHAR(trans_temp(i).t_date,'WW');

          INSERT INTO Dimension_Time (T_DATE, T_DATE_YEAR, T_DAY, T_WEEK, T_MONTH, T_QUARTER, T_YEAR)
          VALUES (trans_temp(i).t_date, v_DATE, v_DAY, v_WEEK, v_MONTH, v_QUARTER, v_YEAR);
          EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN null;
        END;
 -- fact sale 
        INSERT INTO Fact_Sales 
        VALUES (trans_temp(i).store_id, v_Supplier_id, trans_temp(i).product_id, trans_temp(i).customer_id,
          trans_temp(i).t_date, trans_temp(i).quantity, v_Price * trans_temp(i).quantity);

      END LOOP;

    END LOOP;
  CLOSE trans_cursor;
  COMMIT;
END;
