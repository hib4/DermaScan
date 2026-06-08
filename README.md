# DermaScan

AI-powered skin screening app with on-device TensorFlow Lite inference and a
FastAPI backend for authentication and scan history.

DermaScan is an informational screening assistant, not a medical diagnosis tool.
Users should consult a certified medical professional for clinical evaluation.

## Stack

- **Mobile:** Flutter, Dart, Bloc/Cubit, TensorFlow Lite, camera/image tools.
- **Backend:** FastAPI, PostgreSQL, async SQLAlchemy, Alembic, JWT auth.
- **Infrastructure:** Docker Compose for local API and database development.

## Project Structure

```text
backend/   FastAPI app, database models, migrations, Docker setup
mobile/    Flutter app, TFLite model assets, UI, tests
SUMMARY.md Full project summary and implementation notes
```

## Features

- User registration and login with JWT authentication.
- Skin image capture or selection from the mobile app.
- Image quality checks for brightness and blur.
- Local TFLite classification into:
  - `Malignant`
  - `Pre-malignant`
  - `Benign & Common`
- Educational result details and safety disclaimers.
- Background scan sync and authenticated scan history.

## Quick Start

### Backend

```sh
cd backend
docker compose up -d --build
docker compose exec web alembic upgrade head
```

The API runs on port `8000`.

### Mobile

```sh
cd mobile
flutter pub get
flutter run
```

The mobile API base URL is configured in
`mobile/lib/core/network/api_config.dart`.

## Tests

```sh
cd mobile
flutter test
```

Mobile tests cover widgets, screens, services, cubits, models, networking, and
image utilities. Backend test dependencies are installed, but backend tests are
not currently present.

## More Details

See [SUMMARY.md](SUMMARY.md) for the complete architecture, API, setup, and
implementation summary.
