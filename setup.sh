#!/bin/bash

echo "Generating .env...";
cp config/.env.example config/.env;
cp config/.env.example config/prod.env;
echo "Fetching flutter packages...";
flutter pub get;
echo "Generating missing files...";
flutter packages pub run build_runner build --delete-conflicting-outputs;
echo "Setup localization"
flutter gen-l10n
echo "Configuring git hooks..."
git config core.hooksPath .hooks

echo "Done."