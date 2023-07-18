# demo-cloud-app-objectiveC


## ObjectiveC Token App
This is a simple app that demonstrates how to expose a token and pass it through a WebView. The app allows users to input a token and displays a WebView that loads a webpage using the provided token for authentication.

### Prerequisites
1. Xcode (minimum version: 12.0)
3. iOS 13.0 or later

### Installation
1. Clone or download the repository to your local machine.
2. Open the project in Xcode.
3. Add valid initial token to constants file.

### Usage
0. Replace `urlString` with the base url you want to use.
1. Open the project in Xcode.
2. Build and run the app on the iOS simulator or a physical device.
3. The app will launch and display a prompt.
4. Enter your initial token in the prompt.
5. The WebView will load a webpage using the provided token for authentication.
6. Make sure your token has opt in flow, go to wallet view to start "authentication" flow.
7. Tap on the continue button, a window will be displayed intercepting the javascript.
8. Use the prompt to send a new token to complete the authentication.


### Code Structure
The project follows a simple structure:

* ViewController.m: Contains the main view of the app, including the prompt and WebView.
* ViewController.h: header/interface
