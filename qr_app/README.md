# QR Pro

A professional QR Code Scanner and Generator app built with Flutter. Scan QR codes using your device camera or generate new QR codes from text input.

![Flutter](https://img.shields.io/badge/Flutter-3.2%2B-blue)
![Dart](https://img.shields.io/badge/Dart-3.2%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

✨ **QR Code Generation**
- Convert text, URLs, and other data into scannable QR codes
- Real-time QR code preview
- Clean and intuitive interface

📱 **QR Code Scanner**
- High-performance camera-based QR code scanner
- Instant barcode recognition
- Support for multiple QR code formats
- Auto-focus and flash control
- Camera permission handling

🎨 **User Experience**
- Beautiful Material Design UI
- Dark and Light theme support
- Portrait orientation for optimal scanning
- Smooth tab navigation between Scanner and Generator
- Responsive layout for various screen sizes

## Platform Support

- ✅ **Android** 5.0+
- ✅ **iOS** 12.0+

## Getting Started

### Prerequisites

- Flutter SDK 3.2.0 or higher
- Dart SDK 3.2.0 or higher
- Android Studio / Xcode for building

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/qr_app.git
cd qr_app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                      # App entry point and navigation setup
├── screens/
│   ├── generator_screen.dart      # QR code generation screen
│   ├── scanner_screen.dart        # QR code scanning screen
│   └── scanner_screen_camera.dart # Camera interface for scanning
├── theme/
│   └── app_theme.dart             # App theming and styling
└── widgets/                       # Reusable UI components
```

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `qr_flutter` | ^4.1.0 | QR code generation and rendering |
| `mobile_scanner` | ^7.2.0 | Camera-based QR/Barcode scanning |
| `permission_handler` | ^12.0.1 | Runtime camera permission handling |
| `google_fonts` | ^8.0.2 | Inter typeface for enhanced typography |

## Usage

### Generate QR Code
1. Open the app and navigate to the **Generator** tab
2. Enter text, URL, or any data
3. View the generated QR code
4. Share or save the QR code

### Scan QR Code
1. Open the app and navigate to the **Scanner** tab
2. Point your camera at a QR code
3. The app will automatically recognize and process the code
4. View the decoded data

## Configuration

### Android Configuration

Permissions are configured in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### iOS Configuration

Permissions are configured in `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>
```

## Building for Release

### Android APK
```bash
flutter build apk --release
```

### iOS App
```bash
flutter build ios --release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Troubleshooting

### Camera Permission Denied
- Ensure you've granted camera permissions in your device settings
- On Android, check Settings > Apps > QR Pro > Permissions

### QR Code Not Scanning
- Ensure the QR code is clearly visible
- Try adjusting the camera angle and distance
- Check that adequate lighting is available

### Build Issues
- Run `flutter clean` and `flutter pub get`
- Ensure all platform requirements are met
- Check Flutter and Dart versions: `flutter --version`

## Support

For issues and questions, please open an issue on the GitHub repository.

## Authors

- Your Name - [GitHub](https://github.com/yourusername)

## Acknowledgments

- Flutter team for the amazing framework
- mobile_scanner package for efficient QR scanning
- qr_flutter package for QR generation
- Material Design for UI/UX guidelines
