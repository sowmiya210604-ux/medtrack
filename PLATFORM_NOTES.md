# Platform-Specific Notes

## Overview
Med Track is designed primarily for **Android and iOS** mobile platforms. Some features have limited functionality on web due to platform constraints.

## Feature Availability by Platform

### ✅ Full Support (All Platforms)
- Authentication (Login, Register, OTP, Password Reset)
- Home Screen & Navigation
- Reports Viewing & Filtering
- Insights & Charts
- Profile Management
- Mock Data Testing

### ⚠️ Limited on Web
- **ML Kit OCR**: Text recognition from medical reports
  - **Android/iOS**: ✅ Full OCR support using Google ML Kit
  - **Web**: ❌ Not available (platform limitation)
  - **Workaround**: Message displayed; use mobile devices for OCR

- **Camera Access**: 
  - **Android/iOS**: ✅ Direct camera capture
  - **Web**: ⚠️ Limited (browser-dependent)

- **Image Clarity Validation**:
  - **Android/iOS**: ✅ Using ML Kit Image Labeling
  - **Web**: ❌ Disabled

### 🔧 Technical Implementation

The app uses `kIsWeb` flag to detect platform and conditionally enable features:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;

if (!kIsWeb) {
  // Mobile-only code (ML Kit, etc.)
} else {
  // Web fallback
}
```

## Running on Different Platforms

### 🌐 Web (Testing & Preview)
```bash
flutter run -d chrome
```
**Use for**: UI testing, layout verification, general functionality
**Limitations**: No OCR, limited camera access

### 📱 Android
```bash
flutter run -d <android_device_id>
```
**Use for**: Full feature testing including ML Kit OCR
**Requirements**: 
- Android device/emulator (API 21+)
- Google Play Services
- Camera permissions

### 🍎 iOS  
```bash
flutter run -d <ios_device_id>
```
**Use for**: Full feature testing including ML Kit OCR
**Requirements**:
- iOS device/simulator (iOS 10.0+)
- Camera permissions
- CocoaPods dependencies

## Recommended Development Workflow

1. **Initial Development & UI**: Use **web** for fast hot reload
2. **ML Kit Testing**: Switch to **Android/iOS** device
3. **Final Testing**: Test on both **Android** and **iOS**

## ML Kit Setup Requirements

### Android
Add to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-mlkit-text-recognition:19.0.0'
    implementation 'com.google.android.gms:play-services-mlkit-image-labeling:17.0.7'
}
```

### iOS
Add to `ios/Podfile`:
```ruby
target 'Runner' do
  pod 'GoogleMLKit/TextRecognition'
  pod 'GoogleMLKit/ImageLabeling'
end
```

Then run:
```bash
cd ios
pod install
```

## Troubleshooting

### Error: "No implementation found for method vision#closeTextRecognizer"
**Cause**: Running on web platform where ML Kit is not supported
**Solution**: ✅ Already handled with platform detection

### Error: "File class not available on web"
**Cause**: Using dart:io File class on web
**Solution**: ✅ Fixed - Now using XFile with conditional rendering

### Camera Not Working on Web
**Solution**: 
- Use mobile device for full camera support
- Or ensure browser permissions are granted
- Some browsers may not support camera API

### Image Not Displaying on Web
**Solution**: ✅ Fixed - Now using `Image.network` for web, `Image.file` for mobile

## Future Enhancements

### Web Platform
- Implement web-based OCR alternative (e.g., Tesseract.js)
- Add drag-and-drop file upload
- Improve browser compatibility

### Mobile Platforms
- ✅ Already optimized for mobile
- Background upload queuing
- Offline mode support

## Testing Checklist

### Web Testing ✓
- [ ] Login/Register flow
- [ ] Navigation between tabs
- [ ] View existing reports
- [ ] Upload image (gallery only)
- [ ] View charts and insights
- [ ] Edit profile

### Android Testing 📱
- [ ] All web features
- [ ] Camera capture
- [ ] OCR text extraction
- [ ] Image clarity validation
- [ ] Permissions handling

### iOS Testing 🍎
- [ ] All web features  
- [ ] Camera capture
- [ ] OCR text extraction
- [ ] Image clarity validation
- [ ] Permissions handling

## Performance Notes

- **Web**: Faster hot reload, good for UI development
- **Android Emulator**: Slower than physical device
- **iOS Simulator**: Cannot test camera (use physical device)
- **Physical Devices**: Best performance and feature testing

## Deployment

- **Web**: Deploy to Firebase Hosting, Netlify, or Vercel
  - Note: OCR will not work on deployed web app
  
- **Android**: Build APK/AAB for Google Play Store
  - Full feature support including OCR
  
- **iOS**: Build IPA for App Store
  - Full feature support including OCR

## Summary

For the **best development experience**:
1. Use **web** for rapid UI development and testing
2. Switch to **mobile device** when testing OCR and camera features
3. Final testing on **both Android and iOS** physical devices

The app gracefully handles platform differences and provides appropriate feedback to users when features are unavailable.
