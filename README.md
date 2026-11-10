# Co-Working Space & Meeting Room Reservation — Customer App (تطبيق العميل)

مشروع Flutter مخصص للعملاء (**Customers**) لحجز غرف الاجتماعات والمكاتب الخاصة في مساحات العمل المشتركة، مبني باستخدام بنية **MVVM + Cubit** مع دعم كامل لـ **Light Mode** و **Dark Mode**، ثنائية اللغة (**AR/EN**)، الحجز اللحظي المانع للتضارب (**Real-time Concurrency Booking**)، والاعتماد الصارم على مبادئ **OOP** و **SOLID** و **Clean Code**.

📌 **ملاحظة هامة:** هذا الملف هو المصدر الأساسي والمرجع الأول الدائم لكافة معايير تطبيق **Customer App**، البنية المعمارية، تقسيم المجلدات، القواعد الإلزامية، وإرشادات التطوير.

---

## 📑 نظرة عامة (Overview)

يتيح تطبيق **Co-Working Customer App** للعملاء تسجيل الدخول، استكشاف تصنيفات مساحات العمل، البحث عن الأماكن بالاسم، استعراض مخطط الغرف التفاعلي (Figure 3)، وحجز الغرف بتحديد عدد الكراسي والتاريخ والموعد المتاح (Figure 4) في الوقت الفعلي، ويشمل الدليل الأقسام التالية:
1. **📋 معلومات ومتطلبات المشروع (Customer App Requirements)**
2. **🚀 البدء السريع وأوامر التشغيل**
3. **📦 المكتبات والأدوات الإلزامية (Mandatory Stack Wrappers)**
4. **🏗️ بنية المشروع (MVVM Folder Structure)**
5. **📖 شرح البنية المعمارية ومنطق منع الحجز المزدوج (Real-time MVVM)**
6. **🧱 قواعد الكود النظيف ومبادئ OOP & SOLID (Clean Code Rules)**
7. **🎨 نظام الثيمات والألوان والخطوط (Theming System)**
8. **📱 التكيف مع الشاشات (Responsive Design - 393×852)**
9. **🌍 اللغات ومحاذاة RTL المنطقية (i18n & RTL Alignment)**
10. **🔒 قواعد الأمان وحماية التزامن (Security & Hostile Client Rules)**
11. **🔀 إدارة Git وسيناريو الاختبار النهائي**

---

## 📋 1. معلومات ومتطلبات المشروع (Customer App)

* **اسم المشروع:** `coworking_customer_app` (Co-Working Space & Meeting Room Reservation - Customer App)
* **الإصدار:** `1.0.0+1`
* **Flutter SDK:** `^3.5.3`
* **البنية المعمارية:** `MVVM (Model-View-ViewModel)`
* **إدارة الحالة:** `flutter_bloc (Cubit + Equatable)`
* **المصادقة (Authentication):** **يتطلب تسجيل دخول وإنشاء حساب إجبارياً** (Customer App requires login and register).

### المتطلبات الوظيفية الأساسية (Core Business Rules)
1. **المصادقة (Login & Register):**
   * يجب على العميل إنشاء حساب أو تسجيل الدخول قبل التمكن من حجز أي غرفة أو مكتب، مع حفظ الجلسة بشكل آمن.
2. **التصفح حسب التصنيفات (Navigate Workspace Categories):**
   * يمكن للعميل التنقل بين تصنيفات مساحات العمل (مثل: `Silent Study Rooms`, `Podcast Studios`, `Executive Conference Rooms`) وعرض الأماكن المضافة داخل كل تصنيف.
3. **البحث بالاسم (Search by Venue Name):**
   * يمكن للعميل البحث عن مساحة عمل معينة باستخدام اسمها مباشرة.
4. **تفاصيل المكان ومخطط الغرف التفاعلي (Interactive Room Selection - Figure 3):**
   * بعد اختيار مساحة العمل وعرض تفاصيلها (الوصف، الصورة، الموقع، عدد الغرف)، يظهر للعميل مخطط مرئي للغرف/الطاولات والكراسي المحيطة بها (مطابق لـ Figure 3) ليختار غرفة متاحة.
