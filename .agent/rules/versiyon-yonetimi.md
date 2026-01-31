# Versiyon Yönetimi Kuralları (v2.6.7+)

## 🎯 Tek Global Versiyon Sistemi

**Prensip:** GEMINI.md (Rules), Workflows, Skills ve PowerShell Script hepsi **aynı dağıtım paketinin** parçasıdır ve **tek bir global versiyon** numarası kullanır.

---

## 📋 ZORUNLU GÜNCELLEME LİSTESİ

Herhangi bir dosyada değişiklik yapıldığında, **TÜM** aşağıdaki dosyalar aynı versiyona güncellenmeli:

### 1. Global Rules (2 dosya)
- [ ] `C:\Users\HP\.gemini\GEMINI.md` (başlık: `# [vX.Y.Z]`)
- [ ] `gemini/GEMINI.dist.md` (başlık: `# [vX.Y.Z]`)

### 2. README ve Changelog (1 dosya)
- [ ] `README.md`
  - Satır ~12: `**Versiyon:** X.Y.Z (Stable)`
  - Changelog bölümü: Yeni versiyon ekle

### 3. PowerShell Script (1 dosya)
- [ ] `script/antigravity-kurulum.ps1`
  - Satır ~12: `[vX.Y.Z YENILIKLER]` (Changelog başlığı)
  - Satır ~99: `v2.6.7 (Stable)` (Ekran gösterimi)
  - Satır ~222: `ISLEM BASARILI! (vX.Y.Z)` (Başarı mesajı)

### 4. Workflows (3 dosya)
- [ ] `gemini/antigravity/workflows/analist.md`
  - YAML: `version: X.Y.Z`
  - YAML: `description: "[vX.Y.Z] analist..."`
- [ ] `gemini/antigravity/workflows/backend-architect.md`
  - YAML: `version: X.Y.Z`
  - YAML: `description: "[vX.Y.Z] backend-architect..."`
- [ ] `gemini/antigravity/workflows/frontend-design.md`
  - YAML: `version: X.Y.Z`
  - YAML: `description: "[vX.Y.Z] frontend-design..."`

### 5. Skills (3 dosya)
- [ ] `gemini/antigravity/skills/havsan-appsscript/SKILL.md`
  - YAML: `version: X.Y.Z`
- [ ] `gemini/antigravity/skills/havsan-code-review/SKILL.md`
  - YAML: `version: X.Y.Z`
- [ ] `gemini/antigravity/skills/havsan-development/SKILL.md`
  - YAML: `version: X.Y.Z`

**TOPLAM: 10 dosya**

---

## 🔄 ADIM ADIM GÜNCELLEME SÜRECİ

### Adım 1: Versiyon Numarasını Belirle
```
Mevcut: 2.6.7
Yeni: 2.6.8 (veya 2.7.0, 3.0.0)
```

### Adım 2: Tüm Dosyaları Güncelle
Yukarıdaki **10 dosyayı** tek tek aç ve versiyon numaralarını değiştir.

**Önemli:** Hiçbir dosyayı atlama! Hepsi aynı versiyonda olmalı.

### Adım 3: README.md Changelog Güncelle
```markdown
### vX.Y.Z (Stable)
- ✅ Değişiklik 1
- ✅ Değişiklik 2
- ✅ Değişiklik 3
```

### Adım 4: PowerShell Script Changelog Güncelle
`script/antigravity-kurulum.ps1` dosyasında:
```powershell
$CHANGELOG = @'
    [vX.Y.Z YENILIKLER]
    - Değişiklik 1
    - Değişiklik 2
'@
```

### Adım 5: Git Commit (Versiyon ile Başla!)
```bash
git add .
git commit -m "[vX.Y.Z] Ana değişiklik açıklaması

- Değişiklik 1
- Değişiklik 2
- Tüm dosyalar vX.Y.Z versiyonuna senkronize edildi"
```

**Format:** `[vX.Y.Z] Açıklama`

---

## ⚠️ KONTROL LİSTESİ (Her Güncelleme Öncesi)

- [ ] Versiyon numarası belirlendi mi?
- [ ] **10 dosyanın hepsi** güncellendi mi?
- [ ] README.md changelog'a yeni versiyon eklendi mi?
- [ ] PowerShell script changelog güncellendi mi?
- [ ] Git commit mesajı `[vX.Y.Z]` ile başlıyor mu?
- [ ] Commit mesajında "senkronize edildi" ifadesi var mı?

---

## 🚨 ÖLÜMCÜL HATALAR (ASLA YAPMA!)

1. ❌ **Kısmi Güncelleme:** Sadece birkaç dosyayı güncelleme
2. ❌ **PowerShell Script Unutma:** Script versiyonu eski kalırsa CMD'de eski versiyon görünür
3. ❌ **README Changelog Unutma:** Kullanıcılar değişiklikleri göremez
4. ❌ **Git Commit Formatı Hatası:** Versiyon numarası olmadan commit yapma

---

## 📊 Versiyon Numarası Formatı

**Semantic Versioning (Basitleştirilmiş):**
- `MAJOR.MINOR.PATCH` (örn: `2.6.7`)
- **MAJOR (2.x.x):** Büyük değişiklikler, breaking changes
- **MINOR (x.6.x):** Yeni özellikler, yeni kurallar
- **PATCH (x.x.7):** Hata düzeltmeleri, küçük iyileştirmeler

---

## 🎓 Neden Bu Kadar Katı?

1. **Kullanıcı Deneyimi:** IDE'de görünen versiyon ile script versiyonu farklıysa kafa karışıklığı olur
2. **Güvenilirlik:** Tüm bileşenler aynı versiyonda olmalı
3. **Takip Edilebilirlik:** Git history'de versiyon numaraları ile arama yapılabilir
4. **Profesyonellik:** HAVSAN standartlarına uygun, kurumsal kalite

---

*Bu kural, kullanıcı tarafından 2026-01-31 tarihinde oluşturulmuştur ve v2.6.7'den itibaren geçerlidir.*
