# 🔄 HAVSAN Antigravity Güncelleme Scriptleri

Bu klasör, Antigravity konfigürasyonlarını yönetmek için PowerShell scriptleri içerir.

---

### 👥 Ekip Üyesi (Kullanıcı)
Ekip üyeleri için kurulum süreci çok basittir:

1. `gemini/antigravity/` klasörünü kopyala
2. `C:\Users\<KULLANICI_ADIN>\.gemini\antigravity\` altına yapıştır
3. Antigravity IDE'yi yeniden başlat
*(Veya otomatik kurulum için `install-team.ps1` dosyasını çalıştır)*

### 👨‍💻 Admin (Atıf)
Proje yöneticisi için senkronizasyon araçları:

**Kullanım:**
Script dosyasına sağ tıklayıp "Run with PowerShell" deyin.

**Ne Yapar:**

## 📝 Scriptler

### `antigravity-kurulum.ps1` - Kurulum ve Güncelleme Sihirbazı
**Amaç:** Antigravity IDE kurallarını yüklemek veya güncellemek için kullanılan **TEK** araçtır. Hem ilk kurulum hem de güncelleme için kullanılır.

**Kullanım:**
*Windows Dosya Gezgini'nde dosyaya sağ tıklayıp **"Run with PowerShell"** seçeneğini kullanın.*

```powershell
.\scripts\antigravity-kurulum.ps1
```

**Ne Yapar:**
- `.gemini` klasörünü kontrol eder ve oluşturur.
- Mevcut kurallar (`backups/` altına) yedekler.
- Global kuralları (`GEMINI.md`) yükler/günceller.
- Skills ve Workflows dosyalarını senkronize eder.
- "Path Too Long" hatalarını önlemek için gereksiz klasörleri atlar.

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
