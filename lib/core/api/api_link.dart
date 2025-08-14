import 'package:midical_laboratory/features/pages/booking/booking_page.dart';

abstract final class ApiLink {
  static const baseUrl = "http://192.168.1.104:8000";
  static const baseApiUrl = "$baseUrl/api";
  static const login = '$baseApiUrl/login';
  static const advertisementSearch = '$baseApiUrl/advertisementSearch';
  static const labSearchPatient = '$baseApiUrl/labSearchPatient';
  static const registerPatient = '$baseApiUrl/registerPatient';
  static const allEvaluation = '$baseApiUrl/allEvaluation';
  static const availableAppintments = '$baseApiUrl/labs';


  static String fileUrl(String url) {
    if (url.startsWith(baseUrl)) return url;
    return '$baseUrl$url';
  }

  static String fileUrlForEvaluation(int lab_id) {
    return '$allEvaluation/$lab_id';
  }
   static String fileUrlForAvailableAppointments(int lab_id) {
    return '$availableAppintments/$lab_id/available-appointments';
  }
}
