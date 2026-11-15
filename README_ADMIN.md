# Credix Admin Panel

The admin panel is a separate Flutter Web entry point for super admins, department admins and read-only auditors. It uses a small shared demo dataset (two students and seven certificates) and does not make API calls. Alex has a low score and review examples; Maria has 120 points, with 40 in each group.

## Run

```powershell
flutter run -d chrome -t lib/main_admin.dart
```

## Build

```powershell
flutter build web --target lib/main_admin.dart --base-href /credix-admin/
```

## Structure

- `lib/main_admin.dart` — admin-only application entry point.
- `lib/admin/admin_router.dart` — named routes, deep links and session guard.
- `lib/admin/admin_theme.dart` — admin colors and theme.
- `lib/admin/screens/` — login, shell, dashboard and feature screens.
- `lib/admin/widgets/` — shared cards, status pills and reason dialog.
- `lib/admin/models/` — role, user, session and audit entry models.
- `lib/admin/mock_data/` — dashboard and rulebook sample data.
- `lib/admin/data/` — repository interfaces and mock implementation.
- `lib/admin/services/audit_service.dart` — central audit log writer.

The mock login accepts any non-empty email and password. Choose a role on the sign-in screen to preview that role's permissions. `AuditService.instance` is the only write path for audit entries. The student/tutor app continues to use `lib/main.dart`.
