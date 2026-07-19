# Quimify Client

## Overview

The Quimify client is the app behind [Quimify](https://quimify.com/): a chemistry companion for students, running on Android, iOS and web from a single codebase.

Built with Flutter.

## Architecture

```
lib/
├── main.dart            # entry point
├── routes.dart          # navigation
│
├── internet/            # services layer
│   ├── api/             # Quimify API client
│   ├── accounts/        # Firebase auth
│   ├── payments/        # RevenueCat
│   ├── ads/             # Google Mobile Ads
│   ├── ocr/             # photo → formula
│   ├── chatbot/         # AI assistant
│   ├── practice_mode/   # quizzes & leaderboard
│   └── language/        # locale
│
├── pages/               # UI layer
│   ├── home/
│   ├── inorganic/       # name ↔ formula
│   ├── organic/         # naming · finding formula · diagrams
│   ├── calculator/      # molecular mass · equations
│   ├── periodic_table/
│   ├── practice_mode/   # quiz · difficulty · leaderboard
│   ├── histo
```

## Usage

Clone the repository and run it with Flutter:

```bash
flutter pub get
flutter run
```

It needs environment variables (via `envied`) and Firebase configuration to connect to the [Quimify API](https://github.com/quimifyapp/api).

## Dependencies

Quimify Client talks to the [Quimify API](https://github.com/quimifyapp/api) and uses Firebase, RevenueCat and Google Mobile Ads.

## License?

Do whatever you want with this code.

However, please be aware that our code relies on open-source dependencies, each with their own licenses and usage terms. Non-compliance with their licenses could have legal consequences.
