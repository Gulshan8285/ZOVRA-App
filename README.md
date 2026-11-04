# ZOVRA – Premium Home Services Booking Mobile Application

![ZOVRA Hero Banner](https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=1200&q=80)

> **ZOVRA** is an ultra-premium, modern, and fully functional mobile application for on-demand home services booking, inspired by the simplicity and user experience of Urban Company with a distinctive, original brand identity.

Built with **Flutter** (Clean Architecture, Feature-First organization, Riverpod state management, and GoRouter declarative navigation) for both **Android** (Google Play Store) and **iOS** (Apple App Store).

---

## 📱 Features & Implemented Modules

### 1. Brand Identity & Design System
- **Palette**: Obsidian Charcoal (`#131518`), Vibrant Zovra Orange (`#FF5E00`), Surface Muted (`#F8F9FA`), Emerald Green (`#10B981`) for verified badges & ratings, and Premium Gold (`#F59E0B`).
- **Typography**: Plus Jakarta Sans for headings & numbers; Inter for clean, legible body text.
- **Card Design**: Rounded luxury cards, subtle shadows, image overlays, and discount tags.

### 2. Authentication & Onboarding
- **Onboarding Carousel**: 3-step value proposition with auto-playing indicators and high-definition photography.
- **Google Sign-In**: Integration architecture ready for Firebase `GoogleAuthProvider.credential()`.
- **Demo Mode**: 1-tap instant login with demo credentials (`Gulshan Yadav`, `demo@zovra.com`).
- **Session Persistence**: Persistent local user session across app restarts via `SharedPreferences`.
- **Profile Management**: Edit name, email, phone number, and choose avatar presets.
- **Store Compliance**: In-app **Account Deletion** option adhering to Apple App Store Guideline 5.1.1 and Google Play Data Safety requirements.

### 3. Home Screen
- **Header**: ZOVRA brand icon, interactive Location Selector sheet, Notification Bell with live unread counter, and Profile avatar shortcut.
- **Quick Search Bar**: Tap-through shortcut to instant explore & discovery.
- **Promotional Carousel**: Manageable banner carousel with badges, discounts, and deep links.
- **Dynamic Category Grid**: Full Body Massage, Spa Services, Hydra Facial, Salon at Home, Beauty Services, Deep Cleaning, Home Cleaning, Other Home Services (Appliance Repair).
- **Featured Sections**: Most Popular Services, Trending Wellness & Spa, Best Selling Home Care.
- **Trust & Safety Banner**: Highlights police verification, sealed single-use kits, and satisfaction guarantee.

### 4. Service Discovery & Details
- **Explore Screen**: Live search filter, category filter pills, price range slider (₹300 - ₹6,000), minimum rating filter (4.5★, 4.8★), and sorting (Popularity, Price Low/High, Rating).
- **Service Details**:
  - Hero image with gradient overlay & share button.
  - Duration, rating chip with review count, discount tag.
  - Full description, what's included (checklist), key benefits, and expandable FAQ accordion.
  - Service Package / Duration variant selector (e.g. 60 mins vs 90 mins).
  - Add-on services selection (e.g. Hot Herbal Potli, Foot Scrub, LED light mask).
  - Sticky bottom action bar with live price calculation and "Add to Cart" / "Go to Cart" counter.

### 5. Shopping Cart & Discount System
- **Itemized Cart**: Service image, name, chosen package, add-ons list, unit price, quantity stepper (+ / -), and instant total calculation.
- **Coupons & Offers**:
  - Enter custom coupon codes (e.g., `WELCOME10`, `ZOVRA20`, `FIRSTBOOKING`, `SUPER50`).
  - Available coupon drawer with 1-tap "APPLY" button.
  - Automated rule validation (checks minimum cart order requirement).
  - Live discount deduction & coupon removal.
- **Bill Breakdown**: Item subtotal, service discount savings, coupon discount, 18% GST calculation, visiting fee, total payable amount, and total customer savings badge.

### 6. Address & Location Management
- **Saved Address Book**: Tagged as Home, Office, or Other.
- **Current Location**: Instant GPS simulation that auto-populates exact street, locality, city, state, and PIN code.
- **Add / Edit / Delete Address**: Form validation, house number, apartment, locality, city, state, 6-digit PIN code, special instructions for partner, and default address switcher.

