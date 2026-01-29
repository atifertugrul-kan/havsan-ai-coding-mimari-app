# 🔄 HAVSAN Antigravity Güncelleme Scriptleri

Bu klasör, Antigravity konfigürasyonlarını yönetmek için PowerShell scriptleri içerir.

---

## 📝 Scriptler

### `guncelle.ps1` - Hızlı Güncelleme (Atıf için)

**Amaç:** Proje içindeki `gemini/` klasöründeki değişiklikleri `.gemini/` klasörüne otomatik kopyalar.

**Kullanım:**
```powershell
.\scripts\guncelle.ps1
```

**Ne Yapar:**
1. ✅ Mevcut `.gemini/` içeriğini yedekler (timestamp ile)
2. ✅ `gemini/GEMINI.md` → `.gemini/GEMINI.md`
3. ✅ `gemini/antigravity/skills/` → `.gemini/antigravity/skills/`
4. ✅ `gemini/antigravity/workflows/` → `.gemini/antigravity/workflows/`
5. ✅ Özet rapor gösterir

**Sonrası:**
- Antigravity IDE'yi yeniden başlat (veya refresh et)
- Değişiklikler otomatik yüklenecek

---

## 🎯 Atıf'ın Workflow'u

### 1️⃣ Konfigürasyon Değiştir

Proje içinde düzenle:
- `gemini/GEMINI.md`
- `gemini/antigravity/skills/`
- `gemini/antigravity/workflows/`

### 2️⃣ Hızlı Güncelle

```powershell
.\scripts\guncelle.ps1
```

### 3️⃣ IDE'yi Refresh Et

Antigravity IDE'de:
- Yeniden başlat veya
- Customizations sayfasını refresh et

### 4️⃣ Git Commit

```powershell
git add gemini/
git commit -m "feat: Update GEMINI rules"
git push
```

---

## 💡 İpuçları

### Sadece Test Etmek İçin

Yedek oluşturulur, geri almak için:
```powershell
# Yedek konumunu kopyala (script çıktısından)
Copy-Item "C:\Users\HP\.gemini\backups\guncelleme-2026-01-29_17-45-00\*" "C:\Users\HP\.gemini\" -Recurse -Force
```

### Otomatik Yedekleme

Her `guncelle.ps1` çalıştırıldığında otomatik yedek oluşturulur:
```
C:\Users\HP\.gemini\backups\guncelleme-YYYY-MM-DD_HH-mm-ss\
```

---

## 🆘 Sorun Giderme

### "Antigravity klasörü bulunamadı"

**Sebep:** Antigravity IDE hiç çalıştırılmamış.

**Çözüm:**
1. Antigravity IDE'yi aç
2. Bir kez çalıştır (`.gemini` klasörü oluşur)
3. Kapat
4. Scripti tekrar çalıştır

### "Kaynak klasör bulunamadı"

**Sebep:** Script yanlış konumdan çalıştırılmış.

**Çözüm:**
```powershell
cd C:\Repos\HAVSAN\havsan-ai-coding-mimari-app
.\scripts\guncelle.ps1
```

---

**Hazırlayan:** Atıf Ertuğrul Kan  
**Tarih:** 2026-01-29
