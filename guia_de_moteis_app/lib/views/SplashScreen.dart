import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState

    //Realizar aplicação de verificação de escolha do usuário para o a seleção do topbar

    Future.wait([
      Future.delayed(
        const Duration(seconds: 3),
      )
    ]).then(
      (escolha) => Navigator.of(context).pushReplacementNamed('/home'),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Icon(Icons.logo_dev),
      ),
    );
  }
}
