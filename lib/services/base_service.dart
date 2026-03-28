class BaseService {
  static const String rootApi = "http://10.0.2.2:3000/v1";  // ✅ Only one rootApi
  
  static String GOOGLE_GEOCODER = "AIzaSyDgIDdU1WUh6_qQywGAGnT4CG6R4_zmux0";

  Map<String, String> header = {"Content-Type": "application/json"};
}