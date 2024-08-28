# SiyaTech Assign App(Hacker News App)

## Overview

This Flutter application displays the top posts from Hacker News using the BLoC pattern and pagination. The posts are loaded incrementally as the user scrolls.

## Getting Started

1. **Clone the Repository**

    ```bash
    https://github.com/JahidDev24/assign.git
    ```

2. **Navigate to the Project Directory**

    ```bash
    cd siyatech_assig_app
    ```

3. **Install Dependencies**

    ```bash
    flutter pub get
    ```

4. **Run the Application**

    ```bash
    flutter run
    ```

## Architecture

- **MVC Structure**: The application follows the Model-View-Controller (MVC) pattern.
- **BLoC Pattern**: State management is handled using the BLoC pattern for efficient state management and separation of concerns.
- **Pagination**: Posts are loaded incrementally to improve performance and user experience.

## Folder Structure

- **`lib/models/`**: Contains data models.
- **`lib/repositories/`**: Contains data fetching logic.
- **`lib/screens/`**: Contains UI screens.
- **`lib/blocs/`**: Contains BLoC classes for state management.
- **`lib/utils/`**: Contains utility functions.

## Features

- **Dynamic Loading**: Posts are loaded as the user scrolls.
- **Error Handling**: Proper error handling for network requests.
- **Pagination**: Efficient loading of posts using pagination.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details 🦁.
