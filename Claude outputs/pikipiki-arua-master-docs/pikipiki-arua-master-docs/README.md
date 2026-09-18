# Pikipiki Arua: Master Planning & Design Package

This folder is a self-contained set of planning and design documents for the Pikipiki Arua platform, covering the Phase 1 product (boda boda ride hailing for Arua City) and the extensibility groundwork that lets it grow into a super app later without a rewrite.

## Contents, in reading order

| File | What it covers |
|---|---|
| `00_DESIGN_SYSTEM_REFERENCE.md` | The master design system and brand guidelines, as supplied, included here for reference alongside the UI/UX document. |
| `01_PRD.md` | Product Requirements Document: problem statement, goals, scope, functional and non-functional requirements, success metrics, current build status, and the super app extensibility requirements. |
| `02_TRD.md` | Technical Requirements Document: architecture, tech stack, sequence diagrams, security, and the technical design behind super app extensibility. |
| `03_BACKEND_SCHEMA.md` | The database schema exactly as implemented today, the target schema designed for super app growth, and the evolutionary migration path between them. |
| `04_IMPLEMENTATION_PLAN.md` | The phased delivery plan: Phase 1 milestones with current status, recommended near term sequencing, and the later Phase 2 super app foundation milestones. |
| `05_APP_FLOW.md` | Screen level flow diagrams for the rider app, driver app, admin console, the SOS flow, and a future super app home screen concept. |
| `06_UI_UX_DESIGN.md` | How the master design system tokens apply to Pikipiki Arua's actual screens, plus the open decision on reconciling the current dark themed build with the supplied light themed system. |

## How these documents relate to the codebase

This package is a planning and reference bundle. Nothing in it has been applied to the `pikipiki-arua` codebase yet. The codebase's own `CHANGELOG.md` and `docs/` folder remain the source of truth for what has actually shipped; `01_PRD.md` section 11 and `04_IMPLEMENTATION_PLAN.md` both summarise current build status accurately as of this package's creation date, so they can be used to orient a new contributor without needing to read the code first.

## Notes on this package

- Every document here avoids em dashes by convention.
- Diagrams are written in Mermaid syntax (flowcharts, sequence diagrams, entity relationship diagrams, state diagrams) and will render in any Markdown viewer that supports Mermaid, including GitHub.
- The super app extensibility content (in `01_PRD.md` section 9, `02_TRD.md` section 8, `03_BACKEND_SCHEMA.md` section 2, and `04_IMPLEMENTATION_PLAN.md`'s Phase 2) is explicitly a design constraint on Phase 1, not a set of features being built now. It exists so the identity model, wallet, order abstraction, and app shell do not need to be rebuilt when a second service vertical (delivery, errands, bill pay) is eventually added.
