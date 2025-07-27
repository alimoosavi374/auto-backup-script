
# پروژه آزمایشگاه سیستم‌های عامل

## ✅ مشخصات کلی
- **نام پروژه**: اسکریپت پشتیبان‌گیری خودکار
- **نام دانشجو**: سیدعلی موسوی
- **استاد راهنما**: علی سامانی‌پور
- **تاریخ تحویل**: ۲۰ تیر ۱۴۰۴

---

## 📚 فهرست محتوا
- سورس کد اسکریپت اصلی `backup_script.sh`
- فایل پیکربندی نمونه `backup.conf`
- اسکریپت زمان‌بندی اجرای بکاپ `schedule_backup.sh`
- نمونه خروجی اجرای اسکریپت (عادی و dry-run)
- نمونه گزارش تولید شده (`backup.log`)
- لینک مخزن گیت‌هاب
- تاریخچه کامیت‌ها

---

## 🛠️ اسکریپت‌ها

### `backup_script.sh`:
اسکریپت اصلی به زبان Bash با قابلیت‌های:
- تعیین دایرکتوری مبدا و مقصد
- فیلتر فایل‌ها بر اساس پسوند
- dry-run
- پشتیبانی از فایل config
- نگهداری فقط نسخه‌های ۷ روز اخیر
- لاگ‌گیری

---

### `backup.conf`:
نمونه فایل پیکربندی:
```bash
source=/home/user/documents
destination=/home/user/backups
formats=pdf,docx,txt,jpg
```

---

### `schedule_backup.sh`:
اسکریپت افزودن job به `crontab` برای اجرای روزانه در ساعت ۲ بامداد.

---

## 🧪 نمونه خروجی
خروجی‌های واقعی از اجرای اسکریپت، شامل:
- مسیر بکاپ تولیدشده
- تعداد فایل‌های انتخاب شده
- اندازه نهایی بکاپ
- زمان اجرا

نمونه‌ای از خروجی dry-run نیز آورده شده است.

---

## 📝 فایل گزارش (`backup.log`)
نمونه‌هایی از پیام‌های ثبت شده در فایل لاگ با timestamp.

---

## 🔗 لینک مخزن گیت‌هاب
[https://github.com/username/auto-backup-script](https://github.com/username/auto-backup-script)

---

## 📌 تاریخچه کامیت‌ها (نمونه)

1. Initial commit - basic script structure  
2. Add config file support  
3. Implement file format filtering  
4. Add dry-run functionality  
5. Implement logging system  
6. Add backup rotation  
7. Improve error handling  
8. Add command line arguments parsing  
9. Add documentation  
10. Fix bug in file counting  
11. Add scheduling script  
12. Optimize tar command  
13. Update README with usage examples  
14. Add backup size reporting  
15. Final cleanup and comments
