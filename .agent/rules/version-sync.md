# HAVSAN Version Synchronization Policy (v2.6.7+)

**Kural:** Herhangi bir dosyada değişiklik yapıldığında, aşağıdaki **10 dosyanın TÜM versiyonları** senkronize edilmelidir.

---

## 📋 Senkronize Edilecek Dosyalar (10 Dosya)

### 1. Global Rules (2 dosya)
1. `C:\Users\HP\.gemini\GEMINI.md` → Başlık: `# [vX.Y.Z]`
2. `gemini/GEMINI.dist.md` → Başlık: `# [vX.Y.Z]`

### 2. README ve Changelog (1 dosya)
3. `README.md`
   - Satır ~12: `**Versiyon:** X.Y.Z (Stable)`
   - Changelog: Yeni versiyon ekle

### 3. PowerShell Script (1 dosya)
4. `script/antigravity-kurulum.ps1`
   - Satır ~12: `[vX.Y.Z YENILIKLER]`
   - Satır ~99: `v2.6.7 (Stable)`
   - Satır ~222: `ISLEM BASARILI! (vX.Y.Z)`

### 4. Workflows (3 dosya)
5. `gemini/antigravity/workflows/analist.md`
6. `gemini/antigravity/workflows/backend-architect.md`
7. `gemini/antigravity/workflows/frontend-design.md`
   - Her birinde: `version: X.Y.Z` ve `description: "[vX.Y.Z] ..."`

### 5. Skills (3 dosya)
8. `gemini/antigravity/skills/havsan-appsscript/SKILL.md`
9. `gemini/antigravity/skills/havsan-code-review/SKILL.md`
10. `gemini/antigravity/skills/havsan-development/SKILL.md`
    - Her birinde: `version: X.Y.Z`

---

## 🎯 Neden?

- **IDE Görünümü:** Cursor/VSCode'da görünen kurallar ve workflow listesi bu dosyalardan beslenir
- **Script Versiyonu:** CMD'de çalışan script versiyonu ile dokümantasyon uyumsuz olursa kullanıcı yanılır
- **Profesyonellik:** Tüm bileşenler aynı versiyonda olmalı

---

## 🔄 Prosedür

1. **Versiyon Artır:** `2.6.7` → `2.6.8`
2. **10 Dosyayı Güncelle:** Yukarıdaki listeyi tek tek kontrol et
3. **README Changelog:** Yeni versiyon ekle
4. **PowerShell Changelog:** `$CHANGELOG` değişkenini güncelle
5. **Git Commit:** `[vX.Y.Z] Açıklama` formatında commit yap

---

## ⚠️ Kritik Hatırlatma

**ASLA** sadece birkaç dosyayı güncelleme! **HER ZAMAN** 10 dosyanın hepsini aynı versiyona getir!

---

*Bu kural v2.6.7'den itibaren geçerlidir.*
