#!/usr/bin/env bash
# Render build script for the ABD News Django backend
set -o errexit

pip install --upgrade pip
pip install -r requirements.txt

# Admin / CKEditor CSS & JS (served by WhiteNoise)
python manage.py collectstatic --no-input

# Create / update database tables
python manage.py migrate --no-input

# Create the admin account once, from DJANGO_SUPERUSER_* environment variables
if [ -n "$DJANGO_SUPERUSER_USERNAME" ]; then
  python manage.py createsuperuser --no-input || echo "Superuser already exists - skipping"
fi

# Optional: load starter news content (safe to re-run, it never duplicates)
if [ "$SEED_DATA" = "true" ]; then
  python manage.py populate_real_data
fi
