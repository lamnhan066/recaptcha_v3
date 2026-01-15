import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart';

@JS('grecaptcha')
external Grecaptcha get grecaptcha;

extension type Grecaptcha._(JSObject _) implements JSObject {
  external JSVoid ready(JSFunction f);
  external JSPromise<JSString> execute(JSString key, Options options);
}

extension type Options._(JSObject _) implements JSObject {
  external factory Options({JSString action});
  external JSString get action;
}

/// A web implementation of the Recaptcha plugin.
///
/// use `Recaptcha` not ~RecaptchaPlatformInterace~
class RecaptchaImpl {
  static String? _recaptchaKey;
  static final _readyCompleter = Completer<void>();
  static bool _isReadyCalled = false;
  static final _isShowingBadge = ValueNotifier(false);
  static bool? _pendingBadgeVisibility;

  /// Return `true` if the badge is showing.
  static ValueNotifier<bool> get isShowingBadge => _isShowingBadge;

  /// This method should be called before calling `execute()` method.
  static Future<void> ready(
    String key,
    bool showBadge, {
    // Delay before checking the `grecaptcha.ready` to avoid issue on
    // Flutter stable (3.22.2) and beta (3.23.0-0.1.pre).
    // You can change this value to `null` if you're using the `master` channel.
    Duration? delay = const Duration(milliseconds: 300),
  }) async {
    if (!kIsWeb) return;
    if (_isReadyCalled) return;
    if (_readyCompleter.isCompleted) return;
    _isReadyCalled = true;
    _recaptchaKey = key;
    _pendingBadgeVisibility = showBadge;
    _isShowingBadge.value = showBadge;
    await _maybeLoadLibrary();
    await _waitForGrecaptchaReady(delay);
    await changeVisibility(showBadge);
    debugPrint('gRecaptcha V3 ready');
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete();
    }
  }

  static Future<void> _waitForGrecaptchaReady(Duration? delay) async {
    if (delay != null) await Future.delayed(delay);
    while (true) {
      final completer = Completer<bool>();
      grecaptcha.ready(() {
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }.toJS);
      if (delay != null) {
        final isDone = await completer.future.timeout(
          delay,
          onTimeout: () => false,
        );
        if (isDone) return;
      } else {
        return;
      }
    }
  }

  /// use `Recaptcha` not ~RecaptchaPlatformInterace~
  static Future<String?> execute(String action) async {
    if (!kIsWeb) return null;
    await _readyCompleter.future;
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
  static Future<void> changeVisibility(bool showBadge) async {
    if (!kIsWeb) return;

    _pendingBadgeVisibility = showBadge;
    _isShowingBadge.value = showBadge;

    var badge = document.querySelector(".grecaptcha-badge") as HTMLElement?;
    if (badge != null) {
      _applyBadgeVisibility(badge, showBadge);
    } else {
      // Badge not loaded yet, set up a watcher to apply visibility when it appears
      _watchForBadgeInsertion(showBadge);
    }
  }

  static void _applyBadgeVisibility(HTMLElement badge, bool showBadge) {
    badge.style.zIndex = "10";
    badge.style.visibility = showBadge ? "visible" : "hidden";
  }

  static void _watchForBadgeInsertion(bool showBadge) {
    // Use a short polling approach to check for badge insertion
    // This is simpler than MutationObserver for this use case
    const maxAttempts = 50; // ~5 seconds at 100ms intervals
    var attempts = 0;

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      attempts++;
      final badge = document.querySelector(".grecaptcha-badge") as HTMLElement?;

      if (badge != null) {
        timer.cancel();
        // Check if we still need to apply the pending visibility
        if (_pendingBadgeVisibility == showBadge) {
          _applyBadgeVisibility(badge, showBadge);
        }
      } else if (attempts >= maxAttempts) {
        timer.cancel();
        debugPrint('reCAPTCHA badge not found after watching for insertion');
      }
    });
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
      ..async = true
      ..id = scriptId
      ..src = scriptUrl;
    script.onerror = (JSAny _) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('The G reCaptcha cannot be loaded'));
      }
    }.toJS;
    script.onload = (JSAny _) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }.toJS;
    if (document.head != null) {
      document.head!.appendChild(script);
    } else {
      document.appendChild(script);
    }
    return completer.future;
  }
}
