# ⚙️ Antigravity IDE Ayarları

Bu dosya, HAVSAN kurallarının doğru çalışması için gerekli IDE ayarlarını açıklar.

---

## 🛡️ Git Kontrol Ayarları (ZORUNLU)

GEMINI.md'deki Git kontrol kurallarının çalışması için IDE ayarlarını değiştirmen gerekiyor.

### Adım 1: Settings'i Aç

1. Antigravity IDE'yi aç
2. Sağ alt köşede **⚙️ (Settings)** ikonuna tıkla
3. **"Settings"** sekmesine git

### Adım 2: Auto Execution Ayarı

**Mevcut:** `Always Proceed`  
**Değiştir:** `Ask`

**Açıklama:** Bu ayar, IDE'nin komutları otomatik çalıştırmasını engeller. `Ask` seçildiğinde, her komut için onay ister.

### Adım 3: Review Policy Ayarı

**Mevcut:** `Always Proceed`  
**Değiştir:** `Ask`

**Açıklama:** Bu ayar, kod değişikliklerini otomatik onaylamayı engeller. `Ask` seçildiğinde, her değişiklik için onay ister.

---

## ✅ Doğrulama

Ayarları değiştirdikten sonra test et:

1. Yeni bir sohbet başlat
2. Şunu yaz: "Git'e bir commit at"
3. IDE, commit mesajını göstermeli ve **"Accept"** butonu ile onay istemeli
4. **Otomatik commit atmamalı**

---

## 📊 Ayar Özeti

| Ayar | Önceki | Yeni | Neden? |
|------|--------|------|--------|
| **Auto Execution** | Always Proceed | **Ask** | Komutlar için onay iste |
| **Review Policy** | Always Proceed | **Ask** | Kod değişiklikleri için onay iste |

---

## 🎯 Sonuç

Bu ayarlarla:
- ✅ Git commit/push için **mutlaka onay** istenecek
- ✅ GEMINI.md'deki Git kontrol kuralları **çalışacak**
- ✅ Kod değişiklikleri **kontrollü** olacak

---

**Tarih:** 2026-01-29  
**Hazırlayan:** Atıf Ertuğrul Kan
