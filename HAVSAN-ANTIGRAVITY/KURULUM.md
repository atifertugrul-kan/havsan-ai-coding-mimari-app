# 📖 HAVSAN Antigravity Kurulum Rehberi

**Hedef Kitle:** HAVSAN Yazılım Ekibi  
**Tahmini Süre:** 5 dakika  
**Zorluk:** Başlangıç

---

## 🎯 Kurulum Öncesi

### Gereksinimler

- ✅ **Google Antigravity IDE** kurulu olmalı
- ✅ **Windows** işletim sistemi
- ✅ **Yönetici yetkisi** (bazı durumlarda)

### Antigravity IDE Kurulumu

Eğer henüz Antigravity IDE kurulu değilse:

1. [Google Antigravity IDE](https://ide.google.com) adresine git
2. İndir ve kur
3. **En az bir kez çalıştır** (`.gemini` klasörü oluşması için)
4. IDE'yi kapat

---

## 📦 Kurulum Yöntemleri

### Yöntem 1: Manuel Kurulum (Önerilen - Basit)

#### Adım 1: Klasör Konumunu Bul

Windows Gezgini'nde şu adrese git:

```
C:\Users\<KULLANICI_ADIN>\.gemini\
```

**İpucu:** `<KULLANICI_ADIN>` yerine kendi kullanıcı adınızı yazın.

**Hızlı Erişim:**
1. `Win + R` tuşlarına bas
2. `%USERPROFILE%\.gemini` yaz
3. Enter'a bas

#### Adım 2: HAVSAN-ANTIGRAVITY İçeriğini Kopyala

1. Bu paketteki **`HAVSAN-ANTIGRAVITY`** klasörünü aç
2. **İçindeki tüm dosya ve klasörleri seç** (Ctrl+A)
3. **Kopyala** (Ctrl+C)

#### Adım 3: .gemini Klasörüne Yapıştır

1. `.gemini` klasörüne git
2. **Yapıştır** (Ctrl+V)
3. Eğer "Dosyalar zaten var, değiştir mi?" sorusu gelirse:
   - ✅ **"Evet, değiştir"** veya **"Birleştir"** seçin

#### Adım 4: Sonuç Kontrolü

`.gemini` klasörü şu şekilde görünmeli:

```
C:\Users\<KULLANICI_ADIN>\.gemini\
├── GEMINI.md                    ← YENİ
├── antigravity\
│   ├── skills\
│   │   ├── havsan-appsscript\   ← YENİ
│   │   ├── havsan-code-review\  ← YENİ
│   │   └── havsan-development\  ← YENİ
│   └── workflows\
│       ├── analist.md           ← YENİ
│       ├── backend-architect.md ← YENİ
│       └── frontend-design.md   ← YENİ
└── (diğer mevcut dosyalar)
```

#### Adım 5: IDE'yi Yeniden Başlat

1. Antigravity IDE'yi **tamamen kapat**
2. Tekrar **aç**
3. Konfigürasyonlar otomatik yüklenecek

---

### Yöntem 2: PowerShell Script ile Kurulum (İleri Seviye)

#### Ön Gereksinim

PowerShell execution policy ayarı:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Kurulum Komutu

```powershell
# Proje klasörüne git
cd C:\Repos\HAVSAN\havsan-ai-coding-mimari-app

# Kurulum scriptini çalıştır
.\scripts\install-team.ps1
```

Script otomatik olarak:
- ✅ Mevcut konfigürasyonları yedekler
- ✅ Yeni konfigürasyonları kopyalar
- ✅ Doğrulama yapar
- ✅ Sonuç raporu verir

---

## ✅ Kurulum Doğrulama

### 1. IDE Arayüzünden Kontrol

1. Antigravity IDE'yi aç
2. **Sağ üst köşede** ⚙️ (Settings) ikonuna tıkla
3. **"Customizations"** sekmesine git

#### Rules Kontrolü

**"Rules"** sekmesinde şunu görmelisin:

```
🛡️ HAVSAN GLOBAL MASTER RULES
   Global
```

![Rules Ekranı](../docs/screenshots/uploaded_media_1_1769692108115.png)

#### Workflows Kontrolü

**"Workflows"** sekmesinde şunları görmelisin:

```
analist - İteratif Analiz Uzmanı
backend-architect - Backend Mimari Tasarım
frontend-design - Frontend Tasarım
```

![Workflows Ekranı](../docs/screenshots/uploaded_media_0_1769692108115.png)

### 2. Dosya Sisteminden Kontrol

PowerShell'de şu komutu çalıştır:

```powershell
# GEMINI.md kontrolü
Test-Path "$env:USERPROFILE\.gemini\GEMINI.md"

# Skills kontrolü
Test-Path "$env:USERPROFILE\.gemini\antigravity\skills\havsan-development"

# Workflows kontrolü
Test-Path "$env:USERPROFILE\.gemini\antigravity\workflows\analist.md"
```

Hepsi **True** dönmeli.

### 3. Çalışma Testi

Yeni bir sohbet başlat ve şunu yaz:

```
Yeni bir proje başlatmak istiyorum
```

Agent, **havsan-development** skill'ini otomatik olarak devreye sokmalı ve önce **analiz aşaması** başlatmalı.

---

## 🔄 Güncelleme Prosedürü

### Manuel Güncelleme

1. Atıf'tan yeni `HAVSAN-ANTIGRAVITY` klasörünü al
2. **Yöntem 1**'deki adımları tekrarla
3. IDE'yi yeniden başlat

### Script ile Güncelleme

```powershell
cd C:\Repos\HAVSAN\havsan-ai-coding-mimari-app

# Git'ten güncellemeleri çek
git pull

# Antigravity'ye uygula
.\scripts\sync-to-antigravity.ps1
```

---

## 🆘 Sorun Giderme

### Sorun 1: "GEMINI.md bulunamadı" Hatası

**Sebep:** Dosya yanlış konuma kopyalanmış.

**Çözüm:**
```powershell
# Doğru konum kontrolü
Get-ChildItem "$env:USERPROFILE\.gemini\GEMINI.md"
```

Eğer dosya yoksa, kurulum adımlarını tekrarla.

### Sorun 2: Rules/Workflows IDE'de Görünmüyor

**Sebep:** IDE konfigürasyonları yüklememiş.

**Çözüm:**
1. IDE'yi **tamamen kapat** (Task Manager'dan kontrol et)
2. Tekrar aç
3. 30 saniye bekle (ilk yüklemede biraz zaman alabilir)

