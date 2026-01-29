# 🚀 Running MedTrack - Complete Full-Stack App

Complete guide to run your MedTrack healthcare application (Flutter frontend + Node.js backend).

---

## 📋 Prerequisites

Before starting, ensure you have:

- ✅ **Node.js 18+** installed (`node --version`)
- ✅ **PostgreSQL** running
- ✅ **Flutter SDK** installed (`flutter --version`)
- ✅ **Android Studio** / **VS Code** with Flutter extension
- ✅ **Android Emulator** or **Physical Device** connected
- ✅ **Gmail App Password** configured in backend `.env`

---

## 🎯 Step 1: Start the Backend (6 Microservices)

### Option A: Automated Start (Recommended)

```powershell
# Navigate to backend
cd C:\PTU\medtrack\backend

# Start all 6 services at once
.\start-all-services.ps1
```

This opens 6 PowerShell windows (one per service on ports 3001-3006).

### Option B: Manual Start

Open 6 separate terminals and run:

```bash
# Terminal 1 - Auth Service
cd C:\PTU\medtrack\backend
npm run dev:auth

# Terminal 2 - Profile Service
npm run dev:profile

# Terminal 3 - Report Service
npm run dev:report

# Terminal 4 - Health Analysis Service
npm run dev:health

# Terminal 5 - History Service
npm run dev:history

# Terminal 6 - Notification Service
npm run dev:notification
```

### ✅ Verify Backend is Running

Test health endpoints:

```powershell
# Quick test all services
Invoke-RestMethod http://localhost:3001/health
Invoke-RestMethod http://localhost:3002/health
Invoke-RestMethod http://localhost:3003/health
Invoke-RestMethod http://localhost:3004/health
Invoke-RestMethod http://localhost:3005/health
Invoke-RestMethod http://localhost:3006/health
```

All should return: `{"status":"ok","service":"...","timestamp":"..."}`

---

## 📱 Step 2: Configure Flutter App for Backend

### Update API Configuration

Edit **`lib/core/services/api_config.dart`**:

```dart
class ApiConfig {
  static const bool isProduction = false;
  
  // IMPORTANT: Choose based on how you're running Flutter
  
  // For Android Emulator (AVD):
  static const String _devBaseUrl = 'http://10.0.2.2';
  
  // For iOS Simulator:
  // static const String _devBaseUrl = 'http://localhost';
  
  // For Physical Device (use your computer's IP):
  // static const String _devBaseUrl = 'http://192.168.1.100';
  
  static String get baseUrl => isProduction ? _prodBaseUrl : _devBaseUrl;
  
  // Service URLs
  static String get authUrl => '$baseUrl:3001/api/auth';
  static String get profileUrl => '$baseUrl:3002/api/profile';
  static String get reportUrl => '$baseUrl:3003/api/reports';
  static String get healthAnalysisUrl => '$baseUrl:3004/api/health-analysis';
  static String get historyUrl => '$baseUrl:3005/api/history';
  static String get notificationUrl => '$baseUrl:3006/api/notifications';
}
```

**Finding Your Computer's IP (for Physical Device):**

```powershell
# Windows - PowerShell
ipconfig | findstr IPv4

# Look for: IPv4 Address. . . . . . . . . . . : 192.168.1.XXX
```

---

## 🏃 Step 3: Run Flutter App

### Method 1: Using VS Code

1. **Open Flutter Project**: Open `C:\PTU\medtrack` in VS Code
2. **Select Device**: Click device selector in bottom-right (Chrome, Android Emulator, etc.)
3. **Run**: Press `F5` or click "Run > Start Debugging"

### Method 2: Using Command Line

```bash
# Navigate to Flutter project root
cd C:\PTU\medtrack

# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Examples:
flutter run -d chrome              # Web browser
flutter run -d emulator-5554       # Android emulator
flutter run -d windows             # Windows desktop
```

### Method 3: Using Android Studio

1. Open Android Studio
2. Open existing project: `C:\PTU\medtrack`
3. Wait for Gradle sync
4. Select device from dropdown (top toolbar)
5. Click green "Run" button (▶️)

