# Installation & Setup Guide

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**Comprehensive Guide for Installing and Setting Up Vanna AI on All Operating Systems**

</div>

---

## System Requirements

### Basic Requirements

<div align="center">

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **Python** | 3.11+ | 3.11+ |
| **Operating System** | Windows 10, macOS 10.15, Ubuntu 20.04 | Latest versions |
| **Memory (RAM)** | 4 GB | 8 GB |
| **Disk Space** | 2 GB | 5 GB |
| **Internet** | Required for cloud models | High speed |

</div>

### Optional Requirements
- **GPU**: For accelerating local models (CUDA compatible)
- **Docker**: For application deployment
- **Git**: For downloading latest versions

---

## Installation on Windows

### Method 1: Using pip (Easiest)

```bash
# Update pip
python -m pip install --upgrade pip

# Install basic Vanna
pip install vanna

# Install with required add-ons
pip install 'vanna[openai,chromadb]'
```

### Method 2: Using conda

```bash
# Create new environment
conda create -n vanna python=3.11
conda activate vanna

# Install Vanna
pip install 'vanna[openai,chromadb]'
```

### Method 3: From Source

```bash
# Download project
git clone https://github.com/vanna-ai/vanna.git
cd vanna

# Install in development mode
pip install -e .
```

---

## Installation on Linux (Ubuntu/Debian)

### Update System First

```bash
sudo apt update
sudo apt upgrade -y
```

### Install Python and Required Tools

```bash
# Install Python 3.11
sudo apt install python3.11 python3.11-pip python3.11-venv -y

# Create virtual environment
python3.11 -m venv vanna_env
source vanna_env/bin/activate

# Update pip
pip install --upgrade pip
```

### Install Vanna

```bash
# Install Vanna with all add-ons
pip install 'vanna[openai,chromadb,postgresql]'

# Or install basic version
pip install vanna
```

---

## Installation on macOS

### Using Homebrew

```bash
# Install Python 3.11
brew install python@3.11

# Create virtual environment
python3.11 -m venv vanna_env
source vanna_env/bin/activate

# Install Vanna
pip install 'vanna[openai,chromadb]'
```

### Using pyenv

```bash
# Install pyenv
brew install pyenv

# Install Python 3.11
pyenv install 3.11.0
pyenv global 3.11.0

# Create virtual environment
python -m venv vanna_env
source vanna_env/bin/activate

# Install Vanna
pip install vanna
```

---

## Verification

After installation, verify that Vanna is working:

```python
import vanna as vn
print(f"Vanna version: {vn.__version__}")
```

## Database Setup

### Option 1: Use Demo Database (Recommended for Testing)

We've included a complete demo database for testing:

```bash
# Create SQLite database from the demo file
sqlite3 demo.db < demo_db.sql
```

### Option 2: Connect to Your Database

Vanna supports multiple database types:

#### PostgreSQL
```python
import vanna as vn
from vanna.remote import VannaDefault

vn = VannaDefault(
    model="your-model-name",
    api_key="your-api-key"
)

# Connect to PostgreSQL
vn.connect_to_postgres(
    host="localhost",
    port=5432,
    database="your_db",
    username="your_user",
    password="your_password"
)
```

#### Snowflake
```python
vn.connect_to_snowflake(
    account="your-account",
    user="your-user",
    password="your-password",
    warehouse="your-warehouse",
    database="your-database",
    schema="your-schema"
)
```

#### BigQuery
```python
vn.connect_to_bigquery(
    project_id="your-project-id",
    dataset_id="your-dataset-id"
)
```

#### SQLite
```python
vn.connect_to_sqlite("path/to/your/database.db")
```

## Configuration

### Environment Variables

Set these environment variables for secure configuration:

```bash
export VANNA_API_KEY="your-api-key"
export VANNA_MODEL="your-model-name"
export VANNA_DATABASE_URL="your-database-connection-string"
```

### Configuration File

Create a `config.yaml` file:

```yaml
vanna:
  api_key: "your-api-key"
  model: "your-model-name"
  database:
    type: "postgresql"
    host: "localhost"
    port: 5432
    database: "your_db"
    username: "your_user"
    password: "your_password"
```

## First Run

After installation, test Vanna with a simple query:

```python
import vanna as vn

# Initialize Vanna
vn = vn.VannaDefault()

# Test connection
try:
    # Generate SQL for a simple question
    sql = vn.generate_sql("How many customers are there?")
    print("✅ Vanna is working!")
    print(f"Generated SQL: {sql}")
except Exception as e:
    print(f"❌ Error: {e}")
```

## Training the Model

### Basic Training

```python
# Train on database schema
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

### Advanced Training

```python
# Train on CSV files
vn.train_on_csv("customer_data.csv", "customers")

# Train on Excel files
vn.train_on_excel("sales_data.xlsx", "orders")

# Train on JSON data
vn.train_on_json("product_catalog.json", "products")
```

## Troubleshooting

### Common Issues

#### 1. Import Error
```bash
ModuleNotFoundError: No module named 'vanna'
```
**Solution**: Ensure you're using the correct Python environment and reinstall:
```bash
pip uninstall vanna
pip install vanna
```

#### 2. Database Connection Error
```bash
Connection refused
```
**Solution**: Check database credentials and ensure the database is running.

#### 3. API Key Error
```bash
Invalid API key
```
**Solution**: Verify your API key and ensure it's properly set in environment variables.

#### 4. Memory Issues
```bash
Out of memory
```
**Solution**: Increase system memory or use smaller models.

### Getting Help

If you encounter issues:

1. **Check the logs** for detailed error messages
2. **Verify prerequisites** are met
3. **Check network connectivity** for remote databases
4. **Join our Discord** for community support
5. **Open a GitHub issue** for bug reports

## Next Steps

Once installation is complete:

1. **[Basic Usage](./basic-usage.md)** - Learn fundamental commands
2. **[Testing Guide](./testing.md)** - Run comprehensive tests
3. **[Advanced Features](./advanced-features.md)** - Explore advanced capabilities

## System Requirements Summary

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Python    | 3.11    | 3.12+       |
| RAM       | 4GB     | 8GB+        |
| Storage   | 2GB     | 5GB+        |
| CPU       | 2 cores | 4+ cores    |

---

Installation complete? Great! Let's move to [Basic Usage](./basic-usage.md) to start using Vanna AI!
