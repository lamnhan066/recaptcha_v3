import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart';

@JS('grecaptcha')
external Grecaptcha get grecaptcha;

@JS()
@anonymous
@staticInterop
class Grecaptcha {}

extension GRecaptchaExtension on Grecaptcha {
  external JSPromise ready(JSFunction f);
  external JSPromise<JSString> execute(JSString key, Options options);
}

@JS()
@anonymous
@staticInterop
extension type Options._(JSObject _) implements JSObject {
  external factory Options({JSString action});
}

extension OptionsExtension on Options {
  external JSString get action;
}

/// A web implementation of the Recaptcha plugin.
///
/// use `Recaptcha` not ~RecaptchaPlatformInterace~
class RecaptchaImpl {
  static String? _recaptchaKey;
  static final _completer = Completer<void>();

  /// This method should be called before calling `execute()` method.
  static Future<void> ready(String key, bool showBadge) async {
    if (!kIsWeb) return;
    if (_completer.isCompleted) return;

    _recaptchaKey = key;
    await _maybeLoadLibrary();
    await _waitForGrecaptchaReady();
    changeVisibility(showBadge);
    debugPrint('gRecaptcha V3 ready');

    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  /// TODO: Avoid using the `Future.delayed` if possible
  static Future<void> _waitForGrecaptchaReady() async {
    await Future.doWhile(() async {
      final completer = Completer<bool>();
      void complete(bool isBreak) {
        if (!completer.isCompleted) {
          completer.complete(isBreak);
        }
      }

      // TODO: Figure out why the `grecaptcha.ready` is error even when the `grecaptcha` was loaded
      // by checking the `globalContext.hasProperty('grecaptcha'.toJS)` variable.
      //
      // Caused this issue:
      // Error
      // dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 296:3       throw_
      // dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 893:3   defaultNoSuchMethod
      // dart-sdk/lib/_internal/js_dev_runtime/patch/core_patch.dart 63:17                 noSuchMethod
      // dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 868:31  noSuchMethod
      // dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 318:12  callNSM
      // dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 428:10  _checkAndCall
      // dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 431:39  dcall
      try {
        await grecaptcha
            .ready(() {
              complete(false);
            }.toJS)
            .toDart;
      } catch (e) {
        await Future.delayed(const Duration(milliseconds: 10));
        complete(true);
      }

      return completer.future;
    });
  }

  /// use `Recaptcha` not ~RecaptchaPlatformInterace~
  static Future<String?> execute(String action) async {
    await _completer.future;
    if (!kIsWeb) return null;
    if (_recaptchaKey == null) {
      throw Exception('gRecaptcha V3 key not set : Try calling ready() first.');
    }
    try {
      final result =
          grecaptcha.execute(_recaptchaKey!.toJS, Options(action: action.toJS));
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
    var badge = document.querySelector(".grecaptcha-badge") as HTMLElement?;
    if (badge == null) return;
    badge.style.zIndex = "10";
    badge.style.visibility = showBagde ? "visible" : "hidden";
  }

  /// Load the barcode reader library.
  ///
  /// Does nothing if the library is already loaded.
  static Future<void> _maybeLoadLibrary() async {
    final completer = Completer();

    const scriptId = 'g_recapcha_script';
    final scriptUrl =
        'https://www.google.com/recaptcha/api.js?render=$_recaptchaKey';

    // Script already exists.
    if (document.querySelector('script#$scriptId') != null) {
      return;
    }

    final HTMLScriptElement script = HTMLScriptElement()
      ..id = scriptId
      ..src = scriptUrl;

    script.onerror = (JSAny _) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('The G reCaptcha cannot be loaded'));
      }
    }.toJS;

    document.head!.appendChild(script);

    /// TODO: Avoid using the `Future.delayed` if possible
    Future.doWhile(() async {
      if (globalContext.hasProperty('grecaptcha'.toJS).toDart) {
        if (!completer.isCompleted) {
          completer.complete();
        }
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 10));
      return true;
    });

    return completer.future;
  }
}
