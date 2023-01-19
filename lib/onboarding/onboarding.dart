import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:retos_proyecto/Rutas.gr.dart';

import '../Servicios/Autenticacion/login.dart';
import 'contenido.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  late PageController _controller;
  late List<UnbordingContent> contents;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    contents = [
      UnbordingContent(
          title: 'Salas',
          image: 'lib/imgs/undraw_Educator_re_ju47.png',
          discription:
              "Crea o unite a salas en las cuales podrás recibir o asignar tareas"),
      UnbordingContent(
          title: 'Tareas',
          image: 'lib/imgs/undraw_Accept_tasks_re_09mv.png',
          discription: "Recibe o asigna tareas a cambio de puntos"),
      UnbordingContent(
          title: 'Recompensas',
          image: 'lib/imgs/undraw_Gift_box_re_vau4.png',
          discription: "Recibe o asigna recompensas a cambio de puntos"),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: const Text(
                  'Saltar',
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
                  ? "Comenzar"
                  : "Siguiente"),
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
}
