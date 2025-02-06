import 'package:flutter_test/flutter_test.dart';
import 'package:guia_de_moteis/controllers/Request.dart';

void main() async {
  Request request = Request();


  Map listagem = await request.buscar_listagem();

  test(
    'Verificando a integridade da tradução dos dados e sua formatação',
    () {
      expect(listagem, isA<Map>());
      expect(listagem['sucesso'], true);
    },
  );
}