### Sorun 3: "Access Denied" Hatası

**Sebep:** Yönetici yetkisi gerekiyor.

**Çözüm:**
1. PowerShell'i **"Run as Administrator"** ile aç
2. Kurulum komutunu tekrar çalıştır

### Sorun 4: Eski Konfigürasyonlar Hala Aktif

**Sebep:** Dosyalar birleştirilmemiş, yan yana duruyorlar.

**Çözüm:**
```powershell
# Eski dosyaları yedekle
Copy-Item "$env:USERPROFILE\.gemini" "$env:USERPROFILE\.gemini-backup" -Recurse

# HAVSAN konfigürasyonlarını tekrar kopyala (üzerine yaz)
```

---

## 📞 Destek Kanalları

Sorun devam ediyorsa:

1. **Atıf Ertuğrul Kan**
   - Email: atifertugrul.kan@havsanrobotik.com.tr
   - Slack: @atif

2. **HAVSAN Slack**
   - Kanal: `#antigravity-destek`

3. **Ekran Görüntüsü Gönder**
   - Customizations ekranının ekran görüntüsü
   - Hata mesajının ekran görüntüsü

---

## 🎓 Sonraki Adımlar

Kurulum başarılı! Şimdi ne yapmalısın?

### 1. Dokümantasyonu Oku

- [README.md](README.md) - Genel bakış
- [CHANGELOG.md](../CHANGELOG.md) - Versiyon geçmişi

### 2. İlk Projeyi Başlat

Yeni bir proje başlatarak HAVSAN standartlarını test et:

```
Yeni bir web uygulaması geliştirmek istiyorum.
Müşteri: Kütüphane yönetim sistemi
```

Agent otomatik olarak:
- ✅ İteratif analiz başlatacak
- ✅ Docker-first yaklaşımı uygulayacak
- ✅ Frontend-first süreç takip edecek

### 3. Workflows'u Keşfet

Slash komutlarını dene:

- `/analist` - Derinlemesine analiz
- `/backend-architect` - Backend tasarım
- `/frontend-design` - Frontend tasarım

---

## ✨ Başarılar!

Artık HAVSAN Antigravity standartlarıyla çalışmaya hazırsın! 🚀

**Unutma:** Ekip olarak aynı standartlarda çalışmak, kod kalitesini ve verimliliği artırır.

---

**Son Güncelleme:** 2026-01-29  
**Versiyon:** 1.0.0
