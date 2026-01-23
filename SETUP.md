# Setup Instructions for Med Track

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your system PATH

2. **Dart SDK** (comes with Flutter)
   - Verify: `dart --version`

3. **IDE** (choose one):
   - **VS Code** with Flutter extension
   - **Android Studio** with Flutter plugin

4. **Platform-Specific Tools**:
   - **For Android**: Android Studio, Android SDK
   - **For iOS**: Xcode (macOS only)

## Installation Steps

### 1. Verify Flutter Installation
```bash
flutter doctor
```
This command checks your environment and displays a report. Fix any issues it identifies.

### 2. Navigate to Project Directory
```bash
cd c:\PTU\medtrack
```

### 3. Install Dependencies
```bash
flutter pub get
```

This will download all required packages specified in `pubspec.yaml`.

### 4. Verify Project Setup
```bash
flutter analyze
```

This checks for any code issues.

## Platform-Specific Setup

### Android Setup

1. **Open Android Studio**
2. **Configure Android SDK**:
   - Go to Tools > SDK Manager
   - Install Android SDK (API level 21 or higher)
   - Install Android SDK Command-line Tools

3. **Create or Connect Android Emulator**:
   - In Android Studio: Tools > Device Manager
   - Create a new virtual device or connect a physical device

4. **Enable USB Debugging** (for physical devices):
   - Settings > About Phone > Tap "Build Number" 7 times
   - Settings > Developer Options > Enable USB Debugging

5. **Accept Android Licenses**:
   ```bash
   flutter doctor --android-licenses
   ```

6. **Add ML Kit Dependencies** (already in build.gradle):
   - File: `android/app/build.gradle`
   ```gradle
   dependencies {
       implementation 'com.google.android.gms:play-services-mlkit-text-recognition:19.0.0'
       implementation 'com.google.android.gms:play-services-mlkit-image-labeling:17.0.7'
   }
   ```

### iOS Setup (macOS only)

1. **Install Xcode** from App Store

2. **Install CocoaPods**:
   ```bash
   sudo gem install cocoapods
   ```

3. **Navigate to iOS directory**:
   ```bash
   cd ios
   ```

4. **Install iOS Dependencies**:
   ```bash
   pod install
   ```

5. **Open Xcode**:
   ```bash
   open Runner.xcworkspace
   ```

6. **Configure Signing**:
   - Select Runner in project navigator
   - Go to Signing & Capabilities
   - Select your development team

7. **Add ML Kit to Podfile**:
   - File: `ios/Podfile`
   ```ruby
   target 'Runner' do
     pod 'GoogleMLKit/TextRecognition'
     pod 'GoogleMLKit/ImageLabeling'
   end
   ```

## Running the Application

### Option 1: Using Command Line

1. **List Available Devices**:
   ```bash
   flutter devices
   ```

2. **Run on Specific Device**:
   ```bash
   flutter run -d <device_id>
   ```

3. **Run in Debug Mode** (default):
   ```bash
   flutter run
   ```

4. **Run in Release Mode**:
   ```bash
   flutter run --release
   ```

### Option 2: Using VS Code

1. Open the project in VS Code
2. Press `F5` or click "Run" > "Start Debugging"
3. Select your target device from the bottom status bar

### Option 3: Using Android Studio

1. Open the project in Android Studio
2. Select target device from device dropdown
3. Click the green "Run" button (▶️)

## Hot Reload & Hot Restart

While the app is running:
- **Hot Reload** (apply code changes without restart):
  - Press `r` in terminal
  - Or save files in IDE (auto hot reload)

- **Hot Restart** (restart app):
  - Press `R` in terminal
  - Or click hot restart button in IDE

## Testing the Application

### Login Testing
Use any email and password combination (mock authentication):
- Email: `test@example.com`
- Password: `password123`

### Upload Report Testing
1. Navigate to Reports tab
2. Click "Upload Report"
3. Use sample images or capture new ones
4. Select test type and submit

