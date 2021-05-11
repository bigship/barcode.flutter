__Barcode Flutter is a Flutter library for simple and fast Barcode rendering via custom painter__

![screenshot](https://i.ibb.co/58S2psy/barcode-flutter.png)
<hr>

# Update Notes
2.0.0
  - Migrated to Dart null safe

1.1.2
 - Add Codabar support
 - Fix wrong pattern for value 102 of Code128 ([#20](https://github.com/bigship/barcode.flutter/issues/20))

1.1.0
 - Add ITF support
 - Add BarCodeParams class for future expandability

1.0.2
- Fix EAN8 code invalid checksum bug

1.0.1
- Fix issue. Scanning problem when code128 contains character 'M'

1.0.0
- Initial release

# Features
- Supports code type: __Code39__, __Code93__, __Code128__, __EAN13__, __EAN8__, __UPCA__, __UPCE__
- Supports render with or without text label
- Supports adjusting the bar width
- No internet connection required

# Installing
You can install the package by adding the following lines to your `pubspec.yaml`:

```yaml
dependencies:
    barcode_flutter: ^2.0.0
```

After adding the dependency to your `pubspec.yaml` you can run: `flutter packages get` or update your packages using your IDE.

# Getting started
To start, import the dependency in your code:

```dart
import 'package:barcode_flutter/barcode_flutter.dart';
```

Next, to reander a Barcode (Code39 for example), you can use the following code:
```dart
BarCodeImage(
  params: Code39BarCodeParams(
    "1234ABCD",
    lineWidth: 2.0,                // width for a single black/white bar (default: 2.0)
    barHeight: 90.0,               // height for the entire widget (default: 100.0)
    withText: true,                // Render with text label or not (default: false)
  ),
  onError: (error) {               // Error handler
    print('error = $error');
  },
);
```

__NOTE__: You can only tweak the lineWidth parameter to change the entire widget's width. But value less than `2.0` will sometimes make the barcode scaner more difficult to recognize result correctly. `2.0` is a safe value for all code types.

__Error handling__: You have to make sure the code strings provided are valid. If you are not sure about the data, maybe it comes from
user input or something, then setup onError method, and put your error handling logic there. Sometimes the library will render parts of
the barcode if the data is invalid, and if that happens, I can't guarantee that the result can be recognized by a barcode scaner. 

# Example
See the `example` directory for a basic working example.

# FAQ
## Has it been tested in production? Can I use it in production?
Yep! I've test it both on Android and iOS devices. Feel free to test it with any barcode scanner.

## How about the other barcode types ?
I've only implemented some most commonly used barcode types. But feel free to send PR to include more barcode types.

## License
Barcode flutter is released under [BSD license](http://opensource.org/licenses/BSD-2-Clause). See `LICENSE` for details.
