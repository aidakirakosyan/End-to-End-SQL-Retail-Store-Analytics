DELIMITER $$

CREATE TRIGGER trg_purchase_products_before_insert_set_purchase_price
BEFORE INSERT ON purchase_products
FOR EACH ROW
BEGIN
    -- If price was not explicitly provided
    IF NEW.purchase_price IS NULL OR NEW.purchase_price = 0 THEN
        SET NEW.purchase_price = (
            SELECT product_price
            FROM products
            WHERE product_id = NEW.product_id
        );
    END IF;
END$$

DELIMITER ;