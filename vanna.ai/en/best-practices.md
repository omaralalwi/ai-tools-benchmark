# Best Practices Guide

## Overview

This guide provides proven strategies and best practices for maximizing Vanna AI's performance, accuracy, and efficiency in production environments.

## Question Formulation

### 1. Be Specific and Clear

**❌ Avoid Vague Questions:**
```
"Show me data"
"Get information"
"Tell me about customers"
```

**✅ Use Specific Questions:**
```
"Show me all customers who registered in 2024 and have placed at least one order"
"Calculate the total revenue for electronics products sold in the last 3 months"
"Find customers with average order value above $500 who are located in major cities"
```

### 2. Use Business Terminology

**❌ Generic Language:**
```
"Show me the stuff"
"Get the numbers"
"Find the things"
```

**✅ Business-Specific Language:**
```
"Show me customer lifetime value by registration month"
"Calculate monthly recurring revenue for subscription customers"
"Identify high-value prospects based on engagement metrics"
```

### 3. Break Down Complex Questions

Instead of one massive question, break it into logical parts:

**❌ Complex Single Question:**
```
"Show me comprehensive customer analysis including order history, preferences, lifetime value, churn risk, and recommendations"
```

**✅ Broken Down Questions:**
```python
# Step 1: Basic customer data
customers = vn.ask("Show me customer order history with total spend and order count")

# Step 2: Customer preferences
preferences = vn.ask("Identify top product categories for each customer")

# Step 3: Lifetime value calculation
ltv = vn.ask("Calculate customer lifetime value based on purchase frequency and amount")

# Step 4: Churn risk analysis
churn_risk = vn.ask("Identify customers at risk of churning based on recent activity")

# Step 5: Recommendations
recommendations = vn.ask("Suggest products for each customer based on their purchase history")
```

## Database Optimization

### 1. Proper Indexing

Ensure your database has appropriate indexes:

```sql
-- Essential indexes for common queries
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_customers_registration_date ON customers(registration_date);
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_order_items_order ON order_items(order_id);
```

### 2. Table Structure Optimization

```sql
-- Use appropriate data types
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,  -- Instead of TEXT
    registration_date DATE,            -- Instead of TEXT
    is_active BOOLEAN DEFAULT 1,      -- Instead of INTEGER
    city VARCHAR(50)                  -- Instead of TEXT
);

-- Add constraints for data integrity
ALTER TABLE orders ADD CONSTRAINT fk_customer 
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
```

### 3. Partition Large Tables

For tables with millions of records:

```sql
-- Partition orders by year
CREATE TABLE orders_2024 PARTITION OF orders 
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE orders_2023 PARTITION OF orders 
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
```

## Training and Context

### 1. Comprehensive Training Data

```python
import vanna as vn

vn = vn.VannaDefault()

# Train on complete database schema
vn.train_on_database_schema()

# Train on business documentation
vn.train_on_documentation("""
# Customer Management System

## Tables Overview
- customers: Customer information and demographics
- orders: Customer purchase orders
- products: Product catalog and pricing
- employees: Staff information and hierarchy

## Business Rules
- Active customers have is_active = 1
- Orders are marked as 'pending', 'shipped', or 'completed'
- Product prices are in local currency (SAR)
- Employee hierarchy uses manager_id for reporting structure

## Common Queries
- Customer count by city and status
- Monthly sales trends by product category
- Employee performance by department
- Revenue analysis by customer segment
""")

# Train on successful SQL examples
training_examples = [
    {
        "question": "How many active customers are in Riyadh?",
        "sql": "SELECT COUNT(*) FROM customers WHERE is_active = 1 AND city = 'Riyadh'"
    },
    {
        "question": "Show me the top 5 customers by total purchases",
        "sql": """
        SELECT c.first_name, c.last_name, SUM(o.total_amount) as total_spent
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        GROUP BY c.customer_id
        ORDER BY total_spent DESC
        LIMIT 5
        """
    }
]

for example in training_examples:
    vn.train_on_sql(example["question"], example["sql"])
```

