# 🤖 AI Development Guide — Co-Working Space Customer App

> **This file is the single source of truth for any AI assistant working on this project.**
> Send this file to the AI before starting any task so it understands the full context.

---

## 📌 Project Identity

| Key              | Value                                                                           |
| :--------------- | :------------------------------------------------------------------------------ |
| **App Name**     | `CoSpace Customer App` (Co-Working Space & Meeting Room Reservation)            |
| **Package**      | `cospace_customer`                                                              |
| **Version**      | `1.0.0+1`                                                                       |
| **Flutter SDK**  | `^3.5.3+`                                                                       |
| **Architecture** | **MVVM** (Model → View → ViewModel)                                            |
| **State Mgmt**   | `flutter_bloc` with **Cubit + Equatable**                                      |
| **Backend**      | **Firebase** (Auth + Cloud Firestore)                                           |
| **Languages**    | Arabic (AR) + English (EN) — full i18n via `flutter_gen/gen_l10n`               |
| **Themes**       | Light Mode + Dark Mode via `ThemeCubit`                                        |
| **Design Base**  | Figma **393 × 852** via `flutter_screenutil`                                   |

---

## 🏗️ Architecture Rules (MUST FOLLOW)

### MVVM Pattern — Every Feature Has 4 Folders:
```
features/<feature_name>/
├── model/          → Data models (Equatable) + Repository (Firestore logic)
├── view/           → Screens (StatefulWidget / StatelessWidget)
├── view_model/     → Cubit + State classes
└── widgets/        → Small, reusable UI components for this feature
```

### Strict Layer Separation:
1. **View** → NEVER calls Firebase/Firestore directly. Only talks to Cubit.
2. **ViewModel (Cubit)** → Calls Repository methods. Emits States.
3. **Model (Repository)** → Handles all Firestore/Auth operations through `FirebaseService`.
4. **No business logic in View files** — calculations, validations, and Firebase calls go in Cubit or Repository.

---

## 📦 Mandatory Stack & Wrappers

| Package                   | Purpose                                        | Wrapper                                  |
| :------------------------ | :--------------------------------------------- | :--------------------------------------- |
| `flutter_bloc + equatable`| State management                               | `Cubit<State>` in `view_model/`          |
| `firebase_auth`           | Customer login & register                      | `AuthRepository`                         |
| `cloud_firestore`         | Categories, venues, reservations, transactions | `Repositories` + `FirebaseService`       |
| `flutter_secure_storage`  | Secure session/token storage                   | `SecureStorageHelper`                    |
| `shared_preferences`      | Theme & language persistence                   | `CacheHelper` + `AppLocalKeys`           |
| `shimmer`                 | Loading skeletons                              | `AppShimmer`                             |
| `flutter_screenutil`      | Responsive sizing (393×852)                    | `.w`, `.h`, `.r`, `.sp`                  |
| `intl`                    | Date formatting                                | `DateExtensions`                         |

**⚠️ NEVER import packages directly in View files. Always use the project wrappers.**

---

## 📂 Full Folder Structure

