---
version: 2.6.7
name: havsan-appsscript
description: Master guide for Google Apps Script projects in HAVSAN. Enforces Dockerized Clasp usage, safety checks for deployments, and environment isolation. Use this skill when you detect `.gs`, `appsscript.json` files or when the user mentions "Apps Script" / "Clasp".
---

# 📜 HAVSAN Apps Script Uzmanlığı

Bu beceri, Google Apps Script projelerinde **Docker tabanlı geliştirme** ve **Güvenli Dağıtım** standartlarını sağlar.

## 🚨 1. DOCKER-FIRST KURALI (Anayasa)
HAVSAN ortamında yerel (local) Node.js kurulumu yoktur. Apps Script projeleri Docker içinde çalışır.

### Yasaklı ve Doğru Komutlar
| Yanlış (YASAK) | Doğru (ZORUNLU) |
| :--- | :--- |
| `clasp push` | `docker compose exec -T app npx clasp push` |
| `clasp login` | `docker compose exec app npx clasp login --no-localhost` |
| `npm install` | `docker compose exec app npm install` |

**Neden:** Kullanıcı bilgisayarında `node.exe` aramamalıyız. Her şey konteyner içinde döner.

## 🛡️ 2. GÜVENLİK VE ONAY MEKANİZMASI

### Canlıyı Koru (Push Safety)
`clasp push` komutu canlıdaki kodu değiştirdiği için kritik bir işlemdir.
- **Kural:** Kullanıcı net bir şekilde "Deploy et", "Yükle" veya "Pushla" demeden **ASLA** bu komutu kendi kendine çalıştırma.
- **Onay:** Eğer emin değilsen "Canlıya göndermek (push) istiyor musunuz?" diye sor.

## 🏗️ 3. PROJE YAPISI
Standart bir Apps Script projesi şu yapıda olmalıdır:
- `src/` -> Kodlar (`.js`, `.html`, `appsscript.json`) burada durur.
- `docker-compose.yml` -> Node.js ortamını ayağa kaldırır.
- `.clasp.json` -> Proje bağlantı ayarları.

---

## 🧩 Sık Karşılaşılan Sorunlar
1.  **"Invalid Grant" Hatası:** Token ölmüştür. Çözüm: `clasp login` (Docker içinden!).
2.  **"Node.exe not found":** Yanlışlıkla yerel komut kullandın. Docker'a dön.
