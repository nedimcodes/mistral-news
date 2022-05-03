#  Technical Task - News App 📰

## About project
App is built with SwiftUI and UIKit (mimicking the 'legacy' codebase).<br>
App uses strongly followed MVVM architecture.

## Modules 
#### Background
App enables background mode, and fetches new headlines from server as scheduled task.
After new latest headline has been fetched, app sends notification to the user 
#### Database
Local database for this app is SQLite3 and this module contains methods responsible for functioning database management.
#### Helpers
Helpers module contains helping extensions built for easier development experience
#### Views
Module contains all SwiftUI views shown inside the app. Module is broken to smaller chunks containing views based of feature they are representing.
#### ViewModels
Module contains all ObservableObject classes responsible for runtime state management
### Networking
Module contains handler responsible for all API calls to the news API.

## Packages
App uses native SPM for packages
- Awesome (AwesomeFont Icon)
- SDWebImageSwiftUI (Image Loading)
- SQLite (DBMS) 

## App Features

- Fetching "top" headlines for 5+ categories
- Implemented pagination
- FontAwesome Icons
- Searching news by keywords
- Handling networking errors
- Managing keywords
- Sending notifications when new headline appears for given keyword

