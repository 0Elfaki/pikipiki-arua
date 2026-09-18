# UI/UX Design

Companion to 05_APP_FLOW.md. This document applies the master design system (see `00_DESIGN_SYSTEM_REFERENCE.md` in this package, the design tokens supplied for the platform) to Pikipiki Arua's actual screens, and sets out how the visual language extends to a future super app home screen without a redesign.

---

## 1. Design System Reference

The full token set (colors, typography, spacing, radius, shadows, component rules) is provided in `00_DESIGN_SYSTEM_REFERENCE.md`, included in this package as supplied. Summary of the tokens most relevant to the mobile apps:

- **Primary:** `#1D5FE0` (blue) at roughly 55 percent visual weight: navigation, primary buttons, route lines.
- **Secondary:** `#FFC107` (yellow) at roughly 25 percent: vehicle markers, interactive highlights, tying back to the physical "boda" visibility association.
- **CTA/Alert:** `#E63946` (red) at roughly 10 percent: cancel, SOS, destructive actions.
- **Soft accent:** `#FF6F91` (pink) at roughly 10 percent: promos, favourites.
- **Surfaces:** off white background `#F8F9FA`, white cards `#FFFFFF`, light gray inputs `#F3F4F6`, gray borders `#E5E7EB`.
- **Text:** near black `#111827` primary, medium gray `#6B7280` secondary, `#9CA3AF` disabled.
- **Status:** success `#10B981`, warning `#F59E0B`, error `#E63946`, info `#1D5FE0`.
- **Type:** Inter for the mobile apps, an 8 point spacing scale, 8 to 24px corner radius with a 999px pill for primary actions, and a three tier elevation system.

### 1.1 Open decision: reconciling with the current build

The rider and driver apps as built today use a dark themed UI (a dark background, amber/gold accents, green for positive actions, red for destructive ones), not the light, blue dominant "Trust Led" direction specified in the master design system above. This is flagged here as an open decision, not resolved in this document: per the earlier agreement, no visual token changes are being applied to the codebase until all planning files are finalised. When implementation begins, one of two paths should be chosen deliberately:

