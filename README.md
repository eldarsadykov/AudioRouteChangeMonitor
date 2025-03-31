# AudioRouteChangeMonitor

## Description

A developer tool for monitoring [audio route changes](https://developer.apple.com/documentation/avfaudio/responding-to-audio-route-changes) on iOS, such as switching to a different audio device or when a device becomes unavailable.

All route changes are recorded and viewable as a table on iPad or a list with expandable items on iPhone.

The list can be cleared, imported, and exported as a JSON file. 

You can download the [app from the App Store](https://apps.apple.com/at/app/routemonitor/id6741707408?l=en-GB) for basic monitoring or build it locally from this repository for more advanced debugging scenarios.

## Purpose

Understanding the precise order of audio route changes is crucial, as different types of devices can behave unpredictably. This tool helps developers track and analyze these changes effectively.

## TODO

 - Allow audio session setup from the UI.
 - Enable exporting of individual route changes.

## Contribution

Contributions are welcome! Feel free to fork this repository and submit pull requests to enhance the app's functionality.

## Credits

GitHub SF Symbols: https://github.com/jeremieb/social-symbols.git

## Screenshots

![Simulator Screenshot - iPad Pro 13-inch (M4) - 2025-03-29 at 17 00 32](https://github.com/user-attachments/assets/98808b4e-575e-426c-b49d-d227373a012c)
![Simulator Screenshot - iPad Pro 13-inch (M4) - 2025-03-29 at 17 00 39](https://github.com/user-attachments/assets/b0e1c72e-52f9-4f1e-b4df-786a7d474492)
