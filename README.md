### Temperature Converter App

This is a Flutter mobile application that converts temperatures between Fahrenheit and Celsius. It includes input validation, conversion history tracking, and supports both portrait and landscape orientations.

## Features

- Convert between Fahrenheit and Celsius
- Input validation using Form and TextFormField
- Accurate calculations to two decimal places
- Conversion history list that stores recent conversions
- Responsive layout for both portrait and landscape modes
- Clear button to reset the input
- Clear history button to remove past conversions
- Custom themed user interface with warm and cool colors based on conversion type

## How to Run the App

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/temperature-converter.git
   cd temperature-converter


2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

Make sure an Android emulator or physical device is connected.

## Project Structure

```
/lib
  main.dart             # Main app logic and UI widgets
/android
/ios
/pubspec.yaml           # Project metadata and dependencies
```

## Implementation Overview

* Uses StatefulWidget and setState for managing UI updates
* RadioListTile allows switching between conversion directions
* TextFormField handles numeric input with validation
* OrientationBuilder is used to build different layouts based on device orientation
* Conversion logic:

  * Celsius = (Fahrenheit - 32) \* 5 / 9
  * Fahrenheit = Celsius \* 9 / 5 + 32
* ConversionHistory model stores and formats past conversion results

## Screenshots

Insert screenshots here once available:

* Portrait view
* Landscape view
* Input and result example
* Conversion history list

## License

This project is open-source and available under the MIT License.

## Author

Marie Elyse UYIRINGIYE
GitHub: https://github.com/elyse003
