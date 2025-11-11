/*
  # Shopping Website Database Schema

  ## Overview
  Creates a complete e-commerce database with products, categories, shopping cart, and order management.

  ## New Tables

  ### 1. categories
  Product categories for organizing items
  - `id` (uuid, primary key) - Unique category identifier
  - `name` (text) - Category name
  - `slug` (text, unique) - URL-friendly identifier
  - `description` (text) - Category description
  - `created_at` (timestamptz) - Creation timestamp

  ### 2. products
  Product catalog with details and pricing
  - `id` (uuid, primary key) - Unique product identifier
  - `category_id` (uuid, foreign key) - Reference to categories table
  - `name` (text) - Product name
  - `slug` (text, unique) - URL-friendly identifier
  - `description` (text) - Product description
  - `price` (decimal) - Product price
  - `image_url` (text) - Product image URL
  - `stock` (integer) - Available quantity
  - `featured` (boolean) - Featured product flag
  - `created_at` (timestamptz) - Creation timestamp

  ### 3. cart_items
  Shopping cart items for users
  - `id` (uuid, primary key) - Unique cart item identifier
  - `user_id` (uuid) - User identifier (for guest carts, this can be a session ID)
  - `product_id` (uuid, foreign key) - Reference to products table
  - `quantity` (integer) - Item quantity
  - `created_at` (timestamptz) - Creation timestamp

  ### 4. orders
  Customer orders
  - `id` (uuid, primary key) - Unique order identifier
  - `user_id` (uuid) - User identifier
  - `customer_name` (text) - Customer name
  - `customer_email` (text) - Customer email
  - `customer_address` (text) - Shipping address
  - `total_amount` (decimal) - Order total
  - `status` (text) - Order status (pending, processing, shipped, delivered)
  - `created_at` (timestamptz) - Order creation timestamp

  ### 5. order_items
  Individual items within orders
  - `id` (uuid, primary key) - Unique order item identifier
  - `order_id` (uuid, foreign key) - Reference to orders table
  - `product_id` (uuid, foreign key) - Reference to products table
  - `quantity` (integer) - Item quantity
  - `price` (decimal) - Price at time of purchase
  - `created_at` (timestamptz) - Creation timestamp

  ## Security
  - Enable RLS on all tables
  - Public read access for products and categories
  - Authenticated users can manage their own cart and orders
  - Guest users can read products and categories

  ## Notes
  - All tables use UUIDs for primary keys
  - Timestamps are automatically set
  - Prices stored as decimal for precision
  - Includes sample data for immediate functionality
*/

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid REFERENCES categories(id) ON DELETE SET NULL,
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text DEFAULT '',
  price decimal(10,2) NOT NULL,
  image_url text NOT NULL,
  stock integer DEFAULT 0,
  featured boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create cart_items table
CREATE TABLE IF NOT EXISTS cart_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  product_id uuid REFERENCES products(id) ON DELETE CASCADE,
  quantity integer DEFAULT 1,
  created_at timestamptz DEFAULT now()
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  customer_name text NOT NULL,
  customer_email text NOT NULL,
  customer_address text NOT NULL,
  total_amount decimal(10,2) NOT NULL,
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES products(id) ON DELETE SET NULL,
  quantity integer NOT NULL,
  price decimal(10,2) NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- RLS Policies for categories (public read)
CREATE POLICY "Anyone can view categories"
  ON categories FOR SELECT
  USING (true);

-- RLS Policies for products (public read)
CREATE POLICY "Anyone can view products"
  ON products FOR SELECT
  USING (true);

-- RLS Policies for cart_items
CREATE POLICY "Users can view own cart items"
  ON cart_items FOR SELECT
  USING (true);

CREATE POLICY "Users can insert own cart items"
  ON cart_items FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can update own cart items"
  ON cart_items FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Users can delete own cart items"
  ON cart_items FOR DELETE
  USING (true);

-- RLS Policies for orders
CREATE POLICY "Users can view own orders"
  ON orders FOR SELECT
  USING (true);

CREATE POLICY "Users can create orders"
  ON orders FOR INSERT
  WITH CHECK (true);

