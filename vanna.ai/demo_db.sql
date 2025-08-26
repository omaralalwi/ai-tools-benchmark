-- ملف قاعدة البيانات التجريبية لاختبار Vanna AI
-- Demo Database for Vanna AI Testing

-- إنشاء جدول العملاء
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    city TEXT,
    country TEXT,
    registration_date DATE,
    is_active BOOLEAN DEFAULT 1
);

-- إنشاء جدول المنتجات
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    supplier TEXT,
    created_date DATE
);

-- إنشاء جدول الطلبات
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status TEXT DEFAULT 'pending',
    shipping_address TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

-- إنشاء جدول تفاصيل الطلبات
CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);

-- إنشاء جدول الموظفين
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    department TEXT NOT NULL,
    position TEXT NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    manager_id INTEGER,
    FOREIGN KEY (manager_id) REFERENCES employees (employee_id)
);

-- إدراج بيانات العملاء
INSERT INTO customers (first_name, last_name, email, phone, city, country, registration_date, is_active) VALUES
('Ahmed', 'Mohamed', 'ahmed.mohamed@email.com', '+966501234567', 'Riyadh', 'Saudi Arabia', '2023-01-15', 1),
('Fatima', 'Ali', 'fatima.ali@email.com', '+966502345678', 'Jeddah', 'Saudi Arabia', '2023-02-20', 1),
('Mohamed', 'Khaled', 'mohamed.khaled@email.com', '+966503456789', 'Dammam', 'Saudi Arabia', '2023-03-10', 1),
('Nora', 'Saad', 'nora.saad@email.com', '+966504567890', 'Mecca', 'Saudi Arabia', '2023-04-05', 1),
('Abdullah', 'Ahmed', 'abdullah.ahmed@email.com', '+966505678901', 'Medina', 'Saudi Arabia', '2023-05-12', 1),
('Sara', 'Mahmoud', 'sara.mahmoud@email.com', '+966506789012', 'Taif', 'Saudi Arabia', '2023-06-18', 1),
('Youssef', 'Abdulrahman', 'youssef.abdulrahman@email.com', '+966507890123', 'Abha', 'Saudi Arabia', '2023-07-22', 1),
('Mariam', 'Hassan', 'mariam.hassan@email.com', '+966508901234', 'Tabuk', 'Saudi Arabia', '2023-08-30', 1),
('Khaled', 'Omar', 'khaled.omar@email.com', '+966509012345', 'Hail', 'Saudi Arabia', '2023-09-14', 1),
('Layla', 'Fahad', 'layla.fahad@email.com', '+966500123456', 'Qassim', 'Saudi Arabia', '2023-10-08', 1),
('Omar', 'Salem', 'omar.salem@email.com', '+966511234567', 'Riyadh', 'Saudi Arabia', '2023-11-15', 1),
('Aisha', 'Ibrahim', 'aisha.ibrahim@email.com', '+966512345678', 'Jeddah', 'Saudi Arabia', '2023-12-20', 1),
('Hassan', 'Abdullah', 'hassan.abdullah@email.com', '+966513456789', 'Dammam', 'Saudi Arabia', '2024-01-10', 1),
('Zainab', 'Mohamed', 'zainab.mohamed@email.com', '+966514567890', 'Riyadh', 'Saudi Arabia', '2024-02-05', 1),
('Faisal', 'Ahmad', 'faisal.ahmad@email.com', '+966515678901', 'Jeddah', 'Saudi Arabia', '2024-03-12', 0);

