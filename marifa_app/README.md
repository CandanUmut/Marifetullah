# Marifa App

Marifa App is a bilingual (Turkish and English) Flutter application that supports seekers in learning the 99 Names of Allah, reflecting on the concept of ma'rifatullah, and tracking personal progress. The app bundles a concise research dossier, practical exercises, and offline-friendly data so that users can continue their study anywhere.

## Features
- Material 3 interface with responsive layouts for mobile and web.
- Browse the 99 Names of Allah with search, reflection prompts, and daily practices.
- Track reviewed names, completion percentage, and daily streak progress.
- Explore a bilingual research outline covering classical theology, spirituality, and daily application.
- Switch seamlessly between Turkish and English; preferences and progress are stored locally.
- Access curated PDF resources hosted online via the Resources section.

## Getting Started

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) (stable channel, Dart 3 compatible).

### Install dependencies
```bash
flutter pub get
```

### Run the app
```bash
flutter run -d chrome   # Web
flutter run -d ios      # iOS (macOS required)
flutter run -d android  # Android
```

## Project Structure
- `assets/`: Bundled JSON data for names, research dossier, and resource links.
- `lib/`: Flutter application source organized by utilities, models, services, providers, and pages.
- `test/`: Basic unit tests for data loading and streak/progress logic.

## Data & Customization
- Update `assets/names_en.json` and `assets/names_tr.json` to refine entries for the 99 Names.
- Extend `assets/research_en.json` and `assets/research_tr.json` with additional sections or deeper study notes.
- Adjust resource links in `assets/resources.json` to point to your own hosted PDFs or study materials.

After editing any JSON asset, rerun `flutter pub get` (to ensure asset manifests update) and rebuild the application.

## Respectful Usage
The content provided is intended for sincere study and remembrance. Maintain reverence when displaying or modifying the sacred Names. Avoid using the materials for commercial exploitation or contexts that diminish their sanctity.

## License
This project is provided for educational purposes. Review the repository license for usage terms.
