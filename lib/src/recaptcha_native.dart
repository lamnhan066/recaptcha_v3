/// A web implementation of the Recaptcha plugin.
///
/// use `Recaptcha` not ~RecaptchaPlatformInterace~
class RecaptchaImpl {
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
