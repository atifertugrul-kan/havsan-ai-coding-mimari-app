---
name: havsan-code-review
description: Performs a comprehensive code review based on HAVSAN Engineering Standards. Trigger this skill when the user asks to "review code", "check for errors", or before finalizing a task.
---

# 🧐 HAVSAN Code Reviewer

Bu beceri, kodun sadece "çalışıp çalışmadığını" değil, **HAVSAN Standartlarına** uygun olup olmadığını denetler.

## 🕵️ İnceleme Kontrol Listesi (Checklist)

### 1. HAVSAN Mimarisi (Kritik)
*   [ ] **Docker:** Kod yerel yollara (C:\Users...) başvuruyor mu? (Yasak). Her şey Docker içinde mi?
*   [ ] **Dil:** Değişkenler İngilizce (`userList`), Yorumlar ve Commitler Türkçe (`// Kullanıcı listesi getiriliyor`) mi?
*   [ ] **Config:** Şifreler koda gömülü mü? (Yasak). Environment variable kullanılmış mı?

### 2. Kalite ve Temizlik
*   [ ] **Fonksiyonlar:** Bir fonksiyon 50 satırdan uzun mu? (Bölünmeli).
*   [ ] **İsimlendirme:** `var a = 1` gibi anlamsız isimler var mı?
*   [ ] **Hata Yönetimi:** `try-catch` blokları var mı? Hata kullanıcıya düzgün dönüyor mu?

### 3. Güvenlik
*   [ ] **SQL Injection:** Parametrik sorgu kullanılmış mı?
*   [ ] **Input Validation:** Kullanıcıdan gelen veri filtreleniyor mu?

## 📣 Raporlama Formatı

İnceleme sonucunu şu formatta sun:

```markdown
## 🔍 Kod İnceleme Raporu

### 🔴 Kritik Hatalar
*   [Dosyaadı.js]: Şifre açıkta unutulmuş.

### 🟡 İyileştirme Önerileri
*   [Dosyaadı.js]: Fonksiyon çok uzun, ikiye bölünebilir.

### 🟢 Onaylananlar
*   Mimari HAVSAN standartlarına uygun.
```
