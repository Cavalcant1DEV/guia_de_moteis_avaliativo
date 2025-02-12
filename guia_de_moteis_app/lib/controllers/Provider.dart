// ignore: file_names
import 'package:flutter/foundation.dart';

class Filter with ChangeNotifier {
  // ignore: prefer_final_fields
  Map _filtros = {
    'com desconto': {
      'shortcut': true,
      'selected': false,
      'rota': {'periodos': 'desconto'},
    },
    'disponives': {
      'shortcut': true,
      'selected': true,
      'rota': 'qtd',
    },
    'periodos': {
      'shortcut': false,
      'selected': false,
      'rota': {'periodos': 'tempo'},
    },
    'hidro': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'piscina': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'sauna': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'ofurô': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'decoração erótica': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'decoração temática': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'cadeira erótica': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'pista de dança': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'garagem privativa': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'frigobar': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'internet wi-fi': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'suíte para festas': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
    'suíte com acessibilidade': {
      'shortcut': true,
      'selected': false,
      'rota': {'categoriaItens': 'nome'},
    },
  };

  Map get lista => _filtros;

  void selectOption(String key) {
    _filtros[key]['selected'] = !_filtros[key]['selected'];
    notifyListeners(); // Notifica os listeners para que o UI seja atualizado
  }

  void selectOptions(List<String> keys) {
    for (var key in keys) {
      _filtros[key]['selected'] = !_filtros[key]['selected'];
    }

    notifyListeners(); // Notifica os listeners para que o UI seja atualizado
  }

  Map getOnlySelected({bool bool = true}) {
    // bool check para operação inversa caso dê tempo de implementar
    Map selected = {};

    for (var key in _filtros.keys) {
      if (_filtros[key]['selected']) {
        selected[key] = _filtros[key]['rota'];
      }
    }
    return selected;
  }
}