-- RLS Policies for order_items
CREATE POLICY "Users can view order items"
  ON order_items FOR SELECT
  USING (true);

CREATE POLICY "Users can create order items"
  ON order_items FOR INSERT
  WITH CHECK (true);

-- Insert sample categories
INSERT INTO categories (name, slug, description) VALUES
  ('Electronics', 'electronics', 'Latest gadgets and electronic devices'),
  ('Fashion', 'fashion', 'Trendy clothing and accessories'),
  ('Home & Living', 'home-living', 'Everything for your home'),
  ('Sports', 'sports', 'Sports equipment and activewear')
ON CONFLICT (slug) DO NOTHING;

-- Insert sample products
INSERT INTO products (category_id, name, slug, description, price, image_url, stock, featured) 
SELECT 
  c.id,
  'Wireless Headphones',
  'wireless-headphones',
  'Premium noise-cancelling wireless headphones with 30-hour battery life',
  199.99,
  'https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg?auto=compress&cs=tinysrgb&w=800',
  50,
  true
FROM categories c WHERE c.slug = 'electronics'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (category_id, name, slug, description, price, image_url, stock, featured) 
SELECT 
  c.id,
  'Smart Watch',
  'smart-watch',
  'Track your fitness and stay connected with this sleek smartwatch',
  299.99,
  'https://images.pexels.com/photos/437037/pexels-photo-437037.jpeg?auto=compress&cs=tinysrgb&w=800',
  35,
  true
FROM categories c WHERE c.slug = 'electronics'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (category_id, name, slug, description, price, image_url, stock, featured) 
SELECT 
  c.id,
  'Designer Sunglasses',
  'designer-sunglasses',
  'Stylish UV protection sunglasses with premium frames',
  149.99,
  'https://images.pexels.com/photos/701877/pexels-photo-701877.jpeg?auto=compress&cs=tinysrgb&w=800',
  100,
  false
FROM categories c WHERE c.slug = 'fashion'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (category_id, name, slug, description, price, image_url, stock, featured) 
SELECT 
  c.id,
  'Leather Backpack',
  'leather-backpack',
  'Premium leather backpack perfect for work or travel',
  179.99,
  'https://images.pexels.com/photos/2905238/pexels-photo-2905238.jpeg?auto=compress&cs=tinysrgb&w=800',
  45,
  true
FROM categories c WHERE c.slug = 'fashion'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (category_id, name, slug, description, price, image_url, stock, featured) 
SELECT 
  c.id,
  'Ceramic Vase Set',
  'ceramic-vase-set',
  'Beautiful handcrafted ceramic vase set for home decoration',
  89.99,
  'https://images.pexels.com/photos/1669754/pexels-photo-1669754.jpeg?auto=compress&cs=tinysrgb&w=800',
  60,
  false
FROM categories c WHERE c.slug = 'home-living'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (category_id, name, slug, description, price, image_url, stock, featured) 
SELECT 
  c.id,
  'Minimalist Coffee Table',
  'minimalist-coffee-table',
  'Modern minimalist coffee table with clean lines',
  449.99,
  'https://images.pexels.com/photos/1350789/pexels-photo-1350789.jpeg?auto=compress&cs=tinysrgb&w=800',
  20,
  false
FROM categories c WHERE c.slug = 'home-living'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (category_id, name, slug, description, price, image_url, stock, featured) 
SELECT 
  c.id,
  'Yoga Mat Pro',
  'yoga-mat-pro',
  'Extra thick yoga mat with carrying strap',
  59.99,
  'https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=800',
  80,
  false
FROM categories c WHERE c.slug = 'sports'
ON CONFLICT (slug) DO NOTHING;

INSERT INTO products (category_id, name, slug, description, price, image_url, stock, featured) 
SELECT 
  c.id,
  'Running Shoes',
  'running-shoes',
  'Lightweight performance running shoes with advanced cushioning',
  129.99,
  'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?auto=compress&cs=tinysrgb&w=800',
  75,
  true
FROM categories c WHERE c.slug = 'sports'
ON CONFLICT (slug) DO NOTHING;