-- =====================================================
-- SCRIPT PHARMAPLUS (corrigé) - Résout "generation expression is not immutable"
-- =====================================================

-- =====================================================
-- 3. CRÉATION DES TABLES (inchangé sauf customers.age)
-- =====================================================

CREATE TABLE IF NOT EXISTS categories (
                                          category_id SERIAL PRIMARY KEY,
                                          category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );
COMMENT ON TABLE categories IS 'Catégories de produits pharmaceutiques';

CREATE TABLE IF NOT EXISTS suppliers (
                                         supplier_id SERIAL PRIMARY KEY,
                                         supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50) DEFAULT 'France',
    reorder_level INT DEFAULT 10,
    is_active BOOLEAN DEFAULT TRUE,
    barcode VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );
COMMENT ON TABLE suppliers IS 'Fournisseurs de produits pharmaceutiques';

CREATE TABLE IF NOT EXISTS products (
                                        product_id SERIAL PRIMARY KEY,
                                        product_name VARCHAR(200) NOT NULL,
    generic_name VARCHAR(200),
    category_id INT REFERENCES categories(category_id),
    manufacturer VARCHAR(100),
    dosage_form VARCHAR(50),
    strength VARCHAR(50),
    unit_of_measure VARCHAR(20) DEFAULT 'piece',
    requires_prescription BOOLEAN DEFAULT FALSE,
    unit_price NUMERIC(10,2) NOT NULL,
    selling_price NUMERIC(10,2) NOT NULL,
    reorder_level INT DEFAULT 10,
    barcode VARCHAR(50) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT chk_prices CHECK (selling_price >= unit_price)
    );
COMMENT ON TABLE products IS 'Produits pharmaceutiques en vente';

CREATE TABLE IF NOT EXISTS inventory (
                                         inventory_id SERIAL PRIMARY KEY,
                                         product_id INT NOT NULL REFERENCES products(product_id),
    batch_number VARCHAR(50) NOT NULL,
    supplier_id INT REFERENCES suppliers(supplier_id),
    quantity_in_stock INT NOT NULL DEFAULT 0,
    quantity_reserved INT DEFAULT 0,
    manufacturing_date DATE,
    expiry_date DATE NOT NULL,
    purchase_price NUMERIC(10,2),
    received_date DATE DEFAULT CURRENT_DATE,
    location VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT chk_quantity CHECK (quantity_in_stock >= 0),
    CONSTRAINT chk_reserved CHECK (quantity_reserved >= 0 AND quantity_reserved <= quantity_in_stock),
    CONSTRAINT unique_batch UNIQUE (product_id, batch_number)
    );
COMMENT ON TABLE inventory IS 'Stock des produits par lots';

CREATE TABLE IF NOT EXISTS customers (
                                         customer_id SERIAL PRIMARY KEY,
                                         first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    date_of_birth DATE,
    address TEXT,
    allergies TEXT,
    -- age: colonne simple (pas GENERATED) pour éviter l'erreur d'immuabilité
    age INT,
    total_purchases INT DEFAULT 0,
    total_spent DECIMAL(15,2) DEFAULT 0,
    last_purchase_date DATE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );
COMMENT ON TABLE customers IS 'Clients de la pharmacie';

CREATE TABLE IF NOT EXISTS prescriptions (
                                             prescription_id SERIAL PRIMARY KEY,
                                             customer_id INT NOT NULL REFERENCES customers(customer_id),
    doctor_name VARCHAR(100) NOT NULL,
    doctor_license VARCHAR(50),
    prescription_date DATE NOT NULL,
    valid_until DATE,
    notes TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending','filled','partially_filled','cancelled')),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    medications JSONB DEFAULT '[]',
    is_filled BOOLEAN DEFAULT FALSE,
    filled_date DATE
    );