## Troubleshooting

### Common Issues

#### Issue: "Flutter command not found"
**Solution**: Add Flutter to your PATH
```bash
export PATH="$PATH:[PATH_TO_FLUTTER_DIRECTORY]/flutter/bin"
```

#### Issue: "Gradle build failed"
**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Issue: "CocoaPods not installed"
**Solution**:
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

#### Issue: "ML Kit not working"
**Solution**:
1. Ensure Google Play Services is updated on device
2. Check internet connection (first-time ML Kit download)
3. Verify dependencies in build.gradle (Android) or Podfile (iOS)

#### Issue: "Hot reload not working"
**Solution**:
1. Try hot restart (`R` key)
2. Stop app and run again
3. Run `flutter clean` then `flutter pub get`

#### Issue: "Camera permission denied"
**Solution**:
1. **Android**: Add to `AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   ```

2. **iOS**: Add to `Info.plist`:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access to scan medical reports</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>This app needs photo library access to upload medical reports</string>
   ```

### Performance Issues

If the app runs slowly:
1. Run in release mode: `flutter run --release`
2. Close other applications
3. Use a physical device instead of emulator
4. Check device specifications

### Build Errors

If you encounter build errors:
```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter run
```

## Project Configuration

### Environment Variables
Currently uses mock data. To connect to backend:
1. Create `lib/core/config/api_config.dart`:
   ```dart
   class ApiConfig {
     static const String baseUrl = 'YOUR_API_URL';
     static const String apiKey = 'YOUR_API_KEY';
   }
   ```

2. Update providers to use real API endpoints

### Firebase Setup (Optional)
For future push notifications:
1. Create Firebase project
2. Add `google-services.json` (Android)
3. Add `GoogleService-Info.plist` (iOS)
4. Follow Firebase setup guide

## Development Workflow

### Making Changes
1. Create a new branch for features
2. Make code changes
3. Test with hot reload
4. Run `flutter analyze` to check code
5. Run `flutter test` for unit tests
6. Commit and push changes

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable names
- Add comments for complex logic
- Keep widgets small and reusable

### Adding New Features
1. Create models in appropriate feature folder
2. Add provider methods if needed
3. Create UI screens/widgets
4. Add navigation routes
5. Test thoroughly

## Deployment

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS
```bash
flutter build ios --release
```
Then archive and upload via Xcode.

## Useful Commands

```bash
# Check Flutter version
flutter --version

# Update Flutter
flutter upgrade

# List devices
flutter devices

# Run tests
flutter test

# Check code quality
flutter analyze

# Format code
flutter format .

# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade
```

## Resources

### Documentation
- [README.md](README.md) - Project overview
- [QUICKSTART.md](QUICKSTART.md) - User guide
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Technical details
- [FEATURES.md](FEATURES.md) - Complete feature list

### Official Documentation
- Flutter: https://flutter.dev/docs
- Dart: https://dart.dev/guides
- Material Design: https://material.io/design
- ML Kit: https://developers.google.com/ml-kit

### Community
- Flutter Community: https://flutter.dev/community
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- Flutter GitHub: https://github.com/flutter/flutter

## Getting Help

If you encounter issues:
1. Check the troubleshooting section above
2. Review Flutter documentation
3. Search Stack Overflow
4. Check GitHub issues
5. Ask in Flutter community forums

## Next Steps

After successful setup:
1. ✅ Run the app and explore features
2. ✅ Test authentication flow
3. ✅ Upload a sample medical report
4. ✅ View insights and charts
5. ✅ Edit profile information
6. ✅ Familiarize yourself with the codebase
7. ✅ Plan backend integration
8. ✅ Set up version control
9. ✅ Configure CI/CD pipeline
10. ✅ Prepare for deployment

---

**Happy Coding! 🚀**

For questions or issues, refer to the documentation or create an issue in the repository.
