class EndPoints {
  static const String login = "";
  static const String register = '';
  static const String forgotPassword = '/forgot-password';

  static const String subjects = '/subjects';
  static const String students = '/students';
  static const String activityLogs = '/activity-logs';
  static const String profile = '/students/me';

  static String subjectLectures(String subjectId) {
    return '/subjects/$subjectId/lectures';
  }
}
