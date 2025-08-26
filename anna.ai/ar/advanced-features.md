<div dir="rtl">

# المميزات المتقدمة - Vanna AI

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**استكشف المميزات المتقدمة والقدرات المتطورة لـ Vanna AI**

</div>

---

## دعم قواعد البيانات المتقدمة

### قواعد البيانات السحابية

#### Snowflake
```python
vn.connect_to_snowflake(
    account='your-account',
    user='your-username',
    password='your-password',
    warehouse='your-warehouse',
    database='your-database',
    schema='your-schema'
)
```

#### BigQuery
```python
vn.connect_to_bigquery(
    project_id='your-project-id',
    dataset_id='your-dataset-id',
    credentials_path='path/to/service-account.json'
)
```

#### Azure SQL Database
```python
vn.connect_to_azure_sql(
    server='your-server.database.windows.net',
    database='your-database',
    username='your-username',
    password='your-password'
)
```

### قواعد البيانات المحلية المتقدمة

#### DuckDB
```python
vn.connect_to_duckdb('path/to/database.db')
```

#### ClickHouse
```python
vn.connect_to_clickhouse(
    host='localhost',
    port=9000,
    database='default',
    user='default',
    password=''
)
```

---

## نماذج الذكاء الاصطناعي المتقدمة

### نماذج OpenAI المتطورة

#### GPT-4 Turbo
```python
vn = MyVanna(config={
    'api_key': os.getenv('OPENAI_API_KEY'),
    'model': 'gpt-4-1106-preview',  # GPT-4 Turbo
    'temperature': 0.1,
    'max_tokens': 4000
})
```

#### GPT-4 Vision (للرسوم البيانية)
```python
# دعم تحليل الرسوم البيانية والجداول
vn.train(documentation="هذا الجدول يوضح مبيعات المنتجات حسب المنطقة")
vn.train(documentation="الرسم البياني يعرض اتجاه المبيعات الشهرية")
```

### نماذج Anthropic Claude

#### Claude 3 Sonnet
```python
from vanna.anthropic.anthropic_chat import Anthropic_Chat

class MyVanna(ChromaDB_VectorStore, Anthropic_Chat):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Anthropic_Chat.__init__(self, config=config)

vn = MyVanna(config={
    'api_key': os.getenv('ANTHROPIC_API_KEY'),
    'model': 'claude-3-sonnet-20240229'
})
```

#### Claude 3 Haiku (للأداء السريع)
```python
vn = MyVanna(config={
    'api_key': os.getenv('ANTHROPIC_API_KEY'),
    'model': 'claude-3-haiku-20240307',
    'max_tokens': 2000
})
```

### نماذج Google Gemini

#### Gemini Pro
```python
from vanna.google.gemini_chat import Gemini_Chat

class MyVanna(ChromaDB_VectorStore, Gemini_Chat):
    def __init__(self, config=None):
        ChromaDB_VectorStore.__init__(self, config=config)
        Gemini_Chat.__init__(self, config=config)

vn = MyVanna(config={
    'api_key': os.getenv('GOOGLE_API_KEY'),
    'model': 'gemini-pro'
})
```

---

## قواعد البيانات الشعاعية المتقدمة

### Pinecone (سحابي)
```python
from vanna.pinecone.pinecone_vector import Pinecone_VectorStore

class MyVanna(Pinecone_VectorStore, OpenAI_Chat):
    def __init__(self, config=None):
        Pinecone_VectorStore.__init__(self, config=config)
        OpenAI_Chat.__init__(self, config=config)

vn = MyVanna(config={
    'api_key': os.getenv('OPENAI_API_KEY'),
    'pinecone_api_key': os.getenv('PINECONE_API_KEY'),
    'pinecone_environment': 'us-west1-gcp',
    'pinecone_index': 'vanna-vectors'
})
```