CREATE TABLE IF NOT EXISTS prescription_items (
                                                  prescription_item_id SERIAL PRIMARY KEY,
                                                  prescription_id INT NOT NULL REFERENCES prescriptions(prescription_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity_prescribed INT NOT NULL,
    quantity_dispensed INT DEFAULT 0,
    dosage_instructions TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT chk_prescribed_qty CHECK (quantity_prescribed > 0),
    CONSTRAINT chk_dispensed_qty CHECK (quantity_dispensed >= 0 AND quantity_dispensed <= quantity_prescribed)
    );

CREATE TABLE IF NOT EXISTS sales (
                                     sale_id SERIAL PRIMARY KEY,
                                     customer_id INT REFERENCES customers(customer_id),
    prescription_id INT REFERENCES prescriptions(prescription_id),
    sale_date TIMESTAMP DEFAULT NOW(),
    subtotal NUMERIC(10,2) NOT NULL,
    discount_amount NUMERIC(10,2) DEFAULT 0,
    tax_amount NUMERIC(10,2) DEFAULT 0,
    total_amount NUMERIC(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('cash','card','insurance','mobile_payment')),
    payment_status VARCHAR(20) DEFAULT 'paid' CHECK (payment_status IN ('paid','pending','refunded')),
    served_by VARCHAR(50),
    notes TEXT,
    CONSTRAINT chk_amounts CHECK (total_amount >= 0 AND subtotal >= 0)
    );

CREATE TABLE IF NOT EXISTS sale_items (
                                          sale_item_id SERIAL PRIMARY KEY,
                                          sale_id INT NOT NULL REFERENCES sales(sale_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id),
    inventory_id INT NOT NULL REFERENCES inventory(inventory_id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    discount NUMERIC(10,2) DEFAULT 0,
    line_total NUMERIC(10,2) NOT NULL,
    CONSTRAINT chk_sale_qty CHECK (quantity > 0),
    CONSTRAINT chk_line_total CHECK (line_total >= 0)
    );

CREATE TABLE IF NOT EXISTS purchase_orders (
                                               po_id SERIAL PRIMARY KEY,
                                               supplier_id INT NOT NULL REFERENCES suppliers(supplier_id),
    order_date DATE NOT NULL,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending','approved','received','cancelled')),
    total_amount NUMERIC(10,2),
    notes TEXT,
    created_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );

CREATE TABLE IF NOT EXISTS purchase_order_items (
                                                    po_item_id SERIAL PRIMARY KEY,
                                                    po_id INT NOT NULL REFERENCES purchase_orders(po_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity_ordered INT NOT NULL,
    quantity_received INT DEFAULT 0,
    unit_price NUMERIC(10,2) NOT NULL,
    line_total NUMERIC(10,2) NOT NULL,
    CONSTRAINT chk_po_qty CHECK (quantity_ordered > 0),
    CONSTRAINT chk_received_qty CHECK (quantity_received >= 0 AND quantity_received <= quantity_ordered)
    );

CREATE TABLE IF NOT EXISTS stock_adjustments (
                                                 adjustment_id SERIAL PRIMARY KEY,
                                                 inventory_id INT NOT NULL REFERENCES inventory(inventory_id),
    adjustment_type VARCHAR(20) NOT NULL CHECK (adjustment_type IN ('damage','expiry','theft','correction','return')),
    quantity_adjusted INT NOT NULL,
    reason TEXT,
    adjusted_by VARCHAR(50),
    adjustment_date TIMESTAMP DEFAULT NOW()
    );

CREATE TABLE IF NOT EXISTS users (
                                     id BIGSERIAL PRIMARY KEY,
                                     username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    role VARCHAR(50) NOT NULL DEFAULT 'ADMIN',
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS stock_movements (
                                               id BIGSERIAL PRIMARY KEY,
                                               product_id INT NOT NULL REFERENCES products(product_id),
    change_qty INT NOT NULL,
    movement_type VARCHAR(30) NOT NULL,
    reference VARCHAR(100),
    batch_number VARCHAR(50),
    expiration_date DATE,
    unit_cost NUMERIC(10,2),
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW()
    );

-- =====================================================
-- 5. VUES POUR LES REQUÊTES COURANTES (inchangées)
-- =====================================================

CREATE OR REPLACE VIEW v_inventory AS
SELECT
    inventory_id,
    product_id,
    batch_number,
    supplier_id,
    quantity_in_stock,
    quantity_reserved,
    manufacturing_date,
    expiry_date,
    purchase_price,
    received_date,
    location,
    created_at,
    updated_at,
    (expiry_date < CURRENT_DATE) AS is_expired
FROM inventory;

CREATE OR REPLACE VIEW v_current_stock AS
SELECT
    p.product_id,
    p.product_name,
    p.generic_name,
    c.category_name,
    COALESCE(SUM(i.quantity_in_stock), 0) AS total_quantity,
    COALESCE(SUM(i.quantity_reserved), 0) AS reserved_quantity,
    COALESCE(SUM(i.quantity_in_stock - i.quantity_reserved), 0) AS available_quantity,
    p.reorder_level,
    CASE
        WHEN COALESCE(SUM(i.quantity_in_stock - i.quantity_reserved), 0) = 0 THEN 'OUT OF STOCK'
        WHEN COALESCE(SUM(i.quantity_in_stock - i.quantity_reserved), 0) <= p.reorder_level THEN 'LOW STOCK'
        ELSE 'IN STOCK'
        END AS stock_status
FROM products p
         LEFT JOIN inventory i ON p.product_id = i.product_id
         LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.product_name, p.generic_name, c.category_name, p.reorder_level;

CREATE OR REPLACE VIEW v_expiring_products AS
SELECT
    p.product_name,
    i.batch_number,
    i.quantity_in_stock,
    i.expiry_date,
    (i.expiry_date - CURRENT_DATE) AS days_until_expiry,
    s.supplier_name
FROM inventory i
         JOIN products p ON i.product_id = p.product_id
         LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id
WHERE i.expiry_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '60 day')
  AND i.quantity_in_stock > 0
ORDER BY i.expiry_date;

CREATE OR REPLACE VIEW v_sales_summary AS
SELECT
    s.sale_date::date AS sale_date,
    COUNT(DISTINCT s.sale_id) AS total_transactions,
    COUNT(DISTINCT s.customer_id) AS unique_customers,
    SUM(si.quantity) AS items_sold,
    SUM(s.subtotal) AS subtotal,
    SUM(s.discount_amount) AS total_discounts,
    SUM(s.tax_amount) AS total_tax,
    SUM(s.total_amount) AS total_revenue
FROM sales s
         JOIN sale_items si ON s.sale_id = si.sale_id
GROUP BY s.sale_date::date;

-- autres vues ajoutées plus bas (v_customer_stats, v_daily_sales, v_top_products, v_pending_prescriptions)
-- (je conserve les définitions - inchangées sauf si besoin de modifications logiques)

-- =====================================================
-- 6. DONNÉES D'EXEMPLE SIMPLES (inchangées)
-- =====================================================

INSERT INTO categories (category_name, description) VALUES
                                                        ('Analgésiques', 'Médicaments contre la douleur'),
                                                        ('Antibiotiques', 'Antimicrobiens')
    ON CONFLICT (category_name) DO NOTHING;

INSERT INTO suppliers (supplier_name, city, country) VALUES
                                                         ('MediCorp', 'Paris', 'France'),
                                                         ('Global Health', 'Lyon', 'France')
    ON CONFLICT DO NOTHING;

INSERT INTO products (product_name, unit_price, selling_price, category_id) VALUES
                                                                                ('Paracétamol 500mg', 0.10, 0.25, 1),
                                                                                ('Amoxicilline 500mg', 0.50, 1.20, 2)
    ON CONFLICT DO NOTHING;

INSERT INTO inventory (product_id, batch_number, supplier_id, quantity_in_stock, expiry_date) VALUES
                                                                                                  (1, 'BATCH001', 1, 100, '2026-12-31'),
                                                                                                  (2, 'BATCH002', 2, 50, '2026-06-30')
    ON CONFLICT DO NOTHING;

INSERT INTO customers (first_name, last_name) VALUES
                                                  ('Jean', 'Dupont'),
                                                  ('Marie', 'Martin')
    ON CONFLICT DO NOTHING;

INSERT INTO users (username, password, role, active) VALUES
    ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'ADMIN', true)
    ON CONFLICT (username) DO NOTHING;

-- =====================================================
-- 7. STATISTIQUES RAPIDES (inchangées)
-- =====================================================

SELECT
    (SELECT COUNT(*) FROM categories) as categories,
    (SELECT COUNT(*) FROM suppliers) as suppliers,
    (SELECT COUNT(*) FROM products) as products,
    (SELECT COUNT(*) FROM inventory) as inventory_items,
    (SELECT COUNT(*) FROM customers) as customers,
    (SELECT COUNT(*) FROM users) as users;

-- =====================================================
-- 3.11. PARAMÈTRES D'APPLICATION (inchangés)
-- =====================================================

CREATE TABLE IF NOT EXISTS application_parameters (
                                                      parameter_id SERIAL PRIMARY KEY,
                                                      parameter_key VARCHAR(100) NOT NULL UNIQUE,
    parameter_value TEXT NOT NULL,
    parameter_type VARCHAR(20) NOT NULL CHECK (parameter_type IN ('STRING','INTEGER','BOOLEAN','DECIMAL','DATE')),
    category VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );
COMMENT ON TABLE application_parameters IS 'Paramètres de configuration de l''application';

CREATE INDEX IF NOT EXISTS idx_parameters_key ON application_parameters(parameter_key);
CREATE INDEX IF NOT EXISTS idx_parameters_category ON application_parameters(category);

-- =====================================================
-- 3.12. RAPPORTS (AJOUT) (inchangé)
-- =====================================================

CREATE TABLE IF NOT EXISTS reports (
                                       report_id SERIAL PRIMARY KEY,
                                       report_type VARCHAR(50) NOT NULL CHECK (report_type IN ('SALES','STOCK','CUSTOMER','FINANCIAL','PRESCRIPTION','INVENTORY','PRODUCT')),
    report_name VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    parameters JSONB DEFAULT '{}',
    format VARCHAR(20) DEFAULT 'HTML' CHECK (format IN ('HTML','PDF','EXCEL','CSV')),
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING','GENERATING','COMPLETED','FAILED')),
    file_path VARCHAR(500),
    generated_at TIMESTAMP,
    generated_by VARCHAR(100),
    report_data JSONB,
    summary JSONB DEFAULT '{}',
    details JSONB DEFAULT '[]',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );
COMMENT ON TABLE reports IS 'Rapports générés par le système';

CREATE INDEX IF NOT EXISTS idx_reports_type ON reports(report_type);
CREATE INDEX IF NOT EXISTS idx_reports_date ON reports(start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_reports_status ON reports(status);
CREATE INDEX IF NOT EXISTS idx_reports_generated ON reports(generated_at);

-- =====================================================
-- 3.13. AUDIT TRAIL (AJOUT) (inchangé)
-- =====================================================

CREATE TABLE IF NOT EXISTS audit_logs (
                                          log_id SERIAL PRIMARY KEY,
                                          user_id BIGINT REFERENCES users(id),
    action_type VARCHAR(50) NOT NULL,
    table_name VARCHAR(50),
    record_id VARCHAR(100),
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
    );
COMMENT ON TABLE audit_logs IS 'Journal d''audit des actions utilisateurs';
CREATE INDEX IF NOT EXISTS idx_audit_user ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_logs(action_type);
CREATE INDEX IF NOT EXISTS idx_audit_created ON audit_logs(created_at);

-- =====================================================
-- 3.14. NOTIFICATIONS (AJOUT) (inchangé)
-- =====================================================

CREATE TABLE IF NOT EXISTS notifications (
                                             notification_id SERIAL PRIMARY KEY,
                                             user_id BIGINT REFERENCES users(id),
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(30) CHECK (type IN ('INFO','WARNING','ERROR','SUCCESS','STOCK_ALERT','EXPIRY_ALERT')),
    is_read BOOLEAN DEFAULT FALSE,
    action_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW(),
    read_at TIMESTAMP
    );
COMMENT ON TABLE notifications IS 'Notifications système pour les utilisateurs';
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created ON notifications(created_at);

-- =====================================================
-- FONCTIONS UTILES (corrections)
-- =====================================================

-- Fonction calculate_age (utile si tu veux l'appeler ailleurs)
DROP FUNCTION IF EXISTS calculate_age(date);
CREATE OR REPLACE FUNCTION calculate_age(birth_date DATE)
RETURNS INT AS $$
BEGIN
    IF birth_date IS NULL THEN
        RETURN NULL;
END IF;
RETURN DATE_PART('year', AGE(birth_date))::INT;
END;
$$ LANGUAGE plpgsql;

-- Fonction check_product_stock: signature corrigée (paramètre explicite)
DROP FUNCTION IF EXISTS check_product_stock(INT);
CREATE OR REPLACE FUNCTION check_product_stock(p_product_id INT)
RETURNS TABLE (
    total_stock INT,
    available_stock INT,
    status VARCHAR(20)
) AS $$
BEGIN
RETURN QUERY
SELECT
    COALESCE(SUM(i.quantity_in_stock), 0)::INT AS total_stock,
    COALESCE(SUM(i.quantity_in_stock - i.quantity_reserved), 0)::INT AS available_stock,
    CASE
        WHEN COALESCE(SUM(i.quantity_in_stock), 0) = 0 THEN 'OUT_OF_STOCK'
        WHEN COALESCE(SUM(i.quantity_in_stock - i.quantity_reserved), 0) = 0 THEN 'RESERVED'
        WHEN COALESCE(SUM(i.quantity_in_stock - i.quantity_reserved), 0) <= p.reorder_level THEN 'LOW_STOCK'
        ELSE 'IN_STOCK'
        END AS status
FROM products p
         LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.product_id = p_product_id
GROUP BY p.product_id, p.reorder_level;
END;
$$ LANGUAGE plpgsql;

-- Fonction generate_sales_report (inchangée)
DROP FUNCTION IF EXISTS generate_sales_report(date, date);
CREATE OR REPLACE FUNCTION generate_sales_report(start_date DATE, end_date DATE)
RETURNS TABLE (
    sale_day DATE,
    total_transactions BIGINT,
    total_revenue DECIMAL(15,2),
    avg_transaction_value DECIMAL(15,2),
    items_sold BIGINT
) AS $$
BEGIN
RETURN QUERY
SELECT
    DATE(s.sale_date) AS sale_day,
    COUNT(DISTINCT s.sale_id) AS total_transactions,
    COALESCE(SUM(s.total_amount), 0) AS total_revenue,
    COALESCE(AVG(s.total_amount), 0) AS avg_transaction_value,
    COALESCE(SUM(si.quantity), 0) AS items_sold
FROM sales s
    JOIN sale_items si ON s.sale_id = si.sale_id
WHERE DATE(s.sale_date) BETWEEN start_date AND end_date
GROUP BY DATE(s.sale_date)
ORDER BY sale_day;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- TRIGGERS POUR LA MISE À JOUR AUTOMATIQUE
-- =====================================================

-- Trigger update_updated_at_column (générique)
DROP FUNCTION IF EXISTS update_updated_at_column();
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquer le trigger (DROP/CREATE pour éviter collisions)
DROP TRIGGER IF EXISTS update_customers_updated_at ON customers;
CREATE TRIGGER update_customers_updated_at
    BEFORE UPDATE ON customers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_inventory_updated_at ON inventory;
CREATE TRIGGER update_inventory_updated_at
    BEFORE UPDATE ON inventory
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_prescriptions_updated_at ON prescriptions;
CREATE TRIGGER update_prescriptions_updated_at
    BEFORE UPDATE ON prescriptions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_sales_updated_at ON sales;
CREATE TRIGGER update_sales_updated_at
    BEFORE UPDATE ON sales
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_reports_updated_at ON reports;
CREATE TRIGGER update_reports_updated_at
    BEFORE UPDATE ON reports
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_parameters_updated_at ON application_parameters;
CREATE TRIGGER update_parameters_updated_at
    BEFORE UPDATE ON application_parameters
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour mettre à jour l'age du client (remplace GENERATED ALWAYS)
DROP FUNCTION IF EXISTS update_customer_age();
CREATE OR REPLACE FUNCTION update_customer_age()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_of_birth IS NOT NULL THEN
        NEW.age := DATE_PART('year', AGE(NEW.date_of_birth))::INT;
ELSE
        NEW.age := NULL;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_customer_age ON customers;
CREATE TRIGGER trg_update_customer_age
    BEFORE INSERT OR UPDATE ON customers
                         FOR EACH ROW EXECUTE FUNCTION update_customer_age();

-- Trigger pour mettre à jour les statistiques des clients (utilise NEW.customer_id)
DROP FUNCTION IF EXISTS update_customer_stats();
CREATE OR REPLACE FUNCTION update_customer_stats()
RETURNS TRIGGER AS $$
BEGIN
UPDATE customers c
SET
    total_purchases = (
        SELECT COUNT(*)
        FROM sales
        WHERE customer_id = c.customer_id
    ),
    total_spent = (
        SELECT COALESCE(SUM(total_amount), 0)
        FROM sales
        WHERE customer_id = c.customer_id
    ),
    last_purchase_date = (
        SELECT MAX(sale_date)
        FROM sales
        WHERE customer_id = c.customer_id
    )
WHERE c.customer_id = NEW.customer_id;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_customer_stats_trigger ON sales;
CREATE TRIGGER update_customer_stats_trigger
    AFTER INSERT OR UPDATE ON sales
                        FOR EACH ROW EXECUTE FUNCTION update_customer_stats();

-- Trigger pour mettre à jour les statistiques des produits
DROP FUNCTION IF EXISTS update_product_stats();
CREATE OR REPLACE FUNCTION update_product_stats()
RETURNS TRIGGER AS $$
BEGIN
UPDATE products p
SET
    total_sold = (
        SELECT COALESCE(SUM(si.quantity), 0)
        FROM sale_items si
        WHERE si.product_id = p.product_id
    ),
    total_revenue = (
        SELECT COALESCE(SUM(si.line_total), 0)
        FROM sale_items si
        WHERE si.product_id = p.product_id
    ),
    last_sold_date = (
        SELECT MAX(s.sale_date)
        FROM sales s
                 JOIN sale_items si ON s.sale_id = si.sale_id
        WHERE si.product_id = p.product_id
    )
WHERE p.product_id = NEW.product_id;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_product_stats_trigger ON sale_items;
CREATE TRIGGER update_product_stats_trigger
    AFTER INSERT OR UPDATE ON sale_items
                        FOR EACH ROW EXECUTE FUNCTION update_product_stats();

-- =====================================================
-- DONNÉES PAR DÉFAUT POUR LES PARAMÈTRES (inchangées)
-- =====================================================

INSERT INTO application_parameters (parameter_key, parameter_value, parameter_type, category, description) VALUES
-- Paramètres généraux
('app.name', 'PharmaPlus', 'STRING', 'GENERAL', 'Nom de l''application'),
('app.version', '1.0.0', 'STRING', 'GENERAL', 'Version de l''application'),
('company.name', 'OneMaster Pharma', 'STRING', 'GENERAL', 'Nom de la pharmacie'),
('company.address', '', 'STRING', 'GENERAL', 'Adresse de la pharmacie'),
('company.phone', '', 'STRING', 'GENERAL', 'Téléphone de la pharmacie'),
('company.email', '', 'STRING', 'GENERAL', 'Email de la pharmacie'),

-- Paramètres UI
('pagination.items_per_page', '20', 'INTEGER', 'UI', 'Nombre d''éléments par page'),
('ui.date_format', 'dd/MM/yyyy', 'STRING', 'UI', 'Format de date'),
('ui.time_format', 'HH:mm', 'STRING', 'UI', 'Format d''heure'),
('ui.theme', 'light', 'STRING', 'UI', 'Thème de l''interface'),
('ui.language', 'fr', 'STRING', 'UI', 'Langue de l''interface'),

-- Paramètres de sécurité
('security.session_timeout', '30', 'INTEGER', 'SECURITY', 'Timeout session (minutes)'),
('security.password_min_length', '8', 'INTEGER', 'SECURITY', 'Longueur minimale mot de passe'),
('security.login_attempts', '3', 'INTEGER', 'SECURITY', 'Tentatives de connexion max'),

-- Paramètres financiers
('financial.vat_rate', '0.2', 'DECIMAL', 'FINANCIAL', 'Taux de TVA'),
('financial.default_currency', 'MGA', 'STRING', 'FINANCIAL', 'Devise par défaut'),

-- Paramètres des fonctionnalités
('feature.auto_save', 'true', 'BOOLEAN', 'FEATURE', 'Sauvegarde automatique'),
('feature.export_enabled', 'true', 'BOOLEAN', 'FEATURE', 'Exportation activée'),

-- Paramètres de notification
('notification.email.enabled', 'false', 'BOOLEAN', 'NOTIFICATION', 'Notifications email activées'),
('notification.stock_alert', 'true', 'BOOLEAN', 'NOTIFICATION', 'Alerte stock bas'),
('notification.expiry_alert_days', '30', 'INTEGER', 'NOTIFICATION', 'Jours avant alerte expiration'),

-- Paramètres métiers
('business.working_hours_start', '08:00', 'STRING', 'BUSINESS', 'Heure d''ouverture'),
('business.working_hours_end', '18:00', 'STRING', 'BUSINESS', 'Heure de fermeture'),
('business.default_payment_method', 'CASH', 'STRING', 'BUSINESS', 'Mode de paiement par défaut')
    ON CONFLICT (parameter_key) DO UPDATE SET
    parameter_value = EXCLUDED.parameter_value,
                                       parameter_type = EXCLUDED.parameter_type,
                                       category = EXCLUDED.category,
                                       description = EXCLUDED.description,
                                       updated_at = NOW();

-- =====================================================
-- 4. INDEXES POUR LES PERFORMANCES (inchangés)
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_product_name ON products(product_name);
CREATE INDEX IF NOT EXISTS idx_product_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_product_barcode ON products(barcode);
CREATE INDEX IF NOT EXISTS idx_inventory_product ON inventory(product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_expiry ON inventory(expiry_date);
CREATE INDEX IF NOT EXISTS idx_inventory_batch ON inventory(batch_number);
CREATE INDEX IF NOT EXISTS idx_sales_date ON sales(sale_date);
CREATE INDEX IF NOT EXISTS idx_sales_customer ON sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_prescription_customer ON prescriptions(customer_id);
CREATE INDEX IF NOT EXISTS idx_prescription_status ON prescriptions(status);
CREATE INDEX IF NOT EXISTS idx_customers_name ON customers(last_name, first_name);
CREATE INDEX IF NOT EXISTS idx_suppliers_name ON suppliers(supplier_name);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- =====================================================
-- STATISTIQUES MISE À JOUR (inchangées)
-- =====================================================

SELECT '=== BASE DE DONNÉES PHARMAPLUS MISE À JOUR ===' AS message;

SELECT
    (SELECT COUNT(*) FROM categories) as categories,
    (SELECT COUNT(*) FROM suppliers) as suppliers,
    (SELECT COUNT(*) FROM products) as products,
    (SELECT COUNT(*) FROM inventory) as inventory_items,
    (SELECT COUNT(*) FROM customers) as customers,
    (SELECT COUNT(*) FROM prescriptions) as prescriptions,
    (SELECT COUNT(*) FROM sales) as sales,
    (SELECT COUNT(*) FROM reports) as reports,
    (SELECT COUNT(*) FROM application_parameters) as parameters,
    (SELECT COUNT(*) FROM users) as users;

SELECT '=== VUES DISPONIBLES ===' AS message;
SELECT table_name FROM information_schema.views
WHERE table_schema = 'public'
ORDER BY table_name;
