# 🔍 Backend Connection Troubleshooting Guide

## Problem: "Backend not connecting"

Your backend IS running correctly on ports 3001-3006. The issue was:

### ✅ What Was Fixed

1. **Missing GET method** in `HttpService`
   - Added `get()`, `put()`, `delete()` methods
   - Added proper error handling for network issues
   - Added request/response logging

2. **Added Connection Test Screen**
   - Location: `lib/test_connection.dart`
   - Accessible from Login screen → "Test Backend Connection" button
   - Shows real-time connection status

3. **Better Error Messages**
   - Network errors now show helpful messages
   - Logs show in Chrome DevTools Console (F12)

---

## 🧪 How to Test the Connection

### Step 1: Make sure backend is running
```powershell
cd C:\PTU\medtrack\backend
.\start-all-services.ps1
```

Expected output: 6 PowerShell windows open (one per service)

### Step 2: Run Flutter Web
```bash
cd C:\PTU\medtrack
flutter run -d chrome
```

### Step 3: Test the Connection

**Option A: Use the Test Screen**
1. On the login screen, click **"Test Backend Connection"** at the bottom
2. Click **"Test Connection"** button
3. You should see: ✅ Backend Connected!

**Option B: Use Chrome DevTools**
1. Press **F12** to open DevTools
2. Go to **Console** tab
3. Look for logs like:
   ```
   🌐 [API] GET: http://localhost:3001/health
   🌐 [API] Response: 200
   🌐 [API] Success: OK
   ```

---

## 🔧 Common Issues & Solutions

### Issue 1: "Cannot connect to backend. Is it running?"

**Cause:** Backend services not started

**Solution:**
```powershell
cd C:\PTU\medtrack\backend
.\start-all-services.ps1
```

Verify services are running:
```powershell
netstat -ano | findstr ":3001 :3002 :3003 :3004 :3005 :3006" | findstr "LISTENING"
```

---

### Issue 2: CORS errors in Chrome Console

**Cause:** CORS not configured (but we already fixed this!)

**Solution:** Backend already has CORS configured. Just restart services:
```powershell
cd C:\PTU\medtrack\backend
.\kill-all-services.ps1
.\start-all-services.ps1
```

---

### Issue 3: "Failed to connect to server at http://localhost:3001"

**Cause:** Wrong URL or port

**Check the configuration:**
1. Open `lib/core/config/api_config.dart`
2. Verify: `_devBaseUrl = 'http://localhost'` ✅
3. NOT: `_devBaseUrl = 'http://10.0.2.2'` ❌ (that's for Android only)

---

### Issue 4: App doesn't start / Build errors

**Solution:**
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

---

## 📊 Backend Status Quick Check

### Test with PowerShell
```powershell
# Test Auth Service
Invoke-RestMethod http://localhost:3001/health

# Expected output:
# success : True
# service : Auth Service
# status  : running
```

### Test all services
```powershell
3001..3006 | ForEach-Object {
  Write-Host "Testing port $_..." -ForegroundColor Cyan
  try {
    $response = Invoke-RestMethod "http://localhost:$_/health"
    Write-Host "  ✅ $($response.service) - $($response.status)" -ForegroundColor Green
  } catch {
    Write-Host "  ❌ Service not responding" -ForegroundColor Red
  }
}
```

---

## 🎯 What Your API Endpoints Should Be

From Flutter, your app connects to:

```dart
// Auth endpoints
http://localhost:3001/api/auth/register
http://localhost:3001/api/auth/login
http://localhost:3001/api/auth/verify-otp
http://localhost:3001/api/auth/forgot-password

// Profile endpoints
http://localhost:3002/api/profile

// Reports endpoints
http://localhost:3003/api/reports

// Health Analysis endpoints
http://localhost:3004/api/health-analysis

// History endpoints
http://localhost:3005/api/history

// Notification endpoints
http://localhost:3006/api/notifications
```

---

## 🌐 Network Tab Debugging

### How to check API calls in Chrome:

1. Press **F12** → **Network** tab
2. Check "Preserve log"
3. Filter by "XHR" or "Fetch"
4. Try registering/logging in
5. Click on the request to see:
   - **Headers**: Request URL, method, status
   - **Payload**: What data was sent
   - **Response**: What backend returned

### Successful request looks like:
```
Status: 200 OK or 201 Created
Content-Type: application/json
Access-Control-Allow-Origin: http://localhost:8080
```

### Failed request (CORS issue):
```
Status: (failed) net::ERR_FAILED
Console error: "blocked by CORS policy"
```

---

## ✅ Success Checklist

Your connection is working when you see:

- [ ] Backend services running (6 windows open)
- [ ] Test Connection screen shows ✅ green status
- [ ] Chrome Console shows 🌐 [API] logs
- [ ] Network tab shows successful requests (200/201 status)
- [ ] No CORS errors in console
- [ ] Register/Login forms work without errors

---

## 📝 Example: Testing Registration Flow

### 1. Open Chrome DevTools (F12) → Console tab

### 2. Try to register a new user

### 3. You should see these logs:
```
🌐 [API] POST: http://localhost:3001/api/auth/register
🌐 [API] Body: {"name":"Test","email":"test@test.com","password":"***"}
🌐 [API] Response: 201
🌐 [API] Success: Registration successful. Please verify your email...
```

### 4. Check your email for OTP (also check spam folder!)

### 5. Backend Auth Service window should show:
```
📨 Incoming Request:
  Method: POST
  Path: /api/auth/register
  Origin: http://localhost:8080

🔐 Register endpoint hit
📧 Attempting to send OTP email
  To: test@test.com
  OTP: 123456

✅ Email sent successfully
  Message ID: <...>
```

---

## 🚀 Quick Start Command

**Start Everything:**
```powershell
# Terminal 1: Start backend
cd C:\PTU\medtrack\backend
.\start-all-services.ps1

# Terminal 2: Start frontend
cd C:\PTU\medtrack
flutter run -d chrome
```

**Test the connection:**
1. App opens in Chrome
2. Click "Test Backend Connection" on login screen
3. Click "Test Connection"
4. See ✅ green success message

---

## 💡 Pro Tips

1. **Keep DevTools open** while developing (F12)
2. **Watch the Console tab** for API logs
3. **Check Network tab** if requests fail
4. **Monitor backend windows** for incoming requests
5. **Use the Test Connection screen** when in doubt

---

## 🎉 Your Backend Connection Is Now Fixed!

The issue was that `HttpService` was missing the `get()` method, which the test connection screen needs. Now you have:

- ✅ Complete HTTP service with GET, POST, PUT, DELETE
- ✅ Proper error handling and logging
- ✅ Connection test screen
- ✅ All API services running
- ✅ CORS configured correctly

**Next Steps:**
1. Use the Test Connection screen to verify
2. Try registering a new user
3. Check your email for OTP
4. Complete the full registration flow

Need more help? Check the logs in Chrome DevTools (F12) → Console tab!
