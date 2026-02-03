# Med Track - Healthcare Management App

A comprehensive mobile healthcare application built with Flutter that helps users track and manage their medical reports and test results.

## Features

### 🔐 Authentication Flow
- **Login** - Secure user authentication
- **Registration** - New user signup with detailed information
- **OTP Verification** - Email/SMS verification with resend functionality
- **Forgot Password** - Password recovery flow
- **Reset Password** - Secure password reset
- **Success Screens** - User-friendly confirmation messages

### 🏠 Home Screen
- Personalized welcome message with user's name
- Health summary dashboard showing total reports and status overview
- Recent report analysis cards
- Global search bar with all supported test types as selectable buttons
- Quick navigation to detailed test reports

### 📋 Reports Management
- Clean, categorized list of uploaded medical reports
- **Upload Report Flow:**
  - Capture image using camera or select from gallery
  - File size validation (5MB limit)
  - Image clarity validation using Google ML Kit
  - Test type selection from predefined list
  - OCR text extraction using Google ML Kit Text Recognition
  - Preview extracted text before submission
  - Date and lab information input
- Detailed report view with all metadata
- Filter and sort capabilities

### 📊 Insights & Analytics
- Interactive charts showing test results over time using fl_chart
- Latest result display with date and condition status (NORMAL, HIGH, LOW)
- Trend analysis for each health parameter
- Detailed history screen with:
  - Tabular view of all past results
  - Month and year filters
  - Status indicators
  - Normal range comparisons

### 👤 Profile Management
- Display user personal details
- Edit profile information:
  - Name, email, phone
  - Date of birth
  - Gender
  - Blood group
  - Address
- Settings and preferences
- Logout functionality

### 🎨 Design Features
- Modern UI with custom color scheme:
  - Primary: #0E21A0 (Deep Blue)
  - Secondary: #4D2FB2 (Purple Blue)
  - Tertiary: #B153D7 (Light Purple)
  - Accent: #F375C2 (Pink)
- Smooth animations and transitions
- Material Design 3 principles
- Responsive design for various screen sizes
- Notification indicators

### 🔧 Technical Features
- Clean Flutter architecture
- State management using Provider
- ML Kit integration for OCR and image processing
- Reusable widgets and components
- Placeholder API integration points
- Proper routing and navigation

## Available Test Types

The app supports the following medical test categories:

### Blood Tests
- Complete Blood Count (CBC)
- Lipid Profile
- Blood Glucose
- Iron Studies

### Hormones
- Thyroid Function Tests

### Organ Function
- Liver Function Test (LFT)
- Kidney Function Test (KFT)

### Vitamins
- Vitamin D
- Vitamin B12

### Other
- Urine Analysis

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode for mobile development
- VS Code or Android Studio as IDE

### Installation

1. **Clone the repository**
   ```bash
   cd c:\PTU\medtrack
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart       # Color definitions
│       └── app_theme.dart        # Theme configuration
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       ├── otp_verification_screen.dart
│   │       ├── forgot_password_screen.dart
│   │       ├── reset_password_screen.dart
│   │       └── success_screen.dart
│   ├── home/
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   │       ├── health_summary_card.dart
│   │       ├── recent_report_card.dart
│   │       └── test_search_button.dart
│   ├── reports/
│   │   ├── models/
│   │   │   ├── report_model.dart
│   │   │   └── test_type_model.dart
│   │   ├── providers/
│   │   │   └── report_provider.dart
│   │   └── screens/
│   │       ├── reports_screen.dart
│   │       ├── upload_report_screen.dart
│   │       ├── report_detail_screen.dart
│   │       └── test_detail_screen.dart
│   ├── insights/
│   │   ├── screens/
│   │   │   ├── insights_screen.dart
│   │   │   └── test_history_screen.dart
│   │   └── widgets/
│   │       └── test_result_chart.dart
│   ├── profile/
│   │   └── screens/
│   │       ├── profile_screen.dart
│   │       └── edit_profile_screen.dart
│   └── main/
│       └── screens/
│           └── main_screen.dart
└── main.dart
```

## Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # Navigation
  go_router: ^13.0.0
  
  # UI Components
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  
  # Image Processing
  image_picker: ^1.0.7
  image: ^4.1.7
  
  # ML Kit for OCR
  google_mlkit_text_recognition: ^0.11.0
  google_mlkit_image_labeling: ^0.10.0
  
  # Charts
  fl_chart: ^0.66.0
  
  # HTTP & API
  http: ^1.2.0
  
  # Local Storage
  shared_preferences: ^2.2.2
  
  # Date & Time
  intl: ^0.19.0
  
  # Animations
  animations: ^2.0.11
```

## Backend Integration

The app is designed with placeholder API integration points. To connect to your backend:

1. Update the API endpoints in the provider files
2. Implement actual HTTP calls in:
   - `lib/features/auth/providers/auth_provider.dart`
   - `lib/features/reports/providers/report_provider.dart`
3. Add authentication token management
4. Implement proper error handling

### API Endpoints (To Be Implemented)

- **Authentication**
  - `POST /api/auth/login`
  - `POST /api/auth/register`
  - `POST /api/auth/verify-otp`
  - `POST /api/auth/resend-otp`
  - `POST /api/auth/forgot-password`
  - `POST /api/auth/reset-password`

- **Reports**
  - `GET /api/reports`
  - `POST /api/reports/upload`
  - `GET /api/reports/{id}`
  - `DELETE /api/reports/{id}`

- **Test Results**
  - `GET /api/test-results`
  - `GET /api/test-results/{parameter}`

- **User Profile**
  - `GET /api/user/profile`
  - `PUT /api/user/profile`

## ML Kit Configuration

### Android Configuration
Add to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-mlkit-text-recognition:19.0.0'
    implementation 'com.google.android.gms:play-services-mlkit-image-labeling:17.0.7'
}
```

### iOS Configuration
Add to `ios/Podfile`:
```ruby
pod 'GoogleMLKit/TextRecognition'
pod 'GoogleMLKit/ImageLabeling'
```

## Testing

The app includes mock data for testing purposes:
- Mock user authentication
- Sample medical reports
- Sample test results with trends

To test the app:
1. Run the app
2. Register a new account or use the login screen
3. Enter any email and password (mock authentication)
4. Navigate through the app to explore features

## Features Implementation Status

✅ Authentication Flow (Login, Register, OTP, Password Reset)
✅ Home Screen with Search
✅ Reports Management
✅ Upload Report with ML Kit OCR
✅ Insights with Charts
✅ Profile Management
✅ Theme and Styling
✅ State Management
✅ Navigation and Routing

## Future Enhancements

- [ ] Real backend API integration
- [ ] Push notifications
- [ ] Offline support with local database
- [ ] Report sharing via email/WhatsApp
- [ ] PDF report generation
- [ ] Biometric authentication
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Doctor appointment booking
- [ ] Medication reminders
- [ ] Health tips and articles

## License

This project is created for educational purposes.

## Support

For issues and questions, please create an issue in the repository.

---

**Built with ❤️ using Flutter**
