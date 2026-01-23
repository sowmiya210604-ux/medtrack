# Med Track - Project Summary

## 🎯 Project Overview

**Med Track** is a comprehensive mobile healthcare application built with Flutter that enables users to manage their medical reports, track health metrics, and analyze test results over time. The application features a modern UI with custom branding colors and implements ML Kit for intelligent document processing.

## ✨ Core Features Implemented

### 1. Authentication System
- **Login Screen**: Email/password authentication with validation
- **Registration Screen**: Multi-field user registration form
- **OTP Verification**: 6-digit OTP input with:
  - Maximum 5 incorrect attempts
  - 30-second countdown for resend
  - Automatic field focus navigation
- **Forgot Password**: Password recovery flow
- **Reset Password**: Secure password change with confirmation
- **Success Screens**: Beautiful confirmation UI for successful operations

### 2. Main Application Structure
- **Bottom Navigation Bar** with 4 tabs:
  - Home 🏠
  - Reports 📋
  - Insights 📊
  - Profile 👤
- Smooth tab transitions using IndexedStack
- Persistent state across tab switches

### 3. Home Screen
**Components:**
- Branded app bar with logo and user profile
- Notification indicator with red dot
- Personalized greeting with user's name
- Health Summary Card with gradient background showing:
  - Total Reports count
  - Normal results count
  - Attention needed count
- Global Search Bar for test types
- Quick access test buttons (8 most common tests)
- Recent Reports section (last 3 uploads)
- Empty state UI when no reports exist

### 4. Reports Management
**Reports Screen:**
- Categorized report list grouped by month
- Category filter chips (All, Blood Tests, Hormones, etc.)
- Detailed report cards with:
  - Test name and date
  - Lab name
  - Doctor name (if available)
- Filter dialog for advanced filtering
- Floating action button for upload

**Upload Report Flow:**
- Image source selection:
  - Camera capture
  - Gallery selection
- Automatic processing:
  - File size validation (5MB limit)
  - Image clarity check using ML Kit Image Labeling
  - Text extraction using ML Kit Text Recognition
- Form inputs:
  - Test type selection (dropdown with 10 test types)
  - Report date picker
  - Optional lab name
- Extracted text preview with scrollable container
- Quality warning for unclear images
- Confirmation before submission

**Report Detail Screen:**
- Gradient header with test name
- Complete metadata display
- Extracted text section (when available)
- Share and download actions

### 5. Insights & Analytics
**Main Features:**
- Parameter selection chips
- Latest result card showing:
  - Current value with large display
  - Status badge (NORMAL/HIGH/LOW)
  - Test date
  - Normal range reference
- Interactive line chart (using fl_chart):
  - Multiple data points connected
  - Normal range indicator lines
  - Color-coded dots by status
  - Gradient fill under line
  - Touch tooltips
- View detailed history button
- All parameters overview list

**Test History Screen:**
- Year and month filter dropdowns
- Results displayed in table format
- Columns: Date, Value, Status
- Color-coded status badges
- Empty state for no results

### 6. Profile Management
**Profile Screen:**
- Gradient header with profile picture placeholder
- Personal Information section:
  - Full name
  - Email
  - Phone number
  - Date of birth
  - Gender
  - Blood group
  - Address
- Settings section:
  - Edit Profile
  - Notifications
  - Privacy & Security
  - Help & Support
- About section:
  - Terms of Service
  - Privacy Policy
  - App Version
- Logout button with confirmation dialog

**Edit Profile Screen:**
- Editable profile picture (placeholder)
- Form fields for all user data
- Date picker for birth date
- Dropdown for gender (Male/Female/Other)
- Dropdown for blood group (8 options)
- Multi-line address field
- Save changes button with loading state

## 🎨 Design System

### Color Palette
```dart
Primary: #0E21A0 (Deep Blue)
Secondary: #4D2FB2 (Purple Blue)
Tertiary: #B153D7 (Light Purple)
Accent: #F375C2 (Pink)
Background: #F8F9FE (Light Blue Tint)
Success: #10B981 (Green)
Warning: #F59E0B (Orange)
Error: #EF4444 (Red)
```

### Typography
- Font Family: Inter (via Google Fonts)
- Display Large: 32px, Bold
- Display Medium: 28px, Bold
- Display Small: 24px, Bold
- Headline Medium: 20px, Semi-Bold
- Body Large: 16px, Regular
- Body Medium: 14px, Regular

### Components
- **Cards**: White background, rounded corners (16px), subtle border
- **Buttons**: 
  - Elevated: Primary color, no elevation, 12px radius
  - Outlined: Primary border, transparent background