---

## 🔗 Step 4: Test the Complete Stack

### Test 1: Backend Health Check from Flutter

Add this test button to your Flutter app:

```dart
// Temporary test button in your home screen
ElevatedButton(
  onPressed: () async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}:3001/health'),
      );
      print('Backend Status: ${response.statusCode}');
      print('Response: ${response.body}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backend Connected! ✅')),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backend Connection Failed ❌')),
      );
    }
  },
  child: Text('Test Backend Connection'),
)
```

### Test 2: Complete Registration Flow

1. **Start Backend** ✅
2. **Run Flutter App** ✅
3. **Navigate to Registration Screen**
4. **Fill in Details**:
   - Name: Test User
   - Email: your-email@example.com
   - Password: Test@123
5. **Click Register**
6. **Check Email** (medtrack.healthcare@gmail.com) for OTP
7. **Enter OTP** in app
8. **Login** with credentials
9. **Use the App** - Create profile, upload reports, view insights

---

## 🎬 Complete Startup Sequence

### Full Stack Start Script

Save this as `start-full-stack.ps1` in backend folder:

```powershell
# Start Backend
Write-Host "[1/3] Starting Backend Services..." -ForegroundColor Cyan
cd C:\PTU\medtrack\backend
Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\start-all-services.ps1"

Write-Host "[2/3] Waiting for backend to initialize..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Test Backend
Write-Host "[3/3] Testing backend..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod http://localhost:3001/health
    Write-Host "[OK] Backend is running!" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Backend failed to start" -ForegroundColor Red
    exit 1
}

# Start Flutter
Write-Host "`n[*] Starting Flutter App..." -ForegroundColor Cyan
cd C:\PTU\medtrack
Start-Process powershell -ArgumentList "-NoExit", "-Command", "flutter run"

Write-Host "`n[SUCCESS] Full stack starting!`n" -ForegroundColor Green
Write-Host "[INFO] Backend running on ports 3001-3006" -ForegroundColor Gray
Write-Host "[INFO] Flutter app launching..." -ForegroundColor Gray
```

Run it:

```powershell
cd C:\PTU\medtrack\backend
.\start-full-stack.ps1
```

---

## 🐛 Troubleshooting

### Issue 1: "Connection Refused" from Flutter

**Symptoms**: Flutter can't reach backend

**Solutions**:

1. **Check Backend is Running**:
   ```powershell
   Invoke-RestMethod http://localhost:3001/health
   ```

2. **Check IP Configuration** in `api_config.dart`:
   - Android Emulator: Use `10.0.2.2`
   - iOS Simulator: Use `localhost`
   - Physical Device: Use your computer's IP (e.g., `192.168.1.100`)

3. **Check Firewall**:
   ```powershell
   # Allow Node.js through Windows Firewall
   New-NetFirewallRule -DisplayName "Node.js Backend" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3001-3006
   ```

4. **Test from Flutter Device**:
   ```bash
   # If using Android, test from emulator terminal
   adb shell
   curl http://10.0.2.2:3001/health
   ```

### Issue 2: "Port Already in Use"

**Solution**:

```powershell
cd C:\PTU\medtrack\backend
.\kill-all-services.ps1
.\start-all-services.ps1
```

### Issue 3: "Database Connection Failed"

**Solution**:

```powershell
# Check PostgreSQL is running
Get-Service postgresql*

# If stopped, start it
Start-Service postgresql-x64-14

# Test connection
cd C:\PTU\medtrack\backend
npx prisma migrate status
```

### Issue 4: "OTP Email Not Received"

**Solutions**:

1. Check `.env` file has correct Gmail credentials
2. Verify Gmail App Password (not regular password)
3. Check spam folder
4. Test email service:
   ```bash
   # Check backend logs in Auth Service window
   ```

### Issue 5: Flutter Build Errors

**Solution**:

```bash
cd C:\PTU\medtrack

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

## 📊 Monitoring Your App

### Backend Logs