```
lib/
├── main.dart                     → Firebase.initializeApp, CacheHelper.init
├── app.dart                      → ScreenUtilInit, ThemeCubit, LocaleCubit, MultiBlocProvider
├── l10n/                         → app_ar.arb, app_en.arb
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       → Light & Dark color palette
│   │   ├── app_constants.dart    → maxSeats=6, minSeats=1, 5 fixed time slots
│   │   ├── app_enums.dart        → BookingStatus, SlotState, DeviceType
│   │   ├── app_fonts.dart        → Font sizes (.sp) and weights
│   │   ├── app_icons.dart        → Centralized IconData references
│   │   └── app_sizes.dart        → Padding, spacing, radius, button heights
│   │
│   ├── services/
│   │   ├── firebase_service.dart              → Singleton: Auth & Firestore refs
│   │   └── vendor_notification_dispatcher.dart → Notify Vendor app on booking
│   │
│   ├── storage/
│   │   ├── cache_helper.dart          → SharedPreferences wrapper
│   │   ├── secure_storage_helper.dart → FlutterSecureStorage wrapper
│   │   └── local_keys.dart            → Storage key constants
│   │
│   ├── theme/
│   │   ├── app_theme.dart    → Light & Dark ThemeData definitions
│   │   └── theme_cubit.dart  → Theme toggle + persistence
│   │
│   └── utils/
│       ├── extensions/
│       │   ├── context_extensions.dart → colorScheme, textTheme, l10n, showSnackBar
│       │   ├── date_extensions.dart    → toFirestoreDate(), toReadableDate()
│       │   └── string_extensions.dart  → capitalize, isValidEmail, isValidPassword
│       └── locale_cubit.dart          → AR/EN toggle + persistence
│
├── features/
│   ├── auth/            → Login & Register (mandatory before booking)
│   ├── home/            → Categories browsing + venue search
│   └── reservation/     → Venue details, room map (Fig 3), booking (Fig 4)
│
└── shared/
    ├── app_shimmer.dart         → Shimmer skeleton
    ├── custom_button.dart       → Primary action button
    ├── custom_text_field.dart   → Styled text input
    └── empty_error_states.dart  → EmptyStateWidget & ErrorStateWidget
```

---

## 🧱 Clean Code Rules (MANDATORY)

### Naming Conventions:
- **Files:** `snake_case.dart` (e.g., `auth_cubit.dart`, `venue_model.dart`)
- **Classes:** `PascalCase` (e.g., `AuthCubit`, `ReservationModel`)
- **Functions:** `camelCase` — descriptive names revealing intent (e.g., `searchVenuesByName()`, `confirmRealtimeBooking()`)
- **Constants:** `camelCase` in `AppConstants` class (e.g., `maxSeatsPerRoom`)

### Single Responsibility (SRP):
- Each Widget file = 1 widget purpose
- Each Cubit = 1 feature's state management
- Each Repository = 1 feature's data operations

### State Pattern — Every Cubit must have these states:
```dart
Initial → Loading → Success/Loaded → Error
```
- Use `AppShimmer` during `Loading`
- Use `EmptyStateWidget` when data is empty
- Use `ErrorStateWidget` with retry on `Error`

### Constants — NEVER hardcode:
- Colors → `AppColors`
- Sizes/padding → `AppSizes`
- Font sizes → `AppFonts`
- Icons → `AppIcons`
- Domain values (max seats, time slots) → `AppConstants`

---

## 🎨 Theming Rules

### Room/Slot State Colors (via `context.colorScheme`):
| State       | Background                              | Text/Border                                       |
| :---------- | :-------------------------------------- | :------------------------------------------------ |
| **Selected**| `colorScheme.primary`                   | `colorScheme.onPrimary`                           |
| **Available**| `colorScheme.surface`                  | `colorScheme.onSurface` + `colorScheme.outline`   |
| **Booked**  | `colorScheme.surfaceContainerHighest`   | `colorScheme.onSurface.withValues(alpha: 0.38)` + `onTap: null` |

### Always use `context.colorScheme.xxx` — never raw colors in Views.

---

## 📱 Responsive Design Rules

- Design base: **393 × 852** (set in `ScreenUtilInit`)
- Width → `.w` | Height → `.h` | Font → `.sp` | Radius → `.r`
- Text scaling locked: `textScaler: TextScaler.noScaling` in `MaterialApp.builder`
- All spacing values come from `AppSizes`

---

## 🌍 Localization (i18n) Rules

- ALL user-facing text → `context.l10n.keyName` from ARB files
- **NEVER** hardcode Arabic or English strings in Dart files
- Alignment → always use `start`/`end` (not `left`/`right`)
- Use `EdgeInsetsDirectional` instead of `EdgeInsets`
- Use `CrossAxisAlignment.start` instead of `.left`
- Use `TextAlign.start` instead of `.left`

---

## 🔒 Security Rules (Hostile Client Mindset)

