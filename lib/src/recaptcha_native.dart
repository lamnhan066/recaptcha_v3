import 'package:flutter/material.dart';

/// A web implementation of the Recaptcha plugin.
///
/// use `Recaptcha` not ~RecaptchaPlatformInterace~
class RecaptchaImpl {
  /// Return `true` if the badge is showing.
  static ValueNotifier<bool> get isShowingBadge => ValueNotifier(false);

  /// use `Recaptcha` not ~RecaptchaPlatform~
  static Future<void> ready(String key, bool showBadge) async {}

  /// use `Recaptcha` not ~RecaptchaPlatformInterace~
  static Future<String?> execute(String action) async {
    return null;
  }

  /// change the reCaptcha badge visibility
  static Future<void> changeVisibility(bool showBagde) async {
    return;
  }
}
