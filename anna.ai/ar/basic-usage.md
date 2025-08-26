<div dir="rtl">

# الاستخدام الأساسي - Vanna AI

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**تعلم كيفية استخدام Vanna AI لتحويل الأسئلة العربية إلى استعلامات SQL**

</div>

---

## إعداد Vanna الأساسي

### إنشاء فئة Vanna مخصصة

```python
import os
from vanna.openai.openai_chat import OpenAI_Chat
from vanna.chromadb.chromadb_vector import ChromaDB_VectorStore

# إنشاء فئة Vanna مخصصة
class MyVanna(ChromaDB_VectorStore, OpenAI_Chat):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        OpenAI_Chat.__init__(self, config=config)

# إعداد النموذج
vn = MyVanna(config={
    'api_key': os.getenv('OPENAI_API_KEY'),
    'model': 'gpt-4.1-mini',
    'path': './chroma_db'
})
```

---

## تدريب النموذج

### 1. تدريب على هيكل قاعدة البيانات (DDL)

```python
vn.train(ddl="""
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    city TEXT,
    is_active BOOLEAN DEFAULT 1
)
""")
```

### 2. تدريب على توثيق الأعمال

```python
vn.train(documentation="العملاء النشطون هم الذين لديهم is_active = 1")
vn.train(documentation="الربح يُحسب كالفرق بين السعر والتكلفة")
```

### 3. تدريب على أمثلة SQL

```python
vn.train(sql="SELECT COUNT(*) FROM customers WHERE is_active = 1")
vn.train(sql="SELECT category, AVG(price) FROM products GROUP BY category")
```

---

## الاتصال بقاعدة البيانات

### SQLite
```python
vn.connect_to_sqlite('database.db')
```

### PostgreSQL
```python
vn.connect_to_postgres(
    host='localhost',
    dbname='mydb',
    user='username',
    password='password'
)
```

---

## طرح الأسئلة والحصول على النتائج

### الطريقة الأساسية
```python
# طرح سؤال باللغة العربية
question = "كم عدد العملاء النشطين؟"
sql = vn.generate_sql(question)
print(f"SQL المولد: {sql}")

# تشغيل الاستعلام
result = vn.run_sql(sql)
print(f"النتيجة: {result}")
```

### الطريقة المتقدمة مع معالجة الأخطاء
```python
def ask_question(question):
    try:
        print(f"السؤال: {question}")
        sql = vn.generate_sql(question)
        print(f"SQL: {sql}")
        result = vn.run_sql(sql)
        return result
    except Exception as e:
        print(f"خطأ: {e}")
        return None

result = ask_question("من هم أفضل 5 عملاء من ناحية المشتريات؟")
```

---

## أمثلة عملية

### المثال 1: استعلام بسيط
**السؤال**: "كم عدد العملاء المسجلين في النظام؟"  
**SQL المولد**: `SELECT COUNT(*) as total_customers FROM customers`

### المثال 2: استعلام مع شرط
**السؤال**: "من هم العملاء النشطون في مدينة الرياض؟"  
**SQL المولد**: `SELECT first_name, last_name, email FROM customers WHERE is_active = 1 AND city = 'Riyadh'`

### المثال 3: استعلام مع تجميع
**السؤال**: "ما هو متوسط سعر المنتجات في كل فئة؟"  
**SQL المولد**: `SELECT category, AVG(price) as avg_price FROM products GROUP BY category`

---

## الخطوات التالية

بعد تعلم الاستخدام الأساسي، يمكنك الانتقال إلى:

1. **[أمثلة عملية](./testing.md)** - شاهد أمثلة حقيقية للاستخدام
2. **[المميزات المتقدمة](./advanced-features.md)** - استكشف المميزات المتقدمة
3. **[أفضل الممارسات](./best-practices.md)** - تعلم أفضل الطرق للاستخدام

---

<div align="center">

**ابدأ باستخدام Vanna AI اليوم! 🚀**

</div>

</div>