### 2. Regular Training Updates

```python
# Regular training updates
def update_training_data():
    # Get new successful queries from logs
    new_queries = get_successful_queries_from_logs()
    
    for query in new_queries:
        vn.train_on_sql(query["question"], query["sql"])
    
    # Update business documentation
    vn.train_on_documentation(get_updated_business_docs())

# Run training updates as needed
# update_training_data()
```

## Performance Optimization

### 1. Query Caching Strategy

```python
# Implement intelligent caching
class SmartCache:
    def __init__(self):
        self.cache = {}
        self.access_count = {}
        self.last_access = {}
    
    def get(self, key):
        if key in self.cache:
            self.access_count[key] += 1
            self.last_access[key] = time.time()
            return self.cache[key]
        return None
    
    def set(self, key, value, ttl=3600):
        self.cache[key] = value
        self.access_count[key] = 1
        self.last_access[key] = time.time()
        
        # Schedule cleanup
        threading.Timer(ttl, self.cleanup, args=[key]).start()
    
    def cleanup(self, key):
        if key in self.cache:
            del self.cache[key]
            del self.access_count[key]
            del self.last_access[key]

# Use smart caching
cache = SmartCache()

def cached_query(question):
    cache_key = hashlib.md5(question.encode()).hexdigest()
    
    # Check cache first
    cached_result = cache.get(cache_key)
    if cached_result:
        return cached_result
    
    # Generate and cache
    result = vn.ask(question)
    cache.set(cache_key, result, ttl=1800)  # 30 minutes
    
    return result
```

### 2. Connection Pooling

```python
import psycopg2
from psycopg2 import pool

# Configure connection pool
connection_pool = psycopg2.pool.SimpleConnectionPool(
    minconn=5,
    maxconn=20,
    host="localhost",
    database="your_db",
    user="your_user",
    password="your_password"
)

def get_connection():
    return connection_pool.getconn()

def return_connection(conn):
    connection_pool.putconn(conn)

# Use in Vanna
vn.set_connection_pool(connection_pool)
```

### 3. Batch Processing

```python
# Process multiple queries efficiently
def batch_process_queries(questions):
    results = {}
    
    # Group similar questions
    grouped_questions = group_questions_by_type(questions)
    
    for group_type, group_questions in grouped_questions.items():
        # Process similar questions together
        batch_results = process_question_group(group_questions)
        results.update(batch_results)
    
    return results

def group_questions_by_type(questions):
    groups = {
        'count': [],
        'aggregation': [],
        'join': [],
        'analysis': []
    }
    
    for question in questions:
        if 'how many' in question.lower() or 'count' in question.lower():
            groups['count'].append(question)
        elif 'average' in question.lower() or 'sum' in question.lower():
            groups['aggregation'].append(question)
        elif 'show' in question.lower() and 'with' in question.lower():
            groups['join'].append(question)
        else:
            groups['analysis'].append(question)
    
    return groups
```

## Error Handling and Monitoring

### 1. Comprehensive Error Handling

