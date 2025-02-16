-- Create Categories table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    total_available_quantity INTEGER NOT NULL DEFAULT 0,
    category_id INTEGER REFERENCES categories(category_id),
    min_stock_level INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Product Batches table
CREATE TABLE product_batches (
    batch_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    remaining_quantity INTEGER NOT NULL,
    unit_purchase_price DECIMAL(10,2) NOT NULL,
    purchase_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    loyalty_points INTEGER DEFAULT 0,
    total_dues DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Suppliers table
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Sales table
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    sale_date DATE NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    profit DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20) CHECK (payment_status IN ('PAID', 'PARTIAL', 'PENDING')),
    amount_paid DECIMAL(10,2) DEFAULT 0,
    amount_due DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Sale Items table
CREATE TABLE sale_items (
    sale_item_id SERIAL PRIMARY KEY,
    sale_id INTEGER REFERENCES sales(sale_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL,
    unit_selling_price DECIMAL(10,2) NOT NULL,
    batch_id INTEGER REFERENCES product_batches(batch_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Sale Item Batches table
CREATE TABLE sale_item_batches (
    sale_item_batch_id SERIAL PRIMARY KEY,
    sale_item_id INTEGER REFERENCES sale_items(sale_item_id),
    batch_id INTEGER REFERENCES product_batches(batch_id),
    quantity INTEGER NOT NULL,
    unit_cost_price DECIMAL(10,2) NOT NULL,
    item_profit DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Purchases table
CREATE TABLE purchases (
    purchase_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    purchase_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('PENDING', 'RECEIVED', 'CANCELLED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Purchase Items table
CREATE TABLE purchase_items (
    purchase_item_id SERIAL PRIMARY KEY,
    purchase_id INTEGER REFERENCES purchases(purchase_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL,
    unit_purchase_price DECIMAL(10,2) NOT NULL,
    batch_id INTEGER REFERENCES product_batches(batch_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Payments table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    sale_id INTEGER REFERENCES sales(sale_id),
    customer_id INTEGER REFERENCES customers(customer_id),
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    payment_reference VARCHAR(100),
    status VARCHAR(20) CHECK (status IN ('SUCCESS', 'PENDING', 'FAILED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Payment Reminders table
CREATE TABLE payment_reminders (
    reminder_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    sale_id INTEGER REFERENCES sales(sale_id),
    reminder_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('SENT', 'PENDING', 'RESOLVED')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);