# S.A.M.E
Navigating Management of the Rapidly Decompensating Patient: S.A.M.E - Software Application for Medical Emergencies

Techstack:
Frontend - Flutter
Backend - Node.js
Database - MongoDB

To run the application you must have flutter and node.js installed. Following these installations, all necessary packages must also be installed. A personal database's access key must be specified in backend/app.js in the uri variable. The database must use mongoDB as a platform. Running node app.js will start the server and connect to the database automatically. Then run the flutter app through main.dart.

The artifact chosen to be implemented is the admin symptom adding functionality as it checks all parts of the tech stack along with serving as an important part of the application.


## Release Notes
---
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
