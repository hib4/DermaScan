# DermaScan Project Summary

## Overview

DermaScan is an AI-powered skin screening project made of a Flutter mobile
application and a FastAPI backend. The mobile app captures or selects a skin
image, evaluates image quality, runs an on-device TensorFlow Lite model, shows
an educational result, and syncs scan history to the backend for authenticated
users.

DermaScan is an informational screening assistant. It is not a medical
diagnosis tool and is not a substitute for evaluation by a certified medical
professional.

## Repository Layout

```text
.
├── backend/              # FastAPI API, database models, migrations, Docker setup
├── mobile/               # Flutter mobile app, TFLite model, UI, tests
├── README.md             # Minimal root project README
├── kevin.md              # Contributor note
├── nicho.md              # Contributor note
├── rafaeln.md            # Contributor note
└── vincent.md            # Contributor note
```

## Main Technologies

### Mobile App

- Flutter and Dart.
- Bloc/Cubit for authentication, scan state, and scan history state.
- TensorFlow Lite via `tflite_flutter` for local model inference.
- Camera and image picker packages for image capture and selection.
- `image` package for preprocessing and quality checks.
- `flutter_secure_storage` for JWT token persistence.
- `http` for API communication.

### Backend

- FastAPI for the HTTP API.
- Async SQLAlchemy with `asyncpg` for PostgreSQL access.
- Alembic for database migrations.
- Pydantic and Pydantic Settings for schemas and configuration.
- JWT authentication using PyJWT and password hashing with Passlib/bcrypt.
- Docker Compose for local backend and PostgreSQL orchestration.

## Mobile App

The Flutter app entrypoint is `mobile/lib/main.dart`. It initializes secure
storage, the API client, authentication service, authentication Cubit, scan
repository, scan Cubit, and scan history Cubit before launching `DermaScanApp`.

The app routes are defined in `mobile/lib/routes/app_router.dart`:

- `/onboarding` shows onboarding for unauthenticated users.
- `/login` handles user login.
- `/register` handles user registration.
- `/` opens the main tab shell.
- `/camera` opens camera capture.
- `/processing` runs scan processing for an image path.
- `/results` displays the scan result.

The main authenticated app shell uses bottom navigation with these tabs:

- Home
- Scan
- History
- Learn
- Profile

### Scan Flow

1. The user captures or selects an image.
2. The app evaluates image quality before inference.
3. The image is preprocessed into a `224x224x3` normalized tensor.
4. `TfliteService` loads `mobile/assets/model.tflite` and
   `mobile/assets/labels.txt`.
5. The model returns confidence scores for all labels.
6. The app selects the highest-confidence label and shows the result.
7. The scan result is synced to the backend in the background.

The current model labels are:

- `Malignant`
- `Pre-malignant`
- `Benign & Common`

### Image Quality Checks

`mobile/lib/core/utils/image_quality_evaluator.dart` rejects images that cannot
be decoded, are too dark, are too bright, or appear blurry. This helps avoid
running inference on low-quality inputs.

### Result Information

`mobile/lib/core/models/condition_info.dart` maps model labels to educational
information, risk levels, visual characteristics, risk factors, and suggested
next steps. The app consistently presents the output as an AI screening result,
not a diagnosis.

### API Configuration

The mobile API base URL is defined in
`mobile/lib/core/network/api_config.dart`. The current configured base URL is:

```text
https://dermascan.hib4.me
```

The mobile app uses these API paths:

- `/api/auth/register`
- `/api/auth/login`
- `/api/scans`

## Backend

The backend entrypoint is `backend/main.py`. It creates the FastAPI app,
configures CORS, registers auth and scan routers, and exposes health endpoints.

### API Endpoints

#### Health

- `GET /`
- `GET /api/health`

Both endpoints check database connectivity and return either a healthy response
or a degraded response with HTTP 503.

#### Authentication

