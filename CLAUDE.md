# Locora — Proje Yönetim Rehberi

Bu dosya, Claude Code'un her oturumda referans alması gereken proje kurallarını, stack'i ve geliştirme disiplinini içerir.

## 📋 Proje Özeti

**Locora** — Konum tabanlı, AI-destekli keşif ve plan yapma uygulaması. Kullanıcı, profiline göre kişiselleştirilmiş yerleri keşfeder, favorilere kaydeder, ve zamanı/bütçesi ile bir plan oluşturur.

---

## 🛠️ Stack (Değişmez)

### Mobil
- **Flutter** (latest stable)
- **Dart** (Flutter uyumlu latest)
- **Riverpod** (state management + dependency injection)
- **Clean Architecture** (presentation / domain / data katmanları)

### Backend
- **Supabase** 
  - PostgreSQL + PostGIS (yer verisi)
  - Supabase Auth
  - Supabase Storage
  - Supabase Edge Functions (tüm dış API entegrasyonları)

### UI/UX
- **Material 3** tasarım sistemi
- **Dark Mode** (baştan itibaren)
- **Responsive tasarım**
- **Çoklu dil** (TR/EN, genişletilebilir)

---

## 🏗️ Mimari Kurallar (Kesin)

### 1. Clean Architecture
```
feature/
  ├── presentation/
  │   ├── pages/
  │   ├── widgets/
  │   └── providers.dart (Riverpod)
  ├── domain/
  │   ├── entities/
  │   ├── repositories/ (arayüzler)
  │   └── usecases/
  └── data/
      ├── datasources/
      ├── models/
      └── repositories/ (implementasyon)
```

### 2. Feature-First Klasör Yapısı
Kod katmanlarına (presentation, domain, data) değil, özelliklere (auth, places, collections) göre organize edilir.

### 3. Riverpod ile Dependency Injection
- Tüm provider'lar feature'ın `presentation/providers.dart` içinde
- Hiçbir provider doğrudan datasource'a erişmez; repository üzerinden geçer
- State yönetimi: `StateNotifier`, `FutureProvider`, `StreamProvider`

### 4. Repository Pattern
- Presentation katmanı **hiçbir zaman** data source'ı doğrudan görmez
- Her data source, repository arayüzünün arkasında saklanır
- Repository implementasyonları dependency injection ile inject edilir

### 5. Hiçbir Gizli Bilgi Kodda Olmayacak
- Supabase URL, API Key, vb. **environment variables** (.env) üzerinden
- Tüm dış servisler (Google Places, AI, vb.) **Edge Functions** üzerinden proxy'lenir
- Client tarafında hiçbir API anahtarı bulunmayacak

### 6. Error Handling
- Custom exception sınıfları (domain katmanında)
- try-catch blokları veri katmanında
- Presentation katmanında meaningful error mesajları

---

## 📁 Monorepo Yapısı

```
locora/
├── ROADMAP.md              # Tüm fazlar (bu dosya referans olarak okunacak)
├── CLAUDE.md               # Bu dosya
├── README.md               # Proje genel bilgileri
├── .gitignore
├── mobile/                 # Flutter uygulaması
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main.dart
│   │   ├── config/
│   │   │   ├── env.dart           # Environment variables
│   │   │   ├── supabase_config.dart
│   │   │   ├── theme_config.dart  # Material 3 tema
│   │   │   └── router_config.dart # Navigation
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   ├── extensions/
│   │   │   ├── utils/
│   │   │   └── theme/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── places/
│   │   │   ├── collections/
│   │   │   ├── profile/
│   │   │   └── (diğer features)
│   │   └── l10n/               # Localization
│   │       ├── en.json
│   │       ├── tr.json
│   │       └── app_localizations.dart
│   ├── test/
│   └── android/, ios/, web/    # Platform-specific
│
├── supabase/                # Supabase backend
│   ├── migrations/          # SQL migrations
│   ├── seed.sql             # Test verileri
│   ├── functions/           # Edge Functions
│   │   ├── place-provider/  # Place API proxy
│   │   ├── ai-tagging/      # AI etiketleme
│   │   └── (diğer functions)
│   └── .env.example         # Supabase env template
│
└── docs/                    # Dokümantasyon
    ├── ARCHITECTURE.md      # Mimari derinlemesine
    ├── API.md               # Edge Functions API
    ├── LOCALIZATION.md      # Çeviri sistemi
    └── SETUP.md             # Kurulum rehberi
```

---

## 🔄 Faz Kuralları

### Temel Prensip
**Bir fazı bitirmeden bir sonrakine geçilmez.**

Her fazın:
- ✅ **Bitiş Kriteri** vardır ve karşılanmalıdır
- ✅ **Production-ready** koddur (temporary çözümler, placeholder mimariler yok)
- ✅ **Temel amacına** tamamen ulaşır
- ✅ **Sonraki fazın temelini** oluşturur

### İş Akışı
1. **Faz başında:** Yol haritadan o fazın "Yapılacaklar" ve "Bitiş Kriteri" okunur
2. **Çalışma sırasında:** Production-ready kod yazılır; hiçbir teknik borç bırakılmaz
3. **Faz sonunda:** Bitiş kriteri kontrol edilir
4. **Onay:** Eğer bitiş kriteri karşılanmışsa, bir sonraki faza geçilir

---

## ⚙️ Environment Variables

### mobile/.env (git'e commit edilmeyecek)
```
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=xxxxx
ENVIRONMENT=development
```

### supabase/.env (git'e commit edilmeyecek)
```
SUPABASE_PROJECT_ID=xxxxx
SUPABASE_PROJECT_URL=https://xxxxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=xxxxx
GOOGLE_PLACES_API_KEY=xxxxx  # Edge Functions'da kullanılacak
```

---

## 🎨 Tema Sistemi (Material 3 + Dark Mode)

- **Tema tanımı:** `mobile/lib/core/theme/app_theme.dart`
- **Light Mode:** Varsayılan Material 3 colors
- **Dark Mode:** Otomatik Material 3 dark variant
- **Responsive:** Material 3'ün built-in breakpoint sistemi
- **Font:** Satisfactory, responsive padding/sizing

Tema değişimi: Riverpod provider'ı (`themeProvider`) üzerinden

---

## 🌍 Localization Sistemi

### Dosya Yapısı
```
mobile/lib/l10n/
├── en.json       # İngilizce çeviriler
├── tr.json       # Türkçe çeviriler
└── app_localizations.dart  # Dart wrapper
```

### Kullanım
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.welcomeMessage); // context'e göre otomatik dil seçer
```

### Yeni Dil Ekleme
1. `mobile/lib/l10n/{lang_code}.json` dosyası oluştur
2. `app_localizations.dart` güncelle (dil listesine ekle)
3. Bitti

---

## 🚀 Supabase Entegrasyon

### Client (Flutter)
```dart
// Supabase istemci, supabase_config.dart'ta singleton olarak
final supabase = SupabaseClient.instance;
```

### Data Source Örneği
```dart
// Hiçbir API anahtarı burada yok; tüm çağrılar Edge Function'a gider
final response = await supabase.functions.invoke(
  'place-provider',
  body: {'lat': 41.0, 'lng': 29.0, 'radius': 1000},
);
```

### Edge Functions
- Tüm dış servisler (Google Places, AI, vb.) buradan proxy'lenir
- Supabase ve Google API anahtarları Supabase'te depolanır, client'ta değil
- Her function'ın ayrı `index.ts` dosyası

---

## 📝 Kod Standartları

### Naming Conventions
- **Dosyalar:** snake_case (auth_repository.dart)
- **Sınıflar:** PascalCase (AuthRepository)
- **Değişkenler/Fonksiyonlar:** camelCase (userProfile)
- **Constants:** UPPER_SNAKE_CASE (MAX_RETRIES)
- **Enums:** PascalCase (UserRole)

### Dokumentasyon
- Tüm public sınıf/fonksiyona /// doc comment
- Complex logic'e inline comment
- Hiçbir TODO/FIXME bırakılmaz

### Test
- Unit test: domain entities ve use cases için
- Widget test: UI bileşenleri için
- Integration test: supabase entegrasyonu için
- Test coverage: en az %70

---

## ✅ Kalite Kontrol

Her faz bitmeden önce:
1. **Bitiş Kriteri** kontrol edilir
2. **Code formatting:** `dart format .`
3. **Linting:** `flutter analyze`
4. **Build:** `flutter build apk` / `flutter build ios` hata vermez
5. **No hardcoded secrets:** Kodda API key, URL vb. yok
6. **Production-ready:** Temporary solution, placeholder mimariler yok

---

## 🔗 Referans Dökümanları

- ROADMAP.md — Tüm fazlar
- mobile/lib/core/ARCHITECTURE.md — Clean Architecture uygulaması derinlemesine
- supabase/ — Backend kurulumu

---

## 📞 İletişim ve Kurallar

- **Her faz başında:** Faz numarası, "Yapılacaklar" ve "Bitiş Kriteri" açıkça belirtilir
- **Bitince:** Özet, bitiş kriteri kontrol, ve "Onay bekliyorum" mesajı
- **Hiçbir faza geçilmez:** Bitiş kriteri karşılanmadan

---

**Son Güncelleme:** 2026-07-06  
**Versiyon:** 1.0 (Faz 0 için hazırlanmış)
