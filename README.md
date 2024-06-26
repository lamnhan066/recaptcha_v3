
# recaptcha

Create Google reCAPTCHA v3 token for Flutter web.  Google reCAPTCHA v3 plugin for Flutter. A Google reCAPTCHA is a free service that protects your website from spam and abuse.

[![Pub](https://img.shields.io/pub/v/recaptcha.svg?style=flat-square)](https://pub.dartlang.org/packages/recaptcha)

> [Web Demo](https://pub.github.io/recaptcha/)

<img src='https://raw.githubusercontent.com/lamnhan066/recaptcha/dev/sample.gif' width='70%'>

<hr>

## Preparation

#### Step 1

- [Create your keys 🗝](https://www.google.com/recaptcha/admin)
- [ReCaptcha Docs](https://developers.google.com/recaptcha/docs/v3)
- For development, add `localhost` as domain in reCaptcha console

#### Step 2

- Add `recaptcha` to pubspec.yaml

```bash
  flutter pub add recaptcha
```

## Development

### 1. Recaptcha.ready()

The `ready()` method should be called before `execute()`

````dart
import 'package:recaptcha/recaptcha.dart'; //--1

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Recaptcha.ready("<your Recaptcha site key>"); //--2
  runApp(const MyApp());
}
````

### 2. Recaptcha.execute()

The `ready()` method should be called before `execute()`

````dart
import 'package:recaptcha/recaptcha.dart';

void generateToken() async {
  await Recaptcha.ensureReady;
  String? token = await Recaptcha.execute('<your_action>'); //--3
  print(token);
  // send token to server and verify
}
````

- `String action` - used to verify the string in backend. ( [action docs](https://developers.google.com/recaptcha/docs/v3#actions) )
- `token` will be null if the,
  - web setup has any errors.
  - method called from other than web platform.

### 3. Show / Hide reCaptcha badge

change the reCaptcha badge visibility

````dart
    Recaptcha.showBadge();
    Recaptcha.hideBadge();
````
  
## Warning
  
You are allowed to hide the badge as long as you `include the reCAPTCHA branding` visibly in the user flow.`

Sample Image

![alternate way](https://developers.google.com/recaptcha/images/text_badge_example.png)

### [Read more about hiding in reCaptcha docs](https://developers.google.com/recaptcha/docs/faq#id-like-to-hide-the-recaptcha-badge.-what-is-allowed)
  
### Web Port 80 setup

##### (for localhost only)

If in case recaptcha script gives you error for port other than port :80, you can use the following code to setup the port.

```bash
  flutter run -d chrome --web-port 80
```

### FAQ

**Q:** How to hide reCaptcha until / before Flutter render its UI?

**A:** [https://github.com/bharathraj-e/recaptcha/issues/3](https://github.com/bharathraj-e/recaptcha/issues/3)
