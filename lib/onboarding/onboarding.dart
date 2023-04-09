import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:retos_proyecto/Rutas.gr.dart';

import '../Servicios/Autenticacion/login.dart';
import 'contenido.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  late PageController _controller;
  late List<UnbordingContent> contents;
  AppLocalizations? valores;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    _setContent(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40, right: 20),
            child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () =>
                    context.router.replaceAll([const LoginRouter()]),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent)),
                child: Text(
                  valores?.boton_saltar_p_1 as String,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    children: [
                      Card(
                        elevation: 0,
                        child: Image.asset(
                          contents[i].image,
                          height: 300,
                        ),
                      ),
                      Text(
                        contents[i].title,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: ElevatedButton(
              child: Text(currentIndex == contents.length - 1
                  ? valores?.boton_comenzar_p_3 as String
                  : valores?.boton_next_p_1 as String),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  context.router.replaceAll([const LoginRouter()]);
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  void _setContent(BuildContext context){
    contents = [
      UnbordingContent(
          title: valores?.titulo_p_1 as String,
          image: 'lib/recursos/imgs/undraw_Educator_re_ju47.png',
          discription:
          valores?.contenido_p_1 as String),
      UnbordingContent(
          title: valores?.titulo_p_2 as String,
          image: 'lib/recursos/imgs/undraw_Accept_tasks_re_09mv.png',
          discription: valores?.contenido_p_2 as String),
      UnbordingContent(
          title: valores?.titulo_p_3 as String,
          image: 'lib/recursos/imgs/undraw_Gift_box_re_vau4.png',
          discription: valores?.contenido_p_3 as String),
    ];
  }
}