5. **إعدادات الحجز (Booking Configuration - Figure 4):**
   * يحدد العميل عند الحجز:
     * **عدد الكراسي/الضيوف للغرفة (`Amount of guests / seats`):** من `1` وحتى **`6` كراسي كحد أقصى** (`Max 6 seats`) عبر أزرار `+` و `-`.
     * **تاريخ الحجز (`Reservation Date`):** اختيار التاريخ المطلوب.
     * **موعد الحجز (`Available Time Slots`):** اختيار موعد متاح غير محجوز من المواعيد اليومية الخمسة الثابتة (`09:00`, `11:00`, `13:00`, `15:00`, `17:00`).
6. **منع الحجز المزدوج في الوقت الفعلي (Real-time Double-Booking Prevention):**
   * لا يمكن للعميل أبداً حجز غرفة في موعد وتاريخ قام عميل آخر بحجزه بالفعل (يتم تحديث حالة المواعيد والغرف لحظياً عبر `Streams` وتأكيد الحجز عبر `Firestore Transaction`).
7. **إشعار المالك (Vendor Notification Trigger):**
   * فور نجاح الحجز، يُرسل إشعار فوري يظهر في تطبيق الـ Vendor.

---

## 🚀 2. البدء السريع وأوامر التشغيل

```bash
# استنساخ المشروع
git clone <customer-repository-url>

# الانتقال إلى مجلد المشروع
cd coworking_customer_app

# تثبيت الحزم
flutter pub get

# توليد ملفات الترجمة (AR/EN)
flutter gen-l10n

# فحص جودة الكود والاختبارات
flutter analyze
flutter test

# تشغيل التطبيق على جهاز/محاكي مستقل عن جهاز الـ Vendor
flutter run
```

---

## 📦 3. المكتبات والأدوات الإلزامية (Mandatory Stack Wrappers)

يُمنع استدعاء الحزم مباشرة داخل الـ Views؛ يتم استخدام الـ Helpers والـ Repositories المعرّفة في المشروع فقط:

| الحزمة (Package) | الاستخدام في Customer App | الـ Wrapper الإلزامي |
| :--- | :--- | :--- |
| **`flutter_bloc` + `equatable`** | إدارة الحالة بنمط Cubit مع حالات غير قابلة للتعديل | `Cubit<State>` في `view_model/` |
| **`firebase_auth`** | تسجيل الدخول وإنشاء حساب للعميل | `AuthRepository` في `features/auth/model/` |
| **`cloud_firestore`** | جلب التصنيفات، البحث، البث اللحظي للمواعيد، وتنفيذ Transactions الحجز | عبر `Repositories` + `FirebaseService` |
| **`flutter_secure_storage`** | حفظ توكن ومعرف جلسة العميل بأمان | `SecureStorageHelper` في `lib/core/storage/` |
| **`shared_preferences`** | حفظ الثيم (`Light/Dark`) واللغة (`AR/EN`) محلياً | `CacheHelper` + `AppLocalKeys` |
| **`shimmer`** | عرض Skeletons أثناء انتظار تحميل التصنيفات والأماكن وحالة الغرف | `AppShimmer` في `lib/shared/` |
| **`flutter_screenutil`** | ضبط الأبعاد والمسافات والخطوط بناءً على مقاس فيجما `393×852` | `.w`, `.h`, `.r`, `.sp` |
| **`intl`** | تنسيق تاريخ الحجز (`June, 9th` / `YYYY-MM-DD`) | `DateExtensions` في `lib/core/utils/` |

---

## 🏗️ 4. بنية المشروع (MVVM Folder Structure)

