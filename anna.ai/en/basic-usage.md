# Basic Usage Guide

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**Complete Guide for Using Vanna AI Basic Features**

</div>

---

## Getting Started

Once Vanna AI is installed and configured, you can start using it immediately. This guide covers the fundamental operations and common use cases.

## Basic Operations

### 1. Initialization

Start by importing and initializing Vanna:

```python
import vanna as vn

# Basic initialization
vn = vn.VannaDefault()

# Or with custom configuration
vn = vn.VannaDefault(
    model="your-model-name",
    api_key="your-api-key"
)
```

### 2. Generate SQL from Natural Language

The core functionality - convert questions to SQL:

```python
# Simple question
question = "How many customers are there?"
sql = vn.generate_sql(question)
print(sql)

# Complex question
question = "Show me the top 5 customers by total purchase amount"
sql = vn.generate_sql(question)
print(sql)
```

### 3. Execute Queries

Run the generated SQL and get results:

```python
# Generate and execute in one step
results = vn.ask("What is the average order value?")
print(results)

# Or step by step
sql = vn.generate_sql("What is the average order value?")
results = vn.run_sql(sql)
print(results)
```

## Common Query Types

### Simple Count Queries

```python
# Count all records
sql = vn.generate_sql("How many products are in the electronics category?")
# Output: SELECT COUNT(*) FROM products WHERE category = 'Electronics'

# Count with conditions
sql = vn.generate_sql("How many active customers are in Riyadh?")
# Output: SELECT COUNT(*) FROM customers WHERE is_active = 1 AND city = 'Riyadh'
```

### Filtering and Selection

```python
# Basic filtering
sql = vn.generate_sql("Show me all customers from Saudi Arabia")
# Output: SELECT * FROM customers WHERE country = 'Saudi Arabia'

# Multiple conditions
sql = vn.generate_sql("Find customers who registered this year and are active")
# Output: SELECT * FROM customers WHERE strftime('%Y', registration_date) = '2024' AND is_active = 1
```

### Aggregations

```python
# Simple aggregation
sql = vn.generate_sql("What is the total revenue from all orders?")
# Output: SELECT SUM(total_amount) FROM orders

# Grouped aggregation
sql = vn.generate_sql("Show average salary by department")
# Output: SELECT department, AVG(salary) FROM employees GROUP BY department
```

### Joins

```python
# Basic join
sql = vn.generate_sql("Show customer names with their order details")
# Output: SELECT c.first_name, c.last_name, o.* FROM customers c JOIN orders o ON c.customer_id = o.customer_id

# Complex join
sql = vn.generate_sql("Find products that have been ordered more than 3 times")
# Output: SELECT p.product_name, COUNT(oi.order_id) FROM products p JOIN order_items oi ON p.product_id = oi.product_id GROUP BY p.product_id HAVING COUNT(oi.order_id) > 3
```

## Working with Results

### Basic Result Handling

```python
# Get results as DataFrame
results = vn.ask("Show me the top 10 customers by order count")
print(results)

# Access specific columns
print(results['customer_name'])
print(results['order_count'])

# Basic statistics
print(results.describe())
```

### Exporting Results

```python
# Export to CSV
results = vn.ask("Export all customer data")
results.to_csv('customers.csv', index=False)

# Export to Excel
results.to_excel('customers.xlsx', index=False)

# Export to JSON
results.to_json('customers.json', orient='records')
```

## Error Handling

### Common Error Scenarios

```python
try:
    # Try to generate SQL
    sql = vn.generate_sql("Show me customer data")
    results = vn.run_sql(sql)
    print("Success:", results)
    
except Exception as e:
    print(f"Error occurred: {e}")
    
    # Get more details about the error
    if "syntax error" in str(e).lower():
        print("SQL syntax issue - check the generated query")
    elif "table not found" in str(e).lower():
        print("Table doesn't exist - check your database schema")
    elif "column not found" in str(e).lower():
        print("Column doesn't exist - check your table structure")
```

### Debugging Queries