### Weaviate (مفتوح المصدر)
```python
from vanna.weaviate.weaviate_vector import Weaviate_VectorStore

class MyVanna(Weaviate_VectorStore, OpenAI_Chat):
    def __init__(self, config=None):
        Weaviate_VectorStore.__init__(self, config=config)
        OpenAI_Chat.__init__(self, config=config)

vn = MyVanna(config={
    'api_key': os.getenv('OPENAI_API_KEY'),
    'weaviate_url': 'http://localhost:8080',
    'weaviate_class_name': 'VannaDocument'
})
```

### Qdrant (مفتوح المصدر)
```python
from vanna.qdrant.qdrant_vector import Qdrant_VectorStore

class MyVanna(Qdrant_VectorStore, OpenAI_Chat):
    def __init__(self, config=None):
        Qdrant_VectorStore.__init__(self, config=config)
        OpenAI_Chat.__init__(self, config=config)

vn = MyVanna(config={
    'api_key': os.getenv('OPENAI_API_KEY'),
    'qdrant_url': 'http://localhost:6333',
    'qdrant_collection': 'vanna_docs'
})
```

---

## واجهات المستخدم المتقدمة

### Streamlit (واجهة ويب تفاعلية)
```python
import streamlit as st
import pandas as pd

def create_streamlit_app():
    st.title("Vanna AI - محول الأسئلة العربية إلى SQL")
    
    # إدخال السؤال
    question = st.text_input("اكتب سؤالك باللغة العربية:", 
                            placeholder="مثال: كم عدد العملاء النشطين؟")
    
    if st.button("تحويل إلى SQL"):
        if question:
            with st.spinner("جاري معالجة السؤال..."):
                try:
                    # توليد SQL
                    sql = vn.generate_sql(question)
                    st.code(sql, language="sql")
                    
                    # تنفيذ الاستعلام
                    result = vn.run_sql(sql)
                    st.dataframe(result)
                    
                except Exception as e:
                    st.error(f"حدث خطأ: {e}")
        else:
            st.warning("يرجى إدخال سؤال")

if __name__ == "__main__":
    create_streamlit_app()
```

### Flask (تطبيق ويب مخصص)
```python
from flask import Flask, request, jsonify, render_template
import json

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/query', methods=['POST'])
def process_query():
    data = request.get_json()
    question = data.get('question', '')
    
    try:
        # توليد SQL
        sql = vn.generate_sql(question)
        
        # تنفيذ الاستعلام
        result = vn.run_sql(sql)
        
        return jsonify({
            'success': True,
            'sql': sql,
            'result': result.to_dict('records') if hasattr(result, 'to_dict') else str(result)
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

if __name__ == '__main__':
    app.run(debug=True)
```

### Slack Bot (تكامل مع فرق العمل)
```python
from slack_bolt import App
from slack_bolt.adapter.socket_mode import SocketModeHandler

app = App(token=os.environ["SLACK_BOT_TOKEN"])

@app.message("!sql")
def handle_sql_query(message, say):
    # استخراج السؤال من الرسالة
    question = message['text'].replace('!sql', '').strip()
    
    if question:
        try:
            # توليد SQL
            sql = vn.generate_sql(question)
            
            # تنفيذ الاستعلام
            result = vn.run_sql(sql)
            
            # إرسال النتيجة
            say(f"*السؤال:* {question}\n*SQL:* ```{sql}```\n*النتيجة:* {str(result)}")
            
        except Exception as e:
            say(f"حدث خطأ: {e}")
    else:
        say("يرجى كتابة سؤال بعد !sql")

if __name__ == "__main__":
    handler = SocketModeHandler(app, os.environ["SLACK_APP_TOKEN"])
    handler.start()
```

---

## المميزات المتقدمة للتدريب

### التدريب على أنواع بيانات معقدة

#### JSON Fields
```python
vn.train(ddl="""
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    specifications JSON,
    tags TEXT[]
)
""")

vn.train(documentation="حقل specifications يحتوي على مواصفات المنتج بتنسيق JSON")
vn.train(documentation="حقل tags يحتوي على قائمة من العلامات")
```

