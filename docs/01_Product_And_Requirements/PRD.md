# 📋 Product Requirements Document (PRD)

## 1. Problem Statement
In Arua City and across the West Nile sub-region, Boda Bodas are the primary lifeblood of intra-city transport and last-mile logistics. However, existing transportation relies on unstructured street-corner haggling, inconsistent pricing, safety concerns, and lack of accountability.

## 2. Platform Objectives
- **Predictable Pricing**: Fair, transparent UGX pricing using stage distance calculation.
- **Vetted Drivers**: Verification via National ID (NIN), motorcycle registration, and Stage Chairman endorsement.
- **Low Connectivity Resilience**: Support offline caching, delayed telemetry synchronization, and optional USSD fallbacks.
- **Financial Inclusion**: Direct integration with MTN MoMo & Airtel Money.

## 3. Core Functional Requirements
1. **Rider Experience**:
   - Phone number OTP authentication.
   - Stage selection / GPS pin drop on map.
   - Upfront fare estimate in UGX.
   - Realtime driver tracking with ETA.
   - Trip completion receipt & safety rating.
2. **Driver Experience**:
   - Online/Offline toggle with stage association.
   - Sound alert & countdown modal for incoming ride requests.
   - Turn-by-turn route overview.
   - Wallet balance and daily/weekly earnings summary.