1. Adopt the master design system's light theme as specified, retiring the current dark theme, or
2. Keep a dark theme as the primary mobile experience for daylight outdoor legibility (a real constraint for a driver in direct sun, called out in PRD.md's accessibility requirement) and treat the master design system's palette as the canonical **brand** and **web/admin** palette, with a documented dark mode variant derived from the same hue family (blue primary, amber/yellow secondary, red alert) for the two mobile apps.

Path 2 is worth serious consideration given the existing accessibility requirement for outdoor daylight legibility on the driver app specifically, but the decision belongs to whoever owns the brand, not to this document.

## 2. Rider App Screens

### 2.1 Login / OTP
- Centered vertical layout: brand mark, headline, phone input, primary action button.
- Primary input uses the "Input Fields" token (`#F3F4F6` fill, no visible border until focused), 56px height per the mobile input height spec.
- Primary action button: pill shaped (999px radius), primary color fill, inverted white text, per the Buttons and Corner Radius sections of the design system.
- OTP entry re-uses the same layout with a 4 cell numeric input; a "resend" text action sits below, styled as a secondary/tertiary action, not a second primary button.

### 2.2 Home / booking screen
- A full bleed map background (the vector map style described in the design system's Assets and Media section: muted silver/gray roads, default POIs off, so the route line and vehicle markers stand out).
- A bottom sheet (24px top corner radius, Elevation 3 overlay shadow, a 32x4px drag handle) holding: pickup stage selector, dropoff stage selector, fare display, payment method selector, and the primary "Request" button.
- Each stage selector is a compact row using the sm (16px) spacing unit between icon, label, and chevron.
- The fare figure uses the Title 2 (Fares/Timers) type style specifically, 18px SemiBold with tabular figures enabled, so the number does not visually jitter as it recalculates.
- Map markers follow the design system's map marker spec: a pulsing primary colored dot for the rider's own position, secondary (yellow) icons for boda markers, and dark squares for pickup/dropoff points.

### 2.3 Active trip screen (dispatch and live trip)
- A status card at the top communicates the current dispatch state in plain language ("Looking for the nearest available boda", "Confirming with the nearest boda driver", "Your boda is on the way"), using Title 1 weight so it reads at a glance without requiring the rider to parse a technical status word.
- The matched driver card appears only once a real match exists (see APP_FLOW.md section 1.3); until then a lower emphasis placeholder row is shown rather than an empty space, so the layout does not visually jump when the match arrives.
- The driver card layout: avatar/photo circle, name (Title 2), vehicle and plate (Secondary text weight, tagged in the secondary/yellow accent color to visually tie to the physical vehicle branding), rating with a star glyph, and a call action icon button using the success color.
- Route/fare summary card below uses the same list pattern as the booking sheet for visual consistency between "before" and "during" a trip.
- The cancel action is a full width outlined button using the CTA/Alert red, never a filled red button, so it reads as available but not falsely urgent.

### 2.4 Profile
- Standard list of account rows (name, phone, language, saved landmarks, sign out) on the card surface color, dividers using the Borders/Dividers token.

## 3. Driver App Screens

### 3.1 Login (demo identity today, real OTP planned)
- Same layout pattern as the rider login for brand consistency, with driver specific copy ("Arua City Boda Boda Operator Portal").

### 3.2 Radar / online status screen
- A large circular status visualizer is the focal point: outlined in a neutral tone while offline, filled with the success/positive color and a radar icon once online. This is the single most important piece of state on the screen and should dominate the visual hierarchy accordingly.
- A stats bar (today's earnings, completed rides) sits above the visualizer using the Web/Admin style data presentation pattern adapted to mobile: tabular figures, secondary text labels above the numbers.
- The go online/offline action is a full width, high contrast button that swaps between the success color (go online) and the alert color (go offline), never ambiguous about which state a tap will produce.
- **Incoming offer modal:** a high emphasis overlay (dark scrim per Mobile Shadows' Elevation 3 logic, though here used as a modal backdrop rather than a bottom sheet edge), a two amber bordered card, fare shown prominently in Display/Hero weight, route summary below, and two actions: a secondary "Decline" (outlined, alert color) and a primary "Accept" (filled, success color, weighted 2:1 wider than decline to make the desired action the larger target without removing the option to decline).

### 3.3 Active navigation / trip lifecycle
- A single, large, unambiguous primary action button drives the entire lifecycle ("Arrived at Pickup Stage" to "Start Trip" to "Complete Trip & Collect Fare"), always in the same position, so a driver glancing at the phone while stationary in traffic can act without hunting for a control. This directly serves the "driver cognitive load in traffic" friction point identified in product research: big type, minimal text, one clear action.
- Passenger details card mirrors the rider app's driver card pattern for visual symmetry between the two apps.
- The fare collection summary uses the same Title 2/tabular figures treatment as the rider app's fare display.

### 3.4 Earnings
- A data forward screen: today/weekly totals in Display weight, a breakdown by payment method using the same list row pattern used elsewhere, and a commission remittance action styled as a secondary button, not a primary one, since it is an important but not the most frequent action on this screen.

## 4. Admin / Control Centre (web, planned)

Follows the design system's Web UI section directly: a fixed 260px sidebar (white, 1px right border, active item highlighted with a tinted primary background and primary text), 32px page padding, 24px widget padding, 12px radius on metric cards and table containers, 48px table row heights with horizontal only dividers, and status badges using light background/dark text pairs (for example a driver's "Active" status in a light green background with a dark green label, per the design system's example).

The live map component reuses the same marker language as the mobile apps (primary blue route lines, yellow vehicle markers) so an operator watching the admin map and a rider watching their own trip see a visually consistent representation of the same event.

## 5. Interaction and Motion Principles

- Prefer state changes that are communicated through color and copy together, never color alone (a colorblind accessible pattern), especially for the online/offline toggle and dispatch status messaging.
- Any screen that depends on a realtime update (dispatch status, incoming offers, live driver location) should show a lightweight, continuously visible "live" indicator (a subtle pulsing dot or icon) so the rider or driver has confidence the screen is not frozen, particularly important given the product's intermittent connectivity constraint.
- Loading and searching states use the primary color's radar/pulse motif consistently across both apps (already the visual metaphor chosen for the driver's "scanning" state and the rider's "matching" state) rather than a generic spinner, reinforcing the platform's core mental model of "we are actively looking for a nearby boda."

## 6. Extending to a Super App Home Screen (design reference only, not built now)

This section exists to keep today's UI decisions compatible with PRD.md section 9 and TRD.md section 8.5. It is not a Phase 1 deliverable.

- The rider app's current home screen presents exactly one primary action (request a boda). To extend it later without a redesign, that single action should be modeled internally as one entry in a small, ordered list of "service tiles," even though only one tile exists today.
- A future super app home screen would present these tiles as a horizontal row or a compact grid above or alongside the existing map/booking surface, each tile using the same card, radius, and elevation tokens as the rest of the design system, so a second tile (for example "Send a Parcel") looks like it always belonged, not like a bolted on feature.
- A single wallet and profile entry point (per the generic wallet model in BACKEND_SCHEMA.md section 2) should be reserved in the navigation structure now, even while it only ever shows ride related activity, so introducing a second service's transactions into the same wallet view later is a data change, not a navigation restructure.

## 7. Related Documents

- `00_DESIGN_SYSTEM_REFERENCE.md` for the full token set as supplied.
- 05_APP_FLOW.md for the screen sequences this document styles.
- 01_PRD.md section 9 and 02_TRD.md section 8 for the extensibility reasoning behind section 6 above.
