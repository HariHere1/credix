# Activity Points

A Flutter mobile app for a college **activity point allocation system**. Students upload certificates to claim activity points; faculty advisors review flagged submissions, approve/correct/reject them, and sync points to the academic portal. UI-only build with hardcoded mock data (no backend).

## Objectives

- **Digitize activity-point claims**: let students submit certificates (PDF/JPG/PNG) straight from the app and track their status.
- **Automate first-pass screening**: simulate OCR extraction and auto-approve high-confidence certificates, while flagging low-confidence or mismatched ones for review.
- **Give advisors a clear review workflow**: a queue grouped by flag reason, with Approve / Correct & Approve / Reject actions and rejection reasons visible to students.
- **Make progress visible**: per-student total and group-wise point totals (Group I/II/III, max 40 each, 120 total) with animated progress.
- **Track and export**: a student directory with points, plus Excel-style export and portal-sync simulation.
- **Keep it accessible**: a restrained monochrome dark UI, DM Sans typography, section-based layouts, and friendly empty states.

## Roles

- **Student** — Certificates, Points, Account.
- **Advisor** — Review Queue, Students, Export, Account.

## Getting Started

```powershell
flutter pub get
flutter run
```

Verify with:

```powershell
flutter analyze
```

