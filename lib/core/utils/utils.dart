import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/dto/login_response_dto.dart';
import '../di/injector_container.dart';
import '../errors/failures.dart';
import 'constants.dart';
import 'package:collection/collection.dart';

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      ServerFailure serverFailure = failure as ServerFailure;
      return serverFailure.message;
    case DatabaseFailure:
      return Constants.DATABASE_FAILURE_MESSAGE;
    default:
      return Constants.UNEXPECTED_FAILURE_MESSAGE;
  }
}

enum UIState { initial, loading, success, error }

String getSession() {
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour >= 0 && hour <= 11) {
    return "Session 1";
  } else if (hour >= 12 && hour <= 16) {
    return "Session 2";
  } else if (hour >= 17 && hour <= 23) {
    return "Session 3";
  } else {
    return "Unknown Session";
  }
}

String getGreetingsMessage() {
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour >= 0 && hour <= 11) {
    return "Good Morning";
  } else if (hour >= 12 && hour <= 15) {
    return "Good Afternoon";
  } else if (hour >= 16 && hour <= 20) {
    return "Good Evening";
  } else if (hour >= 21 && hour <= 23) {
    return "Good Night";
  } else {
    return "Hello there";
  }
}

String getTodaysDate() {
  DateTime now = DateTime.now();
  String formattedDate = "${now.year}-${now.month}-${now.day}";
  return formattedDate;
}

String getTodaysDateFormatted() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('d MMMM yyyy').format(now);
  String formattedOrdinalDate = _addOrdinalSuffix(formattedDate);
  return formattedOrdinalDate;
}

String _addOrdinalSuffix(String formattedDate) {
  String day = formattedDate.split(' ')[0];
  int numericDay = int.parse(day);

  String suffix;

  if (numericDay >= 11 && numericDay <= 13) {
    suffix = 'th';
  } else {
    switch (numericDay % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
  }

  return formattedDate.replaceFirst(day, day + suffix);
}

Map<String, List<dynamic>> groupByMonthYear(List<dynamic> collectionList) {
  return groupBy(collectionList, (dynamic collection) {
    DateTime collectionDate = DateTime.parse(collection['collection_date']);
    return '${collectionDate.month} ${collectionDate.year}';
  });
}

LoginResponseDto userData() {
  final prefs = sl<SharedPreferences>();
  final userData = prefs.getString("userData");
  final user = LoginResponseDto.fromJson(jsonDecode(userData!));
  return user;
}
