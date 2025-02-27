# XKCD-comics
A comic viewer app of romance, sarcasm, math, and language.

Hello! This is the Readme of my app. I will walk you through the functionalities of the app and I will explain why things work as they are.

## Features

1. **Browse Comics**:
   - Scroll through a list of XKCD comics.
   - View comic details, including the title, image, description and an external link that takes you to a browsing page.

2. **Search Comics**:
   - Search for comics by comic number or text.
   - We use the wiki page to extract results. That might not be the best solution, but its all I found. 

3. **Comic Explanation**:
   - Get explanations for comics to better understand the humor or references.
   - The comic detail page shows all the info available for the user and also has a button that may redirect the user to the comic's wiki page.

4. **Favorite Comics**:
   - Mark comics as favorites and access them offline.
   - That can be done in both browsing and details screens.
   - They can also be removed from favorites.

5. **Share Comics**:
   - Send comics to others via sharing options.

6. **New Comic Notifications**:
   - Receive notifications when a new comic is published (that only works when the app is open).
   - Receive periodicaly notifications to visit the app.
   

7. **Multi-Platform Support**:
   - Supports iPhone and iPad.
   - Notifications work for apple watch as well.

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** architecture for a clean and maintainable codebase.

### 1. **Model**:
   *Comic*: Represents a comic with properties like `id`, `title`, `image`, `description`, etc.

### 2. **View**:
   *ComicsNavigationView*:
   - The main view for browsing comics.
   - Allows users to search for comics by number or text.
   - Displays favorited comics.
   *ComicDetailView*:
   - Displays comic details, including the image and description.
   *ComicCellView*:
   - Displays some informations about the comic for the `ComicsNavigationView`.

### 3. **ViewModel**:
    *ComicsNavigationViewModel*:
        - Manages the state of the comic list, including loading, searching, and favoriting.
        - Loads the comics lists depending on the state of the screen.
    *ComicDetailViewModel* and *ComicCellViewModel*:
        - Handles logic for displaying comic details and explanations.

### 4. **Services**:
    *XKCDService*:
    - Fetches comics and explanations from the XKCD API.
    *StorageService*:
    - Manages local storage for favorited comics using `UserDefaults`.
    *XKCDSearchService*:
    - Fetch a HTML wiki page and parse it using *SwiftSoap* to get the comics ids.
   
### 4. **Utils**:
    *NotificationManager*:
    - Handles local notifications for new comics.
    
Classes in `Servicies` and `Utils` are marked as final and implement the *Singleton pattern*. This ensures a single, shared instance is used throughout the app, improving efficiency and consistency.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **Combine**: For reactive programming and data binding.
- **UserNotifications**: For scheduling and displaying local notifications.
- **URLSession**: For networking and API calls.
- **UserDefaults**: For local storage of favorited comics.
- **SwiftSoap**: For working with real-world HTML.

## How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/mariavidrasc19/XKCD-comics.git
   ```
2. Open the project in Xcode.
3. Build and run the app on your preferred device or simulator.


## Future Improvements

- Add support for dark mode.
- Implement push notifications for new comics using a backend service.
- Add a "Random Comic" feature.
- Improve offline support for comic images and explanations.