```python
# Enable debug mode to see what's happening
vn.set_debug(True)

# Generate SQL with detailed logging
sql = vn.generate_sql("Complex question here")
print("Generated SQL:", sql)

# Check if the SQL is valid
try:
    vn.run_sql(sql)
    print("✅ SQL executed successfully")
except Exception as e:
    print(f"❌ SQL execution failed: {e}")
```

## Training and Improvement

### Basic Training

```python
# Train on your database schema
vn.train_on_database_schema()

# Train on business documentation
vn.train_on_documentation("""
Our business rules:
- Active customers have is_active = 1
- Premium customers have total_spend > 1000
- New customers registered in the last 6 months
""")

# Train on successful SQL examples
vn.train_on_sql("""
Question: "How many premium customers are there?"
SQL: "SELECT COUNT(*) FROM customers WHERE total_spend > 1000"
""")
```

### Continuous Learning

```python
# Train on new successful queries
def learn_from_success(question, sql, results):
    vn.train_on_sql(question, sql)
    print(f"Learned from: {question}")

# Train on CSV data
vn.train_on_csv("customer_segments.csv", "customers")

# Train on Excel data
vn.train_on_excel("sales_analysis.xlsx", "orders")
```

## Best Practices

### 1. Be Specific in Your Questions

```python
# ❌ Vague
"Show me data"

# ✅ Specific
"Show me all customers who registered in 2024 and have placed at least one order"
```

### 2. Use Clear Language

```python
# ❌ Unclear
"Get the stuff"

# ✅ Clear
"Get the total revenue for each product category in the last 6 months"
```

### 3. Break Down Complex Questions

```python
# Instead of one complex question, break it down:
# "Show me customer analysis with order history, preferences, and lifetime value"

# Break into smaller parts:
vn.ask("Show me customer order history")
vn.ask("Calculate customer lifetime value")
vn.ask("Identify customer preferences by category")
```

### 4. Validate Results

```python
# Always check your results
results = vn.ask("How many customers are there?")
print(f"Total customers: {results.iloc[0, 0]}")

# Verify with a simple count
verify = vn.run_sql("SELECT COUNT(*) FROM customers")
print(f"Verification: {verify.iloc[0, 0]}")
```

## Example Workflow

Here's a complete example workflow:

```python
import vanna as vn
import pandas as pd

# Initialize Vanna
vn = vn.VannaDefault()

# 1. Explore the database
print("=== Database Overview ===")
vn.ask("What tables are available in the database?")

# 2. Basic analysis
print("\n=== Customer Analysis ===")
customer_count = vn.ask("How many customers are registered?")
print(f"Total customers: {customer_count.iloc[0, 0]}")

# 3. Detailed analysis
print("\n=== Sales Analysis ===")
top_customers = vn.ask("Show me the top 5 customers by total purchase amount")
print(top_customers)

# 4. Export results
top_customers.to_csv('top_customers.csv', index=False)
print("Results exported to top_customers.csv")
```

## Performance Tips

### 1. Use Appropriate Questions

```python
# ❌ Too broad
"Analyze everything about customers"

# ✅ Specific and focused
"Show me customer count by city with total revenue"
```

### 2. Leverage Training

```python
# Train on common business questions
common_questions = [
    "How many customers are there?",
    "What is the total revenue?",
    "Show top products by sales"
]

for question in common_questions:
    vn.train_on_sql(question, "SELECT COUNT(*) FROM customers")
```

### 3. Cache Frequently Used Queries

```python
# Cache common results
def get_customer_count():
    cache_key = "customer_count"
    if not hasattr(vn, '_cache'):
        vn._cache = {}
    
    if cache_key not in vn._cache:
        vn._cache[cache_key] = vn.ask("How many customers are there?")
    
    return vn._cache[cache_key]
```

## Next Steps

Now that you understand the basics:

1. **[Advanced Features](./advanced-features.md)** - Explore advanced capabilities
2. **[Testing Guide](./testing.md)** - Run comprehensive tests
3. **[Best Practices](./best-practices.md)** - Learn optimization techniques

---

Ready to explore more advanced features? Let's move to [Advanced Features](./advanced-features.md)!
