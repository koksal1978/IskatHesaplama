# 🌙 İskat ve Fidye Hesaplama

> **Modern, Duyarlı ve Güvenilir İskat, Fidye ve Kefaret Hesap Yardımcısı**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Tests](https://img.shields.io/badge/Tests-30%2F30%20Geçti-brightgreen?logo=checkmarx&logoColor=white)](https://github.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Windows%20%7C%20iOS%20%7C%20Web-blue)]()
[![License](https://img.shields.io/badge/Lisans-MIT-green.svg)](LICENSE)

Vefat eden bir Müslümanın kazaya kalmış namaz, oruç ve yemin kefareti yükümlülüklerinin klasik fıkhi iskat usulüne göre matematiksel karşılıklarını hesaplayan, süreyi katılımcı sayısına göre dengeli devir tablosu halinde paylaştıran ve yüksek çözünürlüklü A4 afiş/PDF çıktısı sunan çok platformlu (Android, Windows, iOS, Web) Flutter uygulamasıdır.

---

## ⚠️ Dini Bilgilendirme ve Yasal Uyarı

> **“Bu uygulama yalnızca matematiksel hesaplama ve organizasyon yardımcısıdır. İskat, fidye ve kefaret uygulamalarının dini hükmü, fıkhi mahiyeti, caiz olup olmaması ve uygulanma şartları konusunda yetkili din görevlilerine veya Diyanet İşleri Başkanlığı Din İşleri Yüksek Kuruluna danışınız.”**
>
> *Uygulama herhangi bir dini fetva vermez; yalnızca kullanıcının belirlediği veya onayladığı matematiksel parametreler doğrultusunda hesaplama yapar.*

---

## ✨ Öne Çıkan Özellikler

### 1. 🎨 Zengin İslami Estetik & Duyarlı Tasarım (Material 3)
- **Renk Paleti:** Zümrüt Koyu Yeşil (`#0F4229`), Sıcak Parşömen/Krem (`#FAF7F0`), Antik Altın Sarısı (`#C5A059`) ve fildişi tonları.
- **Masaüstü & Mobil Uyumu:**
  - **Masaüstü (Windows / Web / Tablet):** Sol tarafta parametre girdileri, sağ tarafta anlık güncellenen sonuç kartları ve devir tablosunu içeren **2 kolonlu akıllı grid** düzeni.
  - **Mobil (Android / iOS):** Tek parmakla rahatça kontrol edilebilen, akıcı tek sayfa kaydırma deneyimi.

### 2. 📅 Esnek Yaş ve Süre Belirleme
- **İki Farklı Yaş Giriş Modu:**
  - *Doğum ve Ölüm Yılı:* (Örn: `1946` ve `2026` → `80` yaş)
  - *Doğrudan Yaş Girişi:* Vefat yaşını tek alanda yazabilme.
- **Cinsiyete Göre Otomatik Büluğ/Düşülen Yaş:**
  - **Erkek:** Varsayılan `12` yaş.
  - **Kadın:** Varsayılan `9` yaş.
  - **Manuel Müdahale:** Kullanıcı dilediği yaşı yazabilir (Örn: 10, 11).
  - **Tek Tıkla Sıfırlama:** "Varsayılana Dön" butonu ile cinsiyetin standart değerine anında dönüş.

### 3. 🌐 Diyanet Resmi Fitre Entegrasyonu & Çevrimdışı Bellek
- **Canlı Web Kazıma:** Diyanet İşleri Başkanlığı ve Din İşleri Yüksek Kurulu resmi sayfalarından seçilen yılın (örneğin 2026 yılı için `240 TL`) günlük fidye / fitre bedelini otomatik tespit eder.
- **Çevrimdışı Önbellek (`SharedPreferences`):** İnternet bağlantısı kesildiğinde son alınan veriyi ve yerel arşiv tablosunu kullanır.
- **Manuel Tutar:** Kullanıcı dilediği tutarı (örn. `240,50 TL`) serbestçe yazabilir; manuel giriş her zaman önceliklidir.

### 4. 🧮 Şeffaf Fıkhi Hesaplama Motoru
- **Aylık Esas Katsayılar:**
  - **Namaz Fidyesi:** `180` vakit (1 ay = 30 gün × 6 vakit) × Fitre
  - **Oruç Kefareti:** `61` gün (2 ay oruç kefareti karşılığı) × Fitre
  - **Yemin Kefareti:** `10` adet (10 fakiri doyurma karşılığı) × Fitre
- **1 Aylık Toplam:** `(180 + 61 + 10) × Fitre`
- **Genel Toplam:** `Hesaplanan Ay Sayısı × 1 Aylık Tutar`
- **Kişiselleştirilebilir Katsayılar:** Gelişmiş ayarlar menüsünden 180, 61, 10 katsayıları ve devir kişi sayısı (varsayılan 10) değiştirilebilir.

### 5. 👥 Dengeli Devir Dağılım Tablosu
- Toplam ay sayısını devire katılan kişi sayısına tam ve artık bırakmadan dağıtır.
- Örnek: `816` ay, `10` kişiye paylaştırıldığında `6 kişi × 82 defa` + `4 kişi × 81 defa` = `816 defa` devir olarak dengeli pay edilir.

### 6. 💰 Kuruş Seviyesinde Hassas Aritmetik
- Kuruş cinsinden tamsayı aritmetiği kullanılır; IEEE 754 kayan nokta (floating-point) hassasiyet kayıpları tamamen engellenmiştir.
- Türkçe para birimi standardında biçimlendirme (`49.155.840 TL`, `240,50 TL`).

### 7. 📄 Yüksek Çözünürlüklü A4 Afiş, PDF ve Paylaşım Sistemi
- **Özel A4 Tasarım (`SummaryPosterWidget`):** Referans İslami devir şeması model alınarak geliştirilen; arabesk köşe süslemeleri, akış şeması okları, 1 aylık esas hesap kutusu, altın vurgulu genel toplam bandı ve devir tablosunu tek sayfaya sığdıran estetik afiş.
- **PNG Resim Çıktısı:** `3.0x` piksel yoğunluğunda kristal netliğinde görsel üretimi.
- **A4 PDF Belgesi:** Vektörel kenar boşluklarıyla doğrudan baskıya hazır PDF üretimi.
- **Doğrudan Yazdırma:** Sistem yazdırma iletişim kutusuna (`Printing.layoutPdf`) tek tıkla gönderme.
- **Sosyal Paylaşım:** WhatsApp, Telegram, E-posta vb. uygulamalar üzerinden doğrudan paylaşım (`share_plus`).
- **Cihaza Kaydetme:** İndirilenler / Belgeler klasörüne doğrudan kaydetme.

---

## 📸 Ekran Görüntüleri ve Arayüz

| Masaüstü (2 Kolonlu Grid) | Mobil Görünüm | A4 Devir Afiş Özeti (PDF/Resim) |
|:---:|:---:|:---:|
| Girdiler + Canlı Sonuç Kartı | Akıcı Tek Sayfa Arayüz | Tezhip Motifli A4 Baskı Düzeni |

---

## 🏗️ Mimari ve Dizin Yapısı

Proje, temiz mimari (Clean Architecture) ve ayrık sorumluluk ilkeleri gözetilerek modüler bir yapıda tasarlanmıştır:

```
iskat_hesaplama/
├── android/                             # Android yerel konfigürasyonları
├── windows/                             # Windows masaüstü konfigürasyonları
├── assets/
│   └── icon/
│       └── app_icon.png                 # Uygulama logosu
├── lib/
│   ├── main.dart                        # Giriş noktası ve Material 3 teması
│   ├── controllers/
│   │   └── calculation_controller.dart  # ChangeNotifier tabanlı durum yönetimi (State)
│   ├── models/
│   │   ├── calculation_input.dart       # Yaş, cinsiyet, fitre ve katsayı girdi modeli
│   │   ├── calculation_result.dart      # Süre, ara toplamlar ve devir sonuç modeli
│   │   ├── devir_distribution.dart      # Dengeli devir paylaşım modeli
│   │   ├── fitre_info.dart              # Fitre tutarı, kaynak ve güncelleme bilgisi
│   │   └── gender.dart                  # Cinsiyet enum ve fıkhi varsayılan düşülen yaşlar
│   ├── repositories/
│   │   └── fitre_repository.dart        # SharedPreferences yerel önbellek katmanı
│   ├── screens/
│   │   └── home_page.dart               # Masaüstü grid ve mobil responsive ana ekran
│   ├── services/
│   │   ├── calculation_service.dart     # Matematiksel hesaplama ve devir dağıtım motoru
│   │   ├── export_service.dart          # PNG render, PDF derleme, yazdırma ve paylaşım servisi
│   │   └── fitre_service.dart           # Diyanet web kazıyıcı ve HTML parser servisi
│   ├── utils/
│   │   ├── constants.dart               # Renk paleti, varsayılan katsayılar ve uyarılar
│   │   ├── currency_formatter.dart      # Kuruş dönüşümü ve Türkçe para formatlayıcı
│   │   └── validators.dart              # Kapsamlı form doğrulama kuralları
│   └── widgets/
│       ├── age_input_card.dart          # Doğum/ölüm yılı ve direkt yaş giriş kartı
│       ├── calculation_result_card.dart # Hesap sonuçları, ara toplamlar ve genel toplam
│       ├── calculation_settings_card.dart # Katsayı ve devir kişi sayısı ayar kartı
│       ├── deduction_age_card.dart      # Düşülen yaş ve varsayılana dönüş kartı
│       ├── devir_table.dart             # Responsive devir dağılım tablosu
│       ├── disclaimer_card.dart         # Zorunlu dini/yasal bilgilendirme kartı
│       ├── export_dialog.dart           # Afiş önizleme, PDF/PNG/Yazdır modal penceresi
│       ├── fitre_card.dart              # Fitre bedeli, online güncelleme ve kaynak kartı
│       ├── gender_card.dart             # SegmentedButton cinsiyet seçici
│       ├── summary_card.dart            # Başlık ve karşılama kartı
│       └── summary_poster_widget.dart   # Tezhip motifli A4 tek sayfa afiş bileşeni
├── test/
│   ├── calculation_service_test.dart    # 15 adet matematiksel hesaplama ve kuruş testi
│   ├── controller_test.dart             # 6 adet reaktif durum yönetimi testi
│   ├── fitre_service_test.dart          # 6 adet HTML parser ve regex dayanıklılık testi
│   ├── poster_test.dart                 # 1 adet A4 afiş render ve sıfır-taşma testi
│   └── widget_test.dart                 # 2 adet arayüz ve masaüstü grid layout testi
└── pubspec.yaml                         # Paket bağımlılıkları ve varlık tanımları
```

---

## 🧪 Test Kapsamı ve Kalite Güvencesi

Projede **30 adet** kapsamlı birim (unit), servis, parser ve arayüz (widget) testi bulunmaktadır. Tüm testler sıfır hata ile geçmektedir:

```bash
flutter test
```

### Kapsanan Test Grupları:
1. **Matematiksel Hesaplama Testleri (`calculation_service_test.dart`):**
   - Erkek varsayılan düşülen yaş (80 - 12 = 68 yıl / 816 ay).
   - Kadın varsayılan düşülen yaş (80 - 9 = 71 yıl / 852 ay).
   - Referans senaryo tam hesaplama (816 ay × 60.240 TL = 49.155.840 TL).
   - Kadın tam hesaplama (852 ay × 60.240 TL = 51.324.480 TL).
   - Manuel düşülen yaş önceliği (Erkek 10 yaş, Kadın 11 yaş).
   - Doğum ve ölüm yılından yaş çözümleme (1946 - 2026 = 80 yaş).
   - Tek kişi ve çoklu kişi devir dağılımları (tam bölünen ve kalanlı senaryolar).
   - Kuruşlu fitre (240,50 TL) ile floating-point kayıpsız hassas hesaplama.
   - Sınır durumlar: Yaş = Düşülen yaş (0 ay, 0 TL) ve Negatif yaş koruması.
   - Para formatlayıcı (TL ve Kuruş dönüşümleri).
2. **Durum Yönetimi Testleri (`controller_test.dart`):**
   - Başlangıç varsayılanlarının doğruluğu.
   - Cinsiyet değiştiğinde otomatik düşülen yaş güncellemesi.
   - Kullanıcı manuel girdiğinde cinsiyet değişiminde manuel değerin korunması.
   - "Varsayılana Dön" fonksiyonunun çalışması.
   - Manuel fitre girişinin web verisine göre önceliği.
   - "Tümünü Sıfırla" mekanizması.
3. **HTML Parser Testleri (`fitre_service_test.dart`):**
   - 2026 yılı 240 TL ve 2025 yılı 180 TL ayrıştırma.
   - Metin içinde birden fazla TL tutarı varken doğru tutarı filtreleme.
   - Kuruşlu ve virgüllü tutar tespiti (`240,50 TL`).
   - Geçersiz HTML, boş yanıt veya bulunamayan yıl korumaları.
4. **Görsel ve Afiş Testleri (`poster_test.dart`):**
   - `SummaryPosterWidget` bileşeninin A4 boyutunda hatasız, taşmasız (RenderFlex overflow = 0) render edilmesi ve tüm metinlerin doğrulanması.
5. **Arayüz ve Grid Testleri (`widget_test.dart`):**
   - Uygulama başlatma duman testi.
   - Geniş ekranlarda (>= 900px) 2 kolonlu masaüstü grid sisteminin devreye girmesi.

---

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (sürüm ^3.12.0 veya üzeri)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code / Windows C++ Build Tools (Windows masaüstü için)

### Adım Adım Çalıştırma

```bash
# 1. Depoyu klonlayın
git clone https://github.com/kullaniciadi/iskat_hesaplama.git
cd iskat_hesaplama

# 2. Bağımlılıkları yükleyin
flutter pub get

# 3. Statik kod analizini çalıştırın (0 hata, 0 uyarı)
flutter analyze

# 4. Tüm testleri çalıştırın
flutter test

# 5. Tercih ettiğiniz platformda başlatın:
# Android için:
flutter run -d android

# Windows Masaüstü için:
flutter run -d windows

# Chrome Web için:
flutter run -d chrome
```

---

## 📦 Dağıtım ve Derleme (Build)

```bash
# Android APK üretimi:
flutter build apk --release

# Android App Bundle (Play Store):
flutter build appbundle --release

# Windows Masaüstü (.exe):
flutter build windows --release

# Web Sürümü:
flutter build web --release
```

---

## 📄 Lisans

Bu proje **MIT Lisansı** kapsamında açık kaynak olarak sunulmuştur. Detaylar için `LICENSE` dosyasına bakabilirsiniz.
