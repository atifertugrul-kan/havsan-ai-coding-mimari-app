```text
  _   _    _ __     __ ___    _    _   _ 
 | | | |  / \\ \   / // __|  / \  | \ | |
 | |_| | / _ \\ \ / / \__ \ / _ \ |  \| |
 |  _  |/ ___ \\ V /  |___// ___ \| |\  |
 |_| |_/_/   \_\\_/   |___/_/   \_\_| \_| Robotics & AI | ELAZIG ORGANIZE SANAYI BOLGESI
                                         
```

# 🚀 HAVSAN Antigravity

**Versiyon:** 2.6.4 (Shortcut Fix)
**Amaç:** HAVSAN Yapay Zeka & Robotik ekibi için standart geliştirme ortamı.

---

## ⚡ 10 Saniyede Kurulum & Güncelleme

### Yöntem 1: Otomatik (Önerilen) ⭐
1. `antigravity-kurulum.bat` dosyasına **Çift Tıkla**
2. Bitti! ✅

### Yöntem 2: Manuel (PowerShell)
1. `antigravity-kurulum.ps1` dosyasına **Sağ Tık -> Run with PowerShell**

> **Not:** `.bat` dosyası otomatik olarak PowerShell kontrolü yapar ve güvenlik ayarlarını bypass eder.

---

### Güncelleme İçin
Aynı dosyayı tekrar çalıştırın. Script kimle çalıştığına bakar:
- **ATIF ise:** Değişiklikleri Git'e gönderir (**Push**).
- **Diğerleri ise:** Değişiklikleri çeker (**Pull**).

---

## 🔄 Nasıl Çalışır? (Akıllı Senkronizasyon)

**Merkezi Kural Yönetimi:** Kendi (ATIF) kök kurallarını değiştirdiğinde, bu değişikliklerin tüm ekibi etkilemesi için bir proje geliştirildi.

**Akıllı Script Mantığı:** `antigravity-kurulum.ps1` dosyası çalıştırıldığında kullanıcıyı ayırt eder:

1.  **Eğer kullanıcı "ATIF" ise:**
    *   Yerelindeki güncel kök kurallarını okur.
    *   Git üzerine gönderir (Auto-Push).
2.  **Eğer kullanıcı başka bir yazılımcı ise:**
    *   Git üzerindeki güncel kuralları çeker (Auto-Pull).
    *   Yerel sisteme entegre eder.


**Mimari Güncelleme:** `mimari-app` üzerinde bir geliştirme yapıldığında, PowerShell dosyası da otomatik olarak güncellenip Git'e aktarılır.

---

## 🛡️ Güvenlik ve Yönetişim (Public Repo Policy)

**"Başkaları projemi bozabilir mi?"**
Hayır. Bu depo **Public (Halka Açık)** olsa da, **Write (Yazma/Commit)** yetkileri sıkı bir şekilde korunmaktadır.

1.  **Yetki (Authorization):** Sadece proje sahibi (**Atıf**) ve yetkilendirilmiş Collaborator'lar `main` dalına doğrudan kod gönderebilir (Push).
2.  **Dış Katkı (Community):** Dışarıdan (veya yetkisiz) geliştiriciler projeyi yalnızca **Clone** edebilir veya **Fork**'layabilir.
3.  **Değişiklik Talebi:** Eğer bir başkası değişiklik yapmak isterse, **Pull Request (PR)** açmak zorundadır. Bu talepler, yönetici onayı olmadan projeye dahil edilemez.

> **Özet:** Kodlarınız halka açıktır (okunabilir), ancak kontrol tamamen sizdedir (değiştirilemez).

---

## 🎯 Fullstack Geliştirme Haritası

### Faz 1: Analiz (ZORUNLU)

> **Kural:** `docs/analiz_master.md` tek doğruluk kaynağıdır. Kopyalanmaz!

```mermaid
graph TD
    Start[Yeni Proje] --> Init[analiz_master.md]
    Init --> Loop{İteratif Sorular}
    Loop -- Hayır --> Q[Cevapla]
    Q --> Loop
    Loop -- Evet --> PRD["gereksinim_analizi.md<br/>(Tek Kaynak - Kopyalamak YASAK)"]
    
    style PRD fill:#b30000,stroke:#333,stroke-width:2px,color:#fff
```

### Faz 2: Frontend (Dummy Data)

> **Kural:** Backend yokmuş gibi çalış. %100 Mock Data.

```mermaid
graph TD
    Analiz["analiz_master.md<br/>(Tek Gerçek)"] --> FE[Frontend Başlat]
    FE --> Dev[UI Geliştirme]
    Dev --> Rev{Onay?}
    Rev -- Red --> Dev
    Rev -- Onay --> Next[Backend'e Geç]
    
    style Analiz fill:#b30000,stroke:#333,stroke-width:2px,color:#fff
```

### Faz 3: Backend & Entegrasyon

> **Kural:** Frontend onayı almadan Backend yazılmaz.

```mermaid
graph TD
    Analiz["analiz_master.md<br/>(Tek Gerçek)"] --> BE[Backend Başlat]
    FE_OK[Frontend Onaylı] --> BE
    BE --> API[API & DB]
    API --> Integ[Entegrasyon]
    Integ --> Live[Canlıya Geçiş]
    
    style Analiz fill:#b30000,stroke:#333,stroke-width:2px,color:#fff
```

---

## 🛡️ 7 Altın Kural

1. **%100 Türkçe** 🇹🇷
2. **Docker-First** (Local yasak) 🐳
3. **Frontend-First** (Önce UI) 🎨
4. **İteratif Analiz** (`analiz_master.md`) 📝
5. **Onaylı Git** (Commit yasak, onay şart) 🛑
6. **Teknoloji:** Google > HAVSAN > Open Source ☁️
7. **Hafıza:** Kuralları `.agent/rules/` içine yaz 🧠

---

## ⚙️ IDE Ayarı (Bunu Yapmazsan Çalışmaz!)

Antigravity IDE sağ üstten **Settings**:
1. **Auto Execution:** `Ask` (Always Proceed YAPMA)
2. **Review Policy:** `Ask` (Always Proceed YAPMA)

---

## 📂 Klasör Yapısı

```
proje/
├── docs/               # Analiz (TEK KAYNAK)
├── frontend/           # React/Next.js
├── backend/            # FastAPI/Node.js
└── docker-compose.yml  # Tüm sistem
```
