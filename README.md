# S.A.M.E
Navigating Management of the Rapidly Decompensating Patient: S.A.M.E - Software Application for Medical Emergencies

Techstack:
Frontend - Flutter
Backend - Node.js (Changed to Firebase)
Database - MongoDB (Changed to Firebase Realtime Database and Storage)

To run the application you must have flutter and node.js installed. Following these installations, all necessary packages must also be installed. A personal database's access key must be specified in backend/app.js in the uri variable. Running node app.js will start the server automatically. The server is necessary for an admin to delete an account. Then run the flutter app through main.dart.

## Installation Guide
### Flutter:
- Follow instructions on flutter installation website: https://docs.flutter.dev/get-started/install/macos

    - If you have M1, M2, etc. (silicon) chip, click on the Apple Silicon Installation. Otherwise click on the intel installation.
    - Once you get to the 'Run Flutter Doctor' step, let me know what issues the command prompt shows you and we will move on from there.
    - In case any 'flutter' commands do not work for you, make sure to follow the instructions in this step as well: https://docs.flutter.dev/get-started/install/macos#update-your-path. 
    - We will primarily work off iOS because our client uses an iphone, so do most of their peers, and we are all developing on an iOS environment. This means that we have to make sure xCode and all relevant dependencies are working the way they are supposed to. As such, I highly recommend trying to follow the steps here: https://docs.flutter.dev/get-started/install/macos#ios-setup
    - Finish all the steps on that previous link up until (not including) 'Deploy to physical iOS Devices'
    - From there we can run the base flutter app through visual studio code


### Node.js:
- Follow instructions on https://nodejs.org/en/download
    - Make sure to install the LTS macOS installer
    - As you are going through the installation make sure to take a screenshot of the very last screen of the installer. We need the file path and version it specified in order to make sure we are all on the same version.
 
### Getting the app running:
Once flutter is successfully installed, you can run the application by going to the folder/directory frontend/s_a_m_e/ and then:
- perform the command `flutter pub get` in the directory
- do `flutter run` in the same directory with the device you want to run it on (ios simulator, ios device, android simulator, android device, etc.)
- Assuming you have installed Node.js properly as mentioned above, go into the `/backend` directory and run `npm install` which will download all necessary node.js dependencies
- Then run `node app.js` in the same directory to start the server.

### Using your own Firebase Database:
Currently, the application runs on our production database. To run on your own database, change the firebase_options.dart file according to what level of firebase you purchase and/or are using.


## Release Notes
---
### Version 1.0.0:
#### New Features
* Changed categories to be organ systems and are used to organize both signs and symptoms
* User is now able to navigate to profile and change all necessary information properly
* Diagnoses now account for signs properly when being sorted
* Next steps tab and attribute added to diagnoses
* Sign-up now requires verification
* Disclaimer can now be edited by admins

#### Features
* Users can see all existing diagnoses
* New page created called signs that the user can access
* Admin can see all relevant signs and categories
* User can see all signs that fall under a given category
* Added categories to symptoms to make UI experience better
* Admin ability to add diagnoses
* User ability to select symptoms to get diagnoses
* Ability to search up specific symptoms as a user
* Being able to redirect back to the homepage at any given page
* Ability to see which page user is currently on
* Admin being able to update and delete symptoms/categories/diagnoses
* Sorting functionality using K-Nearest Neighbors for diagnoses
* Backend updated to use Firebase 
* Sign-up and Sign-in Backend Updated to use Firebase
* Admin: User-list functionality
* Admin: View and approve admin requests
* Admin: Delete user accounts
* User: Create and update admin requests
* Seperation of Admin and User pages
* Admin privileges implemented
* Chief complaints renamed to categories

#### Bug Fixes
* Log-in page now throws error on failed log-in attempts
* Home buttons added wherever necessary
* Page titles updated to be consistent
* Certain null condition errors on diagnosis sorting fixed

#### Known Issues
* Next steps for diagnosis not completely implemented
* Organ system classification exists for diagnoses on backend but not in frontend

### Version 0.4.0:
#### New Features
* User can see all existing diagnoses now as well
* New page created called signs that the user can now access
* Admin can see all relevant signs and categories now
* User can see all signs that fall under a given category

#### Bug Fixes
* Fixed UI exceptions thrown on category pages
* Fixed UI exceptions thrown on diagnoses update pages
* Reorganized some backend functions to stop unknown reload behavior

#### Known Issues
* Admin side missing home button
* Diagnosess does not take signs into account
* Profile picture logo is not clickable in some pages
* Inconsistency between potential diagnoses and diagnoses list
* Inconsistent page titles


### Version 0.3.0:
#### New Features
* Added categories to symptoms to make UI experience better
* Admin ability to add diagnoses
* User ability to select symptoms to get diagnoses
* Ability to search up specific symptoms as a user
* Being able to redirect back to the homepage at any given page
* Ability to see which page user is currently on
* Admin being able to update and delete symptoms/categories/diagnoses
* Sorting functionality using K-Nearest Neighbors for diagnoses

#### Bug Fixes
* Updated profile pictures to be on Firebase storage
* Added check to stop duplicate adding to symptoms, categories, and diagnoses
* Fixed expanding VBox issues on certain pages
* 3rd Party API service built to delete users from Firebase authentication
* Profile Picture persists on UI beyond upload


#### Known Issues
* Implementing 'Lost Password' functionality
* Implementing user login beyond app lifecycle
* Exceptions thrown on certain category update pages
* Exceptions thrown on certain diagnoses update pages



### Version 0.2.0:
#### New Features
* Backend updated to use Firebase 
* Sign-up and Sign-in Backend Updated to use Firebase
* Admin: User-list functionality
* Admin: View and approve admin requests
* Admin: Delete user accounts
* User: Create and update admin requests
* Seperation of Admin and User pages
* Admin privileges implemented
* Chief complaints renamed to categories

#### Bug Fixes
* Fixed Profile Picture uploads to update on backend
* Fixed UI Login Page
* Fixed UI for Sign-Up Page

#### Known Issues
* 3rd Party API service needed to delete users from Firebase authentication
* Implementing 'Lost Password' functionality
* Implementing user login beyond app lifecycle
* Profile Picture doesn't persist on UI beyond upload


### Version 0.1.0:
#### New Features
* Disclaimer Popup
* Sign-up and Sign-in UI and API
* Admin Page
* Symptom List Page
* Symptom Addition API
* Profile Picture Icon Functionality
* Profile Picture Upload API

#### Bug Fixes
* Temporary User Flow Fixed
* Backend Sign-up Fixed

---
