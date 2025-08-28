Taskora is a Flutter-based productivity and task management app that helps users manage, track, and report their tasks efficiently. The app includes real-time task updates, task filtering, and export functionality in PDF, CSV, and Excel formats.
Features
Authentication

Simple login using Firebase Authentication.

Keeps the user logged in until logout.

Login screen with email/password (and Google Sign-in ).

Data Management

Uses Firestore as the backend database.

CRUD operations: Add, Update, Delete tasks.

Each task has:

id (unique)

title

description

status (Completed/Pending)

createdDate

Supports offline caching for viewing tasks without internet.

UI & Screens

Dashboard/Home Screen: Shows task summary (total tasks, completed vs pending).

Task List Screen: Scrollable list of tasks with cards and checkboxes.

Task Details Screen: View full task details on tapping a card.

Add Task Screen: Form with validation for creating tasks.

Reports Screen: Filter tasks by date/status, select multiple tasks, and export as PDF, CSV, or Excel.

Export tasks in multiple formats:

PDF using printing and pdf packages.

CSV using csv package.

Excel using excel package.

Share or save generated reports.

Libraries & Tools

flutter_bloc: State management for handling app state with BLoC pattern.

bloc & equatable: Core libraries for BLoC architecture and value comparisons.

firebase_core, firebase_auth, cloud_firestore: Firebase backend for authentication and real-time Firestore data.

google_sign_in: Optional Google login integration.

intl: Formatting dates for tasks and reports.

pdf & printing: Generate and share PDF reports.

csv & excel: Export tasks as CSV or Excel files.

path_provider: Access local storage directories for saving reports.

get_it: Dependency injection for clean architecture and service management.

animated_bottom_navigation_bar & google_nav_bar: Modern bottom navigation bars for better UX.

material_symbols_icons: Access to Google's Material Symbols icons.

image_picker: Picking images for tasks (attachments or notes).
