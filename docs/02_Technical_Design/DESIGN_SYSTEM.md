# Taxi Platform Master Design System & Brand Guidelines

This document outlines the design tokens and component rules for the entire taxi platform ecosystem, including the rider/driver mobile apps, the marketing website, and the web-based admin dashboard.

---

## 1. Core Brand Strategy: The Dual Approach

*   **Digital UI (Trust-Led):** Blue-dominant to reduce eye strain, establish trust, and ensure high accessibility.
*   **Physical Branding (Cab-Bright):** Yellow-dominant for maximum street visibility on cars, vests, and billboards.

---

## 2. Global Color Palette

These colors remain strictly consistent across all mobile and web platforms.

### Brand Colors
*   **Primary (55%):** `#1D5FE0` (Blue) — App navigation, primary buttons, map route lines, active sidebar states.
*   **Secondary (25%):** `#FFC107` (Yellow) — Driver vehicle markers, physical car decals, interactive highlights.
*   **CTA / Alert (10%):** `#E63946` (Red) — Cancel ride, SOS buttons, destructive admin actions.
*   **Soft Accent (10%):** `#FF6F91` (Pink) — Promo banners, favorite locations.

### Shared Neutrals & Surfaces
*   **App/Web Background:** `#F8F9FA` (Off-white, sits behind maps and admin pages)
*   **Surface / Cards:** `#FFFFFF` (Pure white for mobile bottom sheets, admin widgets, web cards)
*   **Input Fields:** `#F3F4F6` (Light gray for search bars and admin filters)
*   **Borders / Dividers:** `#E5E7EB` (Thin gray for list separators and table rows)

### Typography Colors
*   **Primary Text:** `#111827` (Near-Black for headings and crucial data)
*   **Secondary Text:** `#6B7280` (Medium Gray for subtitles, timestamps, and table headers)
*   **Disabled / Placeholder:** `#9CA3AF`
*   **Inverted Text:** `#FFFFFF` (Text inside Primary Blue buttons)

### System & Status Colors
*   **Success:** `#10B981` (Completed rides, confirmed payments)
*   **Warning:** `#F59E0B` (Surge pricing, pending approvals)
*   **Error:** `#E63946` (Failed transactions, system errors)
*   **Info:** `#1D5FE0` (General banners, tooltips)

---

## 3. Typography Rules

### Mobile App (iOS & Android)
*   **Font Family:** Inter (or Native SF Pro/Roboto)
*   **Display / Hero:** 28px, Bold (700), Line Height 34px, Tracking -0.4px
*   **Title 1:** 22px, SemiBold (600), Line Height 28px, Tracking -0.3px
*   **Title 2 (Fares/Timers):** 18px, SemiBold (600), Line Height 24px, Tabular Figures enabled
*   **Body (Primary):** 15px, Regular (400), Line Height 20px
*   **Button / Callout:** 16px, SemiBold (600), Line Height 20px
*   **Caption:** 13px, Regular (400), Line Height 16px
*   **Micro Tag:** 11px, SemiBold (600), Uppercase, Tracking +0.4px

### Web (Website & Admin Dashboard)
*   **Marketing Headers (Website):** Montserrat, 56px, Bold, Line Height 64px, Tracking -1px
*   **Section Titles (Website):** Montserrat, 32px, SemiBold, Line Height 40px
*   **Page Headers (Admin):** Inter, 24px, SemiBold, Line Height 32px
*   **Body Text (Web):** Inter, 16px, Regular, Line Height 24px
*   **Data Tables (Admin):** Inter, 14px, Regular, Line Height 20px, Tabular Figures enabled for all numbers

---

## 4. Spacing & Grid System (8-Point Grid)

### Mobile Spacing
*   **xxs (4px):** Icon to text distance inside chips.
*   **xs (8px):** Tightly related items (Title and subtitle).
*   **sm (16px):** Default screen margin and card padding.
*   **md (24px):** Separation between scrolling list sections.
*   **lg (32px):** Top margin above main call-to-actions.

### Web Spacing
*   **Admin Sidebar:** Fixed 260px width.
*   **Admin Page Padding:** 32px standard margins around the content area.
*   **Web Card Padding:** 24px inside admin widgets and data tables.
*   **Website Section Spacing:** 96px or 128px vertical gap between marketing sections.
*   **Input Heights:** 40px (Admin filters), 48px (Website lead forms), 56px (Mobile App inputs).

---

## 5. Corner Radius (Border Radius)

### Mobile UI
*   **8px:** Form inputs, search bars, small status tags.
*   **16px:** Vehicle selection cards, promo banners.
*   **24px:** Top corners of the main Bottom Sheet over the map.
*   **999px (Pill):** Primary Action buttons, Floating Action Buttons (FABs).

### Web UI
*   **2px:** Checkboxes, small admin status tags.
*   **6px:** Standard web buttons, dropdowns, web input fields.
*   **12px:** Admin metric cards, data table containers.
*   **24px:** Large website hero images.

---

## 6. Shadows & Elevation

### Mobile Shadows
*   **Elevation 1 (Resting):** `0px 2px 8px rgba(17, 24, 39, 0.04)` — Ride option cards.
*   **Elevation 2 (Floating):** `0px 4px 16px rgba(17, 24, 39, 0.08)` — Map FABs, back arrows.
*   **Elevation 3 (Overlay):** `0px -4px 24px rgba(17, 24, 39, 0.12)` — Bottom Sheet top edge.

### Web Shadows
*   **Base (Cards):** `0px 4px 12px rgba(17, 24, 39, 0.04)` — Admin dashboard widgets.
*   **Hover State:** `0px 12px 24px rgba(17, 24, 39, 0.08)` — Clickable table rows or web buttons.
*   **Dropdown/Modal:** `0px 20px 40px rgba(17, 24, 39, 0.12)` — Floating navigation menus, admin modals.

---

## 7. Component Library Guidelines

### Buttons (Universal)
*   **Primary:** Background `#1D5FE0`, Text `#FFFFFF`.
*   **Secondary:** Background `#F3F4F6`, Text `#111827`.
*   **Disabled:** Background `#E5E7EB`, Text `#9CA3AF`.

### Mobile Specifics
*   **Bottom Sheet:** `#FFFFFF` background, 24px top radius, 32x4px drag handle (`#E5E7EB`).
*   **Map Markers:** `16px` `#1D5FE0` user dot with pulsing aura. `#FFC107` car icons. `#111827` pickup/dropoff squares.

### Web Specifics
*   **Admin Sidebar:** `#FFFFFF` background, 1px right border (`#E5E7EB`). Active items: `#EFF4FD` background with `#1D5FE0` text.
*   **Data Tables:** 48px row heights. No vertical borders. 1px horizontal border (`#F3F4F6`). Primary actions right-aligned.
*   **Status Badges (Web):** Light backgrounds with dark text. (e.g., Active: `#D1FAE5` bg / `#065F46` text).

---

## 8. Assets & Media

*   **Icons:** Stroke-based (2px thickness), rounded terminals, drawn on a 24x24px bounding box. Ensure visual weight consistency between mobile and web.
*   **Map Style:** Custom JSON. Terrain/roads must be muted silver/gray (`#F3F4F6`) and light green. Default POIs turned off to ensure Primary Blue route lines and Yellow car markers stand out without visual clutter.
