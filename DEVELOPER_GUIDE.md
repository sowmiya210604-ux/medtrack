# Developer Guide - Using New Components

This guide shows how to use the new reusable components created in this project.

---

## Table of Contents
1. [FilterWidget](#filterwidget)
2. [AnimatedCard](#animatedcard)
3. [AnimatedButton](#animatedbutton)
4. [EmptyStateWidget](#emptystatewidget)
5. [Page Transitions](#page-transitions)
6. [Animation Helpers](#animation-helpers)

---

## FilterWidget

**Location**: `lib/core/widgets/filter_widget.dart`

**Purpose**: Reusable filter bottom sheet with date range, type, and status filters.

### Usage Example:

```dart
// Show filter bottom sheet
void _showFilters() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FilterWidget(
      startDate: _startDate,
      endDate: _endDate,
      selectedType: _selectedType,
      selectedStatus: _selectedStatus,
      availableTypes: ['Type 1', 'Type 2', 'Type 3'],
      availableStatuses: ['Active', 'Inactive', 'Pending'],
      onDateRangeChanged: (start, end) {
        setState(() {
          _startDate = start;
          _endDate = end;
        });
      },
      onTypeChanged: (type) {
        setState(() {
          _selectedType = type;
        });
      },
      onStatusChanged: (status) {
        setState(() {
          _selectedStatus = status;
        });
      },
      onReset: () {
        setState(() {
          _startDate = null;
          _endDate = null;
          _selectedType = null;
          _selectedStatus = null;
        });
      },
    ),
  );
}
```

### Properties:
- `startDate` - Selected start date
- `endDate` - Selected end date
- `selectedType` - Currently selected type filter
- `selectedStatus` - Currently selected status filter
- `availableTypes` - List of type options
- `availableStatuses` - List of status options
- `onDateRangeChanged` - Callback for date changes
- `onTypeChanged` - Callback for type changes
- `onStatusChanged` - Callback for status changes
- `onReset` - Callback for reset button

---

## AnimatedCard

**Location**: `lib/core/widgets/animated_card.dart`

**Purpose**: Wrapper for cards with fade-in, slide-up, and hover animations.

### Usage Example:

```dart
// Single animated card
AnimatedCard(
  onTap: () {
    // Handle tap
  },
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text('Card Content'),
  ),
)

// Card with custom animation timing
AnimatedCard(
  duration: Duration(milliseconds: 600),
  delay: Duration(milliseconds: 200),
  onTap: () => print('Tapped'),
  child: MyCardWidget(),
)

// Cards in a list with staggered animation
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return AnimatedCard(
      delay: Duration(milliseconds: 100 * index),
      onTap: () => onItemTap(items[index]),
      child: ItemCard(item: items[index]),
    );
  },
)
```

### Properties:
- `child` (required) - The widget to wrap
- `duration` - Animation duration (default: 500ms)
- `delay` - Delay before animation starts (default: 0ms)
- `onTap` - Optional tap callback

### Features:
- Fade-in animation
- Slide-up animation
- Scale animation
- Hover lift effect (on desktop/web)
- Shadow enhancement on hover

---

## AnimatedButton

**Location**: `lib/core/widgets/animated_button.dart`

**Purpose**: Button with press animation and loading state support.

### Usage Example:

```dart
// Basic elevated button
AnimatedButton(
  text: 'Submit',
  onPressed: () {
    // Handle press
  },
)

// Outlined button with icon
AnimatedButton(
  text: 'Cancel',
  icon: Icons.close,
  isOutlined: true,
  onPressed: () {
    // Handle press
  },
)

// Button with loading state
AnimatedButton(
  text: 'Save',
  icon: Icons.save,
  isLoading: _isLoading,
  onPressed: _handleSave,
)

// Custom styled button
AnimatedButton(
  text: 'Custom',
  icon: Icons.star,
  backgroundColor: Colors.green,
  textColor: Colors.white,
  width: 200,
  height: 56,
  onPressed: () {},
)
```

### Properties:
- `text` (required) - Button label
- `onPressed` (required) - Tap callback
- `icon` - Optional leading icon
- `isOutlined` - Use outlined style (default: false)
- `isLoading` - Show loading spinner (default: false)
- `backgroundColor` - Custom background color
- `textColor` - Custom text color
- `width` - Button width (optional)
- `height` - Button height (default: 50)

### Features:
- Scale animation on press
- Loading state with spinner
- Icon support
- Outlined and filled variants
- Customizable colors

---

## EmptyStateWidget

**Location**: `lib/core/widgets/empty_state_widget.dart`

**Purpose**: Consistent empty state display across the app.

### Usage Examples:

```dart
// Basic empty state
EmptyStateWidget(
  icon: Icons.folder_open,
  title: 'No Items',
  message: 'Start by adding your first item',
)

// Empty state with action
EmptyStateWidget(
  icon: Icons.search_off,
  title: 'No Results',
  message: 'Try adjusting your search criteria',
  actionText: 'Clear Search',
  onAction: () {
    // Clear search
  },
)

// Custom colored empty state
EmptyStateWidget(
  icon: Icons.favorite_outline,
  title: 'No Favorites',
  message: 'Mark items as favorites to see them here',
  iconColor: Colors.red,
  actionText: 'Browse Items',
  onAction: () => Navigator.push(...),
)

// Loading state
LoadingStateWidget(
  message: 'Loading your data...',
)

// Error state
ErrorStateWidget(
  title: 'Connection Error',
  message: 'Please check your internet connection',
  onRetry: () {
    // Retry loading
  },
)
```

### EmptyStateWidget Properties:
- `icon` (required) - Icon to display
- `title` (required) - Main heading
- `message` (required) - Description text
- `actionText` - Optional button text
- `onAction` - Optional button callback
- `iconColor` - Custom icon color

### Additional Widgets:
- `LoadingStateWidget` - Spinner with optional message
- `ErrorStateWidget` - Error display with retry option

---

## Page Transitions

**Location**: `lib/core/utils/page_transitions.dart`

**Purpose**: Custom page transitions for navigation.

### Usage Examples:

```dart
// Slide from right (default mobile behavior)
Navigator.push(
  context,
  AppPageTransitions.slideFromRight(DestinationPage()),
)

// Fade transition
Navigator.push(
  context,
  AppPageTransitions.fade(DestinationPage()),
)

// Scale with fade
Navigator.push(
  context,
  AppPageTransitions.scaleWithFade(DestinationPage()),
)

// Slide from bottom (modal-like)
Navigator.push(
  context,
  AppPageTransitions.slideFromBottom(DestinationPage()),
)

// Slide and fade combined
Navigator.push(
  context,
  AppPageTransitions.slideAndFade(DestinationPage()),
)
```

### Available Transitions:
- `slideFromRight()` - Horizontal slide (300ms)
- `fade()` - Simple fade (250ms)
- `scaleWithFade()` - Scale up + fade (300ms)
- `slideFromBottom()` - Vertical slide (350ms)
- `slideAndFade()` - Horizontal slide + fade (300ms)

---

## Animation Helpers

**Location**: `lib/core/utils/animation_helpers.dart`

**Purpose**: Helper widgets for common animations.

### Usage Examples:

```dart
// Fade in a widget
FadeInWidget(
  child: Text('Hello'),
)

// Fade in with delay
FadeInWidget(
  duration: Duration(milliseconds: 600),
  delay: Duration(milliseconds: 200),
  child: MyWidget(),
)

// Slide in from side
SlideInWidget(
  child: Card(...),
)

// Slide in from top
SlideInWidget(
  begin: Offset(0, -0.2),
  child: AppBar(...),
)

// Slide in from bottom
SlideInWidget(
  begin: Offset(0, 0.3),
  delay: Duration(milliseconds: 300),
  child: BottomSheet(...),
)
```

### FadeInWidget Properties:
- `child` (required) - Widget to animate
- `duration` - Animation duration (default: 500ms)
- `delay` - Delay before starting (default: 0ms)

### SlideInWidget Properties:
- `child` (required) - Widget to animate
- `duration` - Animation duration (default: 500ms)
- `delay` - Delay before starting (default: 0ms)
- `begin` - Starting offset (default: Offset(0, 0.2))

---

## Best Practices

### 1. Animation Performance
```dart
// ✅ Good: Dispose controllers
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

// ❌ Bad: Forgetting to dispose
// Memory leaks will occur
```

### 2. Using Const Constructors
```dart
// ✅ Good: Use const when possible
const EmptyStateWidget(
  icon: Icons.folder_open,
  title: 'No Items',
  message: 'Add your first item',
)

// ❌ Bad: Unnecessary rebuilds
EmptyStateWidget(
  icon: Icons.folder_open,
  title: 'No Items',
  message: 'Add your first item',
)
```

### 3. Staggered Animations
```dart
// ✅ Good: Reasonable delays
ListView.builder(
  itemBuilder: (context, index) {
    return AnimatedCard(
      delay: Duration(milliseconds: 50 * index),
      child: ItemCard(index),
    );
  },
)

// ❌ Bad: Too long delays
// Users will wait too long
delay: Duration(milliseconds: 500 * index), // Too slow!
```

### 4. Empty States
```dart
// ✅ Good: Always provide action
EmptyStateWidget(
  icon: Icons.folder_open,
  title: 'No Items',
  message: 'Start by adding your first item',
  actionText: 'Add Item',
  onAction: _addItem,
)

// ❌ Bad: No way to resolve empty state
EmptyStateWidget(
  icon: Icons.folder_open,
  title: 'No Items',
  message: 'Start by adding your first item',
  // Missing action!
)
```

---

## Common Patterns

### Pattern 1: List with Empty State
```dart
Widget build(BuildContext context) {
  if (isLoading) {
    return LoadingStateWidget();
  }

  if (items.isEmpty) {
    return EmptyStateWidget(
      icon: Icons.inbox,
      title: 'No Items',
      message: 'Add your first item',
      actionText: 'Add',
      onAction: _addItem,
    );
  }

  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return AnimatedCard(
        delay: Duration(milliseconds: 100 * index),
        onTap: () => _onItemTap(items[index]),
        child: ItemCard(item: items[index]),
      );
    },
  );
}
```

### Pattern 2: Filtered List with No Results
```dart
final filteredItems = _applyFilters(items);

if (filteredItems.isEmpty && hasActiveFilters) {
  return EmptyStateWidget(
    icon: Icons.filter_list_off,
    title: 'No Results',
    message: 'Try different filters',
    actionText: 'Clear Filters',
    onAction: _clearFilters,
  );
}
```

### Pattern 3: Card Grid with Animations
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) {
    return AnimatedCard(
      delay: Duration(milliseconds: 50 * index),
      onTap: () => _onItemTap(items[index]),
      child: GridItemCard(item: items[index]),
    );
  },
)
```

---

## Troubleshooting

### Animation Not Showing
```dart
// Check if controller is started
_controller.forward();

// Check if mounted before animating
if (mounted) {
  _controller.forward();
}
```

### Memory Leaks
```dart
// Always dispose animation controllers
@override
void dispose() {
  _controller?.dispose();
  super.dispose();
}
```

### Jerky Animations
```dart
// Use proper curves
CurvedAnimation(
  parent: _controller,
  curve: Curves.easeOutCubic, // Smooth curve
)

// Avoid heavy computations during animations
// Move heavy work outside animation builder
```

---

## Additional Resources

- [Flutter Animation Docs](https://flutter.dev/docs/development/ui/animations)
- [Material Design Motion](https://material.io/design/motion)
- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)

---

Happy Coding! 🎨✨
