# 🎯 Quick Start Guide - Run Complete MedTrack App

## 🚀 Super Quick Start (One Command)

```powershell
cd C:\PTU\medtrack\backend
.\start-full-stack.ps1
```

This single command will:
1. ✅ Check prerequisites (Node.js, Flutter, PostgreSQL)
2. ✅ Start all 6 backend services
3. ✅ Test backend health
4. ✅ Launch Flutter app

---

## 📝 Manual Step-by-Step

### 1️⃣ Start Backend (30 seconds)

```powershell
cd C:\PTU\medtrack\backend
.\start-all-services.ps1
```

**Result**: 6 PowerShell windows open, showing:
```
[*] Auth Service
Port: 3001
🚀 Auth Service running on port 3001
📊 Database connected
```

### 2️⃣ Configure Flutter API (One-time setup)

Edit **`lib/core/services/api_config.dart`**:

```dart
// For Android Emulator:
static const String _devBaseUrl = 'http://10.0.2.2';

// For Physical Device - find your IP:
// Windows: ipconfig | findstr IPv4
// Use result: static const String _devBaseUrl = 'http://192.168.1.XXX';
```

### 3️⃣ Start Flutter App

**Option A - VS Code:**
- Press `F5`

**Option B - Command Line:**
```bash
cd C:\PTU\medtrack
flutter run
```

**Option C - Android Studio:**
- Click green ▶️ button

---

## ✅ Verify Everything Works

### Test Backend:
```powershell
Invoke-RestMethod http://localhost:3001/health
# Should return: {"status":"ok",...}
```

### Test from Flutter:
Add test button in your app:
```dart
ElevatedButton(
  onPressed: () async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}:3001/health'),
    );
    print('Backend: ${response.statusCode}');
  },
  child: Text('Test Backend'),
)
```

### Full Flow Test:
1. Register new user → Check email for OTP → Verify
2. Login → Create profile → Upload report
3. View health insights → Check notifications

---

## 🛠️ Troubleshooting Quick Fixes

### Problem: "Port in use"
```powershell
cd C:\PTU\medtrack\backend
.\kill-all-services.ps1
.\start-all-services.ps1
```

### Problem: "Can't connect to backend"
Check `api_config.dart`:
- Android Emulator: `10.0.2.2` ✅
- iOS Simulator: `localhost` ✅
- Physical Device: Your computer's IP ✅

### Problem: "Database error"
```powershell
# Start PostgreSQL
Get-Service postgresql* | Start-Service

# Check migrations
cd C:\PTU\medtrack\backend
npx prisma migrate status
```

---

## 📊 What's Running?

```
┌─────────────────────────────────────────┐
│         MedTrack Full Stack             │
├─────────────────────────────────────────┤
│                                         │
│  Backend (Node.js):                     │
│  ├─ Auth Service       → :3001         │
│  ├─ Profile Service    → :3002         │
│  ├─ Report Service     → :3003         │
│  ├─ Health Service     → :3004         │
│  ├─ History Service    → :3005         │
│  └─ Notification       → :3006         │
│                                         │
│  Frontend (Flutter):                    │
│  └─ Mobile App         → Device/Emulator│
│                                         │
│  Database:                              │
│  └─ PostgreSQL         → :5432         │
│                                         │
└─────────────────────────────────────────┘
```

---

## 🎯 Daily Workflow

**Morning:**
```powershell
cd C:\PTU\medtrack\backend
.\start-full-stack.ps1
```

**During Development:**
- Edit Flutter code → Press `r` (hot reload)
- Edit backend code → Auto-reloads (nodemon)

**Evening:**
```powershell
.\kill-all-services.ps1    # Stop backend
# Press 'q' in Flutter      # Stop frontend
```

---

## 📚 Need More Help?

- **Complete Guide**: [RUNNING_FULL_STACK.md](RUNNING_FULL_STACK.md)
- **API Reference**: [backend/API_DOCUMENTATION.md](backend/API_DOCUMENTATION.md)
- **Flutter Integration**: [backend/FLUTTER_INTEGRATION.md](backend/FLUTTER_INTEGRATION.md)
- **Testing**: [backend/RUN_AND_TEST.md](backend/RUN_AND_TEST.md)

---

## 🎉 You're All Set!

Your complete healthcare management application is running!

**Test it**: Register → Verify OTP → Login → Explore! 🏥📱
