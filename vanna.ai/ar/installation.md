<div dir="rtl">

# التنصيب والإعداد - Vanna AI

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**دليل شامل لتنصيب وإعداد Vanna AI على جميع أنظمة التشغيل**

</div>

---

## متطلبات النظام

### متطلبات أساسية

<div align="center">

| المتطلب | الحد الأدنى | المُوصى به |
|---------|------------|-------------|
| **Python** | 3.11+ | 3.11+ |
| **نظام التشغيل** | Windows 10, macOS 10.15, Ubuntu 20.04 | أحدث الإصدارات |
| **الذاكرة (RAM)** | 4 GB | 8 GB |
| **مساحة القرص** | 2 GB | 5 GB |
| **الإنترنت** | مطلوب للنماذج السحابية | سرعة عالية |

</div>

### متطلبات اختيارية
- **GPU**: لتسريع النماذج المحلية (CUDA compatible)
- **Docker**: لنشر التطبيقات
- **Git**: لتحميل أحدث الإصدارات

---

## التنصيب على Windows

### الطريقة الأولى: باستخدام pip (الأسهل)

```bash
# تحديث pip
python -m pip install --upgrade pip

# تنصيب Vanna الأساسي
pip install vanna

# تنصيب مع الإضافات المطلوبة
pip install 'vanna[openai,chromadb]'
```

### الطريقة الثانية: باستخدام conda

```bash
# إنشاء بيئة جديدة
conda create -n vanna python=3.11
conda activate vanna

# تنصيب Vanna
pip install 'vanna[openai,chromadb]'
```

### الطريقة الثالثة: من المصدر

```bash
# تحميل المشروع
git clone https://github.com/vanna-ai/vanna.git
cd vanna

# تنصيب في وضع التطوير
pip install -e .
```

---

## التنصيب على Linux (Ubuntu/Debian)

### تحديث النظام أولاً

```bash
sudo apt update
sudo apt upgrade -y
```

### تنصيب Python والأدوات المطلوبة

```bash
# تنصيب Python 3.11
sudo apt install python3.11 python3.11-pip python3.11-venv -y

# إنشاء بيئة افتراضية
python3.11 -m venv vanna_env
source vanna_env/bin/activate

# تحديث pip
pip install --upgrade pip
```

### تنصيب Vanna

```bash
# التنصيب الأساسي
pip install vanna

# التنصيب مع الإضافات
pip install 'vanna[openai,chromadb,postgres,mysql]'
```

---

## التنصيب على macOS

### باستخدام Homebrew

```bash
# تنصيب Python إذا لم يكن موجوداً
brew install python@3.11

# إنشاء بيئة افتراضية
python3.11 -m venv vanna_env
source vanna_env/bin/activate

# تنصيب Vanna
pip install 'vanna[openai,chromadb]'
```

---

## التحقق من التنصيب

### إنشاء ملف اختبار

إنشاء ملف `test_installation.py`:

```python
#!/usr/bin/env python3
"""
اختبار تنصيب Vanna AI
"""

import sys
import os

def test_vanna_installation():
    """اختبار تنصيب Vanna وجميع المكونات المطلوبة"""
    
    print("🔍 اختبار تنصيب Vanna AI...")
    print("=" * 50)
    
    # اختبار استيراد Vanna الأساسي
    try:
        import vanna
        try:
            version = vanna.__version__
        except AttributeError:
            import pkg_resources
            version = pkg_resources.get_distribution("vanna").version
        print(f"✅ Vanna الأساسي: الإصدار {version}")
    except ImportError as e:
        print(f"❌ فشل في استيراد Vanna الأساسي: {e}")
        return False
    except Exception as e:
        print(f"✅ Vanna الأساسي: متاح (لا يمكن تحديد الإصدار: {e})")
        pass
    
    # اختبار استيراد OpenAI
    try:
        from vanna.openai.openai_chat import OpenAI_Chat
        print("✅ OpenAI Chat: متاح")
    except ImportError as e:
        print(f"❌ فشل في استيراد OpenAI Chat: {e}")
        return False
    
    # اختبار استيراد ChromaDB
    try:
        from vanna.chromadb.chromadb_vector import ChromaDB_VectorStore
        print("✅ ChromaDB Vector Store: متاح")
    except ImportError as e:
        print(f"❌ فشل في استيراد ChromaDB Vector Store: {e}")
        return False
    
    # اختبار إنشاء فئة Vanna مخصصة
    try:
        class TestVanna(ChromaDB_VectorStore, OpenAI_Chat):
            def __init__(self, config=None):
                ChromaDB_VectorStore.__init__(self, config=config)
                OpenAI_Chat.__init__(self, config=config)
        
        print("✅ إنشاء فئة Vanna مخصصة: نجح")
    except Exception as e:
        print(f"❌ فشل في إنشاء فئة Vanna مخصصة: {e}")
        return False
    
    # اختبار متغيرات البيئة
    openai_key = os.getenv('OPENAI_API_KEY')
    if openai_key:
        print(f"✅ OPENAI_API_KEY: متاح (يبدأ بـ {openai_key[:10]}...)")
    else:
        print("⚠️  OPENAI_API_KEY: غير متاح (سيتم استخدام مفتاح تجريبي)")
    
    print("=" * 50)
    print("🎉 تم اختبار التنصيب بنجاح!")
    return True

if __name__ == "__main__":
    success = test_vanna_installation()
    sys.exit(0 if success else 1)
```

### تشغيل الاختبار

```bash
python test_installation.py
```

---

## إعداد متغيرات البيئة

### إنشاء ملف .env

```bash
# مفتاح OpenAI API
OPENAI_API_KEY=sk-your-api-key-here

# مفتاح Anthropic (اختياري)
ANTHROPIC_API_KEY=your-anthropic-key

# إعدادات قاعدة البيانات
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
```

### تحميل متغيرات البيئة في Python

```python
import os
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv('OPENAI_API_KEY')
```

---

## إعداد قاعدة البيانات

### قاعدة بيانات SQLite (للاختبار)

```python
import sqlite3

# إنشاء قاعدة بيانات تجريبية
conn = sqlite3.connect('demo.db')
cursor = conn.cursor()

# إنشاء جدول تجريبي
cursor.execute('''
    CREATE TABLE IF NOT EXISTS customers (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE,
        city TEXT
    )
''')

conn.commit()
conn.close()
```

### قاعدة بيانات PostgreSQL

```python
import psycopg2
from psycopg2 import sql

# الاتصال بقاعدة البيانات
conn = psycopg2.connect(
    host="localhost",
    database="your_database",
    user="your_username",
    password="your_password"
)
```

---

## الخطوات التالية

بعد التنصيب الناجح، يمكنك الانتقال إلى:

1. **[الاستخدام الأساسي](./basic-usage.md)** - تعلم كيفية استخدام Vanna AI
2. **[أمثلة عملية](./testing.md)** - شاهد أمثلة حقيقية للاستخدام
3. **[المميزات المتقدمة](./advanced-features.md)** - استكشف المميزات المتقدمة

---

<div align="center">

**تم التنصيب بنجاح! ��**

</div>

</div>
