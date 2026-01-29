# 🔧 Setup Kont dla Postiz - HardbanRecordsLab Social Media Planner

Kompletny przewodnik krok po kroku do założenia wszystkich wymaganych kont dla projektu **HardbanRecordsLab Social Media Planner**.

---

## 📋 Przegląd - Co Będziesz Potrzebować

| Serwis | Cel | Koszt | Email |
|--------|-----|-------|-------|
| **Neon.tech** | PostgreSQL (2 bazy) | $0 (free) | Twój email |
| **Upstash.com** | Redis cache | $0 (free) | Twój email |
| **Cloudflare** | R2 Storage (pliki) | $0 (10GB free) | Twój email |
| **Hugging Face** | Hosting aplikacji | $9/m (PRO) | Twój email |

**Czas setup**: ~20-30 minut

---

## 1️⃣ Neon.tech - PostgreSQL Database

### Krok 1: Rejestracja

1. Otwórz: https://neon.tech
2. Kliknij **"Sign Up"** (prawy górny róg)
3. Wybierz metodę rejestracji:
   - ✅ **GitHub** (zalecane - szybsze)
   - lub Email + hasło

**Dane do rejestracji**:
```
Metoda: GitHub (zalecane)
lub
Email: [twój-email@domena.com]
Password: [minimum 8 znaków, 1 wielka, 1 cyfra]
```

### Krok 2: Pierwsza Baza (Main Database)

Po zalogowaniu:

1. **Create a project** pojawi się automatycznie
2. Wypełnij formularz:

```yaml
Project name: hardbanrecordslab-postiz-main
Database name: postiz_db
Region: Europe (Frankfurt) - lub najbliższy
PostgreSQL version: 16 (domyślne)
```

3. Kliknij **"Create project"**
4. **WAŻNE**: Skopiuj connection string!

**Connection String Format**:
```
postgresql://[username]:[password]@[host]/[database]?sslmode=require
```

**Zapisz jako**:
```bash
# Neon Database #1 - Main Database
DATABASE_URL="postgresql://username:password@ep-xyz-123.eu-central-1.aws.neon.tech/postiz_db?sslmode=require"
```

### Krok 3: Druga Baza (Temporal Database)

1. W dashboardzie kliknij: **Projects** → **New Project**
2. Wypełnij:

```yaml
Project name: hardbanrecordslab-temporal
Database name: temporal_db
Region: Europe (Frankfurt) - TEN SAM co poprzednio!
PostgreSQL version: 16
```

3. Kliknij **"Create project"**
4. Skopiuj drugi connection string:

```bash
# Neon Database #2 - Temporal Database
TEMPORAL_DATABASE_URL="postgresql://username:password@ep-abc-456.eu-central-1.aws.neon.tech/temporal_db?sslmode=require"
```

### ✅ Checklist Neon

- [ ] Konto założone
- [ ] Projekt 1: `hardbanrecordslab-postiz-main` utworzony
- [ ] Projekt 2: `hardbanrecordslab-temporal` utworzony
- [ ] Oba connection stringi zapisane
- [ ] Region: Europe (Frankfurt) dla obu

---

## 2️⃣ Upstash.com - Redis Cache

### Krok 1: Rejestracja

1. Otwórz: https://upstash.com
2. Kliknij **"Get Started"** lub **"Sign Up"**
3. Wybierz metodę:
   - ✅ **GitHub** (zalecane)
   - lub Email

**Dane do rejestracji**:
```
Metoda: GitHub
lub
Email: [twój-email@domena.com]
Full Name: HardbanRecordsLab
Company: HardbanRecordsLab (opcjonalne)
```

### Krok 2: Tworzenie Redis Database

Po zalogowaniu zobaczysz dashboard:

1. Kliknij **"Create Database"** (zielony przycisk)
2. Wypełnij formularz:

```yaml
Database Name: hardbanrecordslab-redis
Type: Regional (domyślne - FREE)
Region: Europe (Frankfurt) - najbliższy HF
Primary Region: eu-central-1 (Frankfurt)
Read Regions: (zostaw puste dla free tier)
Eviction: ✅ No eviction (zalecane)
TLS: ✅ Enabled (domyślne)
```

3. Kliknij **"Create"**

### Krok 3: Pobieranie Connection String

Po utworzeniu bazy:

1. Kliknij na nazwę bazy: **hardbanrecords-redis**
2. Przejdź do zakładki **"Details"**
3. Znajdź sekcję **"REST API"** lub **"Redis URL"**
4. Skopiuj **Connection String**

**Będą 2 formaty, użyj Redis URL**:

```bash
# Upstash Redis
REDIS_URL="redis://default:[password]@[host].upstash.io:6379"

# Przykład:
REDIS_URL="redis://default:AXxxx...xxxxGbg==@eu1-polished-bird-12345.upstash.io:6379"
```

### Dodatkowe Informacje