```text
lib/
├── main.dart                               # تهيئة Firebase, CacheHelper, SecureStorageHelper
├── app.dart                                # إعدادات ScreenUtil (393×852), ThemeCubit, LocaleCubit
├── l10n/                                   # ملفات الترجمة (app_ar.arb, app_en.arb)
│
├── core/                                   # الملفات الأساسية المشتركة
│   ├── constants/
│   │   ├── app_colors.dart                 # ألوان Light & Dark
│   │   ├── app_constants.dart              # الثوابت: maxSeats = 6 ، والمواعيد الـ 5 الثابتة
│   │   ├── app_enums.dart                  # Enums (BookingStatus, SlotState, DeviceType)
│   │   ├── app_fonts.dart                  # الخطوط
│   │   ├── app_icons.dart                  # الأيقونات
│   │   └── app_sizes.dart                  # أبعاد التصميم القياسية (393×852)
│   │
│   ├── services/
│   │   ├── firebase_service.dart           # مرجعيات Firestore & Auth
│   │   └── vendor_notification_dispatcher.dart # إرسال حدث الإشعار لتطبيق المالك عند الحجز
│   │
│   ├── storage/
│   │   ├── cache_helper.dart               # SharedPreferences للإعدادات غير الحساسة
│   │   ├── secure_storage_helper.dart      # تخزين آمن لجلسة وتوكن العميل
│   │   └── local_keys.dart                 # مفاتيح التخزين
│   │
│   ├── theme/
│   │   ├── app_theme.dart                  # تعريف Light & Dark ThemeData
│   │   └── theme_cubit.dart                # إدارة حالة الثيم
│   │
│   └── utils/
│       ├── extensions/
│       │   ├── context_extensions.dart
│       │   ├── date_extensions.dart
│       │   └── string_extensions.dart
│       └── locale_cubit.dart               # إدارة اللغة (AR/EN)
│
├── features/                               # ميزات تطبيق العميل (Customer Features)
│   ├── auth/                               # 1. تسجيل الدخول وإنشاء الحساب (إجباري)
│   │   ├── model/
│   │   │   ├── customer_user_model.dart
│   │   │   └── auth_repository.dart
│   │   ├── view/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── view_model/
│   │   │   ├── auth_cubit.dart
│   │   │   └── auth_state.dart
│   │   └── widgets/
│   │       └── auth_form_fields.dart
│   │
│   ├── home/                               # 2. تصفح التصنيفات والبحث عن مساحة عمل بالاسم
│   │   ├── model/
│   │   │   ├── category_model.dart
│   │   │   ├── venue_model.dart
│   │   │   └── home_repository.dart
│   │   ├── view/
│   │   │   └── customer_home_screen.dart
│   │   ├── view_model/
│   │   │   ├── home_cubit.dart
│   │   │   └── home_state.dart
│   │   └── widgets/
│   │       ├── categories_horizontal_list.dart
│   │       ├── venue_search_bar.dart
│   │       └── customer_venue_card.dart
│   │
│   └── reservation/                        # 3. تفاصيل المكان، مخطط الغرف (Fig 3)، والحجز اللحظي (Fig 4)
│       ├── model/
│       │   ├── reservation_model.dart
│       │   └── reservation_repository.dart
│       ├── view/
│       │   ├── venue_details_screen.dart
│       │   └── room_booking_screen.dart
│       ├── view_model/
│       │   ├── reservation_cubit.dart
│       │   └── reservation_state.dart
│       └── widgets/
│           ├── interactive_room_table_map.dart # مخطط الطاولات والكراسي التفاعلي (Figure 3)
│           ├── guests_seat_counter.dart        # عداد الكراسي 1..6 (Figure 4)
│           ├── reservation_date_picker.dart    # اختيار تاريخ الحجز (Figure 4)
│           └── realtime_time_slots_wrap.dart   # اختيار الموعد المتاح وتعطيل المحجوز لحظياً (Figure 4)
│
└── shared/                                 # العناصر المشتركة على مستوى التطبيق
    ├── app_shimmer.dart                    # Shimmer Skeletons للقوائم ومخطط الغرف
    ├── custom_button.dart
    ├── custom_text_field.dart
    └── empty_error_states.dart
```

---

## 📖 5. شرح البنية المعمارية ومنطق منع الحجز المزدوج (Real-time MVVM)

