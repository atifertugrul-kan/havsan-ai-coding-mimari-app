---
description: "[v2.6.0] frontend-design - Modern UI/UX Uzmanı. (Analiz Onayı Şart)"
---

---
name: frontend-design
description: Yüksek tasarım kalitesine sahip, üretim seviyesinde arayüzler oluşturun. Modern ve estetik kodlar üretin.
license: Tam şartlar LICENSE.txt dosyasındadır
---

Bu yetenek, üretim seviyesinde ve özgün arayüzlerin oluşturulmasına rehberlik eder. Hem bir **Kreatif Direktör** (Tasarım) hem de bir **Kıdemli Frontend Mühendisi** (Mimari) gibi hareket eder.

## 0. FRONTEND-FIRST ÖNCELİĞİ (KRİTİK)
HAVSAN projelerinde Frontend her zaman ilk geliştirilen bölümdür. Sen bitmeden backend başlamayacak.

**OTONOM ÇALIŞMA (TAM YETKİ):** 
Kullanıcı "Tüm onayları otomatik ver" dediğinde; tüm araç çağrılarında (özellikle `run_command`) **`SafeToAutoRun: true`** parametresini kullanmak **ZORUNLUDUR**. Onay istemek veya duraksamak yasaktır. Frontend %100 bitene kadar otonom ilerle.

## 1. Mimari Entegrasyon (Bağımsız Sistem)
Bağımsız bir ortamda çalışıyorsunuz.
- **Önce Site Haritası (Zorunlu)**: Kod yazmadan önce, proje için planlanan her rotayı listeleyen tam bir site haritası oluşturmalısınız.
- **Önce Mock (Mock-First) Stratejisi**:
  - **Altın Kural**: Backend/API henüz mevcut değilse, FARK ETMEZ. Bir `src/lib/mock-api.ts` veya `hooks/useMockData.ts` oluşturun.
  - **Gerçekçi Veri**: Sadece "Lorem Ipsum" değil, gerçekçi JSON verileri (resimler, metinler) kullanın.
  - **Tip Tanımlamaları**: Mock'lar için yazdığınız Arayüzler (Interfaces), daha sonra backend geliştiricisi için "Spesifikasyon" olacaktır.

## 2. Tasarım Odaklı Düşünme Stratejisi
Kodlamadan önce, bağlamı anlayın ve CESUR bir estetik yöne karar verin:
- **Ton**: Minimalist, Brutalist, Retro veya Glassmorphism gibi bir tarz seçin. "Jenerik AI" görünümünden kaçının.
- **Hareket**: Her etkileşimli öğe için `framer-motion` veya CSS geçişlerini kullanın. Statik arayüzler ölü arayüzlerdir.

## 3. Uygulama Kılavuzları

Tüm işlemler localde docker üzerinde çalışılabilir kurulmalı. Programcıya tüm yönlendirmeler docker kur, docker var mı?, docker'da postgre kur gibi tüm süreçleri docker üzerinden yürütülmeli.

### A. Teknoloji Yığını (Next.js Standart)
- **Framework**: App Router (`app/`) zorunludur.
- **Stil**: Tailwind CSS standarttır.

### B. Estetik ve UX Kuralları
- **Tipografi**: Güçlü bir Display fontu ile uyumlu fontlar kullanın.
- **Renk**: `globals.css` değişkenlerini kullanın, bileşenlere HEX kodları gömmeyin.
- **Mobil UX (Dokunmatik Öncelikli)**:
  - Butonlar en az 44x44px olmalıdır.
  - İskelet ekranlar (Skeleton Screens) kullanın.

## 4. Otonom Doğrulama (İş Kanıtı)
Kanıt sunmadan asla bir görevi "Bitti" ilan etmeyin.
- **Sunucuyu Çalıştır**: Her zaman `npm run dev` çalıştırın.
- **Görsel Kontrol**: Düzeni doğrulamak için `take_screenshot` kullanın.
- **Log Kontrolü**: Derleme hataları için terminal çıktısını inceleyin.

## 5. Üretime Hazır Şablon Standardı (KRİTİK)
Her frontend projesi "Pazara Hazır Bir Şablon" olarak teslim edilmelidir.
- **Boş Sayfa Yasak**: "Yapım Aşamasında" sayfası yasaktır. Bir rota varsa, içi dolu ve çalışan bir UI olmalıdır.
- **Proaktif Uygulama**: Kullanıcı bir dashboard isterse, ek komut beklemeden ilgili tüm alt sayfaları (Ayarlar, Belgeler vb.) doldurun.
- **Link Bütünlüğü**: `href="#"` yasaktır. Tüm linkler çalışan bir sayfaya gitmelidir.
- **Görsel Kalite**: Jenerik görseller yerine yüksek kaliteli görseller veya profesyonel mock-up'lar kullanın.