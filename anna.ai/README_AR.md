<div dir="rtl">

# Vanna AI - أداة تحويل النصوص إلى استعلامات SQL

<div align="center">

![Vanna AI Logo](https://vanna.ai/img/vanna-logo.png)

**أداة ذكية مفتوحة المصدر لتحويل الأسئلة الطبيعية إلى استعلامات SQL دقيقة**

[![GitHub Stars](https://img.shields.io/github/stars/vanna-ai/vanna?style=for-the-badge)](https://github.com/vanna-ai/vanna)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.11+-green.svg?style=for-the-badge)](https://python.org)

</div>

---

## ما هو Vanna AI؟

Vanna AI هو مكتبة Python مفتوحة المصدر تحول الأسئلة الطبيعية إلى استعلامات SQL دقيقة باستخدام تقنية RAG (Retrieval-Augmented Generation). تم تصميمها لمساعدة المستخدمين غير التقنيين على الوصول إلى بيانات قواعد البيانات بسهولة دون الحاجة لمعرفة عميقة بـ SQL.

### لماذا Vanna AI؟

- 🌍 **دعم متعدد اللغات** - دعم ممتاز للغة العربية
- 🗄️ **دعم قواعد بيانات متعددة** - يعمل مع Snowflake و BigQuery و PostgreSQL والمزيد
- 🔒 **الأمان أولاً** - محتويات قاعدة البيانات لا تُرسل للـ LLM إلا إذا تم تمكينها خصيصاً
- 📈 **تعلم ذاتي** - يتحسن باستمرار مع الاستخدام
- 🎯 **دقة عالية** - يحقق معدلات دقة عالية على مجموعات البيانات المعقدة

## البداية السريعة

### التثبيت

```bash
pip install vanna
```

### الاستخدام الأساسي

```python
import vanna as vn

# تهيئة Vanna
vn = vn.VannaDefault()

# اطرح أسئلة باللغة الطبيعية
sql = vn.generate_sql("كم عدد العملاء المسجلين في النظام؟")
print(sql)
```

## التوثيق

يحتوي هذا المستودع على توثيق شامل بلغات متعددة:

- **[التوثيق باللغة الإنجليزية](./en/)** - دليل شامل باللغة الإنجليزية
- **[التوثيق باللغة العربية](./ar/)** - دليل شامل باللغة العربية

## ما بداخل المستودع

### التوثيق باللغة الإنجليزية (`/en/`)
- [دليل البداية](./en/getting-started.md)
- [التنصيب والإعداد](./en/installation.md)
- [أمثلة الاستخدام الأساسي](./en/basic-usage.md)
- [المميزات المتقدمة](./en/advanced-features.md)
- [الاختبار والتقييم](./en/testing.md)
- [أفضل الممارسات](./en/best-practices.md)
- [حل المشاكل](./en/troubleshooting.md)

### التوثيق باللغة العربية (`/ar/`)
- [دليل البداية](./ar/getting-started.md)
- [التنصيب والإعداد](./ar/installation.md)
- [الاستخدام الأساسي](./ar/basic-usage.md)
- [المميزات المتقدمة](./ar/advanced-features.md)
- [الاختبار والتقييم](./ar/testing.md)
- [أفضل الممارسات](./ar/best-practices.md)
- [حل المشاكل](./ar/troubleshooting.md)

## قاعدة البيانات التجريبية

يتم تضمين قاعدة بيانات تجريبية كاملة للاختبار:
- [demo_db.sql](./demo_db.sql) - قاعدة بيانات SQLite مع بيانات تجريبية
- 15 عميل، 15 منتج، 20 طلب، 15 موظف
- سيناريوهات تجارية واقعية للاختبار

## نتائج الاختبار

تظهر اختباراتنا أداءً ممتازاً:
- **معدل النجاح**: 100% (10/10 حالات اختبار)
- **متوسط وقت التنفيذ**: ~1 ثانية
- **الدقة**: 100% عبر جميع مستويات الصعوبة
- **دعم اللغة**: فهم ممتاز للغة العربية

انظر نتائج الاختبار التفصيلية في [vanna_test_results.json](./vanna_test_results.json)

## روابط مفيدة

- [الموقع الرسمي](https://vanna.ai/)
- [مستودع GitHub](https://github.com/vanna-ai/vanna)
- [التوثيق](https://docs.vanna.ai/)
- [مجتمع Discord](https://discord.gg/vanna-ai)

## الترخيص

هذا التوثيق مرخص تحت رخصة MIT.

## المساهمة

المساهمات مرحب بها! يرجى تقديم طلب Pull Request.

---

<div align="center">

** بـ ❤️ لمجتمع المطورين**

</div>

</div>

