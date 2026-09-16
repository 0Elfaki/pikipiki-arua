# 🚀 Deployment Runbook

This runbook guides engineers through deploying Pikipiki Arua services.

## 1. Supabase Database & Edge Functions
```bash
# Authenticate CLI
supabase login

# Link to production project
supabase link --project-ref <PROJECT_ID>

# Push new migrations
supabase db push

# Deploy edge functions
supabase functions deploy dispatch-webhook
supabase functions deploy ussd-handler
supabase functions deploy product-image
```

## 2. Mobile App Release Builds

### Rider App
```bash
cd apps/rider_app
# Android App Bundle (AAB) for Google Play Store
flutter build appbundle --release --flavor production

# iOS Archive
flutter build ipa --release
```

### Driver App
```bash
cd apps/driver_app
flutter build appbundle --release --flavor production
```
