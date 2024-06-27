
# Recaptcha v3

A forked version of [g_recaptcha_v3](https://github.com/bharathraj-e/g_recaptcha_v3) for my own purpose with automatically loading the script and WASM compilation because the original version almost 2 years without updated.

Create Google reCAPTCHA v3 token for Flutter web. Google reCAPTCHA v3 plugin for Flutter. A Google reCAPTCHA is a free service that protects your website from spam and abuse.

[![Pub](https://img.shields.io/pub/v/recaptcha_v3.svg?style=flat-square)](https://pub.dartlang.org/packages/recaptcha_v3)

> [Web Demo (Build with WASM)](https://pub.lamnhan.dev/recaptcha_v3/)

<img src='https://raw.githubusercontent.com/lamnhan066/recaptcha_v3/main/sample.gif' width='70%'>

<hr>

## Preparation

#### Step 1

- [Create your keys 🗝](https://www.google.com/recaptcha/admin)
- [ReCaptcha Docs](https://developers.google.com/recaptcha/docs/v3)
- For development, add `localhost` as domain in reCaptcha console

#### Step 2

- Add `recaptcha_v3` to pubspec.yaml

```bash
  flutter pub add recaptcha_v3
```

## Development

### 1. Recaptcha.ready()

The `ready()` method should be called before `execute()`

```dart
import 'package:recaptcha_v3/recaptcha_v3.dart'; //--1

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Recaptcha.ready("<your Recaptcha site key>"); //--2
  runApp(const MyApp());
}
```

### 2. Recaptcha.execute()

The `ready()` method should be called before `execute()`

```dart
import 'package:recaptcha_v3/recaptcha_v3.dart';

void generateToken() async {
  String? token = await Recaptcha.execute('<your_action>'); //--3
  print(token);
  // send token to server and verify
}
```

- `String action` - used to verify the string in backend. ( [action docs](https://developers.google.com/recaptcha/docs/v3#actions) )
- `token` will be null if the,
  - web setup has any errors.
  - method called from other than web platform.

### 3. Show / Hide reCaptcha badge

change the reCaptcha badge visibility

```dart
Recaptcha.showBadge();
Recaptcha.hideBadge();
```

or you can toogle the badge visibility using:

```dart
Recaptcha.toogleBadge();
```

### 4. The reCAPTCHA branding Widget

```dart
RecaptchaBrand();
```

This brand will automatically show/hide regarding to the state of the badge. So you just need to put it anywhere you want without any condition.

### 5. A `ValueListenable` of the badge's show/hide state

```dart
final isShowing = Recaptcha.isShowingBadge.value;
```
  
## Warning
  
You are allowed to hide the badge as long as you `include the reCAPTCHA branding` visibly in the user flow.`

Sample Image

![alternate way](https://developers.google.com/recaptcha/images/text_badge_example.png)

### [Read more about hiding in reCaptcha docs](https://developers.google.com/recaptcha/docs/faq#id-like-to-hide-the-recaptcha-badge.-what-is-allowed)

You can use the `RecaptchaBrand` widget to show the reCaptcha brand.
  
### Web Port 80 setup

##### (for localhost only)

If in case recaptcha script gives you error for port other than port :80, you can use the following code to setup the port.

```bash
  flutter run -d chrome --web-port 80
```

### Known Issues

1. This issue is shown in the console by the native code issue (cannot be catched by `try-catch` and can be ignored):

```shell
Error
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 296:3       throw_
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 893:3   defaultNoSuchMethod
dart-sdk/lib/_internal/js_dev_runtime/patch/core_patch.dart 63:17                 noSuchMethod
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 868:31  noSuchMethod
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 318:12  callNSM
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 428:10  _checkAndCall
dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 431:39  dcall
```
