abstract final class ApiLink {
  static const baseUrl = "http://192.168.1.103:8000";
  static const baseApiUrl = "$baseUrl/api";
  static const login = '$baseApiUrl/login';
  static const advertisementSearch = '$baseApiUrl/advertisementSearch';
  static const labSearchPatient = '$baseApiUrl/labSearchPatient';
  static const registerPatient = '$baseApiUrl/registerPatient';
  static const allEvaluation = '$baseApiUrl/allEvaluation';

  static String fileUrl(String url) {
    if (url.startsWith(baseUrl)) return url;
    return '$baseUrl$url';
  }

  static String fileUrlForEvaluation(int lab_id) {
    return '$allEvaluation/$lab_id';
  }
}
