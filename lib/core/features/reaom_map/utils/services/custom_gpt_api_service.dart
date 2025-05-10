import 'package:dio/dio.dart';
import 'package:road_map_mentor/core/constants/constants.dart';

class CustomGptApiService {
  final String _baseUrl = "https://api.openai.com/v1";
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.openai.com/v1",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "${Constants.openAIAuth}",
        "OpenAI-Beta": "assistants=v2",
      },
    ),
  );

  Future<List<dynamic>> get({required String endPoint}) async {
    Response<dynamic> response = await _dio.get('$_baseUrl$endPoint');
    return response.data['data'];
  }

  Future<Response<dynamic>> post(
      {required String endPoint, required Object data}) async {
    Response<dynamic> response = await _dio.post(endPoint, data: data);
    return response;
  }
}
