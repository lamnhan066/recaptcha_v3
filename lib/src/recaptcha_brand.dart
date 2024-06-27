import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:recaptcha_v3/recaptcha_v3.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecaptchaBrand extends StatelessWidget {
  const RecaptchaBrand({
    super.key,
    this.normalTextColor = Colors.grey,
    this.tappableTextColor = Colors.blue,
    this.fontSize = 11,
    this.margin = const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
  });

  final Color normalTextColor;
  final Color tappableTextColor;
  final double fontSize;
  final EdgeInsetsGeometry margin;

  Future<bool> goToUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      return await launchUrlString(url);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Recaptcha.isShowingBadge,
      builder: (context, value, child) {
        if (value) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: margin,
          child: Text.rich(
            TextSpan(
              text: 'This site is protected by reCAPTCHA and the Google\n',
              children: [
                TextSpan(
                  text: 'Privacy Policy',
                  style:
                      TextStyle(color: tappableTextColor, fontSize: fontSize),
                  recognizer: TapGestureRecognizer()
                    ..onTap =
                        () => goToUrl('https://policies.google.com/privacy'),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Terms of Service',
                  style:
                      TextStyle(color: tappableTextColor, fontSize: fontSize),
                  recognizer: TapGestureRecognizer()
                    ..onTap =
                        () => goToUrl('https://policies.google.com/terms'),
                ),
                const TextSpan(text: ' apply.'),
              ],
              style: TextStyle(color: normalTextColor, fontSize: fontSize),
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