### أ. نموذج الحجز (`lib/features/reservation/model/reservation_model.dart`)
```dart
import 'package:equatable/equatable.dart';

class ReservationModel extends Equatable {
  final String id;
  final String venueId;
  final String venueName;
  final String customerId;
  final int roomNumber;
  final int seatsCount; // 1 إلى 6 كراسي كحد أقصى
  final String reservationDate; // YYYY-MM-DD
  final String timeSlot; // أحد المواعيد الـ 5 الثابتة

  const ReservationModel({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.customerId,
    required this.roomNumber,
    required this.seatsCount,
    required this.reservationDate,
    required this.timeSlot,
  });

  /// مفتاح مركب فريد لمنع حجز نفس الغرفة في نفس التاريخ ونفس الموعد من عميلين في نفس اللحظة
  String get uniqueSlotLockId => '${venueId}_room${roomNumber}_${reservationDate}_$timeSlot';

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] as String? ?? '',
      venueId: json['venueId'] as String? ?? '',
      venueName: json['venueName'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      roomNumber: json['roomNumber'] as int? ?? 1,
      seatsCount: json['seatsCount'] as int? ?? 1,
      reservationDate: json['reservationDate'] as String? ?? '',
      timeSlot: json['timeSlot'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
        'venueName': venueName,
        'customerId': customerId,
        'roomNumber': roomNumber,
        'seatsCount': seatsCount,
        'reservationDate': reservationDate,
        'timeSlot': timeSlot,
      };

  @override
  List<Object?> get props => [
        id,
        venueId,
        venueName,
        customerId,
        roomNumber,
        seatsCount,
        reservationDate,
        timeSlot,
      ];
}
```

### ب. الحجز الذري اللحظي (`ReservationRepository` Transaction)
لضمان عدم قيام عميلين بحجز نفس الغرفة في نفس الموعد، يستخدم المستودع `runTransaction` باستخدام المعرّف المركب `uniqueSlotLockId`:
```dart
Future<void> bookRoomInRealTime(ReservationModel reservation) async {
  final docRef = _firestore
      .collection('reservations')
      .doc(reservation.uniqueSlotLockId);

  await _firestore.runTransaction((transaction) async {
    final snapshot = await transaction.get(docRef);
    if (snapshot.exists) {
      throw const SlotAlreadyBookedException();
    }
    transaction.set(docRef, reservation.toJson());
  });
}
```

### ج. طبقة الـ ViewModel (`ReservationCubit`)
* يستمع عبر `StreamSubscription` لتغييرات مجموعة `reservations` الخاصة بـ `venueId` و `reservationDate` المختارين.
* بمجرد أن يحجز عميل آخر غرفة أو موعداً، تُحدّث الـ State فوراً لتعطيل الموعد المحجوز في شاشة العميل الحالي بدون الحاجة لإعادة تحميل الشاشة.

---

## 🧱 6. قواعد الكود النظيف ومبادئ OOP & SOLID (إلزامي)

1. **تسمية تكشف القصد:** استخدم أسماء واضحة مثل `searchVenuesByName()`, `selectRoomNumber()`, `incrementGuestSeats()`, `confirmRealtimeBooking()`.
2. **مسؤولية واحدة (SRP):**
   * قسّم الشاشات الغنية بالتفاصيل إلى Widgets فرعية صغيرة ومعزولة:
     * `InteractiveRoomTableMap` (لرسم الطاولة والكراسي كما في Figure 3).
     * `GuestsSeatCounter` (لعداد الضيوف `+` و `-` كما في Figure 4).
     * `RealtimeTimeSlotsWrap` (لأزرار المواعيد المتاحة والمحجوزة كما في Figure 4).
   * لا تضع أي استدعاء لـ Firebase أو حسابات منطقية داخل الـ View.
3. **ثوابت الدومين في `AppConstants`:**
   * الحد الأقصى للكراسي (`6`) والحد الأدنى (`1`) والمواعيد الـ 5 الثابتة تُقرأ من `AppConstants` فقط.
4. **حالات واضحة (`Loading / Empty / Error / Success`):**
   * أثناء جلب الأماكن أو حالة الغرف، اعرض `AppShimmer` يحاكي شكل البطاقات أو الطاولات.
   * عند عدم وجود نتائج للبحث بالاسم، اعرض حالة `EmptyStateWidget` واضحة.

---

## 🎨 7. نظام الثيمات والألوان والخطوط (Theming System)

يدعم التطبيق الوضعين **Light Mode** و **Dark Mode** عبر `ThemeCubit`:

* **تمثيل حالة الغرف والمواعيد (Figure 3 & Figure 4) عبر `ColorScheme`:**
  * **الغرفة/الموعد المختار (`Selected`):** خلفية `context.colorScheme.primary` مع نص `context.colorScheme.onPrimary`.
  * **الغرفة/الموعد المتاح (`Available`):** خلفية `context.colorScheme.surface` وحدود `context.colorScheme.outline` مع نص `context.colorScheme.onSurface`.
  * **الغرفة/الموعد المحجوز (`Booked / Disabled`):** خلفية `context.colorScheme.surfaceContainerHighest` مع نص باهت `context.colorScheme.onSurface.withValues(alpha: 0.38)` وتعطيل الضغط (`onTap: null`).

