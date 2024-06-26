library g_recaptcha_v3_web;

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

@JS('grecaptcha')
external Grecaptcha get grecaptcha;

@JS()
@anonymous
@staticInterop
class Grecaptcha {}

@staticInterop
extension GRecaptchaExtension on Grecaptcha {
  external JSPromise ready(JSFunction f);
  external JSPromise<JSString> execute(JSString key, Options options);
}

@JS()
@anonymous
@staticInterop
extension type Options._(JSObject _) implements JSObject {
  external factory Options({String action});
}

extension OptionsExtension on Options {
  external String get action;
}

/// A web implementation of the GRecaptchaV3 plugin.
///
/// use `GRecaptchaV3` not ~GRecaptchaV3PlatformInterace~
class GRecaptchaV3PlatformInterface {
  static String? _gRecaptchaV3Key;

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'g_recaptcha_v3',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = GRecaptchaV3PlatformInterface();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'g_recaptcha_v3 for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// This method should be called before calling `execute()` method.
  static Future<bool> ready(String key, bool showBadge) async {
    if (!kIsWeb) return false;

    _gRecaptchaV3Key = key;
    if (await _waitForGrecaptchaReady()) {
      changeVisibility(showBadge);
      debugPrint('gRecaptcha V3 ready');
      return false;
    }

    return true;
  }

  static Future<bool> _waitForGrecaptchaReady() async {
    final completer = Completer<bool>();
    void complete(bool isBreak) {
      if (!completer.isCompleted) {
        completer.complete(isBreak);
      }
    }

    try {
      await grecaptcha
          .ready(() {
            complete(true);
          }.toJS)
          .toDart;
      complete(true);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 20));
      complete(false);
    }
    return completer.future;
  }

  /// use `GRecaptchaV3` not ~GRecaptchaV3PlatformInterace~
  static Future<String?> execute(String action) async {
    if (!kIsWeb) return null;
    if (_gRecaptchaV3Key == null) {
      throw Exception('gRecaptcha V3 key not set : Try calling ready() first.');
    }
    try {
      final result =
          grecaptcha.execute(_gRecaptchaV3Key!.toJS, Options(action: action));
      return (await result.toDart).toDart;
    } catch (e) {
      debugPrint(e.toString());
      // Error: No reCAPTCHA clients exist.
      return null;
    }
  }

  /// change the reCaptcha badge visibility
  static Future<void> changeVisibility(bool showBagde) async {
    if (!kIsWeb) return;
    var badge = web.document.querySelector(".grecaptcha-badge") as dynamic;
    if (badge == null) return;
    badge.style.zIndex = "10";
    badge.style.visibility = showBagde ? "visible" : "hidden";
  }
}