- **Input Fields**: White background, 12px radius, focused border animation
- **Bottom Nav**: White background, primary color selection
- **Gradients**: Used for headers and emphasis

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   └── theme/              # Theme and color definitions
├── features/
│   ├── auth/              # Authentication feature
│   │   ├── models/
│   │   ├── providers/
│   │   └── screens/
│   ├── home/              # Home feature
│   ├── reports/           # Reports management
│   ├── insights/          # Analytics and charts
│   ├── profile/           # User profile
│   └── main/              # Main app structure
└── main.dart              # App entry point
```

### State Management
- **Provider Pattern** for global state
- **AuthProvider**: User authentication state
- **ReportProvider**: Medical reports and test results
- ChangeNotifier for reactive updates

### Navigation
- MaterialPageRoute-based routing
- Named routes with parameter passing
- Route guards for authentication

## 🔌 Integrations

### Google ML Kit
1. **Text Recognition**:
   - Extract text from medical report images
   - Process scanned documents
   - Display extracted content

2. **Image Labeling**:
   - Validate image clarity
   - Detect document presence
   - Quality assurance

### FL Chart
- Line charts for trend analysis
- Customizable axes and labels
- Interactive touch tooltips
- Multiple data series support

### Image Picker
- Camera integration
- Gallery access
- Image compression and sizing

### Shared Preferences
- Local token storage
- User data caching
- Settings persistence

## 📊 Data Models

### User Model
```dart
- id: String
- name: String
- email: String
- phone: String
- profileImage: String?
- dateOfBirth: DateTime?
- gender: String?
- bloodGroup: String?
- address: String?
```

### Medical Report Model
```dart
- id: String
- userId: String
- testType: String
- testName: String
- reportDate: DateTime
- imageUrl: String?
- extractedText: String?
- testResults: Map<String, dynamic>?
- uploadedAt: DateTime
- doctorName: String?
- labName: String?
```

### Test Result Model
```dart
- id: String
- reportId: String
- testName: String
- parameterName: String
- value: double
- unit: String
- normalMin: double?
- normalMax: double?
- status: TestStatus (enum)
- testDate: DateTime
```

## 🧪 Test Types Supported

1. **Complete Blood Count (CBC)** - Hemoglobin, WBC, RBC, Platelets
2. **Lipid Profile** - Total Cholesterol, HDL, LDL, Triglycerides
3. **Blood Glucose** - Fasting, Random, HbA1c
4. **Thyroid Function** - TSH, T3, T4
5. **Liver Function Test (LFT)** - SGOT, SGPT, Bilirubin, Albumin
6. **Kidney Function Test (KFT)** - Creatinine, Urea, BUN
7. **Vitamin D** - 25-OH Vitamin D
8. **Vitamin B12** - Vitamin B12
9. **Urine Analysis** - pH, Protein, Glucose, Blood
10. **Iron Studies** - Serum Iron, Ferritin, TIBC

## 📦 Dependencies

### Core Dependencies
- flutter (SDK)
- provider: ^6.1.1 (State Management)
- google_fonts: ^6.1.0 (Typography)
- intl: ^0.19.0 (Date Formatting)

### UI & Navigation
- go_router: ^13.0.0
- flutter_svg: ^2.0.9
- animations: ^2.0.11

### Image & Camera
- image_picker: ^1.0.7
- image: ^4.1.7

### ML Kit
- google_mlkit_text_recognition: ^0.11.0
- google_mlkit_image_labeling: ^0.10.0

### Charts
- fl_chart: ^0.66.0

### Backend
- http: ^1.2.0
- shared_preferences: ^2.2.2

## 🔧 Backend API Structure (To Implement)

### Authentication Endpoints
```
POST /api/auth/login
POST /api/auth/register
POST /api/auth/verify-otp
POST /api/auth/resend-otp
POST /api/auth/forgot-password
POST /api/auth/reset-password
GET  /api/auth/me
```

### Reports Endpoints
```
GET    /api/reports
POST   /api/reports/upload
GET    /api/reports/{id}
PUT    /api/reports/{id}
DELETE /api/reports/{id}
```

### Test Results Endpoints
```
GET /api/test-results
GET /api/test-results/{parameter}
GET /api/test-results/trends
```

### User Endpoints
```
GET /api/user/profile
PUT /api/user/profile
```

## 🚀 Getting Started

1. Install Flutter SDK
2. Clone the repository
3. Run `flutter pub get`
4. Run `flutter run`

See [QUICKSTART.md](QUICKSTART.md) for detailed instructions.

## 📈 Current Status

### Completed ✅
- Complete UI implementation
- Authentication flow
- State management setup
- Reports management
- ML Kit OCR integration
- Charts and analytics
- Profile management
- Navigation and routing
- Mock data for testing

### Ready for Integration 🔌
- Backend API connection
- Real authentication
- Cloud storage for images
- Push notifications
- Real-time data sync

### Future Enhancements 🎯
- Offline support
- PDF report generation
- Doctor appointments
- Medication reminders
- Health articles
- Dark mode
- Multi-language support

## 📝 Notes

- All API calls are currently mocked for frontend testing
- ML Kit requires proper platform configuration (see README)
- Sample data is generated in providers for demonstration
- File size limit for uploads is 5MB
- OTP verification allows 5 attempts before requiring resend
- Charts show trends for the last 3-6 months of data

## 🎓 Learning Outcomes

This project demonstrates:
- Clean Flutter architecture
- State management with Provider
- ML Kit integration
- Custom theming and styling
- Complex UI implementations
- Navigation patterns
- Form validation
- Image processing
- Chart creation
- Responsive design

---

**Project Status**: Frontend Complete ✅
**Ready for**: Backend Integration
**Deployment**: Pending API Setup