#### Arrays and Complex Types
```python
vn.train(ddl="""
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    items INTEGER[],
    shipping_address JSONB,
    created_at TIMESTAMP
)
""")
```

### التدريب على العلاقات المعقدة

#### Self-Referencing Tables
```python
vn.train(ddl="""
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    manager_id INTEGER REFERENCES employees(employee_id)
)
""")

vn.train(documentation="كل موظف يمكن أن يكون له مدير، والمدراء ليس لهم مدراء")
```

#### Many-to-Many Relationships
```python
vn.train(ddl="""
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE product_categories (
    product_id INTEGER REFERENCES products(product_id),
    category_id INTEGER REFERENCES categories(category_id),
    PRIMARY KEY (product_id, category_id)
);
""")
```

---

## تحسين الأداء

### التخزين المؤقت الذكي
```python
# تفعيل التخزين المؤقت
vn.enable_cache(True)

# تعيين مدة التخزين المؤقت
vn.set_cache_ttl(hours=24)

# مسح التخزين المؤقت
vn.clear_cache()
```

### معالجة متوازية
```python
import concurrent.futures

def process_multiple_questions(questions):
    """معالجة عدة أسئلة في نفس الوقت"""
    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        futures = {executor.submit(vn.generate_sql, q): q for q in questions}
        
        results = {}
        for future in concurrent.futures.as_completed(futures):
            question = futures[future]
            try:
                sql = future.result()
                results[question] = sql
            except Exception as e:
                results[question] = f"خطأ: {e}"
    
    return results

# استخدام
questions = [
    "كم عدد العملاء؟",
    "ما هو متوسط سعر المنتجات؟",
    "من هم أفضل العملاء؟"
]

results = process_multiple_questions(questions)
```

---

## المراقبة والتتبع

### تسجيل الاستعلامات
```python
import logging
from datetime import datetime

# إعداد التسجيل
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class MonitoredVanna(MyVanna):
    def generate_sql(self, question):
        start_time = datetime.now()
        
        try:
            sql = super().generate_sql(question)
            
            # تسجيل النجاح
            execution_time = (datetime.now() - start_time).total_seconds()
            logger.info(f"نجح: {question} -> {sql} (الوقت: {execution_time:.2f}s)")
            
            return sql
            
        except Exception as e:
            # تسجيل الخطأ
            execution_time = (datetime.now() - start_time).total_seconds()
            logger.error(f"فشل: {question} -> خطأ: {e} (الوقت: {execution_time:.2f}s)")
            raise

# استخدام النسخة المراقبة
vn = MonitoredVanna(config={...})
```

### مقاييس الأداء
```python
class PerformanceMetrics:
    def __init__(self):
        self.total_queries = 0
        self.successful_queries = 0
        self.failed_queries = 0
        self.total_time = 0
        self.query_times = []
    
    def record_query(self, question, sql, success, execution_time):
        self.total_queries += 1
        self.total_time += execution_time
        self.query_times.append(execution_time)
        
        if success:
            self.successful_queries += 1
        else:
            self.failed_queries += 1
    
    def get_stats(self):
        return {
            'total_queries': self.total_queries,
            'success_rate': self.successful_queries / self.total_queries * 100,
            'average_time': self.total_time / self.total_queries,
            'min_time': min(self.query_times),
            'max_time': max(self.query_times)
        }

# استخدام
metrics = PerformanceMetrics()
```

---

## الخطوات التالية

بعد استكشاف المميزات المتقدمة، يمكنك الانتقال إلى:

1. **[أفضل الممارسات](./best-practices.md)** - تعلم أفضل الطرق للاستخدام
2. **[الاختبار والتقييم](./testing.md)** - شاهد نتائج الاختبارات
3. **[الاستخدام الأساسي](./basic-usage.md)** - راجع الأساسيات

---

<div align="center">

**اكتشف إمكانيات Vanna AI المتقدمة! ��**

</div>

</div>
