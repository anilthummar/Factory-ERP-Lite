import 'package:async/async.dart';

import 'exports.dart';

///this file helps to define all the common function

/// Hides the keyboard.
void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

//----------------------------------------------------------------------

/// Shows the status bar.
Future<void> showStatusBar() async {
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: <SystemUiOverlay>[SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
}
//----------------------------------------------------------------------

/// Hides the status bar.
Future<void> hideStatusBar() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
}
//----------------------------------------------------------------------

/// Navigates back to the previous page.
///
/// [context] is the current build context.
/// [result] is the result to return when popping the route.
Future<void> goBack(BuildContext context, {dynamic result}) async {
  await context.router.maybePop(result);
}

//-------------------------------------------------------------------------------

/// Shows or hides a loader view.
///
/// [value] determines if the loader should be visible.
/// [message] is the message to display with the loader.
Future<void> showLoader({required bool value, String? message}) async {
  if (value) {
    // show loader here
    await EasyLoading.show(status: message);
  } else {
    await EasyLoading.dismiss();
    // hide loader here
  }
}

/// Performs asynchronous tasks using "FutureGroup".
///
/// [functionsList] is the list of functions to perform.
/// [success] is the callback to execute on success.
dynamic performAsyncTask(List<dynamic> functionsList,
    {Function(List<dynamic>)? success}) async {
  FutureGroup<dynamic> futureGroup = FutureGroup<dynamic>();
  for (final dynamic function in functionsList) {
    futureGroup.add(function);
  }
  futureGroup.close();
  await futureGroup.future.then((List<dynamic> value) {
    success?.call(value);
  });
}

/// Checks if the device is small.
bool isSmallDevice() {
  return !(MainConfig.context.height >= AppConstant.smallDeviceHeight);
}
