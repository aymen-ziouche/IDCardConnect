# NFC ID Reader

NFC ID Reader is a Flutter application that allows you to read and extract data from electronic ID Cards using Near Field Communication (NFC) technology. It provides a simple and intuitive interface to scan and retrieve information from ID Card.

## Features

- Scan and read data from ID Card using NFC.
- Extract and display various information from the ID Card, such as personal details, biographical data, photo, etc.
- Utilizes the [dmrtd](https://github.com/ZeroPass/dmrtd) package for parsing and decoding the ID Card data.

## Getting Started

To run the NFC ID Reader application locally, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/aymen-ziouche/nfc-id-reader.git

   ```

2. Navigate to the project directory:

   ```bash
   cd nfc-id-reader

   ```

3. Install the dependencies:

   ```bash
   flutter pub get

   ```

4. Connect your Android device or emulator with NFC support.

   ```bash
   flutter run

   ```

5. Run the application:

   ```bash
   flutter run
   ```

The app should launch on your device/emulator, ready to scan ID Card.

## Dependencies

This project relies on the following key dependency:

dmrtd: A Dart package that provides functionality for parsing and decoding electronic passports (MRTD) data.
For a complete list of dependencies, please refer to the pubspec.yaml file.

## Contributing

Contributions to NFC ID Reader are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.
