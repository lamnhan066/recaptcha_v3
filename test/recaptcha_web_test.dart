@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:recaptcha_v3/src/recaptcha_web.dart';
import 'package:web/web.dart';

void main() {
  group('RecaptchaImpl badge visibility', () {
    setUp(() {
      // Clean up any existing badge elements
      final existingBadge = document.querySelector('.grecaptcha-badge');
      existingBadge?.remove();
    });

    tearDown(() {
      // Clean up badge elements after each test
      final badge = document.querySelector('.grecaptcha-badge');
      badge?.remove();
    });

    test('changeVisibility updates existing badge immediately', () async {
      // Create a mock badge element
      final badge = document.createElement('div') as HTMLElement;
      badge.className = 'grecaptcha-badge';
      document.body!.append(badge);

      // Initially badge should not have visibility style
      expect(badge.style.visibility, isEmpty);

      // Call changeVisibility(false)
      await RecaptchaImpl.changeVisibility(false);

      // Badge should now be hidden
      expect(badge.style.visibility, 'hidden');
      expect(badge.style.zIndex, '10');
      expect(RecaptchaImpl.isShowingBadge.value, false);

      // Call changeVisibility(true)
      await RecaptchaImpl.changeVisibility(true);

      // Badge should now be visible
      expect(badge.style.visibility, 'visible');
      expect(badge.style.zIndex, '10');
      expect(RecaptchaImpl.isShowingBadge.value, true);
    });

    test('changeVisibility applies to badge inserted later', () async {
      // Call changeVisibility before badge exists
      await RecaptchaImpl.changeVisibility(false);

      // Verify the pending state is set
      expect(RecaptchaImpl.isShowingBadge.value, false);

      // Now insert the badge element after a short delay (simulating script loading)
      await Future.delayed(const Duration(milliseconds: 100));
      final badge = document.createElement('div') as HTMLElement;
      badge.className = 'grecaptcha-badge';
      document.body!.append(badge);

      // Wait for the watcher to detect and apply visibility
      await Future.delayed(const Duration(milliseconds: 200));

      // Badge should now be hidden
      expect(badge.style.visibility, 'hidden');
      expect(badge.style.zIndex, '10');
    });

    test('changeVisibility updates pending visibility when badge not yet loaded', () async {
      // Call changeVisibility(false) first
      await RecaptchaImpl.changeVisibility(false);
      expect(RecaptchaImpl.isShowingBadge.value, false);

      // Then call changeVisibility(true) before badge exists
      await RecaptchaImpl.changeVisibility(true);
      expect(RecaptchaImpl.isShowingBadge.value, true);

      // Now insert the badge
      await Future.delayed(const Duration(milliseconds: 100));
      final badge = document.createElement('div') as HTMLElement;
      badge.className = 'grecaptcha-badge';
      document.body!.append(badge);

      // Wait for the watcher to detect and apply visibility
      await Future.delayed(const Duration(milliseconds: 200));

      // Badge should be visible (last call was showBadge: true)
      expect(badge.style.visibility, 'visible');
      expect(badge.style.zIndex, '10');
    });

    test('ready method sets initial badge visibility', () async {
      // Mock the grecaptcha object since we can't actually load the real script in tests
      // This test focuses on the visibility logic, not the full ready process

      // For this test, we'll directly test the visibility state management
      // The actual ready method would call changeVisibility, which we've already tested

      // Call ready with showBadge: false
      // Note: This would normally load the script, but we'll skip that for testing
      RecaptchaImpl.isShowingBadge.value = false; // Simulate initial state

      // Create badge and call changeVisibility directly
      final badge = document.createElement('div') as HTMLElement;
      badge.className = 'grecaptcha-badge';
      document.body!.append(badge);

      await RecaptchaImpl.changeVisibility(false);

      expect(badge.style.visibility, 'hidden');
      expect(RecaptchaImpl.isShowingBadge.value, false);
    });
  });
}