### 7. Booking & Scheduling Experience
- **Date Picker**: Horizontal calendar selector for today, tomorrow, and the next 7 days.
- **Time Slot Selector**: Standard appointment slots (Morning, Afternoon, Evening).
- **Booking Creation**: Instant unique Booking ID generation (e.g. `#ZOV-2026-8941`).
- **Live Status Tracking**: Visual 5-step timeline:
  1. *Booking Confirmed*
  2. *Partner Assigned*
  3. *Partner on the Way*
  4. *Service In Progress*
  5. *Service Completed*
  *(or Cancelled)*
- **Partner Card**: Shows assigned professional's photo, name, rating, verification badge, and interactive "Call Partner" button.
- **Configurable Cancellation**: Cancel booking dialog with reason selection and policy review.
- **Demo Status Advance Button**: Allows instant step-by-step testing of all live status stages in demo mode!

### 8. Secure Payment Gateway Simulation
- **Payment Methods**:
  - UPI (Google Pay, PhonePe, Paytm, Custom UPI VPA).
  - Credit & Debit Cards (Visa, MasterCard, RuPay).
  - Net Banking (HDFC, ICICI, SBI, Axis, Kotak).
  - Cash on Delivery (Pay after service completion).
- **Payment Processing**: Verified transaction ID generation (e.g. `TXN-UPI-8849201948`).
- **Payment Success Screen**: Celebration checkmark, booking ID, time slot, address summary, link to track status.
- **Payment Failure Screen**: Realistic failure simulation with retry and contact support flow.
- **Payment History**: Invoices and transaction log in My Account.

### 9. Reviews & Customer Feedback
- **Verified Customer Reviews**: 1–5 star rating picker, detailed comment, compliment tag chips (*#Punctual*, *#HygienicSetup*, *#ProfessionalTechnique*).
- **Rating Breakdown**: 5-star to 1-star percentage progress bars, average rating, helpful votes.
- Reviews persist and update service ratings dynamically.

### 10. Help & Support
- **Channels**: Instant Call Us, WhatsApp Support, and Email Care.
- **Searchable FAQs**: Common questions regarding cancellations, hygiene, delayed partners, and refunds.
- **Support Tickets**: Create complaint tickets with category selection (Booking, Payment, Service Quality, Refund, Other), subject, and description.
- **My Tickets**: Track ticket status (*Open*, *In Review*, *Resolved*) and view admin responses.

### 11. Admin Control & Testing Dashboard
- Accessible via **Account -> Admin Controls & Live Testing**.
- **Live Bookings Manager**: View all placed bookings and change their status live via dropdown to test the live tracking UI on the fly.
- **Service Catalog Manager**: Toggle services active/inactive, view live pricing.
- **Coupon Creator**: Add custom coupon codes live with discount percentages and minimum order values that immediately work in the cart.

---

## 🏗️ Architecture & Project Structure

Feature-first Clean Architecture separating business logic, state management, and UI:

```
lib/
├── core/
│   ├── constants/              # App constants, fee config, cancellation policy
│   ├── router/                 # GoRouter with StatefulShellRoute (5 bottom tabs)
│   ├── storage/                # LocalStorageService (SharedPreferences persistence)
│   ├── theme/                  # AppColors, AppTextStyles, AppTheme (Material 3)
│   ├── utils/                  # CurrencyFormatter (₹ INR), DateTimeUtils
│   └── widgets/                # ZovraButton, RatingChip, ZovraBadge, EmptyView, ConfirmationDialog
├── data/
│   ├── models/                 # UserModel, ServiceCategory, ServiceItem, CartItem,
│   │                           # CouponModel, AddressModel, BookingModel, PaymentModel,
│   │                           # ReviewModel, NotificationItem, SupportTicket, BannerModel
│   ├── repositories/           # ZovraRepository, AuthRepository
│   └── seeds/                  # InitialData (categories, services, packages, coupons, reviews)
├── features/
│   ├── account/                # Profile, Edit Profile, Payment History, Static Pages
│   ├── addresses/              # Address List, Add/Edit Address, Location Picker Sheet
│   ├── admin/                  # Admin Controls, Catalog toggle, Live Status Manager
│   ├── auth/                   # Welcome Screen, Google login flow, Demo Mode
│   ├── bookings/               # My Bookings (Upcoming/Completed/Cancelled), Detail & Live Tracking
│   ├── cart/                   # Cart Screen, Cart Items, Coupon Apply Sheet, Bill Summary Card
│   ├── checkout/               # Scheduling Screen, Payment Screen, Success & Failure screens
│   ├── home/                   # Home Header, Banners, Category Grid, Featured Cards, Trust Banner
│   ├── notifications/          # Notifications Center & unread counter
│   ├── offers/                 # Offers & Coupons screen
│   ├── reviews/                # Customer Reviews Screen, Write Review Sheet
│   ├── services/               # Explore / Discovery Screen, Category Services, Service Detail
│   ├── shell/                  # MainShellScreen with 5-tab Bottom Navigation
│   └── support/                # Help & Support, Create Ticket, My Tickets
└── main.dart                   # Entry point with SharedPreferences & ProviderScope
```

---

## 🚀 Setup & Installation Instructions

### Prerequisites
- Flutter SDK `^3.47.0` or higher
- Dart SDK `^3.13.0` or higher
- Android Studio / Android SDK (for Android builds)
- Xcode (for iOS builds on macOS)

### 1. Clone & Install Dependencies
```bash
git clone <repository_url>
cd "Zovra App"
flutter pub get
```

### 2. Verify Code Quality & Tests
```bash
flutter analyze
flutter test
```

### 3. Run on Device / Emulator
```bash
# Run on connected Android device or emulator
flutter run -d android

# Run on iOS simulator
flutter run -d ios

# Run on Chrome for web preview
flutter run -d chrome
```

---

## 📦 Production Build Instructions

### Android Build (APK & Google Play AAB)

#### Generate Debug APK:
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

#### Generate Production Release APK:
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### Generate Google Play Store App Bundle (AAB):
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

*Note: For release builds, generate an upload keystore and configure `android/key.properties` following [Flutter Android Deployment Guide](https://docs.flutter.dev/deployment/android).*

---

### iOS Build (App Store Archive)

#### 1. Configure iOS Bundle Identifier & Signing:
Open the `ios` workspace in Xcode:
```bash
open ios/Runner.xcworkspace
```
Under **Runner > Signing & Capabilities**, select your Apple Developer Team and ensure the Bundle Identifier matches (`com.zovra.app`).

#### 2. Build Release Archive:
```bash
flutter build ipa --release
```
Then use Xcode Organizer or Transporter to upload the `.ipa` to Apple App Store Connect.

---

## 🔌 Production Integrations Guide

### Firebase Authentication (Google Sign-In)
1. Create a project in [Firebase Console](https://console.firebase.google.com).
2. Add Android app (`com.zovra`) and upload SHA-1 fingerprint.
3. Download `google-services.json` and place in `android/app/`.
4. Add iOS app (`com.zovra.app`), download `GoogleService-Info.plist` and place in `ios/Runner/`.
5. Run `flutter pub add firebase_core firebase_auth google_sign_in`.
6. Replace `AuthRepository.loginWithGoogle()` with `FirebaseAuth.instance.signInWithCredential()`.

### Cloud Firestore & Storage
1. All models in `lib/data/models/` already implement `toJson()` and `fromJson()` matching Firestore document structures.
2. Replace `LocalStorageService` with Firestore collection references (`users`, `services`, `bookings`, `coupons`, `addresses`, `reviews`).

### Payment Gateway (Razorpay / Stripe)
1. Add `razorpay_flutter` or `flutter_stripe` to `pubspec.yaml`.
2. Replace simulated gateway in `lib/features/checkout/presentation/payment_screen.dart` with `Razorpay.open(options)` passing order ID generated by your backend server.

---

## 🛡️ Store Compliance Checklist
- [x] Unique Bundle Identifier: `com.zovra.app`
- [x] App Display Name: **ZOVRA**
- [x] Required Android Permissions: `INTERNET`, `ACCESS_FINE_LOCATION`, `POST_NOTIFICATIONS`
- [x] Required iOS Permissions: Location, Camera, Photo Library descriptions in `Info.plist`
- [x] Complete Account Deletion capability (Apple Guideline 5.1.1)
- [x] Material 3, responsive for phones and tablets
- [x] Offline-friendly persistent storage
