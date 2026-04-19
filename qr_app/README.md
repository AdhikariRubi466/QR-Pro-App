# 🚀 QR Pro App

A professional **QR Code Scanner & Generator** built with Flutter.  
Scan QR codes instantly using your device camera or generate new QR codes from text, URLs, and more.

---

## 📌 Features

### ✨ QR Code Generation
- Convert text, URLs, and data into QR codes  
- Real-time preview  
- Simple and clean interface  

### 📱 QR Code Scanner
- High-performance camera scanning  
- Instant recognition  
- Supports multiple formats  
- Auto-focus & flash control  
- Smart permission handling  

### 🎨 User Experience
- Material Design UI  
- Dark & Light theme support  
- Smooth navigation (Scanner ↔ Generator)  
- Responsive layout  

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- Android (Gradle) / iOS

---

## 📱 Platform Support

- ✅ Android 5.0+
- ✅ iOS 12.0+

---

## 🚀 Getting Started

### 🔧 Prerequisites
- Flutter SDK 3.2+
- Dart SDK 3.2+
- Android Studio / Xcode

---

### 📥 Installation

```bash
git clone https://github.com/AdhikariRubi466/QR-Pro-App.git
cd QR-Pro-App/qr_app
flutter pub get
flutter run
```

---

## 📂 Project Structure

```bash
lib/
├── main.dart
├── screens/
│   ├── generator_screen.dart
│   ├── scanner_screen.dart
│   └── scanner_screen_camera.dart
├── theme/
│   └── app_theme.dart
└── widgets/
```

---

## 📦 Dependencies

| Package | Purpose |
|--------|--------|
| qr_flutter | QR generation |
| mobile_scanner | QR scanning |
| permission_handler | Camera permissions |
| google_fonts | Typography |

---

## 📸 Screenshots

> Add app screenshots here

---

## ⚙️ Configuration

### Android
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### iOS
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>
```

---

## 🏗️ Build

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

---

## 🤝 Contributing

1. Fork the repo  
2. Create a branch (`feature/your-feature`)  
3. Commit changes  
4. Push and open a Pull Request  

---

## 🧪 Troubleshooting

### Camera not working
- Check permissions in device settings  

### QR not scanning
- Ensure proper lighting  
- Adjust distance and angle  

### Build issues
```bash
flutter clean
flutter pub get
```

---

## 📄 License

MIT License

---

## 👤 Author

**AdhikariRubi466**

---

## ⭐ Support

If you like this project, give it a ⭐ on GitHub!
