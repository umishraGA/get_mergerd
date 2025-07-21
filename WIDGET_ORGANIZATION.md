# Widget Organization Guidelines

## Core Principles

1. **Separation of UI and Logic**:

   - UI components (widgets) should be in dedicated widget folders
   - Business logic should remain in the main page files

2. **Folder Structure**:
   - Each feature should have a `widgets` folder
   - Example: `lib/features/profile/widgets/`

## Rules

### Widget Placement

- All reusable UI components must be placed in the `widgets` folder
- Dialog widgets should be in the `widgets` folder
- Complex UI elements should be broken down into smaller widget components

### Logic Placement

- Business logic should remain in the main page files
- Event handlers and state management should be in the main page
- Dialogs can be defined in the widget folder, but their logic should be in the main page

### Naming Conventions

- Widget files should use PascalCase
- Widget files should end with "Widget" (e.g., `ProfileCardWidget.dart`)
- Widget classes should match their filename

## Examples

### Correct Implementation

**Main Page File (`lib/features/profile/ProfilePage.dart`):**

```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: ProfileContentWidget(
        onUpdateProfile: _handleProfileUpdate,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _handleProfileUpdate() {
    // Business logic here
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialogWidget(
        onSave: (item) {
          // Handle saving the item (logic stays in main page)
          Navigator.pop(context);
        },
      ),
    );
  }
}
```

**Widget File (`lib/features/profile/widgets/ProfileContentWidget.dart`):**

```dart
class ProfileContentWidget extends StatelessWidget {
  final VoidCallback onUpdateProfile;

  const ProfileContentWidget({
    Key? key,
    required this.onUpdateProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileHeaderWidget(),
        ProfileDetailsWidget(
          onUpdate: onUpdateProfile,
        ),
      ],
    );
  }
}
```

**Dialog Widget File (`lib/features/profile/widgets/AddItemDialogWidget.dart`):**

```dart
class AddItemDialogWidget extends StatelessWidget {
  final Function(Item) onSave;

  const AddItemDialogWidget({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Item'),
      content: TextField(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Create item from input
            final item = Item();
            // Call the callback from the main page
            onSave(item);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
```

### Incorrect Implementation

**Defining complex widgets directly in the page file:**

```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          // Complex widget defined inline - should be in widgets folder
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Name'),
                    Text('user@example.com'),
                  ],
                ),
              ],
            ),
          ),
          // More UI code...
        ],
      ),
    );
  }
}
```
