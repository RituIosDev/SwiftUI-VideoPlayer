silverorange SwiftUI App Developer Assessment
=============================================

This exercise is designed to assess how you approach tasks required in your
position as a SwiftUI app developer at silverorange. We are interested in how
you work as much we’re interested the final results, so please include useful
Git commit messages and comments where you think your code may be unclear.

Wireframe
---------
![wireframe](docs/wireframe.png)

Tasks
-----
Using the blank iOS project found in `/app`, complete the following:

 1. Display a screen similar to the provided wireframe. The screen should
    contain a video player at the top and a scrollable details section at the
    bottom.
 2. Import and use the provided PDF image assets in `assets/` for the media
    controls.
 3. Fetch a list of videos from the provided API (see instructions below for
    running the API).
 4. Sort the received list of videos by date.
 5. Load the first video into the UI by default.
 6. Implement the play/pause button for the video player. The app should be
    paused on startup.
 7. Implement next/previous buttons for the video player. Clicking next should
    update the UI with the next video and video details. Buttons should be
    insensitive when at the start/end of the list.
 8. In the details section, show the returned description for the current video
    as rendered Markdown.
 9. In the details section, also display the title and author of the current
    video.

Environment
-----------
The project should run on supported iPhone devices and build using supported
Xcode versions.

Please start with the blank project in `/app` using Xcode.

Dependencies
------------
For media playback, Markdown parsing and/or networking you may want to use
external dependencies. Please use the Swift Package Manager.

You may consider using these packages, but are not required to use them:

 - https://swiftpackageindex.com/gonzalezreal/swift-markdown-ui (Markdown)
 - https://swiftpackageindex.com/johnxnguyen/Down (Markdown)
 - https://swiftpackageindex.com/Alamofire/Alamofire (Networking)

Commits
-------
Your commit history is important to us! Try to make meaningful commit messages
that show your progress.

Getting Started With the Server Backend (/server)
-----------------------------------------------
For this exercise a simple pre-built server application is provided. The
application runs by default on `localhost:4000` and has the following endpoints:

 - `http://localhost:4000/videos` - returns a JSON-encoded array of videos.

### Running the Server

The provided API server is needed as a data source for your project. To run the
server you will need Node.js.

You can quickly install the requirements using [Homebrew](https://brew.sh/) with:

```sh
brew install node
```

With dependencies installed, you can run the server with:

```sh
cd server
npm install
npm start
```

You can verify the API is working by visiting http://localhost:4000/videos in
your browser, or another HTTP client.
