import 'package:clean_app/src/core/errors/failure.dart';

class FailuresHandling {
  String onHandlingFailures({required Failure failure}) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Error occurred, please try again !';
      case EmptyCacheFailure:
        return 'No data available !';
      case OfflineFailure:
        return 'Check your internet connection !';
      default:
        return 'Something went wrong occurred, try again later !';
    }
  }
}
