# SwiftUI-VideoPlayer
Its a VideoPlayer application designed in SwiftUI using MVVM architecture

A video player app that:
1. Shows videos from an API
2. Lets you play and pause videos
3. Has next and previous buttons to switch videos
4. Shows video title, author, and description
5. Sorts videos by date automatically

How I Built It
I used the MVVM pattern:
Models: Video and Author data
Views: The screens you see
ViewModels: Handles video playback and navigation
Services: Fetches videos from the API

What I Used
SwiftUI Markdown UI - To show formatted descriptions
AVKit - For playing videos
URLSession - To get videos from the server

How to Run
1. Start the Server
cd server npm install npm start
The server runs on http://localhost:4000
2. Open the App
Open app/VideoPlayer.xcodeproj in Xcode
Make sure the server is running
Select a simulator or device
Press ⌘R to run
The app will load videos and show the first one.

Note: I used 127.0.0.1 instead of localhost in the code because the iOS Simulator works with 127.0.0.1 for local connections.


Features
Video player with play/pause button
Next and previous buttons (disabled at start/end)
Video details with title, author, and description
Videos sorted by date
Error handling with retry button
App starts with video paused
Basic Test case for API mocking and view model
