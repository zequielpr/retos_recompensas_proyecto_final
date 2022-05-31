/*
import 'package:flutter/material.dart';

class BotonOpSala{
  String? titulo;
  String? imagen;
  BuildContext context;
  String? tipo;
  Widget card = Card();


  BotonOpSala(this.titulo, this.imagen, this.context){
      card = Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          height: 100,
          width: 300,
          child:
              RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  color: Color.fromARGB(0, 0, 20, 0) ,
                  child: Align(
                      alignment: Alignment(0, 0),
                      heightFactor: 0,
                      widthFactor: 0,
                      child: Text(titulo!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
                  ),
                  onPressed: (){*/
/*Navigator.push(context, MaterialPageRoute(builder: (context)=>Misiones()));*//*
}),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color(0xff7c94b6),
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: AssetImage(imagen!)
            ),
          ),
        ),
      );
  }


  Widget get getInstance=> card;


}*/
