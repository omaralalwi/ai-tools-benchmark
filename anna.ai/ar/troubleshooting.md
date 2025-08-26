<div dir="rtl">

# حل المشاكل - Vanna AI

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**دليل شامل لحل المشاكل الشائعة في Vanna AI**

</div>

---

## مشاكل التنصيب

### 1. خطأ في تثبيت Python

#### المشكلة
```bash
ERROR: Could not find a version that satisfies the requirement vanna
```

#### الحل
```bash
# تحديث pip
python -m pip install --upgrade pip

# التأكد من إصدار Python
python --version  # يجب أن يكون 3.11+

# تثبيت Vanna
pip install vanna
```

### 2. خطأ في تثبيت ChromaDB

#### المشكلة
```bash
ERROR: Failed building wheel for hnswlib
```

#### الحل
```bash
# تثبيت أدوات البناء
sudo apt-get install build-essential python3-dev

# تثبيت ChromaDB منفصلاً
pip install chromadb

# ثم تثبيت Vanna
pip install vanna
```

---

## مشاكل الاتصال بقاعدة البيانات

### 1. خطأ في الاتصال بـ SQLite

#### المشكلة
```python
sqlite3.OperationalError: no such table
```

#### الحل
```python
import sqlite3

# إنشاء قاعدة البيانات
conn = sqlite3.connect('database.db')
cursor = conn.cursor()

# إنشاء الجداول
cursor.execute('''
CREATE TABLE IF NOT EXISTS customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT
)
''')

conn.commit()
conn.close()

# الاتصال بـ Vanna
vn.connect_to_sqlite('database.db')
```

### 2. خطأ في الاتصال بـ PostgreSQL

#### المشكلة
```python
psycopg2.OperationalError: could not connect to server
```

#### الحل
```python
# التأكد من تشغيل PostgreSQL
sudo systemctl status postgresql

# إنشاء قاعدة البيانات
sudo -u postgres createdb mydatabase

# إنشاء مستخدم
sudo -u postgres createuser myuser

# منح الصلاحيات
sudo -u postgres psql
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;
\q

# الاتصال بـ Vanna
vn.connect_to_postgres(
    host='localhost',
    dbname='mydatabase',
    user='myuser',
    password='mypassword'
)
```

---

## مشاكل النماذج

### 1. خطأ في مفتاح OpenAI API

#### المشكلة
```python
openai.AuthenticationError: Incorrect API key provided
```

#### الحل
```python
import os
from dotenv import load_dotenv

# تحميل متغيرات البيئة
load_dotenv()

# التأكد من المفتاح
api_key = os.getenv('OPENAI_API_KEY')
if not api_key:
    raise ValueError("OPENAI_API_KEY غير موجود")

# إعداد Vanna
vn = MyVanna(config={
    'api_key': api_key,
    'model': 'gpt-4'
})
```

### 2. خطأ في حد الاستخدام

#### المشكلة
```python
openai.RateLimitError: Rate limit exceeded
```

#### الحل
```python
import time

def generate_sql_with_retry(question, max_retries=3):
    for attempt in range(max_retries):
        try:
            return vn.generate_sql(question)
        except Exception as e:
            if "Rate limit" in str(e) and attempt < max_retries - 1:
                wait_time = (2 ** attempt) * 60  # انتظار تصاعدي
                print(f"انتظار {wait_time} ثانية...")
                time.sleep(wait_time)
            else:
                raise e
    
    return None
```

---

## مشاكل التدريب

### 1. خطأ في تدريب DDL

#### المشكلة
```python
ValueError: Invalid DDL format
```

#### الحل
```python
# التأكد من صحة DDL
ddl = """
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
)
"""

# تدريب النموذج
try:
    vn.train(ddl=ddl)
    print("تم التدريب بنجاح")
except Exception as e:
    print(f"خطأ في التدريب: {e}")
```

### 2. خطأ في تدريب التوثيق

#### المشكلة
```python
ValueError: Documentation cannot be empty
```

#### الحل
```python
# التأكد من أن التوثيق غير فارغ
documentation = "العملاء النشطون هم الذين لديهم is_active = 1"

if documentation and documentation.strip():
    vn.train(documentation=documentation)
else:
    print("التوثيق فارغ")
```

---

## مشاكل توليد SQL

### 1. SQL غير صحيح

#### المشكلة
```python
sqlite3.OperationalError: near "FROM": syntax error
```

#### الحل
```python
def validate_and_fix_sql(question):
    try:
        # توليد SQL
        sql = vn.generate_sql(question)
        print(f"SQL المولد: {sql}")
        
        # اختبار SQL
        test_result = vn.run_sql(f"EXPLAIN {sql}")
        print("SQL صحيح")
        
        return sql
        
    except Exception as e:
        print(f"خطأ في SQL: {e}")
        
        # إعادة صياغة السؤال
        reformulated_question = f"أرني {question} باستعلام SQL بسيط"
        print(f"إعادة صياغة: {reformulated_question}")
        
        try:
            sql = vn.generate_sql(reformatted_question)
            return sql
        except Exception as e2:
            print(f"فشل في إعادة الصياغة: {e2}")
            return None
```