- `POST /api/auth/register`
  - Accepts a JSON user registration payload.
  - Hashes the password.
  - Creates a user.
  - Returns a bearer JWT.
  - Returns HTTP 409 if the email is already registered.

- `POST /api/auth/login`
  - Accepts form fields `email` and `password`.
  - Verifies credentials.
  - Returns a bearer JWT.
  - Returns HTTP 401 for invalid credentials.

- `POST /api/auth/oauth`
  - Stub endpoint for future Google or Apple OAuth integration.
  - Currently returns HTTP 501.

#### Scans

- `POST /api/scans`
  - Requires bearer authentication.
  - Accepts multipart upload with:
    - `image`
    - `classification`
    - `confidence`
  - Validates that the upload is an image.
  - Stores the image as base64 data.
  - Stores the image MIME type in `image_path` for data URI construction.
  - Returns the created scan.

- `GET /api/scans`
  - Requires bearer authentication.
  - Returns scan history for the current user.

### Data Model

The backend stores users and scans in PostgreSQL.

`users` contains:

- `id`
- `name`
- `email`
- `hashed_password`
- `created_at`

`scans` contains:

- `id`
- `user_id`
- `image_path`
- `image_data`
- `classification`
- `confidence`
- `created_at`

`ScanResponse` includes a computed `image_uri` field that builds a browser-ready
data URI from the stored MIME type and base64 image data.

### Configuration

Backend settings live in `backend/app/core/config.py` and can be supplied with
environment variables or a `.env` file. The example configuration is in
`backend/.env.example`.

Important settings include:

- `APP_NAME`
- `DEBUG`
- `ALLOWED_ORIGINS`
- `SECRET_KEY`
- `ALGORITHM`
- `ACCESS_TOKEN_EXPIRE_MINUTES`
- PostgreSQL connection settings such as `PGHOST`, `PGDATABASE`, `PGUSER`, and
  `PGPASSWORD`

Docker Compose sets defaults for local development:

- PostgreSQL user: `dermascan`
- PostgreSQL password: `dermascan`
- PostgreSQL database: `dermascan`
- API port: `8000`
- PostgreSQL bound locally on `127.0.0.1:5432`

## Local Development

### Backend With Docker Compose

From the `backend/` directory:

```sh
docker compose up -d --build
```

Useful Makefile targets are available from `backend/`:

```sh
make up
make down
make build
make logs
make migrate
make makemigrations
make shell
```

Run migrations with:

```sh
docker compose exec web alembic upgrade head
```

### Backend Without Docker

From the `backend/` directory, create and activate a Python environment, install
dependencies, configure database environment variables, and run Uvicorn:

```sh
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The backend requires a reachable PostgreSQL database.

### Mobile App

From the `mobile/` directory:

```sh
flutter pub get
flutter run
```

Run mobile tests with:

```sh
flutter test
```

The mobile app must include both model assets declared in `mobile/pubspec.yaml`:

- `assets/model.tflite`
- `assets/labels.txt`

## Testing

The mobile app includes tests for:

- Authentication Cubit.
- Scan history Cubit.
- Models.
- API client behavior.
- Auth, camera, scan repository, and secure storage services.
- Login, registration, and history screens.
- Image preprocessing and image quality evaluation utilities.
- Primary and secondary button widgets.
- General widget smoke coverage.

Backend dependencies include pytest, pytest-asyncio, and httpx, but no backend
test files are currently present in the repository.

## Current Implementation Notes

- TFLite inference is performed locally on the device, not by the backend.
- Backend scan sync is fire-and-forget from the mobile scan Cubit, so sync
  errors are logged but do not block result display.
- JWTs are stored by the mobile app in secure storage.
- OAuth support is planned but not implemented.
- Scan images are stored in the database as base64 text, not as files.
- The backend accepts wildcard CORS origins by default in development.
- The root `README.md` and `mobile/README.md` are minimal placeholders compared
  with this summary.

