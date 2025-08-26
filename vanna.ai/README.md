# Vanna AI - Text-to-SQL Tool Documentation

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**Intelligent Open-Source Tool for Converting Natural Language to SQL Queries**

[![GitHub Stars](https://img.shields.io/github/stars/vanna-ai/vanna?style=for-the-badge)](https://github.com/vanna-ai/vanna)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.11+-green.svg?style=for-the-badge)](https://python.org)

</div>

---

## What is Vanna AI?

Vanna AI is an open-source Python library that transforms natural language questions into accurate SQL queries using RAG (Retrieval-Augmented Generation) technology. It's designed to help non-technical users access database data easily without needing deep SQL knowledge.

### Why Vanna AI?

- 🌍 **Multi-language Support** - Excellent Arabic language support
- 🗄️ **Multi-database Support** - Works with Snowflake, BigQuery, PostgreSQL, and more
- 🔒 **Security-First** - Database contents never sent to LLM unless specifically enabled
- 📈 **Self-Learning** - Continuously improves with usage
- 🎯 **High Accuracy** - Achieves high accuracy rates on complex datasets

## Quick Start

### Installation

```bash
pip install vanna
```

### Basic Usage

```python
import vanna as vn

# Initialize Vanna
vn = vn.VannaDefault()

# Ask questions in natural language
sql = vn.generate_sql("How many customers are registered in the system?")
print(sql)
```

## Documentation

This repository contains comprehensive documentation in multiple languages:

- **[English Documentation](./en/)** - Complete guide in English
- **[Arabic Documentation](./ar/)** - دليل شامل باللغة العربية

## What's Inside

### English Documentation (`/en/`)
- [Getting Started Guide](./en/getting-started.md)
- [Installation & Setup](./en/installation.md)
- [Basic Usage Examples](./en/basic-usage.md)
- [Advanced Features](./en/advanced-features.md)
- [Testing & Evaluation](./en/testing.md)
- [Best Practices](./en/best-practices.md)
- [Troubleshooting](./en/troubleshooting.md)

### Arabic Documentation (`/ar/`)
- [دليل البداية](./ar/getting-started.md)
- [التنصيب والإعداد](./ar/installation.md)
- [الاستخدام الأساسي](./ar/basic-usage.md)
- [المميزات المتقدمة](./ar/advanced-features.md)
- [الاختبار والتقييم](./ar/testing.md)
- [أفضل الممارسات](./ar/best-practices.md)
- [حل المشاكل](./ar/troubleshooting.md)

## Demo Database

A complete demo database is included for testing:
- [demo_db.sql](./demo_db.sql) - SQLite database with sample data
- 15 customers, 15 products, 20 orders, 15 employees
- Realistic business scenarios for testing

## Test Results

Our testing shows excellent performance:
- **Success Rate**: 100% (10/10 test cases)
- **Average Execution Time**: ~1 second
- **Accuracy**: 100% across all difficulty levels
- **Language Support**: Excellent Arabic language understanding

See detailed test results in [vanna_test_results.json](./vanna_test_results.json)

## Useful Links

- [Official Website](https://vanna.ai/)
- [GitHub Repository](https://github.com/vanna-ai/vanna)
- [Documentation](https://docs.vanna.ai/)
- [Discord Community](https://discord.gg/vanna-ai)

## License

This documentation is licensed under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

<div align="center">

**Made with ❤️ for the developer community**

</div>