```python
import logging
from typing import Dict, Any

class VannaErrorHandler:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.error_counts = {}
        self.success_counts = {}
    
    def handle_query(self, question: str) -> Dict[str, Any]:
        try:
            start_time = time.time()
            
            # Generate SQL
            sql = vn.generate_sql(question)
            
            # Execute query
            results = vn.run_sql(sql)
            
            execution_time = time.time() - start_time
            
            # Log success
            self.log_success(question, sql, execution_time, len(results))
            
            return {
                'success': True,
                'sql': sql,
                'results': results,
                'execution_time': execution_time,
                'row_count': len(results)
            }
            
        except Exception as e:
            # Log error
            self.log_error(question, str(e))
            
            # Return structured error
            return {
                'success': False,
                'error': str(e),
                'error_type': type(e).__name__,
                'suggestion': self.get_error_suggestion(str(e))
            }
    
    def log_success(self, question: str, sql: str, execution_time: float, row_count: int):
        self.logger.info(f"Query successful: {question[:100]}... | Time: {execution_time:.2f}s | Rows: {row_count}")
        self.success_counts[question] = self.success_counts.get(question, 0) + 1
    
    def log_error(self, question: str, error: str):
        self.logger.error(f"Query failed: {question[:100]}... | Error: {error}")
        self.error_counts[question] = self.error_counts.get(question, 0) + 1
    
    def get_error_suggestion(self, error: str) -> str:
        if "table not found" in error.lower():
            return "Check if the table exists in your database schema"
        elif "column not found" in error.lower():
            return "Verify the column names in your table structure"
        elif "syntax error" in error.lower():
            return "The generated SQL may have syntax issues. Try rephrasing your question"
        else:
            return "Check your database connection and permissions"

# Use error handler
error_handler = VannaErrorHandler()
result = error_handler.handle_query("How many customers are there?")
```

### 2. Performance Monitoring

```python
import time
import statistics
from collections import defaultdict

class PerformanceMonitor:
    def __init__(self):
        self.query_times = defaultdict(list)
        self.query_counts = defaultdict(int)
        self.error_counts = defaultdict(int)
        self.slow_queries = []
    
    def record_query(self, question: str, execution_time: float, success: bool):
        # Record timing
        self.query_times[question].append(execution_time)
        self.query_counts[question] += 1
        
        # Track slow queries
        if execution_time > 5.0:  # 5 seconds threshold
            self.slow_queries.append({
                'question': question,
                'time': execution_time,
                'timestamp': time.time()
            })
        
        # Track errors
        if not success:
            self.error_counts[question] += 1
    
    def get_performance_report(self) -> Dict[str, Any]:
        report = {
            'total_queries': sum(self.query_counts.values()),
            'unique_questions': len(self.query_counts),
            'success_rate': self.calculate_success_rate(),
            'average_response_time': self.calculate_average_time(),
            'slowest_queries': self.get_slowest_queries(),
            'most_common_queries': self.get_most_common_queries(),
            'error_analysis': self.get_error_analysis()
        }
        return report
    
    def calculate_success_rate(self) -> float:
        total_queries = sum(self.query_counts.values())
        total_errors = sum(self.error_counts.values())
        return ((total_queries - total_errors) / total_queries) * 100 if total_queries > 0 else 0
    
    def calculate_average_time(self) -> float:
        all_times = []
        for times in self.query_times.values():
            all_times.extend(times)
        return statistics.mean(all_times) if all_times else 0
    
    def get_slowest_queries(self) -> List[Dict]:
        return sorted(self.slow_queries, key=lambda x: x['time'], reverse=True)[:10]
    
    def get_most_common_queries(self) -> List[Tuple]:
        return sorted(self.query_counts.items(), key=lambda x: x[1], reverse=True)[:10]
    
    def get_error_analysis(self) -> Dict:
        return dict(sorted(self.error_counts.items(), key=lambda x: x[1], reverse=True)[:10])

# Use performance monitor
monitor = PerformanceMonitor()

# Wrap Vanna queries
def monitored_query(question: str):
    start_time = time.time()
    try:
        result = vn.ask(question)
        execution_time = time.time() - start_time
        monitor.record_query(question, execution_time, True)
        return result
    except Exception as e:
        execution_time = time.time() - start_time
        monitor.record_query(question, execution_time, False)
        raise e

# Generate performance report
report = monitor.get_performance_report()
print(f"Success Rate: {report['success_rate']:.1f}%")
print(f"Average Response Time: {report['average_response_time']:.2f}s")
```

## Security Best Practices

### 1. Input Validation

```python
import re
from typing import List

class QueryValidator:
    def __init__(self):
        self.blocked_keywords = [
            'DROP', 'DELETE', 'TRUNCATE', 'ALTER', 'CREATE', 'INSERT', 'UPDATE'
        ]
        self.allowed_tables = [
            'customers', 'orders', 'products', 'employees', 'order_items'
        ]
        self.max_query_length = 1000
    
    def validate_question(self, question: str) -> bool:
        # Check length
        if len(question) > self.max_query_length:
            raise ValueError("Question too long")
        
        # Check for SQL injection attempts
        if self.contains_sql_injection(question):
            raise ValueError("Potential SQL injection detected")
        
        return True
    
    def validate_generated_sql(self, sql: str) -> bool:
        # Check for dangerous operations
        sql_upper = sql.upper()
        for keyword in self.blocked_keywords:
            if keyword in sql_upper:
                raise ValueError(f"Dangerous operation {keyword} not allowed")
        
        # Check table access
        if not self.only_allowed_tables(sql):
            raise ValueError("Access to unauthorized tables detected")
        
        return True
    
    def contains_sql_injection(self, question: str) -> bool:
        # Look for suspicious patterns
        suspicious_patterns = [
            r'(\b(union|select|insert|update|delete|drop|create|alter)\b)',
            r'(\b(and|or)\s+\d+\s*=\s*\d+)',
            r'(\b(exec|execute|script)\b)',
            r'(\b(xp_|sp_)\b)'
        ]
        
        for pattern in suspicious_patterns:
            if re.search(pattern, question, re.IGNORECASE):
                return True
        
        return False
    
    def only_allowed_tables(self, sql: str) -> bool:
        # Extract table names from SQL
        table_pattern = r'\bFROM\s+(\w+)|JOIN\s+(\w+)'
        matches = re.findall(table_pattern, sql, re.IGNORECASE)
        
        for match in matches:
            table_name = match[0] or match[1]
            if table_name.lower() not in [t.lower() for t in self.allowed_tables]:
                return False
        
        return True

# Use validator
validator = QueryValidator()

def safe_query(question: str):
    # Validate input
    validator.validate_question(question)
    
    # Generate SQL
    sql = vn.generate_sql(question)
    
    # Validate generated SQL
    validator.validate_generated_sql(sql)
    
    # Execute query
    return vn.run_sql(sql)
```

### 2. Access Control

```python
class AccessController:
    def __init__(self):
        self.user_roles = {
            'analyst': ['customers', 'orders', 'products'],
            'manager': ['customers', 'orders', 'products', 'employees'],
            'admin': ['customers', 'orders', 'products', 'employees', 'system']
        }
        self.role_permissions = {
            'analyst': ['SELECT'],
            'manager': ['SELECT', 'INSERT', 'UPDATE'],
            'admin': ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP']
        }
    
    def check_access(self, user_role: str, table: str, operation: str) -> bool:
        if user_role not in self.user_roles:
            return False
        
        # Check table access
        if table not in self.user_roles[user_role]:
            return False
        
        # Check operation permission
        if operation not in self.role_permissions[user_role]:
            return False
        
        return True
    
    def filter_sql_by_permissions(self, user_role: str, sql: str) -> str:
        # Ensure SQL only accesses allowed tables and operations
        if not self.check_access(user_role, 'any', 'SELECT'):
            raise PermissionError("User does not have SELECT permission")
        
        return sql

# Use access control
access_controller = AccessController()

def role_based_query(user_role: str, question: str):
    # Check basic permissions
    if not access_controller.check_access(user_role, 'any', 'SELECT'):
        raise PermissionError("Insufficient permissions")
    
    # Generate SQL
    sql = vn.generate_sql(question)
    
    # Filter by permissions
    filtered_sql = access_controller.filter_sql_by_permissions(user_role, sql)
    
    # Execute query
    return vn.run_sql(filtered_sql)
```

## Deployment Best Practices

### 1. Environment Configuration

