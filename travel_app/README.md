# Travel App

A cross-platform travel app with vibrant UI built using Flutter.

## Features

- Beautiful home page with Instagram-inspired design
- Search functionality for destinations
- Grid of destination cards with animations
- Bottom navigation bar
- Responsive design for both iOS and Android
- Dark/light mode support
- Accessibility features
- Itinerary creation with mock AI integration
- Form with glassmorphic design
- Interactive budget slider
- Travel type selection with chips
- Group size dropdown
- Date picker
- Animated generate button
- Swipeable itinerary cards
- Save functionality with animations

## Setup

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` (ensure emulator/device is connected)

## Development

- The app uses Flutter 3.22.2
- Dependencies are managed through pubspec.yaml
- Tests can be run using `flutter test`

## Project Structure

```
lib/
  ├── features/
  │   ├── home/
  │   │   └── home_page.dart
  │   └── itinerary/
  │       └── itinerary_page.dart
  ├── core/
  │   └── widgets/
  │       └── nav_bar.dart
  ├── models/
  │   └── itinerary.dart
  ├── services/
  │   └── itinerary_service.dart
  └── main.dart
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT License
Copyright (c) 2025 Tuhin Rawat
