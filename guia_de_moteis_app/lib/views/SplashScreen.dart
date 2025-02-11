import 'package:flutter/material.dart';
import 'package:go/views/HomeScreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    //Realizar aplicação de verificação de escolha do usuário para o a seleção do topbar

    Future.wait([
      Future.delayed(
        const Duration(seconds: 3),
      )
    ]).then(
      // Fazer com o que o parâmetro escolha seja definido através da busca pelo cache

      (escolha) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(option: 0),
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 40,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
