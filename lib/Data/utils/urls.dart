class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registrationUrl = '$_baseUrl/registration';
  static const String logInUrl = '$_baseUrl/login';
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String taskCountByStatusUrl = '$_baseUrl/taskStatusCount';

  static String taskListByStatusUrl(String status) =>
      '$_baseUrl/listTaskByStatus/$status';

  static const String updateProfileUrl = '$_baseUrl/profileUpdate';
  static String recoverVerifyEmailUrl(String email) =>
      '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoverVerifyOTP(String email, otp) =>
      '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static String updateTaskStatusUrl(String id, status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';

  static String deleteTaskUrl(String id) =>
      '$_baseUrl/deleteTask/$id';
}
