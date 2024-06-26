/// A web implementation of the Recaptcha plugin.
///
/// use `Recaptcha` not ~RecaptchaPlatformInterace~
class RecaptchaImpl {
  /// Check if the `Recaptcha` is ready to use.
  static bool get isReady => false;

  /// Wait until the `Recaptcha` is ready to use.
  static Future<void> get ensureReady => Future.value();

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
