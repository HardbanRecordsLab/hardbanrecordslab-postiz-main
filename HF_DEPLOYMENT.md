# 🚀 Hugging Face PRO Deployment Guide

Gotowe pliki do wdrożenia Postiz na Hugging Face Spaces PRO ($9/miesiąc).

## 📋 Wymagania

- Konto Hugging Face PRO ($9/m)
- Konto Neon.tech (darmowe PostgreSQL)
- Konto Upstash.com (darmowy Redis)
- Konto Cloudflare (darmowe R2 storage)

## ⚡ Szybki Start (5 kroków)

### 1. Przygotuj External Services

**PostgreSQL (Neon.tech)**:
```bash
# Idź na https://neon.tech
# Stwórz projekt → Zapisz DATABASE_URL
```

**Redis (Upstash)**:
```bash
# Idź na https://upstash.com
# Stwórz Redis DB → Zapisz REDIS_URL
```

**Storage (Cloudflare R2)**:
```bash
# Idź na https://dash.cloudflare.com
# R2 → Create bucket "postiz-uploads"
# Manage R2 API Tokens → Create token
# Zapisz: Account ID, Access Key, Secret Key
```

### 2. Stwórz HF Space

1. Idź na https://huggingface.co/spaces
2. Create new Space:
   - Name: `postiz-app`
   - SDK: **Docker**
   - Hardware: **Persistent** → Upgrade to **PRO** 
3. Zapisz URL przestrzeni

### 3. Przygotuj Pliki

```bash
# Skopiuj Dockerfile dla HF
cp Dockerfile.hf Dockerfile

# Upewnij się że masz wszystkie pliki:
# - Dockerfile (skopiowany z Dockerfile.hf)
# - start-hf.sh (chmod +x)
# - .hfignore
# - cały kod Postiz
```

### 4. Konfiguruj Zmienne

1. Otwórz `.env.hf.example`
2. Wypełnij wymagane wartości:
   - DATABASE_URL (z Neon)
   - REDIS_URL (z Upstash)
   - JWT_SECRET (wygeneruj: `openssl rand -base64 64`)
   - Cloudflare credentials
   - URL HF Space
3. Skopiuj zmienne do HF Space → Settings → Variables

### 5. Deploy!

**Opcja A: Git Push**
```bash
git clone https://huggingface.co/spaces/YOUR_USERNAME/postiz-app
cd postiz-app
cp -r /path/to/postiz-app-main/* .
git add .
git commit -m "Deploy Postiz"
git push
```

**Opcja B: ZIP Upload**
1. Spakuj cały folder
2. Upload przez HF UI

## 📊 Monitorowanie

Po deployu:
1. Space → App → Sprawdź logi
2. Poczekaj ~5 minut na build
3. Aplikacja powinna być dostępna na: `https://your-username-postiz-app.hf.space`

## 🐛 Troubleshooting

**"Application failed to start"**
→ Sprawdź logi, upewnij się że DATABASE_URL i REDIS_URL są poprawne

**"Port 7860 not responding"**
→ Sprawdź czy `start-hf.sh` ma uprawnienia wykonywania (`chmod +x`)

**"Out of memory"**
→ Wyłącz Temporal (ustaw `TEMPORAL_ADDRESS=""`)

## 📁 Pliki w tym folderze

- **Dockerfile.hf** - Gotowy Dockerfile dla HF (skopiuj jako `Dockerfile`)
- **start-hf.sh** - Startup script (automatycznie uruchamia wszystkie serwisy)
- **.hfignore** - Wyklucza niepotrzebne pliki z uploadu
- **.env.hf.example** - Szablon zmiennych środowiskowych

## 💰 Koszty

| Serwis | Koszt |
|--------|-------|
| HF PRO | $9/m |
| Neon PostgreSQL | $0 (free tier) |
| Upstash Redis | $0 (free tier) |
| Cloudflare R2 | $0 (free 10GB) |
| **TOTAL** | **$9/m** |

## 🔗 Pomocne Linki

- [Pełna analiza projektu](../../../brain/c7cd7f7d-7761-4814-982c-00b34cdf93ca/postiz_analysis.md)
- [HF Spaces Docs](https://huggingface.co/docs/hub/spaces)
- [Postiz Documentation](https://docs.postiz.com)

---

**Pytania?** Sprawdź pełną dokumentację w pliku `postiz_analysis.md`
