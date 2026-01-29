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

### Yöntem 1: Script ile Kurulum (Önerilen)

En kolay yöntem kurulum scriptini kullanmaktır:

1. Proje klasörünü aç
2. `scripts/install-team.ps1` dosyasına sağ tıkla -> **PowerShell ile Çalıştır**

Script otomatik olarak:
- ✅ **Yedekleme** alır
- ✅ **Konfigürasyonları** kopyalar
- ✅ **Dosya adlarını** düzeltir
- ✅ Sonuç raporu verir

### Yöntem 2: Manuel Kurulum

#### Adım 1: Klasör Konumunu Bul

Windows Gezgini'nde şu adrese git:

```
C:\Users\<KULLANICI_ADIN>\.gemini\
```

#### Adım 2: Dosyaları Kopyala

1. `gemini/antigravity` klasörünü → `.gemini/` içine kopyala
2. `gemini/GEMINI.dist.md` dosyasını → `.gemini/GEMINI.md` olarak kopyala (yeniden adlandır)
3. `gemini/KURULUM.md` dosyasını → `.gemini/KURULUM.md` olarak kopyala

#### Adım 3: IDE'yi Yeniden Başlat

IDE'yi kapatıp açtığında yeni kurallar aktif olacaktır.

---

## 🚀 Yeni Proje Başlatma Promptu

Kurulum tamamlandı! Şimdi yeni bir proje başlatmak için aşağıdaki promptu kullan:

### 📋 Proje Başlatma Şablonu

```
Yeni bir fullstack proje başlatmak istiyorum.

Proje Adı: [PROJE_ADI]
Müşteri: [MÜŞTERİ_ADI]
Kısa Açıklama: [1-2 CÜMLE]

HAVSAN standartlarına göre ilerleyelim:
1. Önce analiz aşamasını tamamlayalım (analiz_master.md)
2. Analiz onaylandıktan sonra frontend (dummy data ile)
3. Frontend tamamlandıktan sonra backend

Docker-first yaklaşımı kullan, local kurulum yasak.
```

---

## 🔄 Güncelleme Prosedürü

### Manuel Güncelleme

1. Atıf'tan yeni `gemini` klasörünü al
2. **Yöntem 2**'deki adımları tekrarla
3. IDE'yi yeniden başlat

### Script ile Güncelleme

```powershell
cd C:\Repos\HAVSAN\havsan-ai-coding-mimari-app

# Git'ten güncellemeleri çek
git pull

# Antigravity'ye uygula
.\scripts\install-team.ps1
```

---

## 🆘 Sorun Giderme

### Sorun 1: "GEMINI.md bulunamadı" Hatası

**Sebep:** Dosya yanlış konuma kopyalanmış veya adı değiştirilmemiş.
**Çözüm:** `.gemini/GEMINI.md` olduğundan emin olun (uzantısı `.dist.md` OLMAMALI).

### Sorun 2: Rules IDE'de Görünmüyor

**Çözüm:**
1. IDE'yi tamamen kapatıp aç
2. Settings > Rules kısmını kontrol et

---

**Son Güncelleme:** 2026-01-29  
**Versiyon:** 1.0.0