Each service window shows real-time logs:
- Request logs (incoming API calls)
- Database queries
- Errors and warnings
- OTP codes (in development)

### Flutter Logs

```bash
# In terminal where Flutter is running
# Or in VS Code Debug Console

# Filter logs
flutter logs | findstr "ERROR"
```

### Database Viewer

```bash
cd C:\PTU\medtrack\backend
npx prisma studio

# Opens at: http://localhost:5555
# View all tables: users, profiles, reports, etc.
```

---

## ✅ Success Checklist

- [ ] PostgreSQL service running
- [ ] All 6 backend services started (ports 3001-3006)
- [ ] All health endpoints return 200 OK
- [ ] Flutter app running on device/emulator
- [ ] API configuration correct (IP address)
- [ ] Backend logs show no errors
- [ ] Test connection from Flutter successful
- [ ] Can register new user
- [ ] OTP email received
- [ ] Can login successfully
- [ ] Can navigate through app screens
- [ ] Can create profile
- [ ] Can upload reports
- [ ] Can view health insights

---

## 🚀 Quick Commands Reference

### Backend Commands

```powershell
# Start all services
cd C:\PTU\medtrack\backend
.\start-all-services.ps1

# Stop all services
.\kill-all-services.ps1

# Test all endpoints
.\test-complete.ps1

# View database
npx prisma studio
```

### Flutter Commands

```bash
cd C:\PTU\medtrack

# Run app
flutter run

# Run on specific device
flutter run -d chrome
flutter run -d windows
flutter run -d emulator-5554

# Hot reload (while running)
# Press 'r' in terminal

# Hot restart
# Press 'R' in terminal

# Build APK (Android)
flutter build apk

# Build for Windows
flutter build windows
```

---

## 🎯 Development Workflow

### Daily Development Routine:

1. **Morning Setup**:
   ```powershell
   # Start backend
   cd C:\PTU\medtrack\backend
   .\start-all-services.ps1
   
   # Start Flutter
   cd C:\PTU\medtrack
   flutter run
   ```

2. **During Development**:
   - Make code changes in Flutter
   - Press `r` for hot reload (fast)
   - Press `R` for hot restart (full)
   - Backend auto-reloads on file changes (nodemon)

3. **End of Day**:
   ```powershell
   # Stop backend services
   cd C:\PTU\medtrack\backend
   .\kill-all-services.ps1
   
   # Flutter: Press 'q' in terminal or close window
   ```

---

## 🌐 Platform-Specific Notes

### Android

- **Emulator**: Use `http://10.0.2.2:3001` in API config
- **Physical Device**: Use computer IP (e.g., `http://192.168.1.100:3001`)
- **Build APK**: `flutter build apk --release`

### iOS

- **Simulator**: Use `http://localhost:3001` in API config
- **Physical Device**: Use computer IP
- **Requires**: Xcode installed on macOS
- **Build**: `flutter build ios --release`

### Web (Chrome)

- **Use**: `http://localhost:3001` in API config
- **CORS**: Already configured in backend
- **Run**: `flutter run -d chrome`

### Windows Desktop

- **Use**: `http://localhost:3001` in API config
- **Run**: `flutter run -d windows`
- **Build**: `flutter build windows --release`

---

## 📚 Additional Resources

- **Backend API Docs**: [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
- **Flutter Integration**: [FLUTTER_INTEGRATION.md](FLUTTER_INTEGRATION.md)
- **Deployment Guide**: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- **Quick Start**: [QUICK_START.md](QUICK_START.md)
- **Testing Guide**: [RUN_AND_TEST.md](RUN_AND_TEST.md)

---

## 🎉 You're Ready!

Your complete MedTrack healthcare application is now running:

- ✅ **Backend**: 6 microservices handling auth, profiles, reports, health analysis, history, and notifications
- ✅ **Frontend**: Beautiful Flutter app on your device
- ✅ **Database**: PostgreSQL storing all your data
- ✅ **Email**: Automated OTP and notifications via Gmail

**Start building amazing healthcare features!** 🏥📱
