# Todo App

## Overview

This is a Flutter-based Todo application that allows users to manage tasks efficiently. The app includes features for adding, editing, deleting, and marking tasks as complete. It also incorporates user authentication using Firebase and local data persistence using `sqflite`.

## Features Implemented

- **User Authentication**:
  - Sign up, login, and logout using Firebase Authentication.
  
- **Task Management**:
  - Add new tasks with a title, description, due date, and priority level.
  - Edit existing tasks.
  - Delete tasks.
  - Mark tasks as complete.

- **State Management**:
  - Implemented using Riverpod to manage the app's state effectively.

- **Local Data Persistence**:
  - Uses `sqflite` to store tasks locally on the device, allowing offline access to tasks.

## Features Not Implemented

- **Firestore Integration**:
  - Firestore was planned for syncing tasks across devices but is not yet implemented.

- **Testing**:
  - Unit and widget tests have not been written due to time constraints.

## Setup Instructions

1. **Clone the repository**:

    -    git clone https://github.com/SabinSajeevan/todo.git
    -    cd your-repo
    -    flutter pub get
    -    flutter run

Next Steps

Firestore Integration: Complete the integration to allow task syncing across devices.
</br>Testing: Implement unit and widget tests for better code reliability.
</br>UI/UX Improvements: Further refine the user interface for better user experience.
</br>Error Handling: Add comprehensive error handling and input validation.

