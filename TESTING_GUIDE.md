# Testing Guide - MedTrack Improvements

## Quick Test Checklist

### 1. Medical Report Page
**Location**: Navigate to Reports tab

**Tests**:
- [ ] Open the Reports screen
- [ ] Click the filter icon (top-right)
- [ ] Select a date range
- [ ] Select a report type filter
- [ ] Verify reports list updates dynamically
- [ ] Click "Reset" to clear all filters
- [ ] Verify red dot appears on filter icon when filters are active
- [ ] Open a report detail page
- [ ] Verify extracted text section is NOT visible
- [ ] Verify only structured data (graphs, tables) is shown

**Expected Results**:
- Filter bottom sheet opens smoothly
- Reports update immediately when filters change
- Empty state shows when no reports match filters
- Report detail page is clean without raw text

---

### 2. Home Page - Recent Reports
**Location**: Home tab (first tab)

**Tests**:
- [ ] View the Recent Reports section
- [ ] Click on a report card
- [ ] Verify smooth slide transition to report detail
- [ ] Go back to home
- [ ] Click "View All" button
- [ ] Verify navigation to Reports tab
- [ ] Observe card animations (fade-in, slide-up) on page load

**Expected Results**:
- Cards animate in with staggered timing
- Clicking a card navigates with smooth transition
- "View All" switches to Reports tab
- Cards have hover effect (slight elevation)

---

### 3. Profile Navigation
**Location**: Home tab

**Tests**:
- [ ] Look at top-right corner
- [ ] Click on the profile avatar (circle with initial)
- [ ] Verify navigation to Profile tab
- [ ] Hover over avatar (desktop only)
- [ ] Verify cursor changes to pointer

**Expected Results**:
- Clicking avatar switches to Profile tab
- Smooth tab transition animation
- Mouse cursor indicates clickable element

---

### 4. UI/UX Animations
**Location**: Throughout the app

**Tests**:
- [ ] Switch between tabs in bottom navigation
- [ ] Observe fade/slide transition between screens
- [ ] Open filter bottom sheet
- [ ] Observe smooth slide-up animation
- [ ] Navigate to report details
- [ ] Observe page transition
- [ ] Scroll through reports list
- [ ] Verify smooth scrolling

**Expected Results**:
- All transitions are smooth (300ms)
- No janky or stuttering animations
- Animations feel natural and not excessive

---

### 5. Empty States
**Location**: Various screens

**Tests**:
- [ ] View Reports screen with no reports
- [ ] Verify animated empty state appears
- [ ] Click "Upload Report" button
- [ ] Apply filters with no matching results
- [ ] Verify "No Matching Reports" empty state
- [ ] Click "Clear Filters" button
- [ ] View home Recent Reports with no reports
- [ ] Verify empty state with action button

**Expected Results**:
- Empty states animate in smoothly
- Icons, titles, and messages are clear
- Action buttons work correctly
- Design is consistent across all empty states

---

### 6. Filter Functionality
**Location**: Reports screen

**Tests**:
- [ ] Open filters
- [ ] Select start date only
- [ ] Verify reports after selected date show
- [ ] Add end date
- [ ] Verify reports in range show
- [ ] Select "Complete Blood Count" type
- [ ] Verify only CBC reports show
- [ ] Combine multiple filters
- [ ] Verify all filters apply together
- [ ] Click Reset
- [ ] Verify all reports show again

**Expected Results**:
- Date picker opens correctly
- Filters combine logically (AND operation)
- Filter persistence within session
- Reset clears all filters at once

---

## How to Run Tests

### Using Flutter
```bash
# Navigate to project directory
cd c:\PTU\medtrack

# Get dependencies (if not already done)
flutter pub get

# Run on connected device or emulator
flutter run

# Or run on specific device
flutter devices
flutter run -d <device-id>

# Or run in Chrome (web)
flutter run -d chrome
```

### Using VS Code
1. Open the project in VS Code
2. Press `F5` or click "Run and Debug"
3. Select your target device
4. App will launch

---

## Common Issues and Solutions

### Issue: Animations not smooth
**Solution**: Run in Release mode for better performance
```bash
flutter run --release
```

### Issue: Empty states not showing
**Solution**: Clear app data and restart
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Navigation not working
**Solution**: Hot restart the app
- Press `R` in terminal
- Or click the restart button in VS Code

### Issue: Filters not updating
**Solution**: 
- Check that setState is being called
- Verify provider is notifying listeners
- Hot reload: Press `r` in terminal

---

## Performance Monitoring

### Check Frame Rate
- In Flutter DevTools, enable Performance overlay
- Look for green bars (60 FPS is target)
- Red bars indicate dropped frames

### Memory Usage
- Monitor memory in DevTools
- Check for memory leaks after repeated navigation
- Verify AnimationControllers are disposed

---

## Accessibility Testing

### Screen Reader (Optional)
- Enable TalkBack (Android) or VoiceOver (iOS)
- Navigate through the app
- Verify all interactive elements are announced

### Contrast Checker
- Use browser DevTools to check contrast ratios
- Verify text is readable against backgrounds
- Check color blind friendly design

---

## Browser Testing (Web)

```bash
# Run on Chrome
flutter run -d chrome

# Build for web
flutter build web
```

**Web-specific tests**:
- [ ] Hover effects work correctly
- [ ] Click interactions work
- [ ] Scrolling is smooth
- [ ] Responsive design adapts to window resize

---

## Next Steps

After completing these tests:

1. **Document Issues**: Note any bugs or unexpected behavior
2. **Performance**: Record FPS drops or slow transitions
3. **Usability**: Note areas that feel unintuitive
4. **Suggestions**: List additional features or improvements

---

## Quick Commands Reference

```bash
# Clean build
flutter clean && flutter pub get && flutter run

# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests (when tests are added)
flutter test

# Build APK (Android)
flutter build apk

# Build iOS
flutter build ios
```

---

## Support

If you encounter issues:
1. Check the error console
2. Try hot restart (`R`)
3. Try clean rebuild
4. Check Flutter doctor: `flutter doctor -v`

---

Happy Testing! 🚀