### 2. SQL بطيء جداً

#### المشكلة
```python
# استعلام يستغرق وقتاً طويلاً
```

#### الحل
```python
import time

def optimize_query(question):
    start_time = time.time()
    
    # توليد SQL
    sql = vn.generate_sql(question)
    
    # إضافة LIMIT إذا لم يكن موجوداً
    if "LIMIT" not in sql.upper():
        sql += " LIMIT 1000"
    
    # تنفيذ الاستعلام
    result = vn.run_sql(sql)
    
    execution_time = time.time() - start_time
    print(f"وقت التنفيذ: {execution_time:.2f} ثانية")
    
    return result
```

---

## مشاكل الأداء

### 1. بطء في الاستجابة

#### المشكلة
```python
# استعلامات بطيئة
```

#### الحل
```python
# تفعيل التخزين المؤقت
vn.enable_cache(True)
vn.set_cache_ttl(hours=24)

# تحسين النموذج
vn.train(documentation="استخدم INDEX للبحث السريع")
vn.train(documentation="استخدم LIMIT لتقليل النتائج")
```

### 2. استهلاك ذاكرة عالي

#### المشكلة
```python
# استهلاك ذاكرة كبير
```

#### الحل
```python
import gc

def cleanup_memory():
    # تنظيف الذاكرة
    gc.collect()
    
    # مسح التخزين المؤقت
    vn.clear_cache()
    
    print("تم تنظيف الذاكرة")

# تنظيف دوري
cleanup_memory()
```

---

## مشاكل اللغة العربية

### 1. عدم فهم الأسئلة العربية

#### المشكلة
```python
# عدم فهم الأسئلة العربية
```

#### الحل
```python
# تدريب إضافي على اللغة العربية
vn.train(documentation="اللغة العربية مدعومة بالكامل")
vn.train(documentation="يمكنك طرح الأسئلة باللغة العربية")

# أمثلة عربية
vn.train(sql="SELECT COUNT(*) FROM customers WHERE city = 'الرياض'")
vn.train(sql="SELECT * FROM products WHERE category = 'إلكترونيات'")
```

### 2. مشاكل في الترميز

#### المشكلة
```python
UnicodeDecodeError: 'utf-8' codec can't decode
```

#### الحل
```python
# التأكد من الترميز
import sys
sys.stdout.reconfigure(encoding='utf-8')

# حفظ الملفات بترميز UTF-8
with open('output.txt', 'w', encoding='utf-8') as f:
    f.write("نص عربي")
```

---

## مشاكل التكامل

### 1. خطأ في Streamlit

#### المشكلة
```python
streamlit.errors.StreamlitAPIException
```

#### الحل
```python
import streamlit as st

# إعداد Streamlit
st.set_page_config(
    page_title="Vanna AI",
    page_icon="🤖",
    layout="wide"
)

# معالجة الأخطاء
try:
    result = vn.generate_sql(question)
    st.success("تم توليد SQL بنجاح")
except Exception as e:
    st.error(f"حدث خطأ: {e}")
```

### 2. خطأ في Flask

#### المشكلة
```python
werkzeug.exceptions.BadRequest
```

#### الحل
```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/api/query', methods=['POST'])
def process_query():
    try:
        data = request.get_json()
        question = data.get('question', '')
        
        if not question:
            return jsonify({'error': 'السؤال مطلوب'}), 400
        
        sql = vn.generate_sql(question)
        result = vn.run_sql(sql)
        
        return jsonify({
            'sql': sql,
            'result': str(result)
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
```

---

## نصائح عامة

### 1. تسجيل الأخطاء
```python
import logging

# إعداد التسجيل
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    filename='vanna_errors.log'
)

# تسجيل الأخطاء
try:
    result = vn.generate_sql(question)
except Exception as e:
    logging.error(f"خطأ في توليد SQL: {e}")
    raise
```

### 2. اختبار دوري
```python
def test_vanna_health():
    """اختبار صحة Vanna"""
    test_questions = [
        "كم عدد العملاء؟",
        "ما هو متوسط السعر؟"
    ]
    
    for question in test_questions:
        try:
            sql = vn.generate_sql(question)
            print(f"✅ {question}: {sql}")
        except Exception as e:
            print(f"❌ {question}: {e}")

# تشغيل الاختبار
test_vanna_health()
```

---

## الحصول على المساعدة

### 1. الوثائق الرسمية
- [Vanna AI Documentation](https://docs.vanna.ai/)
- [GitHub Repository](https://github.com/vanna-ai/vanna)

### 2. المجتمع
- [Discord Community](https://discord.gg/vanna-ai)
- [GitHub Issues](https://github.com/vanna-ai/vanna/issues)

### 3. التقارير
```python
# إنشاء تقرير خطأ
error_report = {
    'error': str(e),
    'question': question,
    'vanna_version': vanna.__version__,
    'python_version': sys.version,
    'timestamp': datetime.now().isoformat()
}

print("تقرير الخطأ:", error_report)
```

---

<div align="center">

**حل مشاكلك مع Vanna AI! ��**

</div>

</div>
