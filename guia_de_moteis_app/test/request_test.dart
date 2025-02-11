import 'package:flutter_test/flutter_test.dart';
import 'package:go/controllers/Request.dart';

void main() async {
  Request request = Request();

  Map listagem = await request.buscarListagem();

  test(
    'Verificando a integridade da tradução dos dados e sua formatação: $listagem',
    () {
      expect(listagem, isA<Map>());
      expect(listagem['sucesso'], true);
    },
  );
}
