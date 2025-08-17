

abstract final class ApiLink {
  static const baseUrl = "http://192.168.1.104:8000";
  static const baseApiUrl = "$baseUrl/api";
  static const login = '$baseApiUrl/login';
  static const advertisementSearch = '$baseApiUrl/advertisementSearch';
  static const labSearchPatient = '$baseApiUrl/labSearchPatient';
  static const registerPatient = '$baseApiUrl/registerPatient';
  static const allEvaluation = '$baseApiUrl/allEvaluation';
  static const availableAppintments = '$baseApiUrl/labs';
  static const allAnalyses = '$baseApiUrl/labById';

  // static const favoriteLabsForPatient = '$baseApiUrl/labSearchPatient?isfavorite=';
  // "${ApiLink.baseApiUrl}/labSearchPatientt?isfavorite=${filterOptions.isFavorite}",

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

  static String fileUrlForAllAnalyses(int lab_id) {
    return '$allAnalyses/$lab_id';
  }

  //   static String fileUrlForFavoriteLabs(bool isFav) {
  //   return '$favoriteLabsForPatient/$isFav';
  // }
}
