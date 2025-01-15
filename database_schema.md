# Stock Management App Database Schema

## Tables

### 1. Products
This table stores the basic information about products.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | INTEGER | PRIMARY KEY, AUTOINCREMENT | Unique identifier for the product |
| name | TEXT | NOT NULL | Name of the product |
| description | TEXT | | Description of the product |
| price | REAL | NOT NULL | Price of the product |
| created_at | TEXT | NOT NULL | Timestamp when the product was created |
| updated_at | TEXT | NOT NULL | Timestamp when the product was last updated |

### 2. Stock
This table manages the stock levels for products.

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | INTEGER | PRIMARY KEY, AUTOINCREMENT | Unique identifier for the stock entry |
| product_id | INTEGER | NOT NULL, FOREIGN KEY | Reference to the product |
| quantity | INTEGER | NOT NULL, DEFAULT 0 | Current stock quantity |
| min_stock_level | INTEGER | NOT NULL, DEFAULT 10 | Minimum stock level before "Low Stock" warning |
| last_restock_date | TEXT | | Date of the last restock |

### 3. StockHistory
This table tracks all stock movements (increases and decreases).

| Column Name | Data Type | Constraints | Description |
|------------|-----------|-------------|-------------|
| id | INTEGER | PRIMARY KEY, AUTOINCREMENT | Unique identifier for the history entry |
| product_id | INTEGER | NOT NULL, FOREIGN KEY | Reference to the product |
| quantity_changed | INTEGER | NOT NULL | Amount changed (positive for increase, negative for decrease) |
| type | TEXT | NOT NULL | Type of movement ('IN' or 'OUT') |
| timestamp | TEXT | NOT NULL | When the change occurred |
| notes | TEXT | | Additional notes about the stock movement |

## Relationships

1. Products -(1:1)-> Stock
   - Each product has exactly one stock entry
   - Relationship maintained through product_id in Stock table

2. Products -(1:N)-> StockHistory
   - Each product can have multiple stock history entries
   - Relationship maintained through product_id in StockHistory table

## Stock Status Logic

Stock status is determined by the following rules:
- Out of Stock: quantity = 0
- Low Stock: quantity > 0 AND quantity <= min_stock_level
- In Stock: quantity > min_stock_level
