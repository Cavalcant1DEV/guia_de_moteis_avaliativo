import 'dart:convert';

import 'package:http/http.dart' as http;

class Request {
  late Map data;

  Future<Map> buscarListagem() async {
    Map result;
    var url = Uri.https('www.jsonkeeper.com', 'b/1IXK');
    var response = await http.get(url);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      result = jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      result = {'sucesso': false};
    }

    return result;
  }
}