-- إدراج بيانات المنتجات
INSERT INTO products (product_name, category, price, cost, stock_quantity, supplier, created_date) VALUES
('Dell XPS 13 Laptop', 'Electronics', 4500.00, 3200.00, 25, 'Dell', '2023-01-01'),
('iPhone 14', 'Electronics', 3800.00, 2800.00, 50, 'Apple', '2023-01-01'),
('Sony WH-1000XM4 Headphones', 'Electronics', 1200.00, 800.00, 30, 'Sony', '2023-01-01'),
('Python Programming Book', 'Books', 150.00, 80.00, 100, 'Arab Publishing House', '2023-01-01'),
('Blue Cotton Shirt', 'Clothing', 120.00, 60.00, 200, 'Local Textile Factory', '2023-01-01'),
('Nike Sports Shoes', 'Clothing', 450.00, 280.00, 75, 'Nike', '2023-01-01'),
('Apple Watch', 'Electronics', 1800.00, 1200.00, 40, 'Apple', '2023-01-01'),
('Travel Backpack', 'Accessories', 280.00, 150.00, 60, 'Bag Company', '2023-01-01'),
('Canon EOS R5 Camera', 'Electronics', 12000.00, 8500.00, 15, 'Canon', '2023-01-01'),
('Wooden Office Desk', 'Furniture', 800.00, 450.00, 20, 'Furniture Factory', '2023-01-01'),
('Samsung Galaxy S23', 'Electronics', 3200.00, 2400.00, 35, 'Samsung', '2023-02-01'),
('MacBook Pro 14', 'Electronics', 8500.00, 6200.00, 18, 'Apple', '2023-02-01'),
('Wireless Mouse', 'Electronics', 85.00, 45.00, 150, 'Logitech', '2023-02-01'),
('Office Chair', 'Furniture', 650.00, 380.00, 25, 'Furniture Factory', '2023-02-01'),
('Data Science Book', 'Books', 200.00, 110.00, 80, 'Tech Publishers', '2023-02-01');

-- إدراج بيانات الموظفين
INSERT INTO employees (first_name, last_name, department, position, salary, hire_date, manager_id) VALUES
('Saad', 'Al-Ahmad', 'Sales', 'Sales Manager', 15000.00, '2022-01-15', NULL),
('Nadia', 'Mohamed', 'Sales', 'Sales Representative', 8000.00, '2022-03-20', 1),
('Omar', 'Khaled', 'Sales', 'Sales Representative', 7500.00, '2022-05-10', 1),
('Hind', 'Ali', 'Marketing', 'Marketing Manager', 14000.00, '2022-02-01', NULL),
('Tariq', 'Saad', 'Marketing', 'Marketing Specialist', 9000.00, '2022-06-15', 4),
('Rana', 'Fahad', 'HR', 'HR Manager', 13000.00, '2022-01-10', NULL),
('Majed', 'Abdullah', 'IT', 'Software Developer', 12000.00, '2022-04-01', NULL),
('Dana', 'Hassan', 'IT', 'Systems Analyst', 10000.00, '2022-07-20', 7),
('Faisal', 'Omar', 'Accounting', 'Accountant', 8500.00, '2022-08-15', NULL),
('Reem', 'Mahmoud', 'Customer Service', 'Customer Service Specialist', 6500.00, '2022-09-01', NULL),
('Khalid', 'Salem', 'Sales', 'Sales Representative', 7800.00, '2023-01-15', 1),
('Mona', 'Ibrahim', 'Marketing', 'Marketing Specialist', 8800.00, '2023-02-20', 4),
('Yasir', 'Ahmad', 'IT', 'Software Developer', 11500.00, '2023-03-10', 7),
('Lina', 'Abdullah', 'HR', 'HR Specialist', 7200.00, '2023-04-05', 6),
('Badr', 'Mohamed', 'Accounting', 'Financial Analyst', 9200.00, '2023-05-12', 9);

