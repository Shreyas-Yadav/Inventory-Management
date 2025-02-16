CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_customer_updated_at BEFORE UPDATE
    ON customers FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_product_updated_at BEFORE UPDATE
    ON products FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_category_updated_at BEFORE UPDATE
    ON categories FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_supplier_updated_at BEFORE UPDATE
    ON suppliers FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_sale_updated_at BEFORE UPDATE
    ON sales FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_sale_item_updated_at BEFORE UPDATE
    ON sale_items FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_purchase_updated_at BEFORE UPDATE
    ON purchases FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_payment_updated_at BEFORE UPDATE
    ON payments FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_reminder_updated_at BEFORE UPDATE
    ON payment_reminders FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