1. **Session tokens** → stored in `SecureStorageHelper` (NEVER `SharedPreferences`)
2. **Server-side validation in Cubit/Repository before Firestore write:**
   - User is authenticated (`FirebaseService.instance.isAuthenticated`)
   - `1 <= seatsCount <= AppConstants.maxSeatsPerRoom`
   - `timeSlot ∈ AppConstants.dailyFixedTimeSlots`
   - Slot not already booked (Firestore `runTransaction`)
3. **Double-booking prevention:**
   - Atomic booking via `runTransaction` using `uniqueSlotLockId`
   - Real-time slot updates via `StreamSubscription` in `ReservationCubit`
4. **Memory safety:**
   - Cancel ALL `StreamSubscription` in Cubit's `close()` method

---

## 🔑 Core Business Logic

### Fixed Time Slots (5 daily):
```
09:00 | 11:00 | 13:00 | 15:00 | 17:00
```

### Max Seats Per Room: **6** (min: **1**)

### Booking Flow:
1. Customer logs in / registers
2. Browses categories or searches venue by name
3. Opens venue details → sees interactive room map (Figure 3)
4. Selects a room → goes to booking screen (Figure 4)
5. Chooses: seats (1-6) → date → available time slot
6. Confirms booking → Firestore Transaction prevents double-booking
7. Vendor gets notified instantly

### Unique Slot Lock ID (prevents conflicts):
```
{venueId}_room{roomNumber}_{YYYY-MM-DD}_{HH:MM}
```

---

## 📋 Firestore Collections

| Collection              | Purpose                                    |
| :---------------------- | :----------------------------------------- |
| `users`                 | Customer profiles                          |
| `categories`            | Workspace categories                       |
| `venues`                | Co-working spaces/venues                   |
| `reservations`          | Bookings (keyed by `uniqueSlotLockId`)     |
| `vendor_notifications`  | Booking notifications for Vendor app       |

---

## 🔀 Git Conventions

```bash
# Branch naming
feature/<feature-name>     # New feature
fix/<bug-description>      # Bug fix
refactor/<what>            # Code cleanup

# Commit format
feat(<scope>): <description>
fix(<scope>): <description>
refactor(<scope>): <description>
style(<scope>): <description>
docs(<scope>): <description>

# Examples
feat(reservation): implement interactive room map and atomic real-time slot booking
fix(auth): handle expired token on app restart
refactor(home): extract venue search logic to repository
```

---

## ⚠️ Common Mistakes to Avoid

1. ❌ Calling Firebase directly in a View/Widget
2. ❌ Using `Colors.blue` instead of `context.colorScheme.primary`
3. ❌ Using hardcoded `6` instead of `AppConstants.maxSeatsPerRoom`
4. ❌ Using `EdgeInsets` instead of `EdgeInsetsDirectional`
5. ❌ Using `TextAlign.left` instead of `TextAlign.start`
6. ❌ Forgetting to cancel `StreamSubscription` in `close()`
7. ❌ Storing tokens in `SharedPreferences` instead of `SecureStorage`
8. ❌ Writing Arabic/English strings directly instead of using `context.l10n`
9. ❌ Not using `.w`, `.h`, `.sp`, `.r` from ScreenUtil
10. ❌ Putting multiple widgets/screens in a single file
11. ❌ Not handling all states (Loading/Empty/Error/Success) in BlocBuilder

---

## 📝 Checklist Before Every PR

- [ ] `flutter analyze` → zero issues
- [ ] `flutter test` → all pass
- [ ] All new strings added to both `app_en.arb` AND `app_ar.arb`
- [ ] `flutter gen-l10n` runs without errors
- [ ] No hardcoded colors, sizes, strings, or magic numbers
- [ ] Every new Cubit has all 4 states: Initial, Loading, Success, Error
- [ ] StreamSubscriptions cancelled in `close()`
- [ ] Responsive units used (`.w`, `.h`, `.sp`, `.r`)
- [ ] RTL-safe alignment (`start`/`end`, `EdgeInsetsDirectional`)
- [ ] Booking validation exists in both UI AND Repository/Cubit

---

> **🚀 When in doubt, read `README.md` — it's the master reference.**

