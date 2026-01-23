# Med Track - Quick Start Guide

## 🚀 Getting Started

### Step 1: Install Dependencies
Open terminal in the project directory and run:
```bash
cd c:\PTU\medtrack
flutter pub get
```

### Step 2: Run the Application
```bash
flutter run
```

Select your target device (Android emulator, iOS simulator, or physical device).

## 📱 Using the Application

### First Time Setup

1. **Launch the App**
   - The app will open to the login screen

2. **Create an Account**
   - Tap "Register" button
   - Fill in your details:
     - Full Name
     - Email
     - Phone Number
     - Password (minimum 8 characters)
   - Tap "Register"

3. **Verify OTP**
   - Enter the 6-digit OTP sent to your email/phone
   - You have 5 attempts to enter the correct OTP
   - Use "Resend OTP" if needed (available after 30 seconds)

4. **Success**
   - You'll see a success screen
   - Tap "Continue" to proceed to login

### Logging In

1. Enter your email and password
2. Tap "Login"
3. You'll be redirected to the Home screen

### Navigating the App

The app has 4 main sections accessible via bottom navigation:

#### 🏠 Home Tab
- View your personalized welcome message
- See health summary with total reports and status
- Search for specific tests using the search bar
- View recent reports
- Access notifications from the top-right bell icon

#### 📋 Reports Tab
- View all your uploaded medical reports
- Filter by category (Blood Tests, Hormones, etc.)
- Tap "Upload Report" button to add new reports

**Uploading a Report:**
1. Tap the "Upload Report" floating button
2. Choose:
   - "Take Photo" to capture with camera
   - "Choose from Gallery" to select existing image
3. Wait for text extraction (automatic using ML Kit)
4. Select test type from dropdown
5. Choose report date
6. Optionally add lab name
7. Review extracted text preview
8. Tap "Submit Report"

#### 📊 Insights Tab
- View graphical trends of your test results
- See your latest result with status (NORMAL/HIGH/LOW)
- Switch between different parameters using filter chips
- Tap "View Detailed History" to see all past results
- Filter history by month and year

#### 👤 Profile Tab
- View your personal information
- Edit profile details:
  - Name, email, phone
  - Date of birth, gender, blood group
  - Address
- Access settings
- Logout from the app

## 🔑 Key Features

### Search Tests
- Use the search bar on Home screen
- Type test name (e.g., "CBC", "Lipid Profile")
- Tap on a test to view details

### Track Trends
1. Go to Insights tab
2. Select a parameter (e.g., "Hemoglobin")
3. View the trend chart
4. See latest value and status
5. Compare with normal ranges

### Filter History
1. In Insights, tap "View Detailed History"
2. Use year and month dropdowns
3. View filtered results in table format

## 📋 Available Test Types

The app supports these medical tests:

**Blood Tests:**
- Complete Blood Count (CBC)
- Lipid Profile
- Blood Glucose
- Iron Studies

**Hormones:**
- Thyroid Function

**Organ Function:**
- Liver Function Test (LFT)
- Kidney Function Test (KFT)

**Vitamins:**
- Vitamin D
- Vitamin B12

**Other:**
- Urine Analysis

## 🎨 Understanding Status Colors

- 🟢 **Green (NORMAL)**: Your result is within the normal range
- 🔴 **Red (HIGH)**: Your result is above the normal range
- 🟡 **Yellow (LOW)**: Your result is below the normal range

## 💡 Tips & Best Practices

### For Best OCR Results:
1. Take photos in good lighting
2. Keep the document flat and avoid shadows
3. Ensure text is clear and readable
4. Capture the entire report in frame
5. Avoid blurry or tilted images

### Security:
1. Use a strong password (8+ characters)
2. Don't share your login credentials
3. Logout when using shared devices

### Regular Usage:
1. Upload reports as soon as you receive them
2. Check Insights regularly to track health trends
3. Set up notifications for checkup reminders

## 🔧 Troubleshooting

### App won't start?
```bash
flutter clean
flutter pub get
flutter run
```

### OCR not working?
- Ensure image is clear and well-lit
- Check that Google ML Kit dependencies are installed
- Try capturing the image again

### Can't login?
- Check your email and password
- Use "Forgot Password" to reset
- Ensure you've verified your OTP during registration

## 📞 Mock Data for Testing

The app currently uses mock data. You can:
- Login with any email and password
- Upload images (text extraction will work)
- View sample reports and trends

## 🔄 Next Steps

1. **Connect to Backend**: Update API endpoints in provider files
2. **Real Authentication**: Implement actual user management
3. **Cloud Storage**: Store reports in cloud storage
4. **Push Notifications**: Enable real-time notifications

## 📚 Learn More

Check out the main [README.md](README.md) for:
- Detailed feature descriptions
- Technical architecture
- Backend integration guide
- Complete API documentation

---

**Need Help?** Create an issue in the repository or contact support.

**Happy Tracking! 🏥💙**