```python
import os
from typing import Dict, Any

class EnvironmentConfig:
    def __init__(self):
        self.config = self.load_config()
    
    def load_config(self) -> Dict[str, Any]:
        return {
            'development': {
                'debug': True,
                'cache_ttl': 300,
                'max_connections': 10,
                'log_level': 'DEBUG'
            },
            'staging': {
                'debug': False,
                'cache_ttl': 600,
                'max_connections': 20,
                'log_level': 'INFO'
            },
            'production': {
                'debug': False,
                'cache_ttl': 1800,
                'max_connections': 50,
                'log_level': 'WARNING'
            }
        }
    
    def get_config(self, environment: str = None) -> Dict[str, Any]:
        env = environment or os.getenv('ENVIRONMENT', 'development')
        return self.config.get(env, self.config['development'])
    
    def configure_vanna(self, vn, environment: str = None):
        config = self.get_config(environment)
        
        # Apply configuration
        if config['debug']:
            vn.set_debug(True)
        
        vn.configure_connection_pool(
            max_connections=config['max_connections']
        )
        
        # Set logging level
        logging.getLogger().setLevel(getattr(logging, config['log_level']))

# Use environment configuration
env_config = EnvironmentConfig()
vn = vn.VannaDefault()
env_config.configure_vanna(vn, os.getenv('ENVIRONMENT'))
```

### 2. Health Checks

```python
import time
from typing import Dict, Any

class HealthChecker:
    def __init__(self, vn):
        self.vn = vn
        self.last_check = 0
        self.check_interval = 300  # 5 minutes
    
    def check_health(self) -> Dict[str, Any]:
        current_time = time.time()
        
        # Don't check too frequently
        if current_time - self.last_check < self.check_interval:
            return self.last_health_status
        
        try:
            # Test basic functionality
            start_time = time.time()
            test_result = self.vn.ask("SELECT 1 as test")
            response_time = time.time() - start_time
            
            # Check database connection
            db_status = self.check_database_connection()
            
            # Check model availability
            model_status = self.check_model_status()
            
            health_status = {
                'status': 'healthy',
                'timestamp': current_time,
                'response_time': response_time,
                'database': db_status,
                'model': model_status,
                'overall_score': self.calculate_health_score(response_time, db_status, model_status)
            }
            
        except Exception as e:
            health_status = {
                'status': 'unhealthy',
                'timestamp': current_time,
                'error': str(e),
                'overall_score': 0
            }
        
        self.last_health_status = health_status
        self.last_check = current_time
        
        return health_status
    
    def check_database_connection(self) -> Dict[str, Any]:
        try:
            # Simple connection test
            result = self.vn.run_sql("SELECT 1")
            return {'status': 'connected', 'response_time': 0.1}
        except Exception as e:
            return {'status': 'disconnected', 'error': str(e)}
    
    def check_model_status(self) -> Dict[str, Any]:
        try:
            # Test model response
            sql = self.vn.generate_sql("test")
            return {'status': 'available', 'response_time': 0.1}
        except Exception as e:
            return {'status': 'unavailable', 'error': str(e)}
    
    def calculate_health_score(self, response_time: float, db_status: Dict, model_status: Dict) -> float:
        score = 100
        
        # Deduct points for slow response
        if response_time > 5.0:
            score -= 30
        elif response_time > 2.0:
            score -= 15
        
        # Deduct points for database issues
        if db_status['status'] != 'connected':
            score -= 40
        
        # Deduct points for model issues
        if model_status['status'] != 'available':
            score -= 40
        
        return max(0, score)

# Use health checker
health_checker = HealthChecker(vn)

# Check health periodically
def periodic_health_check():
    health = health_checker.check_health()
    if health['overall_score'] < 70:
        # Alert administrators
        send_alert(f"Vanna health score low: {health['overall_score']}")
    
    return health

# Run health check periodically
# schedule.every(5).minutes.do(periodic_health_check)
```

## Next Steps

Now that you understand best practices:

1. **[Testing Guide](./testing.md)** - Run comprehensive tests
2. **[Advanced Features](./advanced-features.md)** - Explore advanced capabilities
3. **[Troubleshooting](./troubleshooting.md)** - Handle common issues

---

Ready to troubleshoot? Let's move to [Troubleshooting](./troubleshooting.md)!
