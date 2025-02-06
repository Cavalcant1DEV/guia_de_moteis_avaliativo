
import 'package:dio/dio.dart';

class Request {
  late Map data;

  Future<Map> buscar_listagem() async {
    Map result;
    final dio = Dio();
    final response = await dio.get('https://www.jsonkeeper.com/b/1IXK');

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      result = response.data;
    } else {
      result = {'sucesso': false};
    }

    return result;
  }
}
