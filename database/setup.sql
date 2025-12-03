-- =====================================================
-- PharmaPlus Pharmacy Database (PostgreSQL)
-- Version: 1.0
-- Auteur: PharmaPlus Team
-- =====================================================

-- 1. CRÉATION DE LA BASE DE DONNÉES
DROP DATABASE IF EXISTS pharmaplus;
CREATE DATABASE pharmaplus
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'French_France.1252'
    LC_CTYPE = 'French_France.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE pharmaplus IS 'Base de données du système PharmaPlus Pharmacy Management';

-- 2. CONNEXION À LA NOUVELLE BASE
\c pharmaplus;

-- 3. CRÉATION DES TABLES
-- =====================================================
-- 3.1. CATÉGORIES
-- =====================================================
CREATE TABLE IF NOT EXISTS categories (
                                          category_id SERIAL PRIMARY KEY,
                                          category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );

COMMENT ON TABLE categories IS 'Catégories de produits pharmaceutiques';

-- =====================================================
-- 3.2. FOURNISSEURS
-- =====================================================
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

-- =====================================================
-- 3.3. PRODUITS
-- =====================================================
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
    unit_price NUMERIC(10, 2) NOT NULL,
    selling_price NUMERIC(10, 2) NOT NULL,
    reorder_level INT DEFAULT 10,
    barcode VARCHAR(50) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT chk_prices CHECK (selling_price >= unit_price)
    );

COMMENT ON TABLE products IS 'Produits pharmaceutiques en vente';

-- =====================================================
-- 3.4. INVENTAIRE
-- =====================================================
CREATE TABLE IF NOT EXISTS inventory (
                                         inventory_id SERIAL PRIMARY KEY,
                                         product_id INT NOT NULL REFERENCES products(product_id),
    batch_number VARCHAR(50) NOT NULL,
    supplier_id INT REFERENCES suppliers(supplier_id),
    quantity_in_stock INT NOT NULL DEFAULT 0,
    quantity_reserved INT DEFAULT 0,
    manufacturing_date DATE,
    expiry_date DATE NOT NULL,
    purchase_price NUMERIC(10, 2),
    received_date DATE DEFAULT CURRENT_DATE,
    location VARCHAR(50),
    is_expired BOOLEAN GENERATED ALWAYS AS (expiry_date < CURRENT_DATE) STORED,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT chk_quantity CHECK (quantity_in_stock >= 0),
    CONSTRAINT chk_reserved CHECK (quantity_reserved >= 0 AND quantity_reserved <= quantity_in_stock),
    CONSTRAINT unique_batch UNIQUE (product_id, batch_number)
    );

COMMENT ON TABLE inventory IS 'Stock des produits par lots';

-- =====================================================
-- 3.5. CLIENTS
-- =====================================================
CREATE TABLE IF NOT EXISTS customers (
                                         customer_id SERIAL PRIMARY KEY,
                                         first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    date_of_birth DATE,
    address TEXT,
    allergies TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );

COMMENT ON TABLE customers IS 'Clients de la pharmacie';

-- =====================================================
-- 3.6. ORDONNANCES
-- =====================================================
CREATE TABLE IF NOT EXISTS prescriptions (
                                             prescription_id SERIAL PRIMARY KEY,
                                             customer_id INT NOT NULL REFERENCES customers(customer_id),
    doctor_name VARCHAR(100) NOT NULL,
    doctor_license VARCHAR(50),
    prescription_date DATE NOT NULL,
    valid_until DATE,
    notes TEXT,
    status VARCHAR(20) DEFAULT 'pending'
    CHECK (status IN ('pending','filled','partially_filled','cancelled')),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
    );

CREATE TABLE IF NOT EXISTS prescription_items (
                                                  prescription_item_id SERIAL PRIMARY KEY,
                                                  prescription_id INT NOT NULL REFERENCES prescriptions(prescription_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity_prescribed INT NOT NULL,
    quantity_dispensed INT DEFAULT 0,
    dosage_instructions TEXT,
    CONSTRAINT chk_prescribed_qty CHECK (quantity_prescribed > 0),
    CONSTRAINT chk_dispensed_qty CHECK (quantity_dispensed >= 0 AND quantity_dispensed <= quantity_prescribed)
    );

-- =====================================================
-- 3.7. VENTES
-- =====================================================
CREATE TABLE IF NOT EXISTS sales (
                                     sale_id SERIAL PRIMARY KEY,
                                     customer_id INT REFERENCES customers(customer_id),
    prescription_id INT REFERENCES prescriptions(prescription_id),
    sale_date TIMESTAMP DEFAULT NOW(),
    subtotal NUMERIC(10, 2) NOT NULL,
    discount_amount NUMERIC(10, 2) DEFAULT 0,
    tax_amount NUMERIC(10, 2) DEFAULT 0,
    total_amount NUMERIC(10, 2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL
    CHECK (payment_method IN ('cash','card','insurance','mobile_payment')),
    payment_status VARCHAR(20) DEFAULT 'paid'
    CHECK (payment_status IN ('paid','pending','refunded')),
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
    unit_price NUMERIC(10, 2) NOT NULL,
    discount NUMERIC(10, 2) DEFAULT 0,
    line_total NUMERIC(10, 2) NOT NULL,
    CONSTRAINT chk_sale_qty CHECK (quantity > 0),
    CONSTRAINT chk_line_total CHECK (line_total >= 0)
    );

-- =====================================================
-- 3.8. COMMANDES FOURNISSEURS
-- =====================================================
CREATE TABLE IF NOT EXISTS purchase_orders (
                                               po_id SERIAL PRIMARY KEY,
                                               supplier_id INT NOT NULL REFERENCES suppliers(supplier_id),
    order_date DATE NOT NULL,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    status VARCHAR(20) DEFAULT 'pending'
    CHECK (status IN ('pending','approved','received','cancelled')),
    total_amount NUMERIC(10, 2),
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
    unit_price NUMERIC(10, 2) NOT NULL,
    line_total NUMERIC(10, 2) NOT NULL,
    CONSTRAINT chk_po_qty CHECK (quantity_ordered > 0),
    CONSTRAINT chk_received_qty CHECK (quantity_received >= 0 AND quantity_received <= quantity_ordered)
    );

-- =====================================================
-- 3.9. AJUSTEMENTS DE STOCK
-- =====================================================
CREATE TABLE IF NOT EXISTS stock_adjustments (
                                                 adjustment_id SERIAL PRIMARY KEY,
                                                 inventory_id INT NOT NULL REFERENCES inventory(inventory_id),
    adjustment_type VARCHAR(20) NOT NULL
    CHECK (adjustment_type IN ('damage','expiry','theft','correction','return')),
    quantity_adjusted INT NOT NULL,
    reason TEXT,
    adjusted_by VARCHAR(50),
    adjustment_date TIMESTAMP DEFAULT NOW()
    );

-- =====================================================
-- 3.10. UTILISATEURS (pour l'authentification)
-- =====================================================
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
-- 4. INDEXES POUR LES PERFORMANCES
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
-- 5. VUES POUR LES REQUÊTES COURANTES
-- =====================================================
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
        WHEN COALESCE(SUM(i.quantity_in_stock - i.quantity_reserved), 0) = 0
            THEN 'OUT OF STOCK'
        WHEN COALESCE(SUM(i.quantity_in_stock - i.quantity_reserved), 0) <= p.reorder_level
            THEN 'LOW STOCK'
        ELSE 'IN STOCK'
        END AS stock_status
FROM products p
         LEFT JOIN inventory i ON p.product_id = i.product_id AND i.is_expired = FALSE
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

-- =====================================================
-- 6. DONNÉES D'EXEMPLE
-- =====================================================

-- 6.1. Catégories
INSERT INTO categories (category_name, description) VALUES
                                                        ('Analgésiques', 'Médicaments contre la douleur'),
                                                        ('Antibiotiques', 'Antimicrobiens'),
                                                        ('Cardiovasculaire', 'Cœur et tension artérielle'),
                                                        ('Respiratoire', 'Système respiratoire'),
                                                        ('Gastro-intestinal', 'Système digestif'),
                                                        ('Vitamines & Suppléments', 'Compléments nutritionnels'),
                                                        ('Diabète', 'Gestion de la glycémie'),
                                                        ('Dermatologie', 'Soins de la peau'),
                                                        ('Psychiatrie', 'Santé mentale'),
                                                        ('Antiviraux', 'Contre les infections virales')
    ON CONFLICT (category_name) DO NOTHING;

-- 6.2. Fournisseurs
INSERT INTO suppliers (supplier_name, contact_person, phone, email, city, country) VALUES
                                                                                       ('MediCorp Pharmaceuticals', 'Jean Dupont', '+33 1 23 45 67 89', 'contact@medicorp.com', 'Paris', 'France'),
                                                                                       ('Global Health Supplies', 'Marie Martin', '+33 1 98 76 54 32', 'info@globalhealth.com', 'Lyon', 'France'),
                                                                                       ('PharmaDirect Ltd', 'Pierre Bernard', '+33 2 34 56 78 90', 'sales@pharmadirect.fr', 'Marseille', 'France'),
                                                                                       ('BioPharma Solutions', 'Sophie Petit', '+33 3 45 67 89 01', 'contact@biopharma.com', 'Toulouse', 'France')
    ON CONFLICT DO NOTHING;

-- 6.3. Produits
INSERT INTO products (product_name, generic_name, category_id, manufacturer, dosage_form, strength, unit_of_measure, requires_prescription, unit_price, selling_price, reorder_level, barcode) VALUES
                                                                                                                                                                                                   ('Paracétamol 500mg', 'Paracétamol', 1, 'MediCorp', 'Comprimé', '500mg', 'pièce', FALSE, 0.10, 0.25, 100, '3400934523456'),
                                                                                                                                                                                                   ('Amoxicilline 500mg', 'Amoxicilline', 2, 'Global Health', 'Gélule', '500mg', 'pièce', TRUE, 0.50, 1.20, 50, '3400934523457'),
                                                                                                                                                                                                   ('Lisinopril 10mg', 'Lisinopril', 3, 'PharmaDirect', 'Comprimé', '10mg', 'pièce', TRUE, 0.30, 0.80, 50, '3400934523458'),
                                                                                                                                                                                                   ('Ventoline Inhalateur', 'Salbutamol', 4, 'MediCorp', 'Inhalateur', '100mcg', 'pièce', TRUE, 5.00, 12.00, 20, '3400934523459'),
                                                                                                                                                                                                   ('Mopral 20mg', 'Oméprazole', 5, 'Global Health', 'Gélule', '20mg', 'pièce', TRUE, 0.40, 1.00, 40, '3400934523460'),
                                                                                                                                                                                                   ('Vitamine C 1000mg', 'Acide ascorbique', 6, 'BioPharma', 'Comprimé', '1000mg', 'pièce', FALSE, 0.15, 0.40, 80, '3400934523461'),
                                                                                                                                                                                                   ('Metformine 500mg', 'Metformine HCl', 7, 'MediCorp', 'Comprimé', '500mg', 'pièce', TRUE, 0.20, 0.50, 60, '3400934523462'),
                                                                                                                                                                                                   ('Doliprane 1000mg', 'Paracétamol', 1, 'MediCorp', 'Comprimé', '1000mg', 'pièce', FALSE, 0.18, 0.45, 80, '3400934523463'),
                                                                                                                                                                                                   ('Ibuprofène 400mg', 'Ibuprofène', 1, 'Global Health', 'Comprimé', '400mg', 'pièce', FALSE, 0.25, 0.60, 70, '3400934523464')
    ON CONFLICT (barcode) DO NOTHING;

-- 6.4. Inventaire
INSERT INTO inventory (product_id, batch_number, supplier_id, quantity_in_stock, expiry_date, purchase_price, manufacturing_date, location) VALUES
                                                                                                                                                (1, 'BATCH202401', 1, 500, '2026-12-31', 0.10, '2024-01-15', 'Étagère A1'),
                                                                                                                                                (2, 'BATCH202402', 2, 200, '2026-06-30', 0.50, '2024-02-10', 'Étagère A2'),
                                                                                                                                                (3, 'BATCH202403', 3, 150, '2026-09-30', 0.30, '2024-03-05', 'Étagère B1'),
                                                                                                                                                (4, 'BATCH202404', 1, 50, '2026-12-31', 5.00, '2024-01-20', 'Réfrigérateur'),
                                                                                                                                                (5, 'BATCH202405', 2, 180, '2026-08-31', 0.40, '2024-02-15', 'Étagère B2'),
                                                                                                                                                (6, 'BATCH202406', 4, 300, '2027-03-31', 0.15, '2024-03-01', 'Étagère C1'),
                                                                                                                                                (7, 'BATCH202407', 1, 250, '2026-11-30', 0.20, '2024-02-20', 'Étagère B3'),
                                                                                                                                                (8, 'BATCH202408', 1, 400, '2026-10-31', 0.18, '2024-01-30', 'Étagère A3'),
                                                                                                                                                (9, 'BATCH202409', 2, 350, '2026-07-31', 0.25, '2024-02-28', 'Étagère C2')
    ON CONFLICT DO NOTHING;

-- 6.5. Clients
INSERT INTO customers (first_name, last_name, phone, email, date_of_birth, address, allergies) VALUES
                                                                                                   ('Jean', 'Dupont', '+33 6 12 34 56 78', 'jean.dupont@email.com', '1985-05-15', '123 Rue de Paris, 75001 Paris', 'Pénicilline'),
                                                                                                   ('Marie', 'Martin', '+33 6 23 45 67 89', 'marie.martin@email.com', '1990-08-22', '456 Avenue des Champs, 69001 Lyon', 'Aucune'),
                                                                                                   ('Pierre', 'Bernard', '+33 6 34 56 78 90', 'pierre.bernard@email.com', '1978-03-10', '789 Boulevard Maritime, 13001 Marseille', 'Aspirine'),
                                                                                                   ('Sophie', 'Petit', '+33 6 45 67 89 01', 'sophie.petit@email.com', '1995-11-30', '321 Rue du Commerce, 31000 Toulouse', 'Iode'),
                                                                                                   ('Luc', 'Durand', '+33 6 56 78 90 12', 'luc.durand@email.com', '1982-07-18', '654 Avenue Centrale, 59000 Lille', 'Sulfamides')
    ON CONFLICT DO NOTHING;

-- 6.6. Utilisateurs (mot de passe: "admin" hashé en SHA-256)
INSERT INTO users (username, password, full_name, role, active) VALUES
                                                                    ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Administrateur Principal', 'ADMIN', true),
                                                                    ('pharmacien', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Dr. Jean Martin', 'PHARMACIST', true),
                                                                    ('assistant', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Marie Dubois', 'ASSISTANT', true),
                                                                    ('caissier', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Pierre Durand', 'CASHIER', true)
    ON CONFLICT (username) DO NOTHING;

-- =====================================================
-- 7. CONFIRMATION
-- =====================================================
DO $$
BEGIN
    RAISE NOTICE '=========================================';
    RAISE NOTICE '✅ BASE DE DONNÉES PHARMAPLUS CRÉÉE AVEC SUCCÈS';
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'Tables créées: 12';
    RAISE NOTICE 'Index créés: 12';
    RAISE NOTICE 'Vues créées: 3';
    RAISE NOTICE 'Données insérées:';
    RAISE NOTICE '  - Catégories: 10';
    RAISE NOTICE '  - Fournisseurs: 4';
    RAISE NOTICE '  - Produits: 9';
    RAISE NOTICE '  - Lots inventaire: 9';
    RAISE NOTICE '  - Clients: 5';
    RAISE NOTICE '  - Utilisateurs: 4';
    RAISE NOTICE '=========================================';
    RAISE NOTICE '🔗 Connexion: jdbc:postgresql://localhost:5432/pharmaplus';
    RAISE NOTICE '👤 Utilisateur par défaut: admin / admin';
    RAISE NOTICE '=========================================';
END $$;

-- Afficher les statistiques
SELECT
    (SELECT COUNT(*) FROM categories) as categories,
    (SELECT COUNT(*) FROM suppliers) as suppliers,
    (SELECT COUNT(*) FROM products) as products,
    (SELECT COUNT(*) FROM inventory) as inventory_items,
    (SELECT COUNT(*) FROM customers) as customers,
    (SELECT COUNT(*) FROM users) as users;