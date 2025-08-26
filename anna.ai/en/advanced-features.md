# Advanced Features Guide

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**Complete Guide for Advanced Vanna AI Features and Capabilities**

</div>

---

## Overview

Beyond basic usage, Vanna AI offers powerful advanced features for enterprise applications, custom integrations, and specialized use cases. This guide explores these capabilities in detail.

## Custom Training & Fine-tuning

### 1. Training on Your Data

Vanna learns from your specific database context:

```python
import vanna as vn

# Initialize with custom training
vn = vn.VannaDefault()

# Train on your database schema
vn.train_on_database_schema()

# Train on business documentation
vn.train_on_documentation("""
Our customers table contains:
- customer_id: Unique identifier
- first_name: Customer's first name
- last_name: Customer's last name
- email: Contact email
- city: Customer's city
- is_active: Account status (1=active, 0=inactive)
""")

# Train on successful SQL examples
vn.train_on_sql("""
Question: "How many active customers are there?"
SQL: "SELECT COUNT(*) FROM customers WHERE is_active = 1"
""")
```

### 2. Custom Training Data Sources

```python
# Train on CSV files
vn.train_on_csv("customer_data.csv", "customers")

# Train on Excel files
vn.train_on_excel("sales_data.xlsx", "orders")

# Train on JSON data
vn.train_on_json("product_catalog.json", "products")

# Train on web content
vn.train_on_url("https://your-domain.com/api-docs")
```

### 3. Advanced Training Techniques

```python
# Train on specific business rules
vn.train_on_documentation("""
Business Rules:
- Premium customers: total_spend > 1000
- Active customers: last_order_date > 30 days ago
- High-value products: price > 100
""")

# Train on complex query patterns
vn.train_on_sql("""
Question: "Show me customer lifetime value by region"
SQL: "SELECT c.region, AVG(c.total_spend) as avg_ltv FROM customers c GROUP BY c.region"
""")

# Train on industry-specific terminology
vn.train_on_documentation("""
Industry Terms:
- ARR: Annual Recurring Revenue
- CAC: Customer Acquisition Cost
- LTV: Lifetime Value
- Churn: Customer loss rate
""")
```

## Advanced Query Generation

### 1. Complex Business Logic

```python
# Multi-step analysis
question = """
Analyze customer behavior:
1. Find customers who made purchases in the last 3 months
2. Calculate their average order value
3. Identify those spending above average
4. Show their preferred product categories
"""

sql = vn.generate_sql(question)
results = vn.run_sql(sql)
```

### 2. Time-Series Analysis

```python
# Monthly trends
vn.ask("Show monthly sales trends for the last 12 months")

# Year-over-year comparison
vn.ask("Compare sales performance between 2023 and 2024 by quarter")

# Seasonal analysis
vn.ask("Identify peak sales months and analyze customer behavior patterns")

# Rolling averages
vn.ask("Calculate 30-day rolling average of daily sales")
```

### 3. Predictive Queries

```python
# Customer lifetime value
vn.ask("Calculate customer lifetime value based on purchase history and frequency")

# Churn prediction
vn.ask("Identify customers at risk of churning based on recent activity")

# Revenue forecasting
vn.ask("Project revenue for next quarter based on current trends and seasonality")

# Product recommendation scoring
vn.ask("Score products by likelihood of customer purchase based on history")
```

### 4. Advanced Analytics

```python
# Cohort analysis
vn.ask("Analyze customer retention by signup month")

# RFM analysis
vn.ask("Segment customers by Recency, Frequency, and Monetary value")

# A/B testing analysis
vn.ask("Compare conversion rates between different marketing campaigns")

# Customer journey analysis
vn.ask("Track customer touchpoints from first visit to purchase")
```

## Integration Capabilities

### 1. Web Application Integration

```python
from flask import Flask, request, jsonify
import vanna as vn

app = Flask(__name__)
vn = vn.VannaDefault()

@app.route('/query', methods=['POST'])
def natural_language_query():
    data = request.get_json()
    question = data['question']
    
    try:
        # Generate SQL
        sql = vn.generate_sql(question)
        
        # Execute query
        results = vn.run_sql(sql)
        
        return jsonify({
            'success': True,
            'sql': sql,
            'results': results.to_dict('records'),
            'row_count': len(results)
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 400

if __name__ == '__main__':
    app.run(debug=True)
```

### 2. Slack Bot Integration

```python
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler
import vanna as vn

app = App(token="your-slack-token")
vn = vn.VannaDefault()

@app.message("query:")
def handle_query(message, say):
    # Extract question after "query:"
    question = message['text'].replace('query:', '').strip()
    
    try:
        results = vn.ask(question)
        
        # Format results for Slack
        response = f"Query: {question}\n\nResults:\n{results.to_string()}"
        say(response)
        
    except Exception as e:
        say(f"Error processing query: {str(e)}")

if __name__ == "__main__":
    handler = SocketModeHandler(app, "your-app-token")
    handler.start()
```

### 3. Streamlit Dashboard

```python
import streamlit as st
import vanna as vn
import pandas as pd

# Initialize Vanna
vn = vn.VannaDefault()

# Streamlit interface
st.title("Vanna AI - Natural Language Database Query")

# Input question
question = st.text_input("Ask a question about your data:", 
                        placeholder="e.g., How many customers are there?")

if st.button("Generate Query"):
    if question:
        try:
            with st.spinner("Generating SQL..."):
                sql = vn.generate_sql(question)
                st.code(sql, language="sql")
            
            with st.spinner("Executing query..."):
                results = vn.run_sql(sql)
                st.dataframe(results)
                
                # Export options
                csv = results.to_csv(index=False)
                st.download_button(
                    label="Download CSV",
                    data=csv,
                    file_name="query_results.csv",
                    mime="text/csv"
                )
                
        except Exception as e:
            st.error(f"Error: {str(e)}")

# Pre-defined queries
st.sidebar.header("Quick Queries")
if st.sidebar.button("Customer Count"):
    results = vn.ask("How many customers are there?")
    st.dataframe(results)

if st.sidebar.button("Top Products"):
    results = vn.ask("Show top 5 products by sales")
    st.dataframe(results)
```

### 4. API Integration

```python
import requests
import json

class VannaAPI:
    def __init__(self, base_url, api_key):
        self.base_url = base_url
        self.headers = {"Authorization": f"Bearer {api_key}"}
    
    def query(self, question):
        response = requests.post(
            f"{self.base_url}/query",
            headers=self.headers,
            json={"question": question}
        )
        return response.json()
    
    def batch_query(self, questions):
        response = requests.post(
            f"{self.base_url}/batch-query",
            headers=self.headers,
            json={"questions": questions}
        )
        return response.json()

# Use the API
vanna_api = VannaAPI("https://your-vanna-api.com", "your-api-key")
results = vanna_api.query("How many customers are there?")
```

## Performance Optimization

### 1. Query Caching

```python
# Enable caching for repeated queries
vn.enable_caching()

# Cache specific queries
vn.cache_query("customer_count", "SELECT COUNT(*) FROM customers")

# Use cached results
if vn.is_cached("customer_count"):
    results = vn.get_cached_result("customer_count")
else:
    results = vn.run_sql("SELECT COUNT(*) FROM customers")
    vn.cache_query("customer_count", "SELECT COUNT(*) FROM customers", results)
```

### 2. Batch Processing

```python
# Process multiple questions efficiently
questions = [
    "How many customers are there?",
    "What is the total revenue?",
    "Show top 10 products by sales",
    "Calculate average order value by month"
]

# Batch process
results = {}
for question in questions:
    try:
        sql = vn.generate_sql(question)
        results[question] = vn.run_sql(sql)
    except Exception as e:
        results[question] = f"Error: {str(e)}"

# Display all results
for question, result in results.items():
    print(f"\nQuestion: {question}")
    if isinstance(result, str):
        print(f"Result: {result}")
    else:
        print(f"Result: {len(result)} rows")
```

### 3. Connection Pooling

```python
# Configure connection pooling for high-traffic applications
vn.configure_connection_pool(
    max_connections=20,
    min_connections=5,
    connection_timeout=30,
    idle_timeout=300
)
```

### 4. Query Optimization

```python
# Enable query optimization
vn.enable_query_optimization()

# Set optimization preferences
vn.set_optimization_preferences({
    'prefer_indexes': True,
    'limit_joins': 5,
    'max_subquery_depth': 3,
    'prefer_window_functions': True
})
```

## Security Features

### 1. Query Validation

```python
# Enable SQL injection protection
vn.enable_sql_validation()

# Custom validation rules
def custom_validation(sql):
    # Block dangerous operations
    dangerous_keywords = ['DROP', 'DELETE', 'TRUNCATE', 'ALTER']
    for keyword in dangerous_keywords:
        if keyword in sql.upper():
            raise ValueError(f"Operation {keyword} is not allowed")
    return sql

vn.set_custom_validator(custom_validation)
```

### 2. Access Control

```python
# Role-based access control
vn.set_user_role("analyst")
vn.set_access_level("read_only")

# Table-level permissions
vn.set_table_permissions({
    "customers": ["SELECT"],
    "orders": ["SELECT"],
    "employees": ["SELECT"],
    "sensitive_data": []  # No access
})
```

### 3. Audit Logging

```python
# Enable comprehensive logging
vn.enable_audit_logging()

# Custom log handler
def custom_logger(user, question, sql, results, execution_time):
    log_entry = {
        'timestamp': datetime.now(),
        'user': user,
        'question': question,
        'sql': sql,
        'row_count': len(results) if results is not None else 0,
        'execution_time': execution_time
    }
    # Save to your logging system
    save_to_logs(log_entry)

vn.set_custom_logger(custom_logger)
```

## Custom Extensions

### 1. Custom SQL Generators

```python
class CustomSQLGenerator:
    def generate_sql(self, question, context):
        # Custom logic for specific business domains
        if "financial" in question.lower():
            return self.generate_financial_sql(question, context)
        elif "inventory" in question.lower():
            return self.generate_inventory_sql(question, context)
        else:
            return self.generate_standard_sql(question, context)
    
    def generate_financial_sql(self, question, context):
        # Specialized financial query generation
        pass

# Use custom generator
vn.set_custom_sql_generator(CustomSQLGenerator())
```

### 2. Custom Result Processors

```python
def custom_result_processor(results, question):
    # Post-process results based on question type
    if "percentage" in question.lower():
        # Convert to percentages
        return results.apply(lambda x: x * 100 if x.dtype in ['float64', 'int64'] else x)
    elif "currency" in question.lower():
        # Format as currency
        return results.apply(lambda x: f"${x:,.2f}" if x.dtype in ['float64', 'int64'] else x)
    return results

vn.set_custom_result_processor(custom_result_processor)
```

## Monitoring & Analytics

### 1. Performance Metrics

```python
# Get performance statistics
stats = vn.get_performance_stats()
print(f"Total queries: {stats['total_queries']}")
print(f"Average response time: {stats['avg_response_time']:.2f}s")
print(f"Success rate: {stats['success_rate']:.1%}")

# Query performance breakdown
query_stats = vn.get_query_performance_breakdown()
for query_type, performance in query_stats.items():
    print(f"{query_type}: {performance['avg_time']:.2f}s")
```

### 2. Usage Analytics

```python
# Track user behavior
usage_stats = vn.get_usage_analytics()
print(f"Most common question types: {usage_stats['common_questions']}")
print(f"Peak usage hours: {usage_stats['peak_hours']}")
print(f"User satisfaction: {usage_stats['satisfaction_score']}")
```

### 3. Health Monitoring

```python
# Monitor system health
health_status = vn.check_system_health()
print(f"Database connection: {health_status['database']}")
print(f"Model availability: {health_status['model']}")
print(f"Overall health score: {health_status['overall_score']}")
```

## Next Steps

Now that you understand advanced features:

1. **[Best Practices](./best-practices.md)** - Learn optimization techniques
2. **[Testing Guide](./testing.md)** - Run comprehensive tests
3. **[Troubleshooting](./troubleshooting.md)** - Handle common issues

---

Ready to learn best practices? Let's move to [Best Practices](./best-practices.md)!
