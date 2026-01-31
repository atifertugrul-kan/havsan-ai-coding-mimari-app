# Versiyon Yönetimi Kuralları

## Tek Global Versiyon Sistemi

**Prensip:** GEMINI.md (Rules), Workflows ve Skills hepsi **aynı dağıtım paketinin** parçasıdır ve **tek bir global versiyon** numarası kullanır.

## Zorunlu Kurallar

### 1. Versiyon Senkronizasyonu (ZORUNLU)
Herhangi bir dosyada değişiklik yapıldığında:
- [ ] Global versiyon numarasını artır (örn: `2.6.7` → `2.6.8`)
- [ ] **TÜM** dosyalardaki versiyon numaralarını güncelle:
  - `GEMINI.md` (başlık)
  - `GEMINI.dist.md` (başlık)
  - `README.md` (versiyon + changelog)
  - Tüm workflow dosyaları (`version:` field)
  - Tüm skill dosyaları (`version:` field)

### 2. Git Commit Formatı (ZORUNLU)
Commit mesajının **en başına** versiyon numarasını ekle:

```
[v2.6.7] Proje başlangıç klasör yapısı kuralı eklendi

- database/docs/db-design.md otomatik oluşturulacak
- backend/docs/api-design.md otomatik oluşturulacak
- Tüm temel klasörler .gitignore ile birlikte başlangıçta hazır
```

**Format:** `[vX.Y.Z] Ana değişiklik açıklaması`

### 3. Changelog Güncellemesi (ZORUNLU)
Her versiyon değişikliğinde `README.md` changelog bölümüne yeni versiyon ekle:

```markdown
### vX.Y.Z (Stable)
- ✅ Değişiklik 1
- ✅ Değişiklik 2
```

## Versiyon Numarası Formatı

**Semantic Versioning (Basitleştirilmiş):**
- `MAJOR.MINOR.PATCH` (örn: `2.6.7`)
- **MAJOR:** Büyük değişiklikler, breaking changes
- **MINOR:** Yeni özellikler, yeni kurallar
- **PATCH:** Hata düzeltmeleri, küçük iyileştirmeler

## Kontrol Listesi

Her güncelleme öncesi:
- [ ] Hangi dosyalar değişti?
- [ ] Versiyon numarası artırıldı mı?
- [ ] Tüm dosyalardaki versiyonlar senkronize mi?
- [ ] README.md changelog güncellendi mi?
- [ ] Git commit mesajı versiyon ile başlıyor mu?

## Önemli Notlar

⚠️ **ASLA** sadece bir dosyanın versiyonunu güncelleme!  
⚠️ **HER ZAMAN** tüm dosyaları aynı versiyona getir!  
⚠️ **GIT COMMIT** mesajına versiyon eklemeyi unutma!

---

*Bu kural, kullanıcı tarafından 2026-01-31 tarihinde oluşturulmuştur.*