---

## 📱 8. التكيف مع الشاشات (Responsive Design - 393×852)

* مقاس التصميم القياسي في `ScreenUtilInit` هو **`393 × 852`**.
* قفل تكبير خط النظام إجباري داخل `MaterialApp.builder` عبر `textScaler: TextScaler.noScaling`.
* الالتزام الكامل بوحدات `.w` للعرض، `.h` للارتفاع، `.sp` للخطوط، و `.r` للحواف الدائرية.

---

## 🌍 9. اللغات ومحاذاة RTL المنطقية (i18n & RTL Alignment)

1. **الترجمة الكاملة (`AppLocalizations`):**
   * جميع نصوص الواجهة (`Amount of guests`, `Reservation date`, `Available time slots`, رسائل نجاح أو فشل الحجز) تُستدعى عبر `context.l10n.*` من ملفات `app_ar.arb` و `app_en.arb`.
2. **المحاذاة المنطقية (`start` / `end`):**
   * بداية السطر أو الشبكة تُبرمج دائماً بـ `start` (`CrossAxisAlignment.start`, `TextAlign.start`, `EdgeInsetsDirectional`) لضمان انعكاس سليم تلقائياً بين العربية والإنجليزية.

---

## 🔒 10. قواعد الأمان وحماية التزامن (Security & Hostile Client Rules)

1. **تخزين الجلسة الآمن:**
   * يُحفظ معرف جلسة العميل/التوكن بعد تسجيل الدخول في `SecureStorageHelper` (`flutter_secure_storage`) وليس في `SharedPreferences` العادي.
2. **عدم الثقة بواجهة العميل فقط (Hostile Client Mindset):**
   * حتى لو كانت الواجهة تمنع زيادة الكراسي عن 6 أو تمنع الضغط على موعد محجوز، يجب على `ReservationCubit` و `ReservationRepository` التحقق برمجياً قبل الكتابة من أن:
     * المستخدم مسجل دخول فعلياً.
     * `1 <= seatsCount <= AppConstants.maxSeatsPerRoom`.
     * الموعد المختار ضمن `AppConstants.dailyFixedTimeSlots` وغير محجوز في الـ Transaction.
3. **إغلاق الاشتراكات (Memory & Stream Safety):**
   * إلغاء جميع اشتراكات `StreamSubscription` الخاصة بمتابعة الغرف اللحظية داخل دالة `close()` في الـ Cubit لمنع تسريب الذاكرة.

---

## 🔀 11. إدارة Git وسيناريو الاختبار النهائي (End-to-End Scenario)

```bash
# إنشاء فرع لميزة الحجز اللحظي من main
git checkout main
git pull origin main
git checkout -b feature/customer-realtime-booking

# فحص التحليل والاختبارات
flutter analyze
flutter test

# حفظ ورفع التعديلات
git add .
git commit -m "feat(reservation): implement interactive room map and atomic real-time slot booking"
git push origin feature/customer-realtime-booking
```

### قائمة الفحص النهائية وسيناريو التسليم (Customer Checklist)
- [ ] تسجيل حساب جديد أو تسجيل الدخول في تطبيق الـ Customer بنجاح.
- [ ] تصفح تصنيفات مساحات العمل أو البحث عن المكان الذي أضافه الـ Vendor بالاسم.
- [ ] فتح صفحة تفاصيل المكان واستعراض مخطط الغرف التفاعلي (Figure 3).
- [ ] اختيار غرفة، تحديد عدد الكراسي (بحد أقصى 6)، اختيار تاريخ الحجز، واختيار موعد متاح غير محجوز (Figure 4).
- [ ] التحقق من أنه بمجرد إتمام الحجز، يتحول الموعد إلى محجوز في الوقت الفعلي لدى أي عميل آخر، ويصل إشعار فوري لتطبيق الـ Vendor.
- [ ] `flutter analyze` و `flutter test` خاليان من الأخطاء تماماً.