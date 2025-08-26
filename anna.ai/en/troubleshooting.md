# Troubleshooting Guide

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**Complete Guide for Solving Common Vanna AI Issues**

</div>

---

## Overview

This guide helps you resolve common issues and errors when using Vanna AI. It covers installation problems, configuration issues, database connection errors, and performance optimization.

## Common Installation Issues

### 1. Python Version Problems

**Error**: `ModuleNotFoundError: No module named 'vanna'`

**Solutions**:
```bash
# Check Python version
python --version

# Ensure Python 3.11+
python3.11 -m pip install vanna

# Or use virtual environment
python3.11 -m venv vanna_env
source vanna_env/bin/activate  # Linux/Mac
vanna_env\Scripts\activate     # Windows
pip install vanna
```

### 2. Package Installation Failures

**Error**: `ERROR: Could not find a version that satisfies the requirement`

**Solutions**:
```bash
# Update pip first
python -m pip install --upgrade pip

# Clear pip cache
pip cache purge

# Install with specific version
pip install vanna==0.7.9

# Install from source
git clone https://github.com/vanna-ai/vanna.git
cd vanna
pip install -e .
```

### 3. Dependency Conflicts

**Error**: `ERROR: Cannot uninstall 'package'. It is a distutils installed project`

**Solutions**:
```bash
# Force reinstall
pip install --force-reinstall vanna

# Use conda instead
conda create -n vanna python=3.11
conda activate vanna
pip install vanna
```

## Configuration Issues

### 1. API Key Problems

**Error**: `Invalid API key` or `API key not found`

**Solutions**:
```python
# Set environment variable
import os
os.environ['VANNA_API_KEY'] = 'your-actual-api-key'

# Or set in code
vn = vn.VannaDefault(api_key='your-actual-api-key')

# Check if key is set
print(f"API Key set: {'VANNA_API_KEY' in os.environ}")
```

### 2. Model Configuration Issues

**Error**: `Model not found` or `Invalid model name`

**Solutions**:
```python
# Use default model
vn = vn.VannaDefault()

# Or specify correct model
vn = vn.VannaDefault(model="gpt-4")

# Available models
available_models = vn.get_available_models()
print(f"Available models: {available_models}")
```

### 3. Environment Variable Issues

**Error**: `Environment variable not found`

**Solutions**:
```bash
# Set in shell
export VANNA_API_KEY="your-key"
export VANNA_MODEL="gpt-4"

# Or create .env file
echo "VANNA_API_KEY=your-key" > .env
echo "VANNA_MODEL=gpt-4" >> .env

# Load in Python
from dotenv import load_dotenv
load_dotenv()
```

## Database Connection Issues

### 1. Connection Refused

**Error**: `Connection refused` or `Connection timeout`

**Solutions**:
```python
# Check database status
import psycopg2
try:
    conn = psycopg2.connect(
        host="localhost",
        port=5432,
        database="your_db",
        user="your_user",
        password="your_password"
    )
    print("✅ Database connection successful")
    conn.close()
except Exception as e:
    print(f"❌ Database connection failed: {e}")

# Test Vanna connection
try:
    vn.connect_to_postgres(
        host="localhost",
        port=5432,
        database="your_db",
        user="your_user",
        password="your_password"
    )
    print("✅ Vanna connection successful")
except Exception as e:
    print(f"❌ Vanna connection failed: {e}")
```

### 2. Authentication Failures

**Error**: `Authentication failed` or `Invalid credentials`

**Solutions**:
```python
# Verify credentials
import psycopg2
try:
    conn = psycopg2.connect(
        host="localhost",
        port=5432,
        database="your_db",
        user="your_user",
        password="your_password"
    )
    print("✅ Credentials are correct")
    conn.close()
except psycopg2.OperationalError as e:
    if "authentication" in str(e).lower():
        print("❌ Authentication failed - check username/password")
    else:
        print(f"❌ Other error: {e}")

# Reset password if needed
# ALTER USER your_user PASSWORD 'new_password';
```

### 3. Database Not Found

**Error**: `Database does not exist` or `Database not found`

**Solutions**:
```sql
-- List available databases
\l

-- Create database if it doesn't exist
CREATE DATABASE your_db;

-- Connect to existing database
\c your_db

-- Check tables
\dt
```

## Query Generation Issues

### 1. SQL Generation Failures

**Error**: `Failed to generate SQL` or `Model error`

**Solutions**:
```python
# Check model status
try:
    test_sql = vn.generate_sql("test")
    print("✅ Model is working")
except Exception as e:
    print(f"❌ Model error: {e}")

# Try different question format
questions = [
    "How many customers are there?",
    "Count customers",
    "SELECT COUNT(*) FROM customers"
]

for question in questions:
    try:
        sql = vn.generate_sql(question)
        print(f"✅ '{question}' -> {sql}")
        break
    except Exception as e:
        print(f"❌ '{question}' -> {e}")
```

### 2. Incorrect SQL Generation

**Error**: Generated SQL doesn't match expected result

**Solutions**:
```python
# Train on specific examples
vn.train_on_sql("""
Question: "How many customers are there?"
SQL: "SELECT COUNT(*) FROM customers"
""")

# Train on business context
vn.train_on_documentation("""
Our database has:
- customers table with customer_id, name, email
- orders table with order_id, customer_id, amount
- products table with product_id, name, price
""")

# Verify training
sql = vn.generate_sql("How many customers are there?")
print(f"Generated SQL: {sql}")
```

### 3. Language Understanding Issues

**Error**: Poor understanding of Arabic/English questions

**Solutions**:
```python
# Train on language-specific examples
vn.train_on_sql("""
Question: "كم عدد العملاء؟"
SQL: "SELECT COUNT(*) FROM customers"
""")

vn.train_on_sql("""
Question: "How many customers are there?"
SQL: "SELECT COUNT(*) FROM customers"
""")

# Test both languages
arabic_result = vn.generate_sql("كم عدد العملاء؟")
english_result = vn.generate_sql("How many customers are there?")

print(f"Arabic: {arabic_result}")
print(f"English: {english_result}")
```

## Performance Issues

### 1. Slow Response Times

**Problem**: Queries taking too long to execute

**Solutions**:
```python
# Enable caching
vn.enable_caching()

# Check query performance
import time

def measure_performance(question):
    start_time = time.time()
    sql = vn.generate_sql(question)
    generation_time = time.time() - start_time
    
    start_time = time.time()
    results = vn.run_sql(sql)
    execution_time = time.time() - start_time
    
    print(f"Generation: {generation_time:.2f}s")
    print(f"Execution: {execution_time:.2f}s")
    print(f"Total: {generation_time + execution_time:.2f}s")
    
    return results

# Test performance
measure_performance("How many customers are there?")
```

### 2. Memory Issues

**Error**: `Out of memory` or `MemoryError`

**Solutions**:
```python
# Check memory usage
import psutil
memory = psutil.virtual_memory()
print(f"Memory usage: {memory.percent}%")

# Use smaller models
vn = vn.VannaDefault(model="gpt-3.5-turbo")  # Smaller than gpt-4

# Limit result size
vn.set_max_results(1000)

# Process in batches
def process_large_query(question, batch_size=100):
    sql = vn.generate_sql(question)
    # Modify SQL to include LIMIT
    if "LIMIT" not in sql.upper():
        sql += f" LIMIT {batch_size}"
    
    return vn.run_sql(sql)
```

### 3. Connection Timeouts

**Error**: `Connection timeout` or `Request timeout`

**Solutions**:
```python
# Increase timeout values
vn.set_timeout(60)  # 60 seconds

# Use connection pooling
vn.configure_connection_pool(
    max_connections=10,
    min_connections=2,
    connection_timeout=60,
    idle_timeout=300
)

# Implement retry logic
import time
from functools import wraps

def retry_on_timeout(max_retries=3, delay=1):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_retries):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if "timeout" in str(e).lower() and attempt < max_retries - 1:
                        time.sleep(delay)
                        continue
                    raise
            return func(*args, **kwargs)
        return wrapper
    return decorator

# Use retry decorator
@retry_on_timeout(max_retries=3, delay=2)
def robust_query(question):
    return vn.ask(question)
```

## Training and Learning Issues

### 1. Poor Query Accuracy

**Problem**: Generated SQL doesn't match business requirements

**Solutions**:
```python
# Comprehensive training
vn.train_on_database_schema()

# Train on business rules
vn.train_on_documentation("""
Business Rules:
- Active customers: is_active = 1
- Premium customers: total_spend > 1000
- New customers: registration_date > 6 months ago
- High-value products: price > 100
""")

# Train on successful examples
successful_examples = [
    ("How many active customers?", "SELECT COUNT(*) FROM customers WHERE is_active = 1"),
    ("Show premium customers", "SELECT * FROM customers WHERE total_spend > 1000"),
    ("List new customers", "SELECT * FROM customers WHERE registration_date > DATE('now', '-6 months')")
]

for question, sql in successful_examples:
    vn.train_on_sql(question, sql)
```

### 2. Training Data Issues

**Error**: `Training failed` or `Invalid training data`

**Solutions**:
```python
# Validate training data
def validate_training_data(question, sql):
    try:
        # Test if SQL is valid
        vn.run_sql(sql)
        print(f"✅ Valid SQL: {sql}")
        return True
    except Exception as e:
        print(f"❌ Invalid SQL: {sql}")
        print(f"Error: {e}")
        return False

# Train only with valid data
training_data = [
    ("Count customers", "SELECT COUNT(*) FROM customers"),
    ("Show active users", "SELECT * FROM customers WHERE is_active = 1")
]

for question, sql in training_data:
    if validate_training_data(question, sql):
        vn.train_on_sql(question, sql)
        print(f"Trained: {question}")
```

## Debugging Tools

### 1. Enable Debug Mode

```python
# Enable detailed logging
vn.set_debug(True)

# Set log level
vn.set_log_level("DEBUG")

# Custom logger
import logging
logging.basicConfig(level=logging.DEBUG)

def debug_query(question):
    print(f"Question: {question}")
    
    try:
        sql = vn.generate_sql(question)
        print(f"Generated SQL: {sql}")
        
        results = vn.run_sql(sql)
        print(f"Results: {len(results)} rows")
        
        return results
    except Exception as e:
        print(f"Error: {e}")
        return None

# Test with debug
debug_query("How many customers are there?")
```

### 2. Query Analysis

```python
def analyze_query(question):
    print(f"=== Query Analysis: {question} ===")
    
    # Step 1: Generate SQL
    try:
        sql = vn.generate_sql(question)
        print(f"✅ Generated SQL: {sql}")
    except Exception as e:
        print(f"❌ SQL Generation failed: {e}")
        return
    
    # Step 2: Validate SQL
    try:
        # Check if SQL is valid
        vn.run_sql("EXPLAIN " + sql)
        print("✅ SQL is valid")
    except Exception as e:
        print(f"❌ SQL validation failed: {e}")
        return
    
    # Step 3: Execute query
    try:
        start_time = time.time()
        results = vn.run_sql(sql)
        execution_time = time.time() - start_time
        
        print(f"✅ Query executed successfully")
        print(f"Execution time: {execution_time:.2f}s")
        print(f"Results: {len(results)} rows")
        
        return results
    except Exception as e:
        print(f"❌ Query execution failed: {e}")
        return None

# Analyze a query
analyze_query("Show me the top 5 customers by order count")
```

### 3. Performance Profiling

```python
import cProfile
import pstats

def profile_query(question):
    profiler = cProfile.Profile()
    profiler.enable()
    
    try:
        results = vn.ask(question)
        profiler.disable()
        
        # Print stats
        stats = pstats.Stats(profiler)
        stats.sort_stats('cumulative')
        stats.print_stats(10)
        
        return results
    except Exception as e:
        profiler.disable()
        print(f"Error: {e}")
        return None

# Profile a query
profile_query("How many customers are there?")
```

## Getting Help

### 1. Self-Diagnosis

```python
def diagnose_issues():
    print("=== Vanna AI Diagnosis ===")
    
    # Check Python version
    import sys
    print(f"Python version: {sys.version}")
    
    # Check Vanna version
    try:
        import vanna as vn
        print(f"Vanna version: {vn.__version__}")
    except ImportError:
        print("❌ Vanna not installed")
        return
    
    # Check configuration
    try:
        vn_instance = vn.VannaDefault()
        print("✅ Vanna initialized successfully")
    except Exception as e:
        print(f"❌ Vanna initialization failed: {e}")
        return
    
    # Check database connection
    try:
        # Test with simple query
        sql = vn_instance.generate_sql("test")
        print("✅ Model is working")
    except Exception as e:
        print(f"❌ Model error: {e}")
    
    # Check environment variables
    import os
    env_vars = ['VANNA_API_KEY', 'VANNA_MODEL']
    for var in env_vars:
        if var in os.environ:
            print(f"✅ {var} is set")
        else:
            print(f"❌ {var} is not set")

# Run diagnosis
diagnose_issues()
```

### 2. Community Support

- **Discord**: [Join our community](https://discord.gg/vanna-ai)
- **GitHub Issues**: [Report bugs](https://github.com/vanna-ai/vanna/issues)
- **Documentation**: [docs.vanna.ai](https://docs.vanna.ai/)

### 3. Professional Support

- **Email**: support@vanna.ai
- **Enterprise Support**: enterprise@vanna.ai

## Next Steps

1. **[Best Practices](./best-practices.md)** - Learn optimization techniques
2. **[Testing Guide](./testing.md)** - Run comprehensive tests
3. **[Advanced Features](./advanced-features.md)** - Explore advanced capabilities

---

Need more help? Check our [Best Practices](./best-practices.md) guide for optimization tips!
