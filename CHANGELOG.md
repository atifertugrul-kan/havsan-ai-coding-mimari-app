# 📝 HAVSAN Antigravity - Değişiklik Geçmişi

Tüm önemli değişiklikler bu dosyada belgelenir.

Format [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) standardını takip eder.

---

## [1.0.0] - 2026-01-29

### ✨ Eklenenler

#### Global Rules (GEMINI.md)
- **Dil ve İletişim:** %100 Türkçe, eğitmen modu
- **Docker-First Anayasası:** Local kurulum yasağı, tüm süreçler Docker ile
- **Frontend-First Süreç:** Analiz → Frontend → Backend sıralaması
- **Güvenli Otonom Çalışma:** Kritik işlemlerde onay mekanizması
- **Teknoloji Tercihleri:** Google Ekosistemi → HAVSAN Cloud → Open Source
- **Proje Hafızası:** `.agent/rules/` ile kalıcı tercih yönetimi
- **İteratif Analiz Sistemi:** `analiz_master.md` ile derinlemesine gereksinim analizi

#### Skills

**havsan-appsscript**
- Dockerized Clasp kullanımı zorunluluğu
- Deployment güvenlik kontrolleri
- `.gs` ve `appsscript.json` dosyalarında otomatik tetikleme

**havsan-code-review**
- HAVSAN Engineering Standards'a göre kod incelemesi
- "Kodu incele", "review yap" komutlarında otomatik tetikleme

**havsan-development**
- **ZORUNLU PROTOKOL** - Tüm yeni projeler için
- Frontend/backend klasörleri oluşturulmadan önce analiz aşaması
- Kullanıcı adı sorgulaması ve kişiselleştirme

#### Workflows

**analist.md**
- İteratif analiz uzmanı
- Tek dosya (`analiz_master.md`) yaklaşımı
- Checkbox takip sistemi
- IDE yorumları ile yanıt toplama

**backend-architect.md**
- Backend mimari tasarımı
- API yapılandırması
- Veritabanı şema tasarımı

**frontend-design.md**
- Frontend tasarım süreci
- Kullanıcı deneyimi odaklı geliştirme
- Dummy data ile prototipleme

### 🔧 Araçlar

**sync-to-antigravity.ps1**
- Proje → Antigravity senkronizasyonu
- Otomatik yedekleme (timestamp ile)
- MD5 hash doğrulama
- Renkli konsol çıktısı
- Dry-run modu

**sync-from-antigravity.ps1**
- Antigravity → Proje senkronizasyonu
- Değişiklik tespiti (MD5 hash)
- Git entegrasyonu
- Otomatik commit özelliği

**validate-config.ps1**
- YAML frontmatter doğrulama
- Zorunlu bölüm kontrolü
- Dosya bütünlüğü kontrolü
- Detaylı hata raporlama

**install-team.ps1**
- Ekip üyesi ilk kurulum
- Otomatik yedekleme
- Adım adım kurulum süreci
- Final doğrulama

### 📚 Dokümantasyon

- **README.md:** Genel bakış, hızlı kurulum, FAQ
- **KURULUM.md:** Detaylı kurulum rehberi, sorun giderme
- **CHANGELOG.md:** Versiyon geçmişi (bu dosya)

### 🎨 Yapı

- **Tek Klasör Yaklaşımı:** `HAVSAN-ANTIGRAVITY/` doğrudan `.gemini/` altına kopyalanabilir
- **Git Versiyon Kontrolü:** Tüm konfigürasyonlar Git ile yönetilir
- **Ekip Dağıtımı:** Basit kopyala-yapıştır ile kurulum

---

## [Planlanmış] - Gelecek Versiyonlar

### v1.1.0 (Planlanan)
- [ ] Otomatik güncelleme kontrolü
- [ ] Web tabanlı konfigürasyon editörü
- [ ] Ekip üyesi kullanım istatistikleri
- [ ] Özel skill oluşturma şablonu

### v1.2.0 (Planlanan)
- [ ] CI/CD entegrasyonu
- [ ] Slack bot ile bildirimler
- [ ] Konfigürasyon diff görüntüleyici
- [ ] Rollback mekanizması

---

## 📋 Versiyon Numaralandırma

Bu proje [Semantic Versioning](https://semver.org/) kullanır:

- **MAJOR:** Uyumsuz API değişiklikleri
- **MINOR:** Geriye uyumlu yeni özellikler
- **PATCH:** Geriye uyumlu hata düzeltmeleri

---

## 🔗 Bağlantılar

- [README](README.md)
- [Kurulum Rehberi](KURULUM.md)
- [HAVSAN Engineering Standards](https://internal.havsanrobotik.com.tr/standards)

---

**Hazırlayan:** Atıf Ertuğrul Kan  
**Ekip:** HAVSAN Robotik Yazılım Ekibi
