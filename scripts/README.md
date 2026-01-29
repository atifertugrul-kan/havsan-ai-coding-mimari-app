# 🔄 HAVSAN Antigravity Güncelleme Scriptleri

Bu klasör, Antigravity konfigürasyonlarını yönetmek için PowerShell scriptleri içerir.

---

## 📝 Scriptler

### `install-team.ps1` - Ekip Kurulumu (HERKES İÇİN)

**Amaç:** Ekip üyelerinin Antigravity ortamını tek tıkla kurmasını sağlar.

**Kullanım:**
Script dosyasına sağ tıklayıp "Run with PowerShell" deyin.

**Ne Yapar:**
1. ✅ `gemini/GEMINI.dist.md` → `.gemini/GEMINI.md` (Adını düzelterek kopyalar)
2. ✅ `gemini/KURULUM.md` → `.gemini/KURULUM.md`
3. ✅ `gemini/antigravity/` → `.gemini/antigravity/`

---

### `guncelle.ps1` - Hızlı Güncelleme (ATIF İÇİN)

**Amaç:** Geliştirme yaparken proje klasöründen lokal `.gemini` klasörüne hızlı senkronizasyon.

**Kullanım:**
*Windows Dosya Gezgini'nde dosyaya sağ tıklayıp **"Run with PowerShell"** seçeneğini kullanın.*

```powershell
.\scripts\guncelle.ps1
```

**Ne Yapar:**
1. ✅ Mevcut `.gemini/` yedeğini alır
2. ✅ `gemini/` altındaki değişiklikleri `.gemini/` altına uygular
3. ✅ `.dist.md` dosyalarını otomatik `.md` olarak kopyalar

---

## 💡 İpuçları

### Otomatik Yedekleme

Her iki script de çalışmadan önce `.gemini` klasörünün yedeğini alır:
```
C:\Users\HP\.gemini\backups\
```

### Sorun Giderme

Eğer script çalışmazsa (Execution Policy hatası):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
komutunu PowerShell'de bir kez çalıştırın.

---

**Hazırlayan:** Atıf Ertuğrul Kan  
**Tarih:** 2026-01-29
