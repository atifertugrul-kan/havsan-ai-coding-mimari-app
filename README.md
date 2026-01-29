# 🚀 HAVSAN Antigravity Konfigürasyon Yönetimi

**Versiyon:** 1.0.0  
**Amaç:** HAVSAN ekibi için standart Antigravity IDE konfigürasyonları

---

## 📦 Ne İçeriyor?

```
gemini/                         # Dağıtım Paketi
├── GEMINI.md                   # Global Rules
├── KURULUM.md                  # Kurulum + Proje Başlatma
└── antigravity/
    ├── skills/                 # 3 özel yetenek
    └── workflows/              # 3 iş akışı
```

---

## ⚡ Hızlı Kurulum

### Ekip Üyesi

1. `gemini` klasörünün **içeriğini** kopyala
2. `C:\Users\<KULLANICI_ADIN>\.gemini\` altına yapıştır
3. Antigravity IDE'yi yeniden başlat

**Detay:** `gemini/KURULUM.md`

### Atıf (Yönetici)

```powershell
# Değişiklik sonrası
.\scripts\sync-from-antigravity.ps1 -AutoCommit
git push
```

---

## 🛡️ HAVSAN Standartları

### 7 Temel Kural

1. **%100 Türkçe** iletişim
2. **Docker-First** (local kurulum yasak)
3. **Frontend-First** (Analiz → Frontend → Backend)
4. **İteratif Analiz** (`analiz_master.md`)
5. **Güvenli Otonom Çalışma** (kritik işlemlerde onay)
6. **Teknoloji Hiyerarşisi** (Google → HAVSAN Cloud → Open Source)
7. **Proje Hafızası** (`.agent/rules/`)

### Skills

- **havsan-appsscript** - Google Apps Script + Dockerized Clasp
- **havsan-code-review** - Kod inceleme standartları
- **havsan-development** - Yeni proje protokolü (ZORUNLU)

### Workflows

- `/analist` - İteratif analiz
- `/backend-architect` - Backend tasarım
- `/frontend-design` - Frontend tasarım

---

## 🎯 Fullstack Geliştirme Yol Haritası

### Faz 1: Analiz (ZORUNLU)

```mermaid
graph TD
    A[Yeni Proje Talebi] --> B[analiz_master.md oluştur]
    B --> C[İteratif Sorular<br/>5-10 Round]
    C --> D{Tüm sorular<br/>cevaplandı mı?}
    D -->|Hayır| C
    D -->|Evet| E[gereksinim_analizi.md]
    E --> F[Frontend'e geç]
```

**Kurallar:**
- ❌ `frontend/` veya `backend/` klasörü **AÇILMAZ**
- ✅ Tek dosya: `docs/analiz_master.md`
- ✅ Checkbox takip: `- [ ]` → `- [x]`
- ✅ IDE yorumları: `<!-- YANIT: ... -->`

### Faz 2: Frontend (Dummy Data)

```mermaid
graph TD
    A[Analiz Onaylandı] --> B[frontend/ klasörü oluştur]
    B --> C[Docker Compose<br/>React/Next.js]
    C --> D[UI Bileşenleri<br/>Dummy Data ile]
    D --> E{Frontend<br/>%100 tamamlandı mı?}
    E -->|Hayır| D
    E -->|Evet| F[Backend'e geç]
```

**Kurallar:**
- ✅ `docker-compose.yml` ile izole ortam
- ✅ %100 dummy data (mock API)
- ❌ Backend'e **DOKUNULMAZ**

### Faz 3: Backend (Gerçek Veri)

```mermaid
graph TD
    A[Frontend Tamamlandı] --> B[backend/ klasörü oluştur]
    B --> C[Docker Compose<br/>API + DB]
    C --> D[Gerçek API<br/>Endpoints]
    D --> E[Frontend<br/>Entegrasyonu]
    E --> F[Test & Deploy]
```

**Kurallar:**
- ✅ Frontend ile aynı `docker-compose.yml`
- ✅ PostgreSQL/MongoDB container
- ✅ API dokümantasyonu

---

## 📂 Proje Klasör Yapısı

### Analiz Aşaması

```
proje-adi/
├── .agent/
│   └── rules/
├── docs/
│   └── analiz_master.md        ← Tek dosya
└── docker-compose.yml          ← Henüz yok
```

### Frontend Aşaması

```
proje-adi/
├── docs/
│   ├── analiz_master.md
│   └── gereksinim_analizi.md   ← Onaylanmış analiz
├── frontend/
│   ├── src/
│   ├── public/
│   └── Dockerfile
├── docker-compose.yml          ← Frontend container
└── .gitignore
```

### Backend Aşaması

```
proje-adi/
├── docs/
├── frontend/
├── backend/
│   ├── src/
│   ├── tests/
│   └── Dockerfile
├── docker-compose.yml          ← Frontend + Backend + DB
└── README.md
```

---

## 🔧 Yönetim Scriptleri

| Script | Amaç |
|--------|------|
| `sync-to-antigravity.ps1` | Proje → Antigravity |
| `sync-from-antigravity.ps1` | Antigravity → Proje |
| `validate-config.ps1` | Doğrulama |
| `install-team.ps1` | Ekip kurulumu |

---

## 📚 Dokümantasyon

- **[gemini/KURULUM.md](gemini/KURULUM.md)** - Kurulum + Proje Başlatma
- **[CHANGELOG.md](CHANGELOG.md)** - Versiyon geçmişi

---

## 🆘 Destek

- **Atıf Ertuğrul Kan:** atifertugrul.kan@havsanrobotik.com.tr
- **Slack:** `#antigravity-destek`

---

**🎯 Misyon:** Tüm HAVSAN ekibinin aynı standartlarda, profesyonel AI-assisted coding yapması!
