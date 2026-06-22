import 'package:intl/intl.dart';

import 'exports.dart';

/// Constants for date formats used in the application.
class DateConstants {
  /// The date time format.
  static const String dateTimeFormat = "yyyy-MM-dd HH:mm:ss";
  /// The year month day format.
  static const String yearMonthDayFormat = "yyyy-MM-dd";
  /// The date month year format.
  static const String dateMonthYearFormat = "dd-MMM-yyyy";
  /// The hours 12 with meridiem format.
  static const String hours12WithMeridiemFormat = "hh:mm a";
  /// The timestamp format.
  static const String timestampFormat = "yyyy-MM-ddTHH:mm:ss.SSS";
  /// The hour 24 format.
  static const String hour24Format = 'HH:mm';
}

/// Returns the current date as a string in the specified format.
Future<String> getCurrentDateString(String dateFormat) async {
  await initializeDateFormatting();
  return DateFormat(dateFormat).format(DateTime.now()).toString();
}

/// Returns the current UTC date as a string.
String getUtcDate() {
  DateTime dateUtc = DateTime.now().toUtc();
  String date = DateFormat(DateConstants.dateTimeFormat).format(dateUtc);
  return date;
}

/// Converts a UTC date string to local time and returns it as a string.
String getLocalTime(String dateUtc, {String? format, bool isUtc = false}) {
  // convert it to local
  DateTime dateTime =
      DateFormat(format ?? DateConstants.dateTimeFormat).parse(dateUtc, isUtc);
  DateTime dateLocal = dateTime.toLocal();
  return DateFormat(DateConstants.hours12WithMeridiemFormat).format(dateLocal);
}

/// Converts a [DateTime] object to a string in the specified format.
String dateToString(DateTime date,
    {String dateFormat = DateConstants.dateMonthYearFormat}) {
  return DateFormat(dateFormat).format(date);
}

/// Converts a date string to a [DateTime] object using the specified format.
DateTime stringToDate(String dateString,
    {String dateFormat = DateConstants.dateMonthYearFormat}) {
  try {
    return DateFormat(dateFormat).parse(dateString);
  } on Exception {
    return DateTime.now();
  }
}

/// Converts a [DateTime] object to an ISO 8601 string.
String dateToISOString(DateTime date) {
  return DateFormat(DateConstants.timestampFormat).format(date);
}

/// Converts a date string from the API response to the app's date format.
String getConvertedDate(String dateString,
    {String dateFormat = DateConstants.dateMonthYearFormat}) {
  try {
    DateTime dateTime =
        DateFormat(DateConstants.dateTimeFormat).parse(dateString);
    String formattedDate = DateFormat(dateFormat).format(dateTime.toLocal());
    return formattedDate;
  } on Exception {
    return "";
  }
}

/// Converts a date string from the API response to the app's time format.
String getConvertedTime(String dateString) {
  try {
    DateTime dateTime =
        DateFormat(DateConstants.dateTimeFormat).parse(dateString);
    String formattedDate = DateFormat(DateConstants.hours12WithMeridiemFormat)
        .format(dateTime.toLocal());
    return formattedDate;
  } on Exception {
    return "";
  }
}

/// Converts a date string from one format to another.
String convertedDateFormat(String dateString,
    {String fromThis = DateConstants.dateTimeFormat,
    String toThis = DateConstants.dateMonthYearFormat}) {
  DateTime dateTime = DateFormat(fromThis).parse(dateString);
  String formattedDate = DateFormat(toThis).format(dateTime.toLocal());
  return formattedDate;
}

/// Parses a UTC date string and returns it in the app's date format.
String parseDate(String dateUtc) {
  DateTime date = DateFormat(DateConstants.dateTimeFormat).parse(dateUtc, true);
  DateTime dateLocal = date.toLocal();
  String formattedDate =
      DateFormat(DateConstants.yearMonthDayFormat).format(dateLocal);
  String currentDate =
      DateFormat(DateConstants.yearMonthDayFormat).format(DateTime.now());
  if (formattedDate == currentDate) {
    return DateFormat(DateConstants.hours12WithMeridiemFormat)
        .format(dateLocal)
        .replaceAll(' ', '')
        .toLowerCase();
  }
  return DateFormat(DateConstants.dateMonthYearFormat).format(dateLocal);
}

/// Returns a list of [DateTime] objects representing the days between two dates.
List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  List<DateTime> days = <DateTime>[];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.add(Duration(days: i)));
  }
  return days;
}

/// Returns the difference between two times as a formatted string.
String twoTimeDifference(String startTime, String endTime,
    {String? startTimeFormat = DateConstants.hours12WithMeridiemFormat,
    String? endTimeFormat = DateConstants.hours12WithMeridiemFormat,
    String? outputFormat = DateConstants.hour24Format}) {
  DateTime sTime = stringToDate(startTime, dateFormat: startTimeFormat!);
  DateTime eTime = stringToDate(endTime, dateFormat: endTimeFormat!);
  Duration difference = eTime.difference(sTime);
  return DateFormat(outputFormat!)
      .format(DateTime(0, 0, 0, 0, difference.inMinutes));
}
