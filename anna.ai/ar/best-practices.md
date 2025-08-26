<div dir="rtl">

# أفضل الممارسات - Vanna AI

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**تعلم أفضل الممارسات والنصائح لاستخدام Vanna AI بكفاءة عالية**

</div>

---

## أفضل الممارسات للتدريب

### 1. تدريب شامل على هيكل قاعدة البيانات

#### تدريب DDL مفصل
```python
# ✅ جيد: تدريب مفصل على كل جدول
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

#### تدريب على العلاقات
```python
vn.train(ddl="""
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
)
""")
```

### 2. توثيق الأعمال الشامل

#### المصطلحات التجارية
```python
vn.train(documentation="العملاء النشطون هم الذين لديهم is_active = 1")
vn.train(documentation="الطلبات المكتملة لها status = 'completed'")
vn.train(documentation="الربح يُحسب كالفرق بين السعر والتكلفة")
```

#### أسماء المدن والمناطق
```python
vn.train(documentation="أسماء المدن مكتوبة بالإنجليزية: Riyadh, Jeddah, Dammam")
vn.train(documentation="المنطقة الشرقية تشمل: Dammam, Khobar, Dhahran")
```

### 3. أمثلة SQL متنوعة

#### استعلامات بسيطة
```python
vn.train(sql="SELECT COUNT(*) FROM customers WHERE is_active = 1")
vn.train(sql="SELECT first_name, last_name FROM customers WHERE city = 'Riyadh'")
```

#### استعلامات مع تجميع
```python
vn.train(sql="SELECT category, COUNT(*) FROM products GROUP BY category")
vn.train(sql="SELECT city, COUNT(*) FROM customers GROUP BY city")
```

#### استعلامات مع ربط جداول
```python
vn.train(sql="SELECT c.first_name, o.order_date FROM customers c JOIN orders o ON c.customer_id = o.customer_id")
```

---

## أفضل الممارسات للاستخدام

### 1. صياغة الأسئلة

#### ✅ أسئلة واضحة ومحددة
- "كم عدد العملاء النشطين في مدينة الرياض؟"
- "ما هو متوسط سعر المنتجات الإلكترونية؟"
- "من هم أفضل 5 عملاء من ناحية المشتريات؟"

#### ❌ أسئلة غامضة
- "أرني العملاء" (غير محدد)
- "كم المبيعات؟" (غير محدد)

### 2. معالجة الأخطاء

```python
def safe_query(question, max_retries=3):
    for attempt in range(max_retries):
        try:
            sql = vn.generate_sql(question)
            result = vn.run_sql(sql)
            return result
        except Exception as e:
            print(f"فشل في المحاولة {attempt + 1}: {e}")
            if attempt < max_retries - 1:
                time.sleep(2)
    return None
```

### 3. تحسين الأداء

#### التخزين المؤقت
```python
vn.enable_cache(True)
vn.set_cache_ttl(hours=24)
```

---

## أفضل الممارسات للأمان

### 1. حماية البيانات

#### عدم إرسال البيانات الحساسة
```python
# ✅ جيد: تدريب على الهيكل فقط
vn.train(ddl="CREATE TABLE customers (id, name, email)")

# ❌ سيء: تدريب على بيانات حقيقية
vn.train(sql="SELECT * FROM customers WHERE phone = '+966501234567'")
```

### 2. التحقق من الاستعلامات

```python
def validate_sql(sql):
    forbidden_keywords = ['DROP', 'DELETE', 'UPDATE', 'INSERT', 'ALTER', 'CREATE']
    
    sql_upper = sql.upper()
    for keyword in forbidden_keywords:
        if keyword in sql_upper:
            raise ValueError(f"الكلمة المحظورة '{keyword}' موجودة")
    
    if not sql_upper.strip().startswith('SELECT'):
        raise ValueError("يجب أن يبدأ الاستعلام بـ SELECT")
    
    return True
```

---

## الخلاصة

### النقاط الرئيسية
1. **تدريب شامل**: غطِ جميع جوانب قاعدة البيانات
2. **توثيق مفصل**: اشرح المصطلحات والقواعد التجارية
3. **أمثلة متنوعة**: قدم أمثلة لجميع أنواع الاستعلامات
4. **معالجة الأخطاء**: تعامل مع الأخطاء بشكل احترافي
5. **الأمان أولاً**: احمِ البيانات الحساسة

### التوصيات
- ابدأ بالتدريب الأساسي ثم تدرج نحو التعقيد
- اختبر النموذج على أسئلة متنوعة
- استخدم التخزين المؤقت لتحسين الأداء
- التزم بأفضل ممارسات الأمان

---

<div align="center">

**استخدم Vanna AI بأفضل الطرق! 🚀**

</div>

</div>
