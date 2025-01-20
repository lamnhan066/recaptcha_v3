## 0.2.0

* Bump the web package to `^1.1.0`. (Thanks @san-smith)ß

## 0.1.1

* Add a small delay to the `ready` method to decrease the known issue happened on Flutter stable (3.22.2) and beta (3.23.0-0.1.pre). You can change this value to `null` when you use it on Flutter master channel.
* Refactored the code to make it clearer.

## 0.1.0

* Add `isShowingBadge` as a `ValueListenable`.
* Add `toogleBadge` method.
* Improve README.

## 0.0.3+1

* Improve the pub score.

## 0.0.3

* Add the `RecaptchaBrand` widget.

## 0.0.2

* The `showBadge` and `hideBadge` work properly when built to WASM.
* Fix some TYPO.
* Update README.

## 0.0.1+1

* Forked from @bharathraj-e.
* Load the script automatically.
* Supports WASM compilation.

# Original

## 0.0.5 - [2022-06-11]

* Added bool return for ready()
* Readme updated.

## 0.0.4 - [2021-11-28]

* Fixed dart html error during android / ios build

## 0.0.3 - [2021-11-20]

* Added Show/hide reCaptcha badge.

## 0.0.2-beta - [2021-11-17]

* Recaptcha Typo fixes.
* `NoSuchMethodError: tried to call a non-function, such as null: 'dart.global.ready'` fixed

## 0.0.1-beta - [2021-11-14]

* Initial release for Web only platform.
