# ALU Internship Bridge

A mobile application connecting ALU students seeking internship experience with
student-led startups and early-stage ventures within the ALU ecosystem. Verified
startups post opportunities; students discover, filter, and apply for them.

Built with **Flutter**, **Firebase** (Authentication, Firestore), and **Riverpod**
for state management.

## Problem

Many ALU students struggle to secure internships at established organizations,
while student entrepreneurs on campus need support in software development,
design, marketing, research, and other areas. This app bridges that gap.

## Tech stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State management | Riverpod (AsyncNotifier, StreamProvider) |
| Backend | Firebase Authentication, Cloud Firestore |
| Language | Dart |

## Features

- Email/password authentication with role selection (student / startup)
- Startup profile submission and admin verification workflow (live-updating status)
- Verified-only opportunity posting (title, description, role type, skills needed)
- Opportunity discovery: search, category filtering, hero "recommended" card
- Bookmarking opportunities
- Application submission with a short qualifying form
- Live application status tracking, filterable by status
- Student profile with application stats
- Real-time updates throughout via Firestore streams — no manual refresh needed

## Architecture

Three-layer separation of concerns:

```
Presentation (screens/widgets)
        ↓
State management (Riverpod providers)
        ↓
Firebase backend (Auth, Firestore)
```

Screens never call Firebase directly — they read Riverpod providers, which call
repository classes, which are the only code permitted to import Firebase packages.
See the full technical report for architecture diagrams, ERD, and justification
of design decisions.

## Folder structure

```
lib/
  core/                   # theme, constants, shared widgets
  data/
    models/               # UserModel, StartupModel, OpportunityModel, ApplicationModel
    repositories/         # the only files that import Firebase
  features/
    auth/                 # login, signup, auth provider
    onboarding/
    startup_verification/ # pending/verified/rejected status, dashboard
    opportunities/        # browse, detail, posting
    applications/         # application form, status tracking
    profile/
  routing/
    app_router.dart       # central routing based on auth state + role
```

## Getting started

### Prerequisites

- Flutter SDK (stable channel)
- Android Studio with an Android SDK + emulator, or a physical Android device
  with USB debugging enabled
- A Firebase project with Authentication (Email/Password) and Firestore enabled

### Setup

```bash
git clone https://github.com/yourusername/alu-internship-bridge.git
cd alu-internship-bridge
flutter pub get
```

This repo includes `lib/firebase_options.dart` and `android/app/google-services.json`
already configured for the project's Firebase backend — no additional Firebase
setup is required to run it as-is.

### Run

```bash
flutter run
```
Select your Android emulator or connected device when prompted.

### Firestore security rules

Rules are enforced server-side: only verified startups can create opportunities,
users can only write their own profile, and students can only submit applications
under their own ID. See `firestore.rules` (or the technical report, Section 3.2)
for the full rule set and reasoning.

## Known limitations

- Startup verification is currently performed manually by an admin directly in
  the Firebase console rather than through an in-app admin panel
- No messaging/chat, skill-based matching, or analytics dashboard yet — see the
  technical report's Future Improvements section

## Author

Elyse Ishimwe - ALU