W zakładce Details znajdziesz też:
- **Endpoint**: `eu1-polished-bird-12345.upstash.io`
- **Port**: `6379` (Redis) lub `6380` (TLS)
- **Password**: Długi token

**WAŻNE**: Użyj **"REDIS_URL"** (format `redis://...`), nie REST API URL!

### ✅ Checklist Upstash

- [ ] Konto założone
- [ ] Database: `hardbanrecordslab-redis` utworzona
- [ ] Region: Europe (Frankfurt)
- [ ] Connection string (REDIS_URL) skopiowany
- [ ] TLS enabled

---

## 3️⃣ Cloudflare - R2 Storage

### Krok 1: Rejestracja Cloudflare

1. Otwórz: https://dash.cloudflare.com/sign-up
2. Wypełnij formularz:

```yaml
Email: [twój-email@domena.com]
Password: [silne hasło, min 8 znaków]
```

3. **Weryfikuj email** (sprawdź skrzynkę)
4. Zaloguj się: https://dash.cloudflare.com

### Krok 2: Aktywacja R2

Po zalogowaniu:

1. W lewym menu znajdź **"R2"** (ikona chmurki)
   - Jeśli nie widzisz, kliknij hamburger menu (≡)
2. Kliknij **"Purchase R2 Plan"**
3. Wybierz **"Free"** (10GB included)
4. **NIE MUSISZ** podawać karty kredytowej dla free tier!
5. Potwierdź plan

### Krok 3: Tworzenie Bucketu

1. W dashboardzie R2 kliknij **"Create bucket"**
2. Wypełnij:

```yaml
Bucket name: hardbanrecordslab-postiz-uploads
Location: Automatic (zalecane) lub Europe
Storage class: Standard (domyślne)
```

3. Kliknij **"Create bucket"**

**WAŻNE**: Bucket name musi być **globalnie unikalny**! Jeśli `hardbanrecordslab-postiz-uploads` jest zajęte, użyj:
- `hardbanrecordslab-uploads-2026`
- `hbrl-postiz-media`
- `hbr-lab-social-media`
- lub dodaj losowe cyfry

### Krok 4: Tworzenie API Token

1. W dashboardzie R2, kliknij zakładkę **"Settings"** (górne menu)
2. Przewiń do sekcji **"R2 API Tokens"**
3. Kliknij **"Create API Token"**
4. Wypełnij formularz:

```yaml
Token name: hardbanrecordslab-postiz-token
Permissions: 
  ✅ Object Read & Write
  ✅ Admin (lub tylko Object Read & Write)
TTL: Forever (bez wygaśnięcia)
Bucket restrictions: 
  ◉ Apply to specific buckets
  → hardbanrecordslab-postiz-uploads
```

5. Kliknij **"Create API Token"**

### Krok 5: Zapisz Credentials

**UWAGA**: Te dane pokażą się **TYLKO RAZ**! Zapisz je teraz:

```bash
# Cloudflare R2 Credentials
CLOUDFLARE_ACCOUNT_ID="abc123def456..."  # 32-znakowy hash
CLOUDFLARE_ACCESS_KEY="xyz789abc..."      # Access Key ID
CLOUDFLARE_SECRET_ACCESS_KEY="longtokenhashhere..."  # Secret Access Key
CLOUDFLARE_BUCKETNAME="hardbanrecordslab-postiz-uploads"
```

### Krok 6: Bucket URL

1. Wróć do **R2** → **Buckets**
2. Kliknij na swój bucket: **hardbanrecords-postiz-uploads**
3. W sekcji **"Bucket Details"** znajdź **"S3 API"**
4. Skopiuj **Endpoint URL**

Format będzie podobny do:
```
https://abc123.r2.cloudflarestorage.com
```

**Ostateczny Bucket URL**:
```bash
CLOUDFLARE_BUCKET_URL="https://[account-id].r2.cloudflarestorage.com/hardbanrecordslab-postiz-uploads/"
CLOUDFLARE_REGION="auto"
```

### ✅ Checklist Cloudflare

- [ ] Konto Cloudflare założone i zweryfikowane
- [ ] R2 aktywowane (free plan)
- [ ] Bucket: `hardbanrecordslab-postiz-uploads` utworzony
- [ ] API Token utworzony z Object Read & Write
- [ ] Account ID zapisany
- [ ] Access Key zapisany
- [ ] Secret Access Key zapisany
- [ ] Bucket URL zapisany

---

## 4️⃣ Hugging Face - Hosting (Opcjonalnie teraz)

### Quick Setup (możesz zrobić później)

1. Otwórz: https://huggingface.co/join
2. Wypełnij:

```yaml
Username: hardbanrecordslab (lub inna unikalna nazwa)
Email: [twój-email@domena.com]
Password: [silne hasło]
```

3. Weryfikuj email
4. **Upgrade do PRO** (później, przed deploymentem):
   - Settings → Billing → Subscribe to PRO ($9/m)

---

## 📝 Zsumowanie - Wszystkie Credentials

