import 'package:flutter/material.dart';
import 'package:go/controllers/Provider.dart';
import 'package:go/controllers/Request.dart';
import 'package:go/views/CategoryDetails.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final int option;
  const HomeScreen({super.key, required this.option});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Não esquecer de utilizar o flutterscreen until para deixar melhor a responsividade das fontes

  double tittleSize = 24.0;
  double smallerText = 10.0;
  Color dominantTC = Colors.white;

  Request request = Request();

  ButtonStyle textButton = ButtonStyle(
    splashFactory: InkSplash.splashFactory,
    overlayColor: WidgetStatePropertyAll(Colors.grey),
  );

  Widget buildDrawerButton(IconData icon, String titulo, String rota) {
    return TextButton(
      onPressed: () {
        // Navigator.pushNamed(context, rota);
      },
      style: textButton,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(
                    icon,
                    color: Colors.black,
                  ),
                ),
                Text(
                  titulo,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  int calculaPorcentagem(valor, desconto) {
    double porcentagem;

    porcentagem = ((desconto * 100) / valor);

    return porcentagem.round();
  }

  @override
  void initState() {
    super.initState();
    // TabController recebe o número de abas e um TickerProvider (State com TickerProviderStateMixin)
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Não esquecer de limpar o controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 60, 20, 40),
                      color: Colors.red,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Icon(
                                        Icons.check_box,
                                        size: 40,
                                        color: dominantTC,
                                      ),
                                    ),
                                    Text(
                                      'go fidelidade',
                                      style: TextStyle(
                                        color: dominantTC,
                                        fontSize: tittleSize,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_circle_right_sharp,
                                  color: dominantTC,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Acumule selinhos e troque por reservas grátis, vale em todos os motéis e horários',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildDrawerButton(Icons.person, 'Login', ''),
                    buildDrawerButton(Icons.help, 'Ajuda', ''),
                    buildDrawerButton(Icons.settings, 'Configurações', ''),
                    buildDrawerButton(
                        Icons.bug_report, 'Comunicar problema', ''),
                    buildDrawerButton(
                        Icons.campaign, 'Tem um motel? Faça parte', ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
        // title: Container(
        //   decoration: BoxDecoration(color: Colors.red[900]),
        //   child: TabBar(
        //     controller: _tabController,
        //     unselectedLabelStyle: TextStyle(color: Colors.white),
        //     indicator: BoxDecoration(
        //       color: Colors.white,
        //     ),
        //     tabs: [
        //       Tab(
        //         child: Row(
        //           children: [
        //             Container(
        //               padding: EdgeInsets.symmetric(horizontal: 8),
        //               child: Icon(Icons.bolt),
        //             ),
        //             Text('Ir agora'),
        //           ],
        //         ),
        //       ),
        //       Tab(
        //         child: Row(
        //           children: [
        //             Container(
        //               padding: EdgeInsets.symmetric(horizontal: 8),
        //               child: Icon(Icons.calendar_month),
        //             ),
        //             Text('Ir outro dia'),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 247, 247, 247),
        child: Column(
          children: [
            // Faixa dos filtros, não precisa separar da árvore
            FilterBar(),
            // Listagem dos resultados
            Consumer<Filter>(
              builder: (context, filtros, child) {
                return FutureBuilder(
                  future: request.buscarListagem(),
                  builder: (context, snapshot) {
                    Map data;

                    snapshot.data == null
                        ? data = {'sucesso': false}
                        : data = snapshot.data!;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Montar a tela cinza com opacity
                      return Expanded(
                          child: Image.asset('assets/skeletonScreen.gif'));
                    } else if (snapshot.hasError) {
                      //Copiar a mensagem de erro do app original
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!data['sucesso']) {
                      // Mensagem de erro
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (data['data'].isEmpty) {
                      // Mensagem de nenhum resultado encontrado. + opção de limpar filtros
                      return const Center(
                        child: Text('Nenhum resultado encontrado'),
                      );
                    } else {
                      // Listagem de moteis
                      List moteis = data['data']['moteis'];

                      Map sFiltros = filtros.getOnlySelected();

                      if (sFiltros.isNotEmpty) {
                        for (int external = 0;
                            external < moteis.length;
                            external++) {
                          List suites = moteis[external]['suites'];
                          // Varrer as suites do motel
                          for (int internal = 0;
                              internal < suites.length;
                              internal++) {
                            List match = [];

                            // Verificar cada suite aplicando os filtros necessários e removendo aquelas que não dão match
                            for (var filtro in sFiltros.keys) {
                              // variável booleana para saber se algum resultado bateu com o esperado
                              bool matchInternal = false;

                              if (sFiltros[filtro] is Map) {
                                for (var chave in sFiltros[filtro].keys) {
                                  // Se for um map a rota é composta por uma lista dentro da lista de suites, se não for é referente a quantidade de quartos, então o acesso é direto e sem varredura
                                  for (Map category in suites[internal]
                                      [chave]) {
                                    // Varrendo a lista dentro dessa rota para buscar o resultado
                                    if (category[sFiltros[filtro][chave]]
                                        is Map) {
                                      matchInternal = true;
                                    } else {

                                      if (category[sFiltros[filtro][chave]].toLowerCase() ==
                                          filtro) {
                                        matchInternal = true;
                                      }
                                    }
                                  }
                                }
                              } else {
                                if (suites[internal][sFiltros[filtro]] > 0) {
                                  matchInternal = true;
                                }
                              }

                              match.add(matchInternal);
                            }

                            if (match.contains(false)) {
                              moteis[external]['suites'].removeAt(internal);
                              // Reajustando as posições após a remoção
                              internal--;
                            }
                          }

                          if (moteis[external]['suites'].isEmpty) {
                            moteis.removeAt(external);
                            external--;
                          }
                        }
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: moteis.length,
                          itemBuilder: (context, index) {
                            // Motel da listagem
                            Map motel = moteis[index];

                            // Listagem de suites do motel
                            List suites = motel['suites'];

                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            motel['logo'],
                                            height: 40,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  motel['fantasia'],
                                                  style: TextStyle(
                                                      fontSize: tittleSize),
                                                ),
                                                Text(
                                                    '${motel['distancia']}km - ${motel['bairro']}'),
                                                Text('Avaliações'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.favorite,
                                          size: 30,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 800,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: PageView.builder(
                                        itemCount: suites.length,
                                        itemBuilder: (context, index) {
                                          Map suite = suites[index];

                                          List<Widget> listaIcones = [];
                                          int exibicaoMaxima = 5;
                                          for (var itemCategoria
                                              in suite['categoriaItens']) {
                                            if (exibicaoMaxima > 0) {
                                              listaIcones.add(
                                                Container(
                                                  height: 40,
                                                  color: const Color.fromARGB(
                                                      255, 247, 247, 247),
                                                  child: Image.network(
                                                    itemCategoria['icone'],
                                                  ),
                                                ),
                                              );
                                              exibicaoMaxima--;
                                            }
                                          }

                                          List<Widget> containers = [];
                                          containers.add(
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                children: [
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxHeight: 250,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        placeholder:
                                                            'assets/skeletonScreen.gif', // Imagem de carregamento
                                                        image: suite['fotos'][
                                                            0], // URL da imagem
                                                        fadeInDuration: Duration(
                                                            seconds:
                                                                1), // Duração do efeito de fade-in)
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Text(suite['nome']),
                                                  ),
                                                  if (suite[
                                                      'exibirQtdDisponiveis'])
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.warning,
                                                          color: Colors.red,
                                                          size: smallerText,
                                                        ),
                                                        Text(
                                                          'Só mais ${suite['qtd']} pelo app.',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                smallerText,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            ),
                                          );
                                          containers.add(
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              padding: EdgeInsets.all(5),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CategoryDetails(),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: listaIcones,
                                                ),
                                              ),
                                            ),
                                          );

                                          for (Map periodo
                                              in suite['periodos']) {
                                            bool temDesconto = false;

                                            if (periodo['desconto'] != null &&
                                                periodo['desconto']
                                                    .isNotEmpty) {
                                              temDesconto = true;
                                            }

                                            containers.add(
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                margin:
                                                    EdgeInsets.only(bottom: 15),
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${periodo['tempoFormatado']}',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    tittleSize,
                                                              ),
                                                            ),
                                                            if (temDesconto)
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .lightGreen),
                                                                ),
                                                                child: Text(
                                                                  '${calculaPorcentagem(periodo['valor'], periodo['desconto']['desconto'])}% off',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .lightGreen,
                                                                      fontSize:
                                                                          smallerText),
                                                                ),
                                                              )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${periodo['valor'].toStringAsFixed(2)} R\$',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    tittleSize,
                                                                color: temDesconto
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .black,
                                                                decoration: temDesconto
                                                                    ? TextDecoration
                                                                        .lineThrough
                                                                    : null,
                                                              ),
                                                            ),
                                                            if (temDesconto)
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  '${periodo['valorTotal'].toStringAsFixed(2)} R\$',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        tittleSize,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Icon(Icons
                                                        .keyboard_arrow_right_sharp),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }

                                          listaIcones.add(
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              width: 40,
                                              height: 40,
                                              color: const Color.fromARGB(
                                                  255, 247, 247, 247),
                                              child: Text(
                                                'Ver mais',
                                                style: TextStyle(
                                                    fontSize: smallerText),
                                              ),
                                            ),
                                          );

                                          return Column(
                                            children: containers,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Filter>(
      builder: (context, filtros, child) {
        return Row(
          children: [
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 247, 247),
                    border: Border(
                      bottom: BorderSide(
                          color: const Color.fromARGB(255, 231, 229, 229)),
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  height: 68,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Builder(
                      builder: (context) {
                        List<Widget> filtrosWidget = [];

                        Iterable keys = filtros.lista.keys;

                        int count = 0;

                        for (var key in keys) {
                          if (filtros.lista[key]['selected']) {
                            count++;
                          }
                          if (filtros.lista[key]['shortcut']) {
                            filtrosWidget.add(
                              Container(
                                margin: EdgeInsets.only(left: 3, right: 5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        filtros.lista[key]['selected']
                                            ? Colors.red
                                            : Colors.white),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: !filtros.lista[key]['selected']
                                              ? const Color.fromARGB(
                                                  255, 247, 247, 247)
                                              : Colors.red,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(7),
                                        ),
                                      ),
                                    ),
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Utilizar do provider para controlar o estado
                                    filtros.selectOption(key);
                                  },
                                  child: Text(
                                    key,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: filtros.lista[key]['selected']
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }

                        filtrosWidget.insert(
                          0,
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 3, right: 5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 247, 247, 247),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7)))),
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2))),
                                  onPressed: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => FilterScreen,),);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.list,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        'Filtros',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (count > 0)
                                Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      '$count',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        );

                        return Row(
                          children: filtrosWidget,
                        );
                      },
                    ),
                  )),
            ),
          ],
        );
      },
    );
  }
}
