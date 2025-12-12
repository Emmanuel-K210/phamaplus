-- Extensions utiles
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- TABLES DE BASE
-- =============================================

-- Table des catégories
CREATE TABLE categories (
                            category_id SERIAL PRIMARY KEY,
                            category_name VARCHAR(100) NOT NULL UNIQUE,
                            description TEXT,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE categories IS 'Catégories de produits pharmaceutiques';

-- Table des fournisseurs
CREATE TABLE suppliers (
                           supplier_id SERIAL PRIMARY KEY,
                           supplier_name VARCHAR(100) NOT NULL,
                           contact_person VARCHAR(100),
                           phone VARCHAR(20),
                           email VARCHAR(100),
                           address TEXT,
                           city VARCHAR(50),
                           country VARCHAR(50) DEFAULT 'France',
                           reorder_level INTEGER DEFAULT 10,
                           is_active BOOLEAN DEFAULT true,
                           barcode VARCHAR(50) ,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE suppliers IS 'Fournisseurs de produits pharmaceutiques';

-- Table des produits
CREATE TABLE products (
                          product_id SERIAL PRIMARY KEY,
                          product_name VARCHAR(200) NOT NULL,
                          generic_name VARCHAR(200),
                          category_id INTEGER REFERENCES categories(category_id),
                          manufacturer VARCHAR(100),
                          dosage_form VARCHAR(50),
                          strength VARCHAR(50),
                          unit_of_measure VARCHAR(20) DEFAULT 'piece',
                          requires_prescription BOOLEAN DEFAULT false,
                          unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
                          selling_price NUMERIC(10,2) NOT NULL CHECK (selling_price >= 0),
                          reorder_level INTEGER DEFAULT 10,
                          barcode VARCHAR(50) UNIQUE,
                          is_active BOOLEAN DEFAULT true,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          total_sold INTEGER DEFAULT 0,
                          total_revenue NUMERIC(18,2) DEFAULT 0,
                          last_sold_date TIMESTAMP
);

COMMENT ON TABLE products IS 'Produits pharmaceutiques en vente';

-- Ajout de la contrainte après création pour éviter les problèmes
ALTER TABLE products ADD CONSTRAINT chk_prices CHECK (selling_price >= unit_price);

-- Table des clients
CREATE TABLE customers (
                           customer_id SERIAL PRIMARY KEY,
                           first_name VARCHAR(50) NOT NULL,
                           last_name VARCHAR(50) NOT NULL,
                           phone VARCHAR(20),
                           email VARCHAR(100),
                           date_of_birth DATE,
                           address TEXT,
                           allergies TEXT,
                           age INTEGER,
                           total_purchases INTEGER DEFAULT 0,
                           total_spent NUMERIC(15,2) DEFAULT 0,
                           last_purchase_date DATE,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE customers IS 'Clients de la pharmacie';

-- Index pour recherche rapide des clients
CREATE INDEX idx_customers_name ON customers(last_name, first_name);
CREATE INDEX idx_customers_phone ON customers(phone);

-- Table d'inventaire (stock par lot)
CREATE TABLE inventory (
                           inventory_id SERIAL PRIMARY KEY,
                           product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
                           batch_number VARCHAR(50) NOT NULL,
                           supplier_id INTEGER REFERENCES suppliers(supplier_id),
                           quantity_in_stock INTEGER DEFAULT 0 NOT NULL CHECK (quantity_in_stock >= 0),
                           quantity_reserved INTEGER DEFAULT 0 CHECK (quantity_reserved >= 0 AND quantity_reserved <= quantity_in_stock),
                           manufacturing_date DATE,
                           expiry_date DATE NOT NULL,
                           purchase_price NUMERIC(10,2),
                           received_date DATE DEFAULT CURRENT_DATE,
                           location VARCHAR(50),
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           UNIQUE(product_id, batch_number)
);

COMMENT ON TABLE inventory IS 'Stock des produits par lots';

-- Index pour l'inventaire
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_inventory_expiry ON inventory(expiry_date);
CREATE INDEX idx_inventory_batch ON inventory(batch_number);

-- Table des prescriptions
CREATE TABLE prescriptions (
                               prescription_id SERIAL PRIMARY KEY,
                               customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
                               doctor_name VARCHAR(100) NOT NULL,
                               doctor_license VARCHAR(50),
                               prescription_date DATE NOT NULL,
                               valid_until DATE,
                               notes TEXT,
                               status VARCHAR(20) DEFAULT 'pending'
                                   CHECK (status IN ('pending', 'filled', 'partially_filled', 'cancelled')),
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_prescription_customer ON prescriptions(customer_id);
CREATE INDEX idx_prescription_status ON prescriptions(status);

-- Table des items de prescription
CREATE TABLE prescription_items (
                                    prescription_item_id SERIAL PRIMARY KEY,
                                    prescription_id INTEGER NOT NULL REFERENCES prescriptions(prescription_id) ON DELETE CASCADE,
                                    product_id INTEGER NOT NULL REFERENCES products(product_id),
                                    quantity_prescribed INTEGER NOT NULL CHECK (quantity_prescribed > 0),
                                    quantity_dispensed INTEGER DEFAULT 0
                                        CHECK (quantity_dispensed >= 0 AND quantity_dispensed <= quantity_prescribed),
                                    dosage_instructions TEXT,
                                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TABLES DE VENTES
-- =============================================

-- Table des ventes
CREATE TABLE sales (
                       sale_id SERIAL PRIMARY KEY,
                       customer_id INTEGER REFERENCES customers(customer_id),
                       prescription_id INTEGER REFERENCES prescriptions(prescription_id),
                       sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       subtotal NUMERIC(10,2) NOT NULL CHECK (subtotal >= 0),
                       discount_amount NUMERIC(10,2) DEFAULT 0,
                       tax_amount NUMERIC(10,2) DEFAULT 0,
                       total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
                       payment_method VARCHAR(20) NOT NULL
                           CHECK (payment_method IN ('cash', 'card', 'insurance', 'mobile_payment')),
                       payment_status VARCHAR(20) DEFAULT 'paid'
                           CHECK (payment_status IN ('paid', 'pending', 'refunded')),
                       served_by VARCHAR(50),
                       notes TEXT
);

CREATE INDEX idx_sales_customer ON sales(customer_id);
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_payment ON sales(payment_method);

-- Table des items de vente
CREATE TABLE sale_items (
                            sale_item_id SERIAL PRIMARY KEY,
                            sale_id INTEGER NOT NULL REFERENCES sales(sale_id) ON DELETE CASCADE,
                            product_id INTEGER NOT NULL REFERENCES products(product_id),
                            inventory_id INTEGER NOT NULL REFERENCES inventory(inventory_id),
                            quantity INTEGER NOT NULL CHECK (quantity > 0),
                            unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
                            discount NUMERIC(10,2) DEFAULT 0,
                            line_total NUMERIC(10,2) NOT NULL CHECK (line_total >= 0)
);

-- =============================================
-- AUTRES TABLES
-- =============================================

-- Table des commandes d'achat
CREATE TABLE purchase_orders (
                                 po_id SERIAL PRIMARY KEY,
                                 supplier_id INTEGER NOT NULL REFERENCES suppliers(supplier_id),
                                 order_date DATE NOT NULL,
                                 expected_delivery_date DATE,
                                 actual_delivery_date DATE,
                                 status VARCHAR(20) DEFAULT 'pending'
                                     CHECK (status IN ('pending', 'approved', 'received', 'cancelled')),
                                 total_amount NUMERIC(10,2),
                                 notes TEXT,
                                 created_by VARCHAR(50),
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des items de commande d'achat
CREATE TABLE purchase_order_items (
                                      po_item_id SERIAL PRIMARY KEY,
                                      po_id INTEGER NOT NULL REFERENCES purchase_orders(po_id) ON DELETE CASCADE,
                                      product_id INTEGER NOT NULL REFERENCES products(product_id),
                                      quantity_ordered INTEGER NOT NULL CHECK (quantity_ordered > 0),
                                      quantity_received INTEGER DEFAULT 0
                                          CHECK (quantity_received >= 0 AND quantity_received <= quantity_ordered),
                                      unit_price NUMERIC(10,2) NOT NULL,
                                      line_total NUMERIC(10,2) NOT NULL
);

-- Table des ajustements de stock
CREATE TABLE stock_adjustments (
                                   adjustment_id SERIAL PRIMARY KEY,
                                   inventory_id INTEGER NOT NULL REFERENCES inventory(inventory_id),
                                   adjustment_type VARCHAR(20) NOT NULL
                                       CHECK (adjustment_type IN ('damage', 'expiry', 'theft', 'correction', 'return')),
                                   quantity_adjusted INTEGER NOT NULL,
                                   reason TEXT,
                                   adjusted_by VARCHAR(50),
                                   adjustment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des mouvements de stock
CREATE TABLE stock_movements (
                                 id BIGSERIAL PRIMARY KEY,
                                 product_id INTEGER NOT NULL REFERENCES products(product_id),
                                 change_qty INTEGER NOT NULL,
                                 movement_type VARCHAR(30) NOT NULL,
                                 reference VARCHAR(100),
                                 batch_number VARCHAR(50),
                                 expiration_date DATE,
                                 unit_cost NUMERIC(10,2),
                                 created_by BIGINT,
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des utilisateurs
CREATE TABLE users (
                       id BIGSERIAL PRIMARY KEY,
                       username VARCHAR(100) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       full_name VARCHAR(255),
                       role VARCHAR(50) DEFAULT 'ADMIN' NOT NULL,
                       active BOOLEAN DEFAULT true,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       last_login TIMESTAMP
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);

-- Table des journaux d'audit
CREATE TABLE audit_logs (
                            log_id SERIAL PRIMARY KEY,
                            user_id BIGINT REFERENCES users(id),
                            action_type VARCHAR(50) NOT NULL,
                            table_name VARCHAR(50),
                            record_id VARCHAR(100),
                            old_values JSONB,
                            new_values JSONB,
                            ip_address INET,
                            user_agent TEXT,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_action ON audit_logs(action_type);
CREATE INDEX idx_audit_created ON audit_logs(created_at);

-- Table des notifications
CREATE TABLE notifications (
                               notification_id SERIAL PRIMARY KEY,
                               user_id BIGINT REFERENCES users(id),
                               title VARCHAR(200) NOT NULL,
                               message TEXT NOT NULL,
                               type VARCHAR(30)
                                   CHECK (type IN ('INFO', 'WARNING', 'ERROR', 'SUCCESS', 'STOCK_ALERT', 'EXPIRY_ALERT')),
                               is_read BOOLEAN DEFAULT false,
                               action_url VARCHAR(500),
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               read_at TIMESTAMP
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_notifications_created ON notifications(created_at);

-- Table des rapports
CREATE TABLE reports (
                         report_id SERIAL PRIMARY KEY,
                         report_type VARCHAR(50) NOT NULL
                             CHECK (report_type IN ('SALES', 'STOCK', 'CUSTOMER', 'FINANCIAL', 'PRESCRIPTION', 'INVENTORY', 'PRODUCT')),
                         report_name VARCHAR(200) NOT NULL,
                         description TEXT,
                         start_date DATE,
                         end_date DATE,
                         parameters JSONB DEFAULT '{}'::jsonb,
                         format VARCHAR(20) DEFAULT 'HTML'
                             CHECK (format IN ('HTML', 'PDF', 'EXCEL', 'CSV')),
                         status VARCHAR(20) DEFAULT 'PENDING'
                             CHECK (status IN ('PENDING', 'GENERATING', 'COMPLETED', 'FAILED')),
                         file_path VARCHAR(500),
                         generated_at TIMESTAMP,
                         generated_by VARCHAR(100),
                         report_data JSONB,
                         summary JSONB DEFAULT '{}'::jsonb,
                         details JSONB DEFAULT '[]'::jsonb,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reports_type ON reports(report_type);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_date ON reports(start_date, end_date);
CREATE INDEX idx_reports_generated ON reports(generated_at);

-- Table des paramètres d'application
CREATE TABLE application_parameters (
                                        parameter_id SERIAL PRIMARY KEY,
                                        parameter_key VARCHAR(100) NOT NULL UNIQUE,
                                        parameter_value TEXT NOT NULL,
                                        parameter_type VARCHAR(20) NOT NULL
                                            CHECK (parameter_type IN ('STRING', 'INTEGER', 'BOOLEAN', 'DECIMAL', 'DATE')),
                                        category VARCHAR(50) NOT NULL,
                                        description TEXT,
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_parameters_key ON application_parameters(parameter_key);
CREATE INDEX idx_parameters_category ON application_parameters(category);
--Tables de medical_receipts (recu medical)
CREATE TABLE medical_receipts (
                                  receipt_id SERIAL PRIMARY KEY,
                                  receipt_number VARCHAR(50) UNIQUE NOT NULL,
                                  receipt_date TIMESTAMP NOT NULL,
                                  patient_name VARCHAR(255) NOT NULL,
                                  patient_contact VARCHAR(50),
                                  service_type VARCHAR(100) NOT NULL,
                                  amount NUMERIC(15, 2) NOT NULL CHECK (amount >= 0),
                                  amount_in_words TEXT,
                                  served_by VARCHAR(100),
                                  notes TEXT,
                                  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE receipt_sequence (
                                  id SERIAL PRIMARY KEY,
                                  prefix VARCHAR(10) DEFAULT 'REC',
                                  year INTEGER NOT NULL,
                                  month INTEGER NOT NULL,
                                  last_number INTEGER DEFAULT 0,
                                  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  UNIQUE (prefix, year, month)
);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

   CREATE OR REPLACE FUNCTION generate_receipt_number()
RETURNS VARCHAR(50) AS $$
DECLARE
current_year INTEGER;
    current_month INTEGER;
    next_number INTEGER;
    new_receipt_number VARCHAR(50);
BEGIN
    current_year := EXTRACT(YEAR FROM CURRENT_DATE);
    current_month := EXTRACT(MONTH FROM CURRENT_DATE);

    -- Récupérer et incrémenter le numéro
SELECT COALESCE(last_number, 0) + 1 INTO next_number
FROM receipt_sequence
WHERE prefix = 'REC'
          AND year = current_year
          AND month = current_month
    FOR UPDATE;

-- Si pas de séquence, en créer une
IF next_number IS NULL THEN
        INSERT INTO receipt_sequence (prefix, year, month, last_number)
        VALUES ('REC', current_year, current_month, 1);

        next_number := 1;
ELSE
        -- Mettre à jour la séquence
UPDATE receipt_sequence
SET last_number = next_number
WHERE prefix = 'REC'
          AND year = current_year
          AND month = current_month;
END IF;

-- Format: REC-YYYYMM-000001
new_receipt_number := 'REC-' ||
                         LPAD(current_year::TEXT, 4, '0') ||
                         LPAD(current_month::TEXT, 2, '0') ||
                         '-' ||
                         LPAD(next_number::TEXT, 6, '0');

RETURN new_receipt_number;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_receipt_number()
RETURNS VARCHAR(50) AS $$
DECLARE
current_year INTEGER;
    current_month INTEGER;
    next_number INTEGER;
    new_receipt_number VARCHAR(50);
BEGIN
    current_year := EXTRACT(YEAR FROM CURRENT_DATE);
    current_month := EXTRACT(MONTH FROM CURRENT_DATE);

    -- Récupérer et incrémenter le numéro
SELECT COALESCE(last_number, 0) + 1 INTO next_number
FROM receipt_sequence
WHERE prefix = 'REC'
          AND year = current_year
          AND month = current_month
    FOR UPDATE;

-- Si pas de séquence, en créer une
IF next_number IS NULL THEN
        INSERT INTO receipt_sequence (prefix, year, month, last_number)
        VALUES ('REC', current_year, current_month, 1);

        next_number := 1;
ELSE
        -- Mettre à jour la séquence
UPDATE receipt_sequence
SET last_number = next_number
WHERE prefix = 'REC'
          AND year = current_year
          AND month = current_month;
END IF;

    -- Format: REC-YYYYMM-000001
    new_receipt_number := 'REC-' ||
                         LPAD(current_year::TEXT, 4, '0') ||
                         LPAD(current_month::TEXT, 2, '0') ||
                         '-' ||
                         LPAD(next_number::TEXT, 6, '0');

RETURN new_receipt_number;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION validate_receipt_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Vérifier que le montant est positif
    IF NEW.amount <= 0 THEN
        RAISE EXCEPTION 'Le montant doit être positif';
END IF;

    -- Générer un numéro de reçu s'il n'est pas fourni
    IF NEW.receipt_number IS NULL THEN
        NEW.receipt_number := generate_receipt_number();
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour la date de mise à jour
CREATE TRIGGER update_medical_receipts_updated_at
    BEFORE UPDATE ON medical_receipts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour la validation à l'insertion
CREATE TRIGGER before_medical_receipts_insert
    BEFORE INSERT ON medical_receipts
    FOR EACH ROW
    EXECUTE FUNCTION validate_receipt_insert();

INSERT INTO receipt_sequence (prefix, year, month, last_number)
VALUES ('REC', EXTRACT(YEAR FROM CURRENT_DATE), EXTRACT(MONTH FROM CURRENT_DATE), 0)
    ON CONFLICT (prefix, year, month) DO NOTHING;

CREATE INDEX idx_medical_receipts_number ON medical_receipts(receipt_number);
CREATE INDEX idx_medical_receipts_date ON medical_receipts(receipt_date);
CREATE INDEX idx_medical_receipts_patient ON medical_receipts(patient_name);
CREATE INDEX idx_medical_receipts_service ON medical_receipts(service_type);

CREATE TABLE medical_service_types (
                                       service_id SERIAL PRIMARY KEY,
                                       service_code VARCHAR(20) UNIQUE NOT NULL,
                                       service_name VARCHAR(100) NOT NULL,
                                       service_category VARCHAR(50),
                                       default_price NUMERIC(15, 2),
                                       is_active BOOLEAN DEFAULT TRUE,
                                       description TEXT,
                                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO medical_service_types (service_code, service_name, service_category, default_price) VALUES
                                                                                                    ('OPHT', 'Ophtamo', 'Consultation', 5000.00),
                                                                                                    ('GYN', 'Gynéco', 'Consultation', 7000.00),
                                                                                                    ('ECHO', 'Écho', 'Examen', 15000.00),
                                                                                                    ('LABO', 'Labo', 'Examen', 10000.00),
                                                                                                    ('CONS-GEN', 'Consultation générale', 'Consultation', 3000.00),
                                                                                                    ('CONS-PRE', 'Consultation prénatale', 'Consultation', 5000.00),
                                                                                                    ('DERMA', 'Dermato', 'Consultation', 6000.00),
                                                                                                    ('DENT', 'Dentiste', 'Consultation', 8000.00),
                                                                                                    ('AUTRE', 'Autre', 'Divers', 0.00);
-- =============================================
-- VUES UTILES
-- =============================================

-- Vue du stock actuel
CREATE VIEW v_current_stock AS
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
WHERE p.is_active = true
GROUP BY p.product_id, p.product_name, p.generic_name, c.category_name, p.reorder_level;

-- Vue des produits expirant
CREATE VIEW v_expiring_products AS
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
WHERE i.expiry_date >= CURRENT_DATE
  AND i.expiry_date <= CURRENT_DATE + INTERVAL '60 days'
        AND i.quantity_in_stock > 0
        ORDER BY i.expiry_date;

-- Vue du résumé des ventes
CREATE VIEW v_sales_summary AS
SELECT
        DATE(s.sale_date) AS sale_date,
        COUNT(DISTINCT s.sale_id) AS total_transactions,
        COUNT(DISTINCT s.customer_id) AS unique_customers,
        SUM(si.quantity) AS items_sold,
        SUM(s.subtotal) AS subtotal,
        SUM(s.discount_amount) AS total_discounts,
        SUM(s.tax_amount) AS total_tax,
        SUM(s.total_amount) AS total_revenue
        FROM sales s
        JOIN sale_items si ON s.sale_id = si.sale_id
        GROUP BY DATE(s.sale_date);

-- =============================================
-- FONCTIONS ET TRIGGERS
-- =============================================

-- Fonction pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour calculer l'âge
CREATE OR REPLACE FUNCTION calculate_age(birth_date DATE)
RETURNS INTEGER AS $$
BEGIN
    IF birth_date IS NULL THEN
        RETURN NULL;
END IF;
RETURN DATE_PART('year', AGE(birth_date))::INT;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour vérifier le stock
CREATE OR REPLACE FUNCTION check_product_stock(p_product_id INTEGER)
RETURNS TABLE(total_stock INTEGER, available_stock INTEGER, status VARCHAR) AS $$
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

-- Fonction CORRIGÉE pour mettre à jour les statistiques des produits
CREATE OR REPLACE FUNCTION update_product_stats()
RETURNS TRIGGER AS $$
BEGIN
UPDATE products p
SET
    total_sold = (
        SELECT COALESCE(SUM(si.quantity), 0)::INTEGER
        FROM sale_items si
        WHERE si.product_id = p.product_id
    ),
    total_revenue = (
        SELECT COALESCE(SUM(si.line_total), 0)
        FROM sale_items si
        WHERE si.product_id = p.product_id
    ),
    last_sold_date = CURRENT_TIMESTAMP
WHERE p.product_id = NEW.product_id;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour mettre à jour l'âge des clients
CREATE OR REPLACE FUNCTION update_customer_age()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_of_birth IS NOT NULL THEN
        NEW.age := calculate_age(NEW.date_of_birth);
ELSE
        NEW.age := NULL;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour mettre à jour les statistiques des clients
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
        SELECT MAX(sale_date)::DATE
        FROM sales
        WHERE customer_id = c.customer_id
    )
WHERE c.customer_id = NEW.customer_id;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour générer des rapports de vente
CREATE OR REPLACE FUNCTION generate_sales_report(start_date DATE, end_date DATE)
RETURNS TABLE(
    sale_day DATE,
    total_transactions BIGINT,
    total_revenue NUMERIC,
    avg_transaction_value NUMERIC,
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

-- =============================================
-- TRIGGERS
-- =============================================

-- Triggers pour updated_at
CREATE TRIGGER update_categories_updated_at
    BEFORE UPDATE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customers_updated_at
    BEFORE UPDATE ON customers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_inventory_updated_at
    BEFORE UPDATE ON inventory
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sales_updated_at
    BEFORE UPDATE ON sales
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_prescriptions_updated_at
    BEFORE UPDATE ON prescriptions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_suppliers_updated_at
    BEFORE UPDATE ON suppliers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_parameters_updated_at
    BEFORE UPDATE ON application_parameters
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reports_updated_at
    BEFORE UPDATE ON reports
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour l'âge des clients
CREATE TRIGGER trg_update_customer_age
    BEFORE INSERT OR UPDATE ON customers
                         FOR EACH ROW
                         EXECUTE FUNCTION update_customer_age();

-- Trigger pour les statistiques des clients
CREATE TRIGGER update_customer_stats_trigger
    AFTER INSERT OR UPDATE ON sales
                        FOR EACH ROW
                        EXECUTE FUNCTION update_customer_stats();

-- Trigger CORRIGÉ pour les statistiques des produits
CREATE TRIGGER update_product_stats_trigger
    AFTER INSERT ON sale_items
    FOR EACH ROW
    EXECUTE FUNCTION update_product_stats();

-- =============================================
-- DONNÉES D'EXEMPLE (OPTIONNEL)
-- =============================================

-- Insérer un utilisateur nous même super_admin par défaut (mot de passe: oneMaster123@)
INSERT INTO users (username, password, full_name, role)
VALUES ('oneMaster', 'ddce6a449a44f807863cea0eb2ac199ccd2acd0bff7e06bf24f3c21822396a5c', 'Administrateur', 'ADMIN');
-- =========================================
--IDENTIFIANT
-- username : admin => M2P : admin123
-- username : caissier => M2P : cash123
-- username : pharmacien => M2P : pharma123
-- ==========================================
INSERT INTO users (username, password, full_name, role, active) VALUES
                                                                    ('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Administrateur', 'ADMIN', 1),
                                                                    ('pharmacien', '1c7d7f2a7668a1de0ea8f04a0ce6ff072e14781b052c51ee506a41b05d28b5cb', 'Dr. Jean Dupont', 'PHARMACIST', 1),
                                                                    ('caissier', 'c246650737293ddc18fc357393db78d1ecc9d1fd1af95469115e4a29f983359a', 'Marie Martin', 'CASHIER', 1);
ALTER TABLE sales ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE inventory ADD COLUMN selling_price DECIMAL(10,2);
-- Insérer des catégories de base
INSERT INTO categories (category_name, description) VALUES
                                                        ('Analgésiques', 'Médicaments contre la douleur'),
                                                        ('Antibiotiques', 'Médicaments antibactériens'),
                                                        ('Antihistaminiques', 'Médicaments contre les allergies'),
                                                        ('Vitamines', 'Compléments vitaminiques'),
                                                        ('Soins de la peau', 'Produits dermatologiques'),
                                                        ('Premiers secours', 'Matériel de premiers soins');

-- Insérer un fournisseur
INSERT INTO suppliers (supplier_name, contact_person, phone, email, address)
VALUES ('PharmaDistrib', 'Jean Dupont', '+33123456789', 'contact@pharmadistrib.fr', '123 Rue de la Santé, Paris');

-- Insérer des produits avec stock
INSERT INTO products (product_name, unit_price, selling_price, total_sold, total_revenue) VALUES
                                                                                              ('aceftyl sp', 1500, 1500, 0, 0),
                                                                                              ('acide folique cp', 1100, 1100, 0, 0),
                                                                                              ('aclav 500', 5300, 5300, 0, 0),
                                                                                              ('aclav60', 3300, 3300, 0, 0),
                                                                                              ('acure 80 cp', 2300, 2300, 0, 0),
                                                                                              ('alben cp', 1450, 1450, 0, 0),
                                                                                              ('algesic500', 500, 500, 0, 0),
                                                                                              ('allergyl cp', 500, 500, 0, 0),
                                                                                              ('almax forte', 4500, 4500, 0, 0),
                                                                                              ('amoxi ubi gel', 1200, 1200, 0, 0),
                                                                                              ('arteluf', 2000, 2000, 0, 0),
                                                                                              ('arthemeter 40', 500, 500, 0, 0),
                                                                                              ('arthemeter 80', 500, 500, 0, 0),
                                                                                              ('arthemeter20', 500, 500, 0, 0),
                                                                                              ('Artrim 40 GH', 1900, 1900, 0, 0),
                                                                                              ('artrim 80GH', 1600, 1600, 0, 0),
                                                                                              ('AZEE', 3500, 3500, 0, 0),
                                                                                              ('Bande grand', 1000, 1000, 0, 0),
                                                                                              ('Bande petit', 500, 500, 0, 0),
                                                                                              ('bendex cp', 500, 500, 0, 0),
                                                                                              ('benzentin 1g', 1000, 1000, 0, 0),
                                                                                              ('biba sp', 0, 0, 0, 0),
                                                                                              ('biofar ca+mg', 3500, 3500, 0, 0),
                                                                                              ('cac1000 cp eff', 1500, 1500, 0, 0),
                                                                                              ('Carbotou 2%', 1500, 1500, 0, 0),
                                                                                              ('Carbotou 5%', 1500, 1500, 0, 0),
                                                                                              ('Carnet individuel', 500, 500, 0, 0),
                                                                                              ('Carnet prenatal', 1500, 1500, 0, 0),
                                                                                              ('catheter 22', 0, 0, 0, 0),
                                                                                              ('catheter 24', 0, 0, 0, 0),
                                                                                              ('ceftriazone1g', 2000, 2000, 0, 0),
                                                                                              ('cetamyl cp eff', 1200, 1200, 0, 0),
                                                                                              ('cimetidine', 0, 0, 0, 0),
                                                                                              ('clavisac 1gscht', 5300, 5300, 0, 0),
                                                                                              ('co-algesic cp', 2000, 2000, 0, 0),
                                                                                              ('combiant sp', 0, 0, 0, 0),
                                                                                              ('dexametasone inj', 0, 0, 0, 0),
                                                                                              ('diazepan inj', 0, 0, 0, 0),
                                                                                              ('diclo inj', 0, 0, 0, 0),
                                                                                              ('diclo TM cp', 0, 0, 0, 0),
                                                                                              ('DIFLUZOL gel', 3800, 3800, 0, 0),
                                                                                              ('DOLIMEX 1GSCHT', 1300, 1300, 0, 0),
                                                                                              ('DOLIMEX 500GSCHT', 1300, 1300, 0, 0),
                                                                                              ('dolo gel', 2500, 2500, 0, 0),
                                                                                              ('doxy 200', 2000, 2000, 0, 0),
                                                                                              ('efferalgan sp', 1500, 1500, 0, 0),
                                                                                              ('efferalgan vit C', 1500, 1500, 0, 0),
                                                                                              ('el-doxy 200cp', 2000, 2000, 0, 0),
                                                                                              ('el-magdox cp', 3000, 3000, 0, 0),
                                                                                              ('epicranien', 0, 0, 0, 0),
                                                                                              ('escodyn cp eff', 2200, 2200, 0, 0),
                                                                                              ('ferviti sp', 2000, 2000, 0, 0),
                                                                                              ('fil de suture', 0, 0, 0, 0),
                                                                                              ('flucazol gel', 2800, 2800, 0, 0),
                                                                                              ('Flucogen gel', 1900, 1900, 0, 0),
                                                                                              ('fungicil ov', 2800, 2800, 0, 0),
                                                                                              ('furosemide inj', 0, 0, 0, 0),
                                                                                              ('genforte cp', 1000, 1000, 0, 0),
                                                                                              ('genforte sp', 1300, 1300, 0, 0),
                                                                                              ('genta coll', 1000, 1000, 0, 0),
                                                                                              ('genta inj', 0, 0, 0, 0),
                                                                                              ('gynospan cp', 1500, 1500, 0, 0),
                                                                                              ('gynospan inj', 0, 0, 0, 0),
                                                                                              ('gynospan supp', 2500, 2505, 0, 0),
                                                                                              ('ibuprofen cp', 1000, 1000, 0, 0),
                                                                                              ('immu c', 1800, 1800, 0, 0),
                                                                                              ('indofer cp', 2500, 2500, 0, 0),
                                                                                              ('intercef sp', 1700, 1700, 0, 0),
                                                                                              ('intercef200 cp', 3700, 3700, 0, 0),
                                                                                              ('ipeprazol cp', 1900, 1900, 0, 0),
                                                                                              ('ixine200cp', 3500, 3500, 0, 0),
                                                                                              ('klavmox 1g scht', 4500, 4500, 0, 0),
                                                                                              ('lame de bistouri', 0, 0, 0, 0),
                                                                                              ('maalox sch', 4000, 4000, 0, 0),
                                                                                              ('MAG2 AMP', 5000, 5000, 0, 0),
                                                                                              ('magnesium inj', 0, 0, 0, 0),
                                                                                              ('malenfantrine sp', 1600, 1600, 0, 0),
                                                                                              ('maltofer sp', 2600, 2600, 0, 0),
                                                                                              ('maximag amp buv', 4200, 4200, 0, 0),
                                                                                              ('medi gel', 2500, 2500, 0, 0),
                                                                                              ('mediclav1g scht', 5000, 5000, 0, 0),
                                                                                              ('metaren500', 2000, 2000, 0, 0),
                                                                                              ('metro cp', 500, 500, 0, 0),
                                                                                              ('metro perf', 0, 0, 0, 0),
                                                                                              ('metro sp', 1200, 1200, 0, 0),
                                                                                              ('micfox 100 cp', 1600, 1600, 0, 0),
                                                                                              ('micfox 100 sp', 2000, 2000, 0, 0),
                                                                                              ('Micfox 200 cp', 3700, 3700, 0, 0),
                                                                                              ('Mucovent sp', 1500, 1500, 0, 0),
                                                                                              ('novalgin', 0, 0, 0, 0),
                                                                                              ('nuravit sp', 2500, 2500, 0, 0),
                                                                                              ('Palucure 80cp', 2200, 2200, 0, 0),
                                                                                              ('paluva 80cp', 1800, 1800, 0, 0),
                                                                                              ('paluva80 inj', 3000, 3000, 0, 0),
                                                                                              ('panalgic cp eff', 1500, 1500, 0, 0),
                                                                                              ('para cp', 100, 100, 0, 0),
                                                                                              ('para perf', 0, 0, 0, 0),
                                                                                              ('parib b cp', 1500, 1500, 0, 0),
                                                                                              ('penicilline 1g', 1000, 1000, 0, 0),
                                                                                              ('perfuseur', 0, 0, 0, 0),
                                                                                              ('plufentrine20 cp', 1000, 1000, 0, 0),
                                                                                              ('plufentrine40 cp', 1500, 1500, 0, 0),
                                                                                              ('plufentrine80 cp', 2300, 2300, 0, 0),
                                                                                              ('primalan 10 cp', 4000, 4000, 0, 0),
                                                                                              ('quinine 400', 0, 0, 0, 0),
                                                                                              ('repar 500', 1000, 1000, 0, 0),
                                                                                              ('Roipar 125 sp', 1200, 1200, 0, 0),
                                                                                              ('roipargrippe sp', 1200, 1200, 0, 0),
                                                                                              ('roivit Ginseng', 3000, 3000, 0, 0),
                                                                                              ('roivit multi vit', 2500, 2500, 0, 0),
                                                                                              ('roivit vit c', 2500, 2500, 0, 0),
                                                                                              ('roivit vt C+CA', 2500, 2500, 0, 0),
                                                                                              ('saniver cp', 500, 500, 0, 0),
                                                                                              ('Saniver sp', 0, 0, 0, 0),
                                                                                              ('sekisan sp', 3000, 3000, 0, 0),
                                                                                              ('seringue 10cc', 100, 100, 0, 0),
                                                                                              ('seringue 5cc', 100, 100, 0, 0),
                                                                                              ('serum gelo', 0, 0, 0, 0),
                                                                                              ('serum glucose', 0, 0, 0, 0),
                                                                                              ('serum ringer', 0, 0, 0, 0),
                                                                                              ('serum sale', 0, 0, 0, 0),
                                                                                              ('shalaltrem forte 80', 1700, 1700, 0, 0),
                                                                                              ('shibudal gel', 2500, 2500, 0, 0),
                                                                                              ('Soclav 30 sp', 3200, 3200, 0, 0),
                                                                                              ('solutan c crem', 2300, 2300, 0, 0),
                                                                                              ('solutan c sol', 1700, 1700, 0, 0),
                                                                                              ('spasfon inj', 0, 0, 0, 0),
                                                                                              ('survit sp', 2500, 2500, 0, 0),
                                                                                              ('TIMER 20 CP', 1200, 1200, 0, 0),
                                                                                              ('TIMER 80 CP', 2300, 2300, 0, 0),
                                                                                              ('touxpa sp', 2200, 2200, 0, 0),
                                                                                              ('traclav inj', 2000, 2000, 0, 0),
                                                                                              ('tramadol inj', 0, 0, 0, 0),
                                                                                              ('tramycin500 cp', 3300, 3300, 0, 0),
                                                                                              ('tributine sp', 2800, 2800, 0, 0),
                                                                                              ('trofocard scht', 5000, 5000, 0, 0),
                                                                                              ('tube bleue', 0, 0, 0, 0),
                                                                                              ('tube grise', 0, 0, 0, 0),
                                                                                              ('tube rouge', 0, 0, 0, 0),
                                                                                              ('tube violette', 0, 0, 0, 0),
                                                                                              ('Viferon B sp', 2500, 2500, 0, 0),
                                                                                              ('visceraligne supp', 2000, 2000, 0, 0),
                                                                                              ('vit k1', 0, 0, 0, 0),
                                                                                              ('vita C1000(petit)', 0, 0, 0, 0),
                                                                                              ('vitavit sp', 2500, 2500, 0, 0),
                                                                                              ('vitB 12', 0, 0, 0, 0),
                                                                                              ('vitB compl', 0, 0, 0, 0),
                                                                                              ('vogalene inj', 0, 0, 0, 0),
                                                                                              ('vogalene sp', 2800, 2800, 0, 0),
                                                                                              ('vogalene supp', 1200, 1200, 0, 0);

-- Insérer du stock

-- Insérer l'inventaire pour chaque produit avec des valeurs par défaut
INSERT INTO inventory (product_id, batch_number, quantity_in_stock, expiry_date, purchase_price) VALUES
                                                                                                     (1, 'BATCH-001', 0, '2025-12-31', 1500),
                                                                                                     (2, 'BATCH-002', 0, '2025-12-31', 1100),
                                                                                                     (3, 'BATCH-003', 0, '2025-12-31', 5300),
                                                                                                     (4, 'BATCH-004', 0, '2025-12-31', 3300),
                                                                                                     (5, 'BATCH-005', 0, '2025-12-31', 2300),
                                                                                                     (6, 'BATCH-006', 0, '2025-12-31', 1450),
                                                                                                     (7, 'BATCH-007', 0, '2025-12-31', 500),
                                                                                                     (8, 'BATCH-008', 0, '2025-12-31', 500),
                                                                                                     (9, 'BATCH-009', 0, '2025-12-31', 4500),
                                                                                                     (10, 'BATCH-010', 0, '2025-12-31', 1200),
                                                                                                     (11, 'BATCH-011', 0, '2025-12-31', 2000),
                                                                                                     (12, 'BATCH-012', 0, '2025-12-31', 500),
                                                                                                     (13, 'BATCH-013', 0, '2025-12-31', 500),
                                                                                                     (14, 'BATCH-014', 0, '2025-12-31', 500),
                                                                                                     (15, 'BATCH-015', 0, '2025-12-31', 1900),
                                                                                                     (16, 'BATCH-016', 0, '2025-12-31', 1600),
                                                                                                     (17, 'BATCH-017', 0, '2025-12-31', 3500),
                                                                                                     (18, 'BATCH-018', 0, '2025-12-31', 1000),
                                                                                                     (19, 'BATCH-019', 0, '2025-12-31', 500),
                                                                                                     (20, 'BATCH-020', 0, '2025-12-31', 500),
                                                                                                     (21, 'BATCH-021', 0, '2025-12-31', 1000),
                                                                                                     (22, 'BATCH-022', 0, '2025-12-31', 0),
                                                                                                     (23, 'BATCH-023', 0, '2025-12-31', 3500),
                                                                                                     (24, 'BATCH-024', 0, '2025-12-31', 1500),
                                                                                                     (25, 'BATCH-025', 0, '2025-12-31', 1500),
                                                                                                     (26, 'BATCH-026', 0, '2025-12-31', 1500),
                                                                                                     (27, 'BATCH-027', 0, '2025-12-31', 500),
                                                                                                     (28, 'BATCH-028', 0, '2025-12-31', 1500),
                                                                                                     (29, 'BATCH-029', 0, '2025-12-31', 0),
                                                                                                     (30, 'BATCH-030', 0, '2025-12-31', 0),
                                                                                                     (31, 'BATCH-031', 0, '2025-12-31', 2000),
                                                                                                     (32, 'BATCH-032', 0, '2025-12-31', 1200),
                                                                                                     (33, 'BATCH-033', 0, '2025-12-31', 0),
                                                                                                     (34, 'BATCH-034', 0, '2025-12-31', 5300),
                                                                                                     (35, 'BATCH-035', 0, '2025-12-31', 2000),
                                                                                                     (36, 'BATCH-036', 0, '2025-12-31', 0),
                                                                                                     (37, 'BATCH-037', 0, '2025-12-31', 0),
                                                                                                     (38, 'BATCH-038', 0, '2025-12-31', 0),
                                                                                                     (39, 'BATCH-039', 0, '2025-12-31', 0),
                                                                                                     (40, 'BATCH-040', 0, '2025-12-31', 0),
                                                                                                     (41, 'BATCH-041', 0, '2025-12-31', 3800),
                                                                                                     (42, 'BATCH-042', 0, '2025-12-31', 1300),
                                                                                                     (43, 'BATCH-043', 0, '2025-12-31', 1300),
                                                                                                     (44, 'BATCH-044', 0, '2025-12-31', 2500),
                                                                                                     (45, 'BATCH-045', 0, '2025-12-31', 2000),
                                                                                                     (46, 'BATCH-046', 0, '2025-12-31', 1500),
                                                                                                     (47, 'BATCH-047', 0, '2025-12-31', 1500),
                                                                                                     (48, 'BATCH-048', 0, '2025-12-31', 2000),
                                                                                                     (49, 'BATCH-049', 0, '2025-12-31', 3000),
                                                                                                     (50, 'BATCH-050', 0, '2025-12-31', 0),
                                                                                                     (51, 'BATCH-051', 0, '2025-12-31', 2200),
                                                                                                     (52, 'BATCH-052', 0, '2025-12-31', 2000),
                                                                                                     (53, 'BATCH-053', 0, '2025-12-31', 0),
                                                                                                     (54, 'BATCH-054', 0, '2025-12-31', 2800),
                                                                                                     (55, 'BATCH-055', 0, '2025-12-31', 1900),
                                                                                                     (56, 'BATCH-056', 0, '2025-12-31', 2800),
                                                                                                     (57, 'BATCH-057', 0, '2025-12-31', 0),
                                                                                                     (58, 'BATCH-058', 0, '2025-12-31', 1000),
                                                                                                     (59, 'BATCH-059', 0, '2025-12-31', 1300),
                                                                                                     (60, 'BATCH-060', 0, '2025-12-31', 1000),
                                                                                                     (61, 'BATCH-061', 0, '2025-12-31', 0),
                                                                                                     (62, 'BATCH-062', 0, '2025-12-31', 1500),
                                                                                                     (63, 'BATCH-063', 0, '2025-12-31', 0),
                                                                                                     (64, 'BATCH-064', 0, '2025-12-31', 2500),
                                                                                                     (65, 'BATCH-065', 0, '2025-12-31', 1000),
                                                                                                     (66, 'BATCH-066', 0, '2025-12-31', 1800),
                                                                                                     (67, 'BATCH-067', 0, '2025-12-31', 2500),
                                                                                                     (68, 'BATCH-068', 0, '2025-12-31', 1700),
                                                                                                     (69, 'BATCH-069', 0, '2025-12-31', 3700),
                                                                                                     (70, 'BATCH-070', 0, '2025-12-31', 1900),
                                                                                                     (71, 'BATCH-071', 0, '2025-12-31', 3500),
                                                                                                     (72, 'BATCH-072', 0, '2025-12-31', 4500),
                                                                                                     (73, 'BATCH-073', 0, '2025-12-31', 0),
                                                                                                     (74, 'BATCH-074', 0, '2025-12-31', 4000),
                                                                                                     (75, 'BATCH-075', 0, '2025-12-31', 5000),
                                                                                                     (76, 'BATCH-076', 0, '2025-12-31', 0),
                                                                                                     (77, 'BATCH-077', 0, '2025-12-31', 1600),
                                                                                                     (78, 'BATCH-078', 0, '2025-12-31', 2600),
                                                                                                     (79, 'BATCH-079', 0, '2025-12-31', 4200),
                                                                                                     (80, 'BATCH-080', 0, '2025-12-31', 2500),
                                                                                                     (81, 'BATCH-081', 0, '2025-12-31', 5000),
                                                                                                     (82, 'BATCH-082', 0, '2025-12-31', 2000),
                                                                                                     (83, 'BATCH-083', 0, '2025-12-31', 500),
                                                                                                     (84, 'BATCH-084', 0, '2025-12-31', 0),
                                                                                                     (85, 'BATCH-085', 0, '2025-12-31', 1200),
                                                                                                     (86, 'BATCH-086', 0, '2025-12-31', 1600),
                                                                                                     (87, 'BATCH-087', 0, '2025-12-31', 2000),
                                                                                                     (88, 'BATCH-088', 0, '2025-12-31', 3700),
                                                                                                     (89, 'BATCH-089', 0, '2025-12-31', 1500),
                                                                                                     (90, 'BATCH-090', 0, '2025-12-31', 0),
                                                                                                     (91, 'BATCH-091', 0, '2025-12-31', 2500),
                                                                                                     (92, 'BATCH-092', 0, '2025-12-31', 2200),
                                                                                                     (93, 'BATCH-093', 0, '2025-12-31', 1800),
                                                                                                     (94, 'BATCH-094', 0, '2025-12-31', 3000),
                                                                                                     (95, 'BATCH-095', 0, '2025-12-31', 1500),
                                                                                                     (96, 'BATCH-096', 0, '2025-12-31', 100),
                                                                                                     (97, 'BATCH-097', 0, '2025-12-31', 0),
                                                                                                     (98, 'BATCH-098', 0, '2025-12-31', 1500),
                                                                                                     (99, 'BATCH-099', 0, '2025-12-31', 1000),
                                                                                                     (100, 'BATCH-100', 0, '2025-12-31', 0),
                                                                                                     (101, 'BATCH-101', 0, '2025-12-31', 1000),
                                                                                                     (102, 'BATCH-102', 0, '2025-12-31', 1500),
                                                                                                     (103, 'BATCH-103', 0, '2025-12-31', 2300),
                                                                                                     (104, 'BATCH-104', 0, '2025-12-31', 4000),
                                                                                                     (105, 'BATCH-105', 0, '2025-12-31', 0),
                                                                                                     (106, 'BATCH-106', 0, '2025-12-31', 1000),
                                                                                                     (107, 'BATCH-107', 0, '2025-12-31', 1200),
                                                                                                     (108, 'BATCH-108', 0, '2025-12-31', 1200),
                                                                                                     (109, 'BATCH-109', 0, '2025-12-31', 3000),
                                                                                                     (110, 'BATCH-110', 0, '2025-12-31', 2500),
                                                                                                     (111, 'BATCH-111', 0, '2025-12-31', 2500),
                                                                                                     (112, 'BATCH-112', 0, '2025-12-31', 2500),
                                                                                                     (113, 'BATCH-113', 0, '2025-12-31', 500),
                                                                                                     (114, 'BATCH-114', 0, '2025-12-31', 0),
                                                                                                     (115, 'BATCH-115', 0, '2025-12-31', 3000),
                                                                                                     (116, 'BATCH-116', 0, '2025-12-31', 100),
                                                                                                     (117, 'BATCH-117', 0, '2025-12-31', 100),
                                                                                                     (118, 'BATCH-118', 0, '2025-12-31', 0),
                                                                                                     (119, 'BATCH-119', 0, '2025-12-31', 0),
                                                                                                     (120, 'BATCH-120', 0, '2025-12-31', 0),
                                                                                                     (121, 'BATCH-121', 0, '2025-12-31', 0),
                                                                                                     (122, 'BATCH-122', 0, '2025-12-31', 1700),
                                                                                                     (123, 'BATCH-123', 0, '2025-12-31', 2500),
                                                                                                     (124, 'BATCH-124', 0, '2025-12-31', 3200),
                                                                                                     (125, 'BATCH-125', 0, '2025-12-31', 2300),
                                                                                                     (126, 'BATCH-126', 0, '2025-12-31', 1700),
                                                                                                     (127, 'BATCH-127', 0, '2025-12-31', 0),
                                                                                                     (128, 'BATCH-128', 0, '2025-12-31', 2500),
                                                                                                     (129, 'BATCH-129', 0, '2025-12-31', 1200),
                                                                                                     (130, 'BATCH-130', 0, '2025-12-31', 2300),
                                                                                                     (131, 'BATCH-131', 0, '2025-12-31', 2200),
                                                                                                     (132, 'BATCH-132', 0, '2025-12-31', 2000),
                                                                                                     (133, 'BATCH-133', 0, '2025-12-31', 0),
                                                                                                     (134, 'BATCH-134', 0, '2025-12-31', 3300),
                                                                                                     (135, 'BATCH-135', 0, '2025-12-31', 2800),
                                                                                                     (136, 'BATCH-136', 0, '2025-12-31', 5000),
                                                                                                     (137, 'BATCH-137', 0, '2025-12-31', 0),
                                                                                                     (138, 'BATCH-138', 0, '2025-12-31', 0),
                                                                                                     (139, 'BATCH-139', 0, '2025-12-31', 0),
                                                                                                     (140, 'BATCH-140', 0, '2025-12-31', 0),
                                                                                                     (141, 'BATCH-141', 0, '2025-12-31', 2500),
                                                                                                     (142, 'BATCH-142', 0, '2025-12-31', 2000),
                                                                                                     (143, 'BATCH-143', 0, '2025-12-31', 0),
                                                                                                     (144, 'BATCH-144', 0, '2025-12-31', 0),
                                                                                                     (145, 'BATCH-145', 0, '2025-12-31', 2500),
                                                                                                     (146, 'BATCH-146', 0, '2025-12-31', 0),
                                                                                                     (147, 'BATCH-147', 0, '2025-12-31', 0),
                                                                                                     (148, 'BATCH-148', 0, '2025-12-31', 0),
                                                                                                     (149, 'BATCH-149', 0, '2025-12-31', 2800),
                                                                                                     (150, 'BATCH-150', 0, '2025-12-31', 1200);

-- Insérer des paramètres par défaut
INSERT INTO application_parameters (parameter_key, parameter_value, parameter_type, category, description) VALUES
                                                                                                               ('TAUX_TVA', '20', 'DECIMAL', 'FINANCE', 'Taux de TVA applicable'),
                                                                                                               ('STOCK_ALERT_SEUIL', '10', 'INTEGER', 'STOCK', 'Seuil d''alerte pour stock bas'),
                                                                                                               ('COMPANY_NAME', 'PharmaPlus', 'STRING', 'GENERAL', 'Nom de l''entreprise'),
                                                                                                               ('COMPANY_ADDRESS', '123 Rue du Commerce, 75001 Paris', 'STRING', 'GENERAL', 'Adresse de l''entreprise'),
                                                                                                               ('COMPANY_PHONE', '+33123456789', 'STRING', 'GENERAL', 'Téléphone de l''entreprise');

-- =============================================
-- CONFIGURATION DES DROITS
-- =============================================

-- Créer un utilisateur spécifique pour l'application
CREATE USER pharmaplus_app WITH PASSWORD 'secure_password_123';

-- Donner les droits nécessaires
GRANT CONNECT ON DATABASE pharmaplus TO pharmaplus_app;
GRANT USAGE ON SCHEMA public TO pharmaplus_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO pharmaplus_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO pharmaplus_app;

-- Donner des droits spécifiques pour les vues
GRANT SELECT ON v_current_stock TO pharmaplus_app;
GRANT SELECT ON v_expiring_products TO pharmaplus_app;
GRANT SELECT ON v_sales_summary TO pharmaplus_app;

-- Vérifier que tout est correctt
SELECT 'Base de données créée avec succès!' as message;