Po skonfigurowaniu wszystkich kont, powinieneś mieć:

```bash
# ============================================
# NEON POSTGRESQL
# ============================================
DATABASE_URL="postgresql://user:pass@ep-xyz-123.eu-central-1.aws.neon.tech/postiz_db?sslmode=require"
TEMPORAL_DATABASE_URL="postgresql://user:pass@ep-abc-456.eu-central-1.aws.neon.tech/temporal_db?sslmode=require"

# ============================================
# UPSTASH REDIS
# ============================================
REDIS_URL="redis://default:AXxxx...xx==@eu1-hash-12345.upstash.io:6379"

# ============================================
# CLOUDFLARE R2
# ============================================
CLOUDFLARE_ACCOUNT_ID="abc123def456..."
CLOUDFLARE_ACCESS_KEY="xyz789abc..."
CLOUDFLARE_SECRET_ACCESS_KEY="longsecrettoken..."
CLOUDFLARE_BUCKETNAME="hardbanrecordslab-postiz-uploads"
CLOUDFLARE_BUCKET_URL="https://abc123.r2.cloudflarestorage.com/hardbanrecordslab-postiz-uploads/"
CLOUDFLARE_REGION="auto"

# ============================================
# INNE (WYGENERUJ LOKALNIE)
# ============================================
# Wygeneruj JWT Secret:
# W terminalu: openssl rand -base64 64
JWT_SECRET="[64+ znakowy losowy string]"
```

---

## 🔐 Generowanie JWT Secret

W terminalu Windows (PowerShell):

```powershell
# Metoda 1: Użyj OpenSSL (jeśli zainstalowane)
openssl rand -base64 64

# Metoda 2: PowerShell (built-in)
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})

# Metoda 3: Online generator
# https://generate-secret.vercel.app/64
```

Skopiuj wynik jako `JWT_SECRET`.

---

## 🎯 Następne Kroki

Po uzyskaniu wszystkich credentials:

1. ✅ Otwórz `.env.hf.example` w folderze `postiz-app-main`
2. ✅ Skopiuj go jako nowy plik (możesz nazwać `.env.local`)
3. ✅ Wypełnij wszystkie zmienne z tego dokumentu
4. ✅ Przejdź do `HF_DEPLOYMENT.md` i follow deployment steps

---

## ⚠️ Ważne Zasady Bezpieczeństwa

### 🔒 Credentials Security

- ❌ **NIE** commituj credentials do Git
- ❌ **NIE** udostępniaj publicznie
- ✅ Trzymaj credentials lokalnie lub w HF Secrets
- ✅ Używaj `.gitignore` dla `.env` files

### 📊 Free Tier Limits

**Neon PostgreSQL**:
- ✅ 2 projekty free
- ✅ 512MB storage per project
- ✅ 100 hours compute/month (wystarczy!)

**Upstash Redis**:
- ✅ 10,000 commands/day
- ✅ 256MB storage
- ✅ Unlimited databases (regional)

**Cloudflare R2**:
- ✅ 10GB storage
- ✅ 1M Class A operations/month
- ✅ 10M Class B operations/month

**WNIOSEK**: Free tiers wystarczą dla małego/średniego projektu!

---

## 🆘 Troubleshooting

### Problem: "Bucket name already taken"
**Rozwiązanie**: Dodaj unikalny suffix:
- `hardbanrecordslab-uploads-2026`
- `hbrl-postiz-media-prod`
- `postiz-hbrl-[twoje-inicjały]`

### Problem: "Region not available"
**Rozwiązanie**: Wybierz najbliższy dostępny:
- Europe: Frankfurt, Amsterdam, London
- US: Virginia, Oregon

### Problem: "Cannot create API token"
**Rozwiązanie**: 
- Upewnij się że R2 plan jest aktywowany
- Poczekaj 5 minut po aktywacji planu
- Wyloguj i zaloguj ponownie

### Problem: "Connection string not working"
**Rozwiązanie**:
- Sprawdź czy skopiowałeś CAŁY string (z hasłem)
- Neon: Musi kończyć się `?sslmode=require`
- Redis: Musi zaczynać się `redis://`

---

## ✅ Final Checklist

Przed przejściem do deploymentu upewnij się że masz:

- [ ] Neon: 2 bazy PostgreSQL (main + temporal)
- [ ] Upstash: 1 Redis database
- [ ] Cloudflare: 1 R2 bucket + API credentials
- [ ] Wszystkie connection strings zapisane
- [ ] JWT_SECRET wygenerowany (64+ znaków)
- [ ] Credentials skopiowane do `.env.local`
- [ ] Free tiers aktywowane i działające

**Następny krok**: Otwórz `HF_DEPLOYMENT.md` i rozpocznij deployment! 🚀

---

**Projekt**: HardbanRecordsLab Social Media Planner  
**Data setup**: 29 stycznia 2026  
**Status**: Ready for deployment ✅