-- إدراج طلبات تجريبية
INSERT INTO orders (customer_id, order_date, total_amount, status, shipping_address) VALUES
(1, '2024-01-15', 4650.00, 'completed', 'Riyadh, King Fahd Road'),
(2, '2024-01-16', 1320.00, 'completed', 'Jeddah, Tahlia Street'),
(3, '2024-01-17', 3950.00, 'shipped', 'Dammam, Corniche Road'),
(4, '2024-01-18', 570.00, 'completed', 'Mecca, Ajyad Street'),
(5, '2024-01-19', 2250.00, 'pending', 'Medina, Prince Abdul Majeed Road'),
(1, '2024-01-20', 800.00, 'completed', 'Riyadh, King Fahd Road'),
(6, '2024-01-21', 1485.00, 'completed', 'Taif, Shubra District'),
(7, '2024-01-22', 12150.00, 'shipped', 'Abha, King Khalid Road'),
(8, '2024-01-23', 365.00, 'completed', 'Tabuk, Prince Fahd bin Sultan Road'),
(9, '2024-01-24', 4780.00, 'completed', 'Hail, King Abdul Aziz Road'),
(2, '2024-01-25', 2080.00, 'completed', 'Jeddah, Tahlia Street'),
(10, '2024-01-26', 930.00, 'pending', 'Qassim, King Saud Road'),
(3, '2024-01-27', 1650.00, 'completed', 'Dammam, Corniche Road'),
(11, '2024-01-28', 8585.00, 'shipped', 'Riyadh, Olaya Street'),
(12, '2024-01-29', 620.00, 'completed', 'Jeddah, Al-Andalus Street'),
(4, '2024-02-01', 3320.00, 'completed', 'Mecca, Ajyad Street'),
(13, '2024-02-02', 1935.00, 'pending', 'Dammam, King Faisal Road'),
(5, '2024-02-03', 12280.00, 'completed', 'Medina, Prince Abdul Majeed Road'),
(14, '2024-02-04', 4585.00, 'shipped', 'Riyadh, King Abdullah Road'),
(6, '2024-02-05', 735.00, 'completed', 'Taif, Shubra District');

-- إدراج تفاصيل الطلبات
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
-- Order 1
(1, 1, 1, 4500.00),
(1, 4, 1, 150.00),
-- Order 2
(2, 3, 1, 1200.00),
(2, 5, 1, 120.00),
-- Order 3
(3, 2, 1, 3800.00),
(3, 4, 1, 150.00),
-- Order 4
(4, 5, 3, 120.00),
(4, 4, 2, 150.00),
-- Order 5
(5, 7, 1, 1800.00),
(5, 6, 1, 450.00),
-- Order 6
(6, 10, 1, 800.00),
-- Order 7
(7, 8, 2, 280.00),
(7, 6, 2, 450.00),
(7, 4, 3, 150.00),
(7, 13, 1, 85.00),
-- Order 8
(8, 9, 1, 12000.00),
(8, 4, 1, 150.00),
-- Order 9
(9, 15, 1, 200.00),
(9, 13, 1, 85.00),
(9, 8, 1, 280.00),
-- Order 10
(10, 1, 1, 4500.00),
(10, 8, 1, 280.00),
-- Order 11
(11, 11, 1, 3200.00),
(11, 7, 1, 1800.00),
-- Order 12
(12, 6, 2, 450.00),
(12, 8, 1, 280.00),
-- Order 13
(13, 12, 1, 8500.00),
-- Order 14
(14, 3, 1, 1200.00),
(14, 14, 1, 650.00),
(14, 13, 1, 85.00),
-- Order 15
(15, 5, 2, 120.00),
(15, 4, 2, 150.00),
(15, 15, 1, 200.00),
-- Order 16
(16, 11, 1, 3200.00),
(16, 5, 1, 120.00),
-- Order 17
(17, 7, 1, 1800.00),
(17, 13, 1, 85.00),
(17, 8, 1, 280.00),
-- Order 18
(18, 9, 1, 12000.00),
(18, 8, 1, 280.00),
-- Order 19
(19, 1, 1, 4500.00),
(19, 13, 1, 85.00),
-- Order 20
(20, 14, 1, 650.00),
(20, 13, 1, 85.00);

-- إنشاء فهارس لتحسين الأداء
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_customers_active ON customers(is_active);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_employees_manager ON employees(manager_id);

-- إحصائيات قاعدة البيانات
-- العملاء: 15 عميل
-- المنتجات: 15 منتج في 5 فئات
-- الطلبات: 20 طلب
-- الموظفين: 15 موظف في 5 أقسام